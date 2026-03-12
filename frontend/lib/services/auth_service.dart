import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'storage_service.dart';
import 'logger_service.dart';

/// Custom exception class for authentication errors
class AuthException implements Exception {
  final String message;
  final String details;
  final String technicalDetails;

  AuthException({
    required this.message,
    required this.details,
    required this.technicalDetails,
  });

  @override
  String toString() => message;
}

final authServiceSingleton = AuthService._internal();

final authServiceProvider = StateNotifierProvider<AuthService, AsyncValue>((ref) => authServiceSingleton);

Future<void> initializeAuthService() async {
  await authServiceSingleton.initialize();
}

class AuthService extends StateNotifier<AsyncValue> {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  static const String _codeVerifierKey = 'code_verifier';
  static const String _redirectUriKey = 'redirect_uri';
  
  static final List<String> _adminEmails = [
    'davejoeem@gmail.com',
    'infiforge@gmail.com',
  ];
  static List<String> get adminEmails => _adminEmails;
  
  final _logger = loggerServiceSingleton;
  final _storage = storageServiceSingleton;
  
  String? _cachedToken;
  Map<String, dynamic>? _cachedUser;
  bool _initialized = false;

  AuthService._internal() : super(const AsyncValue.loading());

  Future<void> initialize() async {
    try {
      _initialized = true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  bool get isInitialized => _initialized;

  // OAuth configuration for Google and Microsoft
  static Map<String, Map<String, String>> get _oauthConfig {
    // Web client ID for Google
    final String googleWebClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
    String googleClientId = googleWebClientId;
    
    if (!kIsWeb) {
      try {
        if (Platform.isAndroid) {
          googleClientId = 'YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com';
        } else if (Platform.isIOS) {
          googleClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com';
        } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
          googleClientId = 'YOUR_DESKTOP_CLIENT_ID.apps.googleusercontent.com';
        }
      } catch (e) {
        googleClientId = googleWebClientId;
      }
    }

    return {
      'google': {
        'clientId': googleClientId,
        'webClientId': googleWebClientId,
        'authEndpoint': 'https://accounts.google.com/o/oauth2/v2/auth',
        'tokenEndpoint': 'https://oauth2.googleapis.com/token',
        'scope': 'openid email profile',
      },
      'microsoft': {
        'clientId': 'YOUR_MICROSOFT_CLIENT_ID',
        'authEndpoint': 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
        'tokenEndpoint': 'https://login.microsoftonline.com/common/oauth2/v2.0/token',
        'scope': 'openid email profile User.Read',
        'supportsPKCE': 'true',
      },
    };
  }

  /// Get the appropriate redirect URI based on platform
  String _getRedirectUriForProvider(String provider) {
    if (!kIsWeb) {
      if (provider == 'google') {
        return 'com.infiforge.ringly:/oauth2redirect';
      } else if (provider == 'microsoft') {
        return 'com.infiforge.ringly://auth';
      }
    }
    // For web
    final loc = Uri.base;
    return '${loc.scheme}://${loc.host}${loc.hasPort ? ':${loc.port}' : ''}/auth';
  }

  /// Generate a random string for state and code verifier
  String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  /// Generate a state parameter that includes provider information
  String _generateStateWithProvider(String provider) {
    final randomPart = _generateRandomString(12);
    return "${provider}_$randomPart";
  }

  /// Extract provider from state parameter
  String extractProviderFromState(String state) {
    if (state.contains('_')) {
      return state.split('_').first;
    }
    return 'unknown';
  }

  /// Generate code challenge from verifier (PKCE)
  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  /// Build the OAuth URL for a provider (with PKCE if supported)
  Future<Map<String, String>> buildAuthRequest(String provider) async {
    final config = _oauthConfig[provider];
    if (config == null) throw Exception('Unsupported provider: $provider');

    final state = _generateStateWithProvider(provider);
    final codeVerifier = _generateRandomString(128);
    final redirectUri = _getRedirectUriForProvider(provider);
    
    // Store code verifier and redirect URI
    final box = await _storage.authBox;
    await box.put('${_codeVerifierKey}_$state', codeVerifier);
    await box.put('${_redirectUriKey}_$state', redirectUri);

    final queryParams = <String, String>{
      'client_id': config['clientId']!,
      'redirect_uri': redirectUri,
      'response_type': 'code',
      'state': state,
    };

    if (config['scope']?.isNotEmpty == true) {
      queryParams['scope'] = config['scope']!.trim();
    }

    if (config['supportsPKCE'] == 'true') {
      final codeChallenge = _generateCodeChallenge(codeVerifier);
      queryParams['code_challenge'] = codeChallenge;
      queryParams['code_challenge_method'] = 'S256';
    }

    // Provider-specific tweaks
    if (provider == 'google') {
      queryParams['access_type'] = 'offline';
      queryParams['prompt'] = 'consent';
    } else if (provider == 'microsoft') {
      queryParams['response_mode'] = 'query';
    }

    final url = Uri.parse(config['authEndpoint']!).replace(queryParameters: queryParams).toString();
    return {'url': url, 'state': state};
  }

  /// Process authentication code from OAuth callback
  Future<Map<String, dynamic>> processAuthCode(String code, String state, String provider) async {
    final box = await _storage.authBox;
    final codeVerifier = box.get('${_codeVerifierKey}_$state') as String?;
    final redirectUri = box.get('${_redirectUriKey}_$state') as String?;
    
    if (codeVerifier == null) {
      throw Exception('No code verifier found for state: $state');
    }
    if (redirectUri == null) {
      throw Exception('No redirect URI found for state: $state');
    }

    try {
      final tokenData = await _exchangeCodeViaBackend(
        code: code,
        codeVerifier: codeVerifier,
        provider: provider,
        state: state,
        redirectUri: redirectUri,
      );

      final jwtToken = tokenData['token'] as String?;
      final user = tokenData['user'] as Map<String, dynamic>?;

      if (jwtToken != null && user != null) {
        await _saveAuthData(
          token: jwtToken,
          user: user,
          provider: provider,
        );
      }

      // Cleanup
      await box.delete('${_codeVerifierKey}_$state');
      await box.delete('${_redirectUriKey}_$state');

      return tokenData;
    } catch (e) {
      _logger.error('Error processing auth code: $e');
      rethrow;
    }
  }

  /// Exchange authorization code via backend
  Future<Map<String, dynamic>> _exchangeCodeViaBackend({
    required String code,
    required String codeVerifier,
    required String provider,
    required String state,
    required String redirectUri,
  }) async {
    final backendUrl = _getBackendBaseUrl();
    final endpoint = '$backendUrl/api/auth/$provider/exchange';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'code': code,
        'code_verifier': codeVerifier,
        'state': state,
        'redirect_uri': redirectUri,
        'platform': _getPlatformIdentifier(),
      }),
    );

    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body) as Map<String, dynamic>;
      throw AuthException(
        message: errorData['error'] ?? 'Authentication failed',
        details: errorData['details'] ?? 'Unknown error',
        technicalDetails: 'status=${response.statusCode}, url=$endpoint',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Save authentication data
  Future<void> _saveAuthData({
    required String token,
    required Map<String, dynamic> user,
    required String provider,
  }) async {
    final box = await _storage.authBox;
    
    final enhancedUser = {
      ...user,
      'name': user['name'] ?? user['fullName'] ?? '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim(),
      'email': user['email'] ?? '',
      'photoUrl': user['photoUrl'],
      'provider': provider,
    };

    await box.putAll({
      _tokenKey: token,
      _userKey: jsonEncode(enhancedUser),
      'provider': provider,
    });

    _cachedToken = token;
    _cachedUser = enhancedUser;

    _logger.info('Authentication data saved for user: ${enhancedUser['email']}');
  }

  /// Get the current authentication token
  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    
    final box = await _storage.authBox;
    final token = box.get(_tokenKey) as String?;
    _cachedToken = token;
    return token;
  }

  /// Get the current user data
  Future<Map<String, dynamic>?> getUser() async {
    if (_cachedUser != null) return _cachedUser;
    
    final box = await _storage.authBox;
    final userJson = box.get(_userKey) as String?;
    if (userJson == null) return null;
    
    _cachedUser = jsonDecode(userJson) as Map<String, dynamic>;
    return _cachedUser;
  }

  /// Check if the user is logged in
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  /// Check if user is admin
  Future<bool> isAdmin() async {
    final user = await getUser();
    final email = user?['email'] as String? ?? '';
    return _adminEmails.contains(email);
  }

  /// Clear authentication data (logout)
  Future<void> logout() async {
    final box = await _storage.authBox;
    await box.delete(_tokenKey);
    await box.delete(_userKey);
    _cachedToken = null;
    _cachedUser = null;
    _logger.info('User logged out');
  }

  /// Get backend base URL
  String _getBackendBaseUrl() {
    if (kIsWeb) {
      return '';
    }
    return 'http://localhost:8800';
  }

  /// Get platform identifier
  String _getPlatformIdentifier() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  /// Sign in with Google (native)
  Future<void> signInWithGoogleNative() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['openid', 'email', 'profile'],
        serverClientId: _oauthConfig['google']!['webClientId'],
      );

      final account = await googleSignIn.signIn();
      if (account == null) {
        throw AuthException(
          message: 'Google Sign-In cancelled',
          details: 'User cancelled the sign-in flow',
          technicalDetails: 'GoogleSignIn.signIn() returned null',
        );
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;

      if (idToken == null) {
        throw AuthException(
          message: 'Failed to get ID token from Google',
          details: 'The authentication did not return an ID token',
          technicalDetails: 'GoogleSignInAuthentication.idToken is null',
        );
      }

      // Send ID token to backend
      final backendUrl = _getBackendBaseUrl();
      final response = await http.post(
        Uri.parse('$backendUrl/api/auth/google/native'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idToken': idToken,
          'platform': _getPlatformIdentifier(),
        }),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw AuthException(
          message: errorData['error'] ?? 'Authentication failed',
          details: errorData['details'] ?? 'Unknown error',
          technicalDetails: 'status=${response.statusCode}',
        );
      }

      final tokenData = jsonDecode(response.body) as Map<String, dynamic>;
      final jwtToken = tokenData['token'] as String?;
      final user = tokenData['user'] as Map<String, dynamic>?;

      if (jwtToken != null && user != null) {
        await _saveAuthData(
          token: jwtToken,
          user: user,
          provider: 'google',
        );
      }
    } catch (e) {
      _logger.error('Google Sign-In error: $e');
      rethrow;
    }
  }
}

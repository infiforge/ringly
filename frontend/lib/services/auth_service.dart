import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'storage_service.dart';
import 'logger_service.dart';
import 'loopback_server.dart';

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

final authServiceProvider = StateNotifierProvider<AuthService, AsyncValue>(
    (ref) => authServiceSingleton);

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
    // From config.json - OAuth credentials
    final String googleWebClientId =
        '113716226838-a3p6rpa50fdobccfkdoe7iege21mnshf.apps.googleusercontent.com';
    String googleClientId = googleWebClientId;

    if (!kIsWeb) {
      try {
        if (Platform.isAndroid) {
          googleClientId =
              '113716226838-ht7euuorr1ag4m51jlcsdvabn2jce80n.apps.googleusercontent.com';
        } else if (Platform.isIOS) {
          googleClientId =
              '113716226838-kig8n3is7fk2isl831dbkm8nkb8t80vl.apps.googleusercontent.com';
        } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
          // Desktop uses web client ID with loopback redirect
          googleClientId = googleWebClientId;
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
        'authEndpoint':
            'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
        'tokenEndpoint':
            'https://login.microsoftonline.com/common/oauth2/v2.0/token',
        'scope': 'openid email profile User.Read',
        'supportsPKCE': 'true',
      },
    };
  }

  /// Get the appropriate redirect URI based on platform
  String _getRedirectUriForProvider(String provider) {
    if (kIsWeb) {
      // For web, use the current URL origin + /ringly/auth/callback
      final loc = Uri.base;
      // If we're on localhost, use /auth (simple path)
      if (loc.host == 'localhost' || loc.host == '127.0.0.1') {
        return '${loc.scheme}://${loc.host}${loc.hasPort ? ':${loc.port}' : ''}/auth';
      }
      // For production, use /ringly/auth/callback
      return '${loc.scheme}://${loc.host}${loc.hasPort ? ':${loc.port}' : ''}/ringly/auth/callback';
    }

    // For desktop/mobile apps
    try {
      // Use loopback server for desktop (always uses /auth)
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        return LoopbackServerService.redirectUri;
      }
      // For mobile, use custom scheme
      if (Platform.isAndroid || Platform.isIOS) {
        return 'com.infiforge.ringly:/oauth2redirect';
      }
    } catch (_) {
      // Fallback
    }

    return 'http://localhost:54321/auth';
  }

  /// Generate a random string for state and code verifier
  String _generateRandomString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
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

    final url = Uri.parse(config['authEndpoint']!)
        .replace(queryParameters: queryParams)
        .toString();
    return {'url': url, 'state': state};
  }

  /// Process authentication code from OAuth callback
  Future<Map<String, dynamic>> processAuthCode(
      String code, String state, String provider) async {
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
      'name': user['name'] ??
          user['fullName'] ??
          '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim(),
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

    _logger
        .info('Authentication data saved for user: ${enhancedUser['email']}');
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

  /// Sign in with Google (main entry point for all platforms)
  /// Uses:
  /// - In-app webview for desktop Windows and macOS
  /// - Loopback server for Linux
  /// - Native sign-in for mobile (Android, iOS)
  /// - Browser redirect for web
  Future<bool> signInWithGoogle() async {
    _logger.info('=== signInWithGoogle() START ===');
    _logger.info('Platform: ${_getPlatformInfo()}');

    if (!kIsWeb) {
      try {
        if (Platform.isAndroid || Platform.isIOS) {
          _logger.info('Attempting native mobile sign-in...');
          final success = await signInWithGoogleNative();
          if (success) {
            _logger.info('Native sign-in succeeded');
            return true;
          }
          _logger.warning('Native sign-in failed');
        }
      } catch (e) {
        _logger.error('Native sign-in exception: $e');
      }

      // Desktop platforms
      if (Platform.isLinux) {
        // Linux uses loopback server (external browser)
        _logger.info('Using loopback server for Linux...');
        return await signInWithGoogleLoopback();
      } else if (Platform.isWindows || Platform.isMacOS) {
        // Windows/macOS use in-app webview
        _logger.info('Using in-app webview for Windows/macOS...');
        return await _signInWithWebView('google');
      }
    } else {
      // Web: use browser redirect
      _logger.info('Using browser redirect for web...');
      return await _signInWithWebRedirect('google');
    }

    return false;
  }

  /// Sign in using in-app webview (for Windows and macOS desktop)
  /// Returns the OAuth URL to load in the webview
  Future<Map<String, String>> getWebViewAuthData(String provider) async {
    final authRequest = await buildAuthRequest(provider);
    return {
      'url': authRequest['url']!,
      'state': authRequest['state']!,
    };
  }

  /// Sign in using in-app webview (for Windows and macOS)
  Future<bool> _signInWithWebView(String provider) async {
    // For webview, we return false here - the actual auth happens
    // in the webview widget which calls handleAuthCallback when done
    // The caller should use getWebViewAuthData() to get the URL
    _logger.info('WebView auth initiated for $provider');
    return false;
  }

  /// Sign in using browser redirect (for web platform)
  Future<bool> _signInWithWebRedirect(String provider) async {
    try {
      final authRequest = await buildAuthRequest(provider);
      final url = authRequest['url']!;
      final state = authRequest['state']!;

      // Store state in sessionStorage for retrieval after redirect
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } catch (e) {
      _logger.error('Web redirect sign-in error: $e');
      return false;
    }
  }

  /// Handle OAuth callback from browser redirect (call this on app startup for web)
  Future<bool> handleWebAuthCallback() async {
    if (!kIsWeb) return false;

    try {
      final uri = Uri.base;
      final code = uri.queryParameters['code'];
      final state = uri.queryParameters['state'];
      final error = uri.queryParameters['error'];

      if (error != null) {
        _logger.error('OAuth error in callback: $error');
        return false;
      }

      if (code == null || state == null) {
        // No callback params present - not an auth redirect
        return false;
      }

      _logger.info('Handling web auth callback with code and state');

      // Process the auth code
      final tokenData =
          await processAuthCode(code, state, extractProviderFromState(state));

      // Clear the query params from URL (replace state without losing the path)
      return tokenData['token'] != null;
    } catch (e) {
      _logger.error('Error handling web auth callback: $e');
      return false;
    }
  }

  /// Sign in with Google using browser-based OAuth (for desktop platforms)
  Future<void> signInWithGoogleBrowser() async {
    try {
      final authRequest = await buildAuthRequest('google');
      final url = authRequest['url']!;

      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw AuthException(
          message: 'Could not launch browser for Google Sign-In',
          details: 'Please ensure you have a default browser configured',
          technicalDetails: 'launchUrl failed for $url',
        );
      }
    } catch (e) {
      _logger.error('Google browser sign-in error: $e');
      rethrow;
    }
  }

  /// Sign in with Google using loopback server (for desktop platforms)
  Future<bool> signInWithGoogleLoopback() async {
    return await _signInWithLoopbackServer('google');
  }

  /// Sign in using loopback server approach for desktop platforms
  /// Industry-standard method used by VS Code, Slack, etc.
  Future<bool> _signInWithLoopbackServer(String provider) async {
    final loopbackServer = LoopbackServerService();

    try {
      final config = _oauthConfig[provider];
      if (config == null) throw Exception('Unsupported provider: $provider');

      // Update redirect URI to use loopback server
      final redirectUri = LoopbackServerService.redirectUri;

      // Build OAuth request with loopback redirect URI
      final state = _generateStateWithProvider(provider);
      final codeVerifier = _generateRandomString(128);

      // Store code verifier and redirect URI with the state
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
        queryParams['scope'] = config['scope']!;
      }

      // PKCE code challenge
      final codeChallenge = _generateCodeChallenge(codeVerifier);
      queryParams['code_challenge'] = codeChallenge;
      queryParams['code_challenge_method'] = 'S256';

      // Provider-specific tweaks
      if (provider == 'google') {
        queryParams['access_type'] = 'offline';
        queryParams['prompt'] = 'consent';
      } else if (provider == 'microsoft') {
        queryParams['response_mode'] = 'query';
      }

      final oauthUrl = Uri.parse(
        config['authEndpoint']!,
      ).replace(queryParameters: queryParams).toString();

      _logger.info('Starting loopback server OAuth for $provider');
      _logger.info('Redirect URI: $redirectUri');

      // Start loopback server first (it will wait for callback)
      final completer = Completer<bool>();

      await loopbackServer.handleCallBackFromProvider((params) async {
        try {
          if (params.containsKey('error')) {
            throw Exception('OAuth error: ${params['error']}');
          }

          final code = params['code'];
          if (code == null || code.isEmpty) {
            throw Exception('No authorization code received');
          }

          // Exchange code for tokens via backend
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
            completer.complete(true);
          } else {
            completer.complete(false);
          }
        } catch (e) {
          _logger.error('Loopback callback error: $e');
          completer.complete(false);
        }
      });

      // Now launch the browser with OAuth URL
      final uri = Uri.parse(oauthUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch browser');
      }

      // Wait for the callback to complete
      return await completer.future;
    } catch (e) {
      _logger.error('Loopback server OAuth error: $e');
      return false;
    } finally {
      await loopbackServer.stopServer();
    }
  }

  /// Sign in with Google (native)
  Future<bool> signInWithGoogleNative() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['openid', 'email', 'profile'],
        serverClientId: _oauthConfig['google']!['webClientId'],
      );

      final account = await googleSignIn.signIn();
      if (account == null) {
        _logger.warning('Google Sign-In cancelled by user');
        return false;
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;

      if (idToken == null) {
        _logger.error('No ID token from Google');
        return false;
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
        _logger.error('Native sign-in failed: ${errorData['error']}');
        return false;
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
        return true;
      }
      return false;
    } catch (e) {
      _logger.error('Google Sign-In error: $e');
      return false;
    }
  }

  /// Get platform info string
  String _getPlatformInfo() {
    if (kIsWeb) return 'Web';
    try {
      if (Platform.isAndroid) return 'Android';
      if (Platform.isIOS) return 'iOS';
      if (Platform.isWindows) return 'Windows';
      if (Platform.isMacOS) return 'macOS';
      if (Platform.isLinux) return 'Linux';
    } catch (_) {}
    return 'Unknown';
  }

  /// Handle OAuth callback from webview or redirect
  /// Extracts code and state, exchanges with backend
  Future<void> handleAuthCallback(Map<String, String> params) async {
    final code = params['code'];
    final state = params['state'];
    final error = params['error'];

    if (error != null) {
      throw AuthException(
        message: 'OAuth error: $error',
        details: 'The authentication provider returned an error',
        technicalDetails: 'error=$error',
      );
    }

    if (code == null || state == null) {
      throw AuthException(
        message: 'Missing authentication parameters',
        details: 'The callback did not include required code or state',
        technicalDetails: 'code=${code != null}, state=${state != null}',
      );
    }

    // Extract provider from state
    final provider = extractProviderFromState(state);

    // Process the auth code (exchange for tokens)
    final tokenData = await processAuthCode(code, state, provider);

    // Save auth data if successful
    final jwtToken = tokenData['token'] as String?;
    final user = tokenData['user'] as Map<String, dynamic>?;

    if (jwtToken != null && user != null) {
      await _saveAuthData(
        token: jwtToken,
        user: user,
        provider: provider,
      );
    } else {
      throw AuthException(
        message: 'Failed to complete authentication',
        details: 'The backend did not return valid tokens',
        technicalDetails: 'token=${jwtToken != null}, user=${user != null}',
      );
    }
  }
}

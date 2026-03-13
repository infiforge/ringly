import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ringly/services/auth_service.dart';
import 'package:ringly/services/loopback_server.dart';

@RoutePage()
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  bool _isLoading = false;
  String? _error;
  bool _showWebView = false;
  String? _authUrl;
  bool _isWebViewLoading = false;

  final _loopbackServerService = LoopbackServerService();

  @override
  void initState() {
    super.initState();
    _checkWebAuthCallback();
  }

  @override
  void dispose() {
    _loopbackServerService.stopServer();
    super.dispose();
  }

  /// Check if we're returning from OAuth redirect (for web platform)
  Future<void> _checkWebAuthCallback() async {
    if (!kIsWeb) return;

    final uri = Uri.base;
    final hasCode = uri.queryParameters.containsKey('code');
    final hasError = uri.queryParameters.containsKey('error');

    if (hasCode || hasError) {
      setState(() => _isLoading = true);

      try {
        final success = await authServiceSingleton.handleWebAuthCallback();
        if (success && mounted) {
          context.router.replaceNamed('/');
        } else if (mounted && hasError) {
          setState(() {
            _error = 'Authentication failed: ${uri.queryParameters['error']}';
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _error = e.toString());
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // For Windows/macOS, use embedded webview
      if (!kIsWeb && (Platform.isWindows || Platform.isMacOS)) {
        final authData =
            await authServiceSingleton.getWebViewAuthData('google');
        setState(() {
          _authUrl = authData['url'];
          _showWebView = true;
        });
        _startLoopbackListener();
        setState(() => _isLoading = false);
        return;
      }

      // For Linux, web, and mobile - use unified sign-in
      final success = await authServiceSingleton.signInWithGoogle();

      if (success && mounted) {
        context.router.replaceNamed('/');
      } else if (mounted) {
        setState(() {
          _error = 'We couldn\'t complete your sign-in. The server might be temporarily unavailable. Please try again in a moment.';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'An unexpected error occurred. Please try again in a moment.';
          _isLoading = false;
        });
      }
    }
  }

  void _startLoopbackListener() {
    _loopbackServerService.handleCallBackFromProvider((params) async {
      if (!mounted) return;
      await _handleAuthCallback(params);
    });
  }

  Future<void> _handleAuthCallback(Map<String, String> params) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _showWebView = false;
    });

    try {
      await authServiceSingleton.handleAuthCallback(params);
      if (mounted) {
        context.router.replaceNamed('/');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'An unexpected error occurred. Please try again in a moment.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithMicrosoft() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check if we need webview (Windows/macOS)
      if (!kIsWeb && (Platform.isWindows || Platform.isMacOS)) {
        final authData =
            await authServiceSingleton.getWebViewAuthData('microsoft');
        setState(() {
          _authUrl = authData['url'];
          _showWebView = true;
        });
        _startLoopbackListener();
        setState(() => _isLoading = false);
        return;
      }

      // For other platforms
      setState(() {
        _error = 'Microsoft sign-in is coming soon! Please use Google sign-in for now.';
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  void _hideWebView() {
    setState(() {
      _showWebView = false;
      _authUrl = null;
    });
    _loopbackServerService.stopServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32),
          child: _showWebView ? _buildWebViewCard() : _buildAuthCard(),
        ),
      ),
    );
  }

  Widget _buildAuthCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App logo from assets
        Image.asset(
          'assets/images/ringly.png',
          width: 64,
          height: 64,
        ),
        const SizedBox(height: 24),
        // Title
        const Text(
          'Ringly',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to continue',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 48),
        // Error message
        if (_error != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              _error!,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
          const SizedBox(height: 16),
        ],
        // Google Sign In button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _signInWithGoogle,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.g_mobiledata, size: 24),
            label: Text(_isLoading ? 'Signing in...' : 'Sign in with Google'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Microsoft Sign In button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _signInWithMicrosoft,
            icon: const Icon(Icons.business, size: 20),
            label: const Text('Sign in with Microsoft'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWebViewCard() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Row(
          children: [
            Icon(
              Icons.lock,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Secure Sign In',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Spacer(),
            IconButton(
              onPressed: _hideWebView,
              icon: const Icon(Icons.close),
              tooltip: 'Cancel',
            ),
          ],
        ),
        const SizedBox(height: 16),
        // WebView
        Container(
          height: 450,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _authUrl != null
                ? InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri(_authUrl!),
                    ),
                    onLoadStart: (controller, url) {
                      if (mounted) {
                        setState(() => _isWebViewLoading = true);
                      }
                    },
                    onLoadStop: (controller, url) {
                      if (mounted) {
                        setState(() => _isWebViewLoading = false);
                      }
                    },
                    onLoadError: (controller, url, code, message) {
                      if (mounted) {
                        setState(() {
                          _error = 'Failed to load page: $message';
                          _isWebViewLoading = false;
                        });
                      }
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      final uri = navigationAction.request.url;
                      if (uri != null) {
                        final uriString = uri.toString();

                        // Check for loopback server callback (ports 54321-54330)
                        final loopbackRegex = RegExp(
                            r'http://(localhost|127\.0\.0\.1):5432[1-9]/');
                        if (loopbackRegex.hasMatch(uriString) ||
                            uriString.contains('/auth/callback')) {
                          final params = uri.queryParameters;
                          if (params.containsKey('code')) {
                            await _handleAuthCallback(params);
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        // Also check for custom scheme
                        if (uri.scheme == 'com.infiforge.ringly') {
                          final params = uri.queryParameters;
                          if (params.containsKey('code')) {
                            await _handleAuthCallback(params);
                            return NavigationActionPolicy.CANCEL;
                          }
                        }
                      }
                      return NavigationActionPolicy.ALLOW;
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
        if (_isWebViewLoading) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Loading...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

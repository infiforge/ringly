import 'dart:async';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';

/// A service that creates a local loopback server to receive OAuth callbacks
/// This is the industry-standard approach for desktop OAuth flows
/// Used by VS Code, Slack, and many other desktop applications
class LoopbackServerService {
  HttpServer? _server;
  Completer<bool>? _serverStarted;
  static int _port = 54321; // Default port for loopback server

  /// Bring window to front (used on Linux where protocol handler isn't supported)
  Future<void> _bringWindowToFront() async {
    if (kIsWeb) return;

    try {
      await windowManager.show();
      await windowManager.focus();

      // Show in taskbar if it was hidden (Windows/Linux)
      if (Platform.isWindows || Platform.isLinux) {
        await windowManager.setSkipTaskbar(false);
      }

      developer.log('Window brought to front after OAuth callback');
    } catch (e) {
      developer.log('Failed to bring window to front: $e');
    }
  }

  /// Starts a server that listens for OAuth callbacks
  /// Returns the port number if successful, null if failed
  /// The callback is called when the OAuth code is received
  Future<void> handleCallBackFromProvider(
    Future<void> Function(Map<String, String> params) onCodeReceived,
  ) async {
    try {
      if (kDebugMode) {
        print('LoopbackServer: Starting loopback server on port $_port');
      }
      developer.log('Starting loopback server on port $_port');

      _serverStarted = Completer<bool>();

      // Try to bind to the default port
      try {
        _server = await HttpServer.bind(InternetAddress.loopbackIPv4, _port);
      } catch (e) {
        // If the default port is in use, try a few others
        for (var i = 0; i < 10; i++) {
          _port = 54322 + i;
          try {
            _server = await HttpServer.bind(
              InternetAddress.loopbackIPv4,
              _port,
            );
            break;
          } catch (e) {
            if (i == 9) {
              // Couldn't find an available port
              developer.log('Failed to start loopback server: $e');
            }
          }
        }
      }

      if (_server == null) {
        if (kDebugMode) {
          print(
              'LoopbackServer: Failed to start loopback server (no available port found)');
        }
        developer.log(
          'Failed to start loopback server (no available port found)',
        );
        _serverStarted?.complete(false);
        return;
      }

      if (kDebugMode) {
        print('LoopbackServer: Loopback server started on port $_port');
      }
      developer.log('OAuth loopback server started on port $_port');

      // Handle incoming requests
      _server!.listen((HttpRequest request) async {
        final path = request.uri.path;

        if (kDebugMode) {
          print('LoopbackServer: Received request: ${request.method} $path');
        }
        developer.log(
          'Loopback server received request: ${request.method} $path',
        );

        // Only handle OAuth callbacks on /auth/callback path
        if (path != '/auth/callback') {
          if (kDebugMode) {
            print('LoopbackServer: Ignoring non-auth request to $path');
          }
          // Return 404 for non-auth paths (favicon, etc.)
          request.response.statusCode = 404;
          await request.response.close();
          return;
        }

        final params = Map<String, String>.from(request.uri.queryParameters);
        developer.log('Request query parameters: $params');

        // CORS headers for browser compatibility
        request.response.headers.add('Access-Control-Allow-Origin', '*');
        request.response.headers.add(
          'Access-Control-Allow-Methods',
          'GET, POST, OPTIONS',
        );
        request.response.headers.add(
          'Access-Control-Allow-Headers',
          'Origin, Content-Type',
        );

        if (kDebugMode) {
          print('LoopbackServer: Received OAuth response: $params');
        }
        developer.log('Received OAuth response: $params', name: 'OAuth');
        params.forEach((key, value) {
          if (kDebugMode) {
            print('LoopbackServer: OAuth param - $key: $value');
          }
          developer.log('OAuth param - $key: $value', name: 'OAuth');
        });
        request.response.statusCode = 200;

        if (params.isEmpty) {
          // If no parameters are received, return an error
          if (kDebugMode) {
            print(
                'LoopbackServer: The parameters received from OAuth response are empty');
          }
          developer.log(
            'The parameters received from OAuth response are empty',
            name: 'OAuth',
          );
          request.response.headers.contentType = ContentType.html;
          request.response.statusCode = 400;
          request.response.write(_getErrorHtml());
          await request.response.close();
          params['error'] = 'Missing parameters';
          // Still call the callback so the app knows there was an error
          await onCodeReceived(params);
          await stopServer();
          return;
        }

        // Send success HTML immediately
        request.response.headers.contentType = ContentType.html;
        request.response.statusCode = 200;
        if (params.containsKey('error')) {
          request.response.write(_getErrorHtml(error: params['error']));
        } else {
          request.response.write(_getSuccessHtml());
        }
        await request.response.close();

        // Process the callback after sending response
        try {
          await onCodeReceived(params);
        } catch (e) {
          if (kDebugMode) {
            print('LoopbackServer: Error handling OAuth callback: $e');
          }
          developer.log('Error handling OAuth callback: $e');
        } finally {
          // Bring window to front on Linux (where protocol handler isn't supported)
          // On other platforms, the protocol handler will bring it to front
          if (Platform.isLinux) {
            await _bringWindowToFront();
          }
          await stopServer();
        }
      });

      _serverStarted!.complete(true);
    } catch (e) {
      if (kDebugMode) {
        print('LoopbackServer: Error starting loopback server: $e');
      }
      developer.log('Error starting loopback server: $e');
      _serverStarted?.completeError(e);
    }
  }

  /// Returns the redirect URI for the loopback server
  static String get redirectUri => 'http://localhost:$_port/auth/callback';

  /// Stops the server
  Future<void> stopServer() async {
    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
      developer.log('Loopback server stopped');
    }
  }

  /// Get success HTML page with Ringly branding and dark mode support
  String _getSuccessHtml() {
    final currentYear = DateTime.now().year;
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Authentication Successful - Ringly</title>
  <style>
    :root {
      --bg-gradient-start: #0D2B1A;
      --bg-gradient-end: #111D14;
      --container-bg: #1A2E1F;
      --text-primary: #FFFFFF;
      --text-secondary: #B8C5B9;
      --text-tertiary: #7A8A7C;
      --shadow-color: rgba(0, 0, 0, 0.5);
      --checkmark-bg: #4ADE80;
      --accent-color: #F5A623;
      --accent-glow: #FFD580;
    }
    
    @media (prefers-color-scheme: light) {
      :root {
        --bg-gradient-start: #1B2B27;
        --bg-gradient-end: #0F172A;
        --container-bg: #FFFFFF;
        --text-primary: #1E293B;
        --text-secondary: #64748B;
        --text-tertiary: #94A3B8;
        --shadow-color: rgba(0, 0, 0, 0.2);
        --checkmark-bg: #4ADE80;
        --accent-color: #F5A623;
        --accent-glow: #FFD580;
      }
    }
    
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      background: linear-gradient(135deg, var(--bg-gradient-start) 0%, var(--bg-gradient-end) 100%);
      margin: 0;
    }
    .container {
      text-align: center;
      padding: 48px 32px;
      background: var(--container-bg);
      border-radius: 24px;
      box-shadow: 0 20px 60px var(--shadow-color);
      max-width: 520px;
      width: 90%;
      transition: background-color 0.3s ease, max-width 0.3s ease;
      border: 1px solid rgba(245, 166, 35, 0.2);
    }
    
    /* Responsive: Larger screens get wider container */
    @media (min-width: 640px) {
      .container {
        max-width: 600px;
        padding: 56px 48px;
      }
    }
    
    @media (min-width: 1024px) {
      .container {
        max-width: 700px;
        padding: 64px 56px;
      }
    }
    
    .logo {
      width: 48px;
      height: 48px;
      margin: 0 auto 16px;
      border-radius: 12px;
      background: linear-gradient(135deg, var(--accent-color) 0%, var(--accent-glow) 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 20px rgba(245, 166, 35, 0.3);
    }
    .logo svg {
      width: 28px;
      height: 28px;
      fill: #0D2B1A;
    }
    .company-title {
      font-size: clamp(20px, 4vw, 28px);
      font-weight: 700;
      color: var(--text-primary);
      margin-bottom: 24px;
      letter-spacing: -0.5px;
      transition: color 0.3s ease;
    }
    .checkmark {
      width: 64px;
      height: 64px;
      margin: 0 auto 24px;
      background: var(--checkmark-bg);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      animation: scaleIn 0.5s ease-out;
      box-shadow: 0 4px 20px rgba(74, 222, 128, 0.4);
    }
    .checkmark svg {
      width: 32px;
      height: 32px;
      fill: white;
    }
    h1 {
      color: var(--text-primary);
      font-size: clamp(18px, 3vw, 24px);
      font-weight: 600;
      margin-bottom: 12px;
      transition: color 0.3s ease;
    }
    p {
      color: var(--text-secondary);
      font-size: clamp(14px, 2.5vw, 18px);
      line-height: 1.6;
      margin-bottom: 24px;
      transition: color 0.3s ease;
    }
    
    /* Allow wrapping on very small screens */
    @media (max-width: 480px) {
      .company-title, h1, p {
        white-space: normal;
      }
      .container {
        padding: 32px 20px;
      }
    }
    
    .launch-btn {
      background: linear-gradient(135deg, var(--accent-color) 0%, var(--accent-glow) 100%);
      color: #0D2B1A;
      border: none;
      padding: 14px 32px;
      font-size: clamp(14px, 2.5vw, 16px);
      font-weight: 600;
      border-radius: 12px;
    }
    .launch-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(245, 166, 35, 0.5);
    }
    .launch-btn:active {
      transform: translateY(0);
    }
    .brand {
      margin-top: 24px;
      font-size: clamp(12px, 2vw, 14px);
      color: var(--text-tertiary);
      font-weight: 500;
      transition: color 0.3s ease;
    }
    
    /* Small screens: allow text wrapping */
    @media (max-width: 480px) {
      .brand {
        white-space: normal;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="logo">
      <svg viewBox="0 0 24 24"><path d="M20.01 15.38c-1.23 0-2.42-.2-3.53-.56-.35-.12-.74-.03-1.01.24l-1.57 1.97c-2.83-1.44-5.15-3.75-6.59-6.59l1.97-1.57c.27-.26.36-.65.25-1.01-.37-1.11-.56-2.3-.56-3.53 0-.54-.45-.99-.99-.99H4.19C3.65 2 3 2.24 3 3.01 3 13.28 12.72 23 22.99 23c.71 0 .99-.63.99-1.18v-3.45c0-.53-.45-.99-.99-.99z"/></svg>
    </div>
    <div class="company-title">Ringly</div>
    <div class="checkmark">
      <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
    </div>
    <h1>Authentication Successful</h1>
    <p>You have successfully signed in to Ringly.<br>You can now return to the app.</p>
    <a href="ringly://auth/success" class="launch-btn" id="launchBtn">Open Ringly</a>
    <div class="brand">© 2025 - $currentYear Ringly by Infiforge</div>
    <div class="manual-close">This tab will close automatically</div>
  </div>
  <script>
    // Auto-redirect to app after 1 second
    setTimeout(function() {
      window.location.href = 'ringly://auth/success';
    }, 1000);
    
    // Close tab after 5 seconds if possible
    setTimeout(function() {
      window.close();
    }, 5000);
    
    // Listen for dark mode changes
    if (window.matchMedia) {
      const darkModeQuery = window.matchMedia('(prefers-color-scheme: dark)');
      darkModeQuery.addEventListener('change', function(e) {
        // CSS variables will update automatically
        console.log('Dark mode:', e.matches);
      });
    }
  </script>
</body>
</html>
''';
  }

  /// Get error HTML page with Ringly branding and dark mode support
  String _getErrorHtml({String? error}) {
    final currentYear = DateTime.now().year;
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Authentication Error - Ringly</title>
  <style>
    :root {
      --bg-gradient-start: #0D2B1A;
      --bg-gradient-end: #111D14;
      --container-bg: #1A2E1F;
      --text-primary: #FFFFFF;
      --text-secondary: #B8C5B9;
      --text-tertiary: #7A8A7C;
      --shadow-color: rgba(0, 0, 0, 0.5);
      --error-icon-bg: #ef4444;
      --error-details-bg: #7f1d1d;
      --error-details-text: #fca5a5;
      --accent-color: #F5A623;
      --accent-glow: #FFD580;
    }
    
    @media (prefers-color-scheme: light) {
      :root {
        --bg-gradient-start: #1B2B27;
        --bg-gradient-end: #0F172A;
        --container-bg: #FFFFFF;
        --text-primary: #1E293B;
        --text-secondary: #64748B;
        --text-tertiary: #94A3B8;
        --shadow-color: rgba(0, 0, 0, 0.2);
        --error-icon-bg: #ef4444;
        --error-details-bg: #fee2e2;
        --error-details-text: #dc2626;
        --accent-color: #F5A623;
        --accent-glow: #FFD580;
      }
    }
    
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      background: linear-gradient(135deg, var(--bg-gradient-start) 0%, var(--bg-gradient-end) 100%);
      margin: 0;
    }
    .container {
      text-align: center;
      padding: 48px 32px;
      background: var(--container-bg);
      border-radius: 24px;
      box-shadow: 0 20px 60px var(--shadow-color);
      max-width: 520px;
      width: 90%;
      transition: background-color 0.3s ease, max-width 0.3s ease;
      border: 1px solid rgba(245, 166, 35, 0.2);
    }
    
    /* Responsive: Larger screens get wider container */
    @media (min-width: 640px) {
      .container {
        max-width: 600px;
        padding: 56px 48px;
      }
    }
    
    @media (min-width: 1024px) {
      .container {
        max-width: 700px;
        padding: 64px 56px;
      }
    }
    
    .logo {
      width: 48px;
      height: 48px;
      margin: 0 auto 16px;
      border-radius: 12px;
      background: linear-gradient(135deg, var(--accent-color) 0%, var(--accent-glow) 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 20px rgba(245, 166, 35, 0.3);
    }
    .logo svg {
      width: 28px;
      height: 28px;
      fill: #0D2B1A;
    }
    .company-title {
      font-size: clamp(20px, 4vw, 28px);
      font-weight: 700;
      color: var(--text-primary);
      margin-bottom: 24px;
      letter-spacing: -0.5px;
      transition: color 0.3s ease;
    }
    .error-icon {
      width: 64px;
      height: 64px;
      margin: 0 auto 24px;
      background: var(--error-icon-bg);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      animation: shake 0.5s ease-out;
      box-shadow: 0 4px 20px rgba(239, 68, 68, 0.4);
    }
    .error-icon svg {
      width: 32px;
      height: 32px;
      fill: white;
    }
    @keyframes shake {
      0%, 100% { transform: translateX(0); }
      25% { transform: translateX(-10px); }
      75% { transform: translateX(10px); }
    }
    h1 {
      color: var(--text-primary);
      font-size: clamp(18px, 3vw, 24px);
      font-weight: 600;
      margin-bottom: 12px;
      transition: color 0.3s ease;
    }
    p {
      color: var(--text-secondary);
      font-size: clamp(14px, 2.5vw, 18px);
      line-height: 1.6;
      margin-bottom: 24px;
      transition: color 0.3s ease;
    }
    
    /* Allow wrapping on very small screens */
    @media (max-width: 480px) {
      .company-title, h1, p {
        white-space: normal;
      }
      .container {
        padding: 32px 20px;
      }
    }
    
    .error-details {
      background: var(--error-details-bg);
      color: var(--error-details-text);
      padding: 12px 16px;
      border-radius: 8px;
      font-size: clamp(12px, 2vw, 14px);
      margin-bottom: 24px;
      font-family: monospace;
      word-break: break-word;
    }
    .brand {
      margin-top: 24px;
      font-size: clamp(12px, 2vw, 14px);
      color: var(--text-tertiary);
      font-weight: 500;
      transition: color 0.3s ease;
    }
    
    /* Small screens: allow text wrapping */
    @media (max-width: 480px) {
      .brand {
        white-space: normal;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="logo">
      <svg viewBox="0 0 24 24"><path d="M20.01 15.38c-1.23 0-2.42-.2-3.53-.56-.35-.12-.74-.03-1.01.24l-1.57 1.97c-2.83-1.44-5.15-3.75-6.59-6.59l1.97-1.57c.27-.26.36-.65.25-1.01-.37-1.11-.56-2.3-.56-3.53 0-.54-.45-.99-.99-.99H4.19C3.65 2 3 2.24 3 3.01 3 13.28 12.72 23 22.99 23c.71 0 .99-.63.99-1.18v-3.45c0-.53-.45-.99-.99-.99z"/></svg>
    </div>
    <div class="company-title">Ringly</div>
    <div class="error-icon">
      <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>
    </div>
    <h1>Authentication Failed</h1>
    <p>Something went wrong during authentication. Please try again.</p>
    \${error != null ? '<div class="error-details">$error</div>' : ''}
    <div class="brand">© 2025 - $currentYear Ringly by Infiforge</div>
  </div>
  <script>
    // Listen for dark mode changes
    if (window.matchMedia) {
      const darkModeQuery = window.matchMedia('(prefers-color-scheme: dark)');
      darkModeQuery.addEventListener('change', function(e) {
        console.log('Dark mode:', e.matches);
      });
    }
  </script>
</body>
</html>
''';
  }
}

// Helper function to avoid import
int min(int a, int b) => a < b ? a : b;

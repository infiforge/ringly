import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:window_manager/window_manager.dart';
import 'package:ringly/app_router.dart';
import 'package:ringly/theme/app_theme.dart';
import 'package:ringly/providers/app_providers.dart';
import 'package:ringly/services/logger_service.dart';
import 'package:ringly/services/auth_service.dart';
import 'package:ringly/services/storage_service.dart';
import 'package:ringly/services/settings_service.dart';

final routerProvider = Provider((ref) => AppRouter());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window manager for desktop
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 720),
      minimumSize: Size(900, 600),
      center: true,
      title: 'Ringly',
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Use path-based URLs instead of hash URLs for web
  if (kIsWeb) {
    usePathUrlStrategy();
  }

  // Initialize services
  await initializeLoggerService();
  await initializeStorageService();
  await initializeAuthService();
  await initializeSettingsService();

  runApp(
    const ProviderScope(
      child: RinglyApp(),
    ),
  );

  // Configure desktop window
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(1280, 720);
      win.minSize = const Size(900, 600);
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = 'Ringly';
      win.show();
    });
  }
}

class RinglyApp extends ConsumerWidget {
  const RinglyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Ringly',
      debugShowCheckedModeBanner: kDebugMode,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router.config(),
    );
  }
}

import 'dart:io' show Platform;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/admin/admin_page.dart';
import 'pages/auth/auth_page.dart';
import 'pages/home/home_page.dart';
import 'pages/setup/setup_page.dart';
import 'pages/website/website_page.dart';
import 'services/auth_service.dart';
import 'services/settings_service.dart';

part 'app_router.gr.dart';

// Platform enum for guard filtering
enum AppPlatform {
  web,
  android,
  ios,
  windows,
  macos,
  linux,
}

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: HomeRoute.page,
          initial: true,
          fullMatch: true,
          guards: [
            PlatformGuard(blockedPlatforms: [AppPlatform.web]),
            SetupGuard(),
            AuthGuard(),
          ],
        ),
        AutoRoute(
          path: '/admin',
          page: AdminRoute.page,
          guards: [
            PlatformGuard(blockedPlatforms: [AppPlatform.web]),
            SetupGuard(),
            AuthGuard(),
            AdminGuard(),
          ],
        ),
        AutoRoute(
          path: '/auth',
          page: AuthRoute.page,
          fullMatch: false,
          guards: [
            PlatformGuard(blockedPlatforms: [AppPlatform.web]),
            SetupGuard(),
          ],
        ),
        AutoRoute(
          path: '/setup',
          page: SetupRoute.page,
          guards: [
            PlatformGuard(blockedPlatforms: [
              AppPlatform.web,
              AppPlatform.android,
              AppPlatform.ios
            ]),
          ],
        ),
        AutoRoute(
          path: '/website',
          page: WebsiteRoute.page,
          guards: [
            PlatformGuard(blockedPlatforms: [
              AppPlatform.android,
              AppPlatform.ios,
              AppPlatform.windows,
              AppPlatform.macos,
              AppPlatform.linux,
            ]),
          ],
        ),
      ];
}

// PlatformGuard: Blocks access based on current platform
// Redirects to appropriate fallback page
class PlatformGuard extends AutoRouteGuard {
  final List<AppPlatform> blockedPlatforms;

  PlatformGuard({required this.blockedPlatforms});

  AppPlatform _getCurrentPlatform() {
    if (kIsWeb) return AppPlatform.web;
    if (Platform.isAndroid) return AppPlatform.android;
    if (Platform.isIOS) return AppPlatform.ios;
    if (Platform.isWindows) return AppPlatform.windows;
    if (Platform.isMacOS) return AppPlatform.macos;
    if (Platform.isLinux) return AppPlatform.linux;
    return AppPlatform.linux; // Fallback
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final currentPlatform = _getCurrentPlatform();

    if (blockedPlatforms.contains(currentPlatform)) {
      // Current platform is blocked: Redirect to appropriate page
      resolver.next(false);

      if (currentPlatform == AppPlatform.web) {
        // Web goes to website
        router.replaceAll([const WebsiteRoute()]);
      } else {
        // Desktop/mobile blocked goes to auth or home
        router.replace(const AuthRoute());
      }
    } else {
      // Platform is allowed: Continue
      resolver.next(true);
    }
  }
}

// SetupGuard: Blocks access if on desktop and setup not complete
// Redirects to setup page (desktop only)
class SetupGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Mobile: Always allow (skip setup)
    if (Platform.isAndroid || Platform.isIOS) {
      resolver.next(true);
      return;
    }

    // Desktop: Check if setup is complete
    final context = router.navigatorKey.currentContext;
    if (context != null) {
      final settings = ProviderScope.containerOf(
        context,
        listen: false,
      ).read(settingsServiceProvider);

      if (!settings.setupCompleted) {
        // Setup not complete: Block access and redirect to setup
        resolver.next(false);
        router.replace(const SetupRoute());
      } else {
        // Setup complete: Allow access
        resolver.next(true);
      }
    } else {
      resolver.next(true);
    }
  }
}

// AuthGuard: Blocks access if user is not authenticated
// Redirects to auth page
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final context = router.navigatorKey.currentContext;
    if (context != null) {
      final authService = authServiceSingleton;
      final isAuthenticated = await authService.isAuthenticated();

      if (isAuthenticated) {
        // User is authenticated: Allow access
        resolver.next(true);
      } else {
        // User is not authenticated: Block access and redirect to auth
        resolver.next(false);
        router.replace(const AuthRoute());
      }
    } else {
      resolver.next(false);
      router.replace(const AuthRoute());
    }
  }
}

// AdminGuard: Blocks access if user is not an admin
// Redirects to home page
class AdminGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final context = router.navigatorKey.currentContext;
    if (context != null) {
      final authService = authServiceSingleton;
      final user = await authService.getUser();
      final email = user?['email'] ?? '';

      if (AuthService.adminEmails.contains(email)) {
        // User is admin: Allow access
        resolver.next(true);
      } else {
        // User is not admin: Block access and redirect to home
        resolver.next(false);
        router.replace(const HomeRoute());
      }
    } else {
      resolver.next(false);
      router.replace(const HomeRoute());
    }
  }
}

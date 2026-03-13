import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/sidebar.dart';
import '../../providers/app_providers.dart';
import 'dashboard_page.dart';
import 'call_log_page.dart';
import 'whatsapp_page.dart';
import 'utm_builder_page.dart';
import 'tracking_setup_page.dart';
import 'ga4_guide_page.dart';
import 'settings_page.dart';

@RoutePage()
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNavItem = ref.watch(selectedNavItemProvider);

    return Scaffold(
      body: Row(
        children: [
          const AppSidebar(),
          Expanded(
            child: _buildContent(selectedNavItem),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String selectedNavItem) {
    switch (selectedNavItem) {
      case 'dashboard':
        return const DashboardPage();
      case 'calls':
        return const CallLogPage();
      case 'whatsapp':
        return const WhatsAppPage();
      case 'utm':
        return const UtmBuilderPage();
      case 'tracking':
        return const TrackingSetupPage();
      case 'ga4':
        return const Ga4GuidePage();
      case 'settings':
        return const SettingsPage();
      default:
        return const DashboardPage();
    }
  }
}

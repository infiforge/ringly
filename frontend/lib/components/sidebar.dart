import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../services/auth_service.dart';

class SidebarItem {
  final String id;
  final String label;
  final IconData icon;
  final String? route;

  const SidebarItem({
    required this.id,
    required this.label,
    required this.icon,
    this.route,
  });
}

class AppSidebar extends ConsumerWidget {
  const AppSidebar({super.key});

  static const List<SidebarItem> navItems = [
    SidebarItem(id: 'dashboard', label: 'Dashboard', icon: Icons.bar_chart_outlined),
    SidebarItem(id: 'calls', label: 'Call Log', icon: Icons.phone_outlined),
    SidebarItem(id: 'whatsapp', label: 'WhatsApp', icon: Icons.chat_bubble_outline),
    SidebarItem(id: 'utm', label: 'UTM Builder', icon: Icons.link_outlined),
    SidebarItem(id: 'tracking', label: 'Tracking Setup', icon: Icons.track_changes_outlined),
    SidebarItem(id: 'ga4', label: 'GA4 Guide', icon: Icons.analytics_outlined),
    SidebarItem(id: 'settings', label: 'Settings', icon: Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedNavItemProvider);
    final isCollapsed = ref.watch(sidebarCollapsedProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: isCollapsed ? AppSpacing.sidebarCollapsedWidth : AppSpacing.sidebarWidth,
      color: AppColors.sidebarBackground,
      child: Column(
        children: [
          // App Logo Section
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: isCollapsed
                ? Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: const Icon(
                      Icons.phone_in_talk,
                      color: AppColors.sidebarBackground,
                      size: 24,
                    ),
                  )
                : Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.accentGreen,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: const Icon(
                          Icons.phone_in_talk,
                          color: AppColors.sidebarBackground,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ringly',
                              style: TextStyle(
                                color: AppColors.sidebarText,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Kenya Ad Intelligence',
                              style: TextStyle(
                                color: AppColors.sidebarTextMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),

          const Divider(color: AppColors.sidebarBackgroundHover, height: 1),

          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = selectedItem == item.id;

                return _NavItem(
                  item: item,
                  isSelected: isSelected,
                  isCollapsed: isCollapsed,
                  onTap: () {
                    ref.read(selectedNavItemProvider.notifier).state = item.id;
                    // Navigate to the appropriate page
                    _handleNavigation(context, item.id);
                  },
                );
              },
            ),
          ),

          const Divider(color: AppColors.sidebarBackgroundHover, height: 1),

          // Collapse/Expand Button
          _buildCollapseButton(ref, isCollapsed),

          // User Profile Section
          _buildUserSection(context, ref, isCollapsed),
        ],
      ),
    );
  }

  Widget _buildCollapseButton(WidgetRef ref, bool isCollapsed) {
    return InkWell(
      onTap: () {
        ref.read(sidebarCollapsedProvider.notifier).state = !isCollapsed;
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(
              isCollapsed ? Icons.chevron_right : Icons.chevron_left,
              color: AppColors.sidebarTextMuted,
              size: 20,
            ),
            if (!isCollapsed) ...[
              const SizedBox(width: AppSpacing.sm),
              const Text(
                'Collapse',
                style: TextStyle(
                  color: AppColors.sidebarTextMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserSection(BuildContext context, WidgetRef ref, bool isCollapsed) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: isCollapsed
          ? InkWell(
              onTap: () => _showLogoutDialog(context, ref),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.sidebarBackgroundHover,
                child: Icon(
                  Icons.person,
                  color: AppColors.sidebarText,
                  size: 20,
                ),
              ),
            )
          : InkWell(
              onTap: () => _showLogoutDialog(context, ref),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.sidebarBackgroundHover,
                    child: Icon(
                      Icons.person,
                      color: AppColors.sidebarText,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Admin User',
                          style: TextStyle(
                            color: AppColors.sidebarText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'admin@ringly.co.ke',
                          style: TextStyle(
                            color: AppColors.sidebarTextMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.logout,
                    color: AppColors.sidebarTextMuted,
                    size: 18,
                  ),
                ],
              ),
            ),
    );
  }

  void _handleNavigation(BuildContext context, String id) {
    // Navigation will be handled by the parent widget
    // This is called when a nav item is tapped
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authServiceSingleton.logout();
              if (context.mounted) {
                context.router.replaceNamed('/auth');
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final SidebarItem item;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 2,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: isCollapsed ? AppSpacing.md : 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sidebarBackgroundHover : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: isCollapsed
            ? Center(
                child: Icon(
                  item.icon,
                  color: isSelected ? AppColors.accentGreen : AppColors.sidebarTextMuted,
                  size: 22,
                ),
              )
            : Row(
                children: [
                  Icon(
                    item.icon,
                    color: isSelected ? AppColors.accentGreen : AppColors.sidebarTextMuted,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected ? AppColors.sidebarText : AppColors.sidebarTextMuted,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

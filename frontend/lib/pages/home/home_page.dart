import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;

import 'package:ringly/services/auth_service.dart';
import 'package:ringly/services/settings_service.dart';
import 'package:ringly/theme/app_theme.dart';
import 'package:ringly/providers/app_providers.dart';

import 'dashboard_page.dart';
import 'call_log_page.dart';
import 'whatsapp_page.dart';
import 'utm_builder_page.dart';
import 'tracking_setup_page.dart';
import 'ga4_guide_page.dart';
import 'settings_page.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  bool _isDrawerExpanded = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInitialized = false;

  // User authentication status
  bool _isUserSignedIn = false;
  bool _isCheckingAuth = true;

  final _authService = authServiceSingleton;

  final List<_NavItemData> _navItems = [
    _NavItemData(
        id: 'dashboard', label: 'Dashboard', icon: Icons.bar_chart_outlined),
    _NavItemData(id: 'calls', label: 'Call Log', icon: Icons.phone_outlined),
    _NavItemData(
        id: 'whatsapp', label: 'WhatsApp', icon: Icons.chat_bubble_outline),
    _NavItemData(id: 'utm', label: 'UTM Builder', icon: Icons.link_outlined),
    _NavItemData(
        id: 'tracking',
        label: 'Tracking Setup',
        icon: Icons.track_changes_outlined),
    _NavItemData(id: 'ga4', label: 'GA4 Guide', icon: Icons.analytics_outlined),
    _NavItemData(
        id: 'settings', label: 'Settings', icon: Icons.settings_outlined),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await _authService.isAuthenticated();
      if (mounted) {
        setState(() {
          _isUserSignedIn = isLoggedIn;
          _isCheckingAuth = false;
        });
      }
    } catch (e) {
      developer.log('Error checking auth status: $e');
      if (mounted) {
        setState(() {
          _isCheckingAuth = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _updateDrawerState();
      _isInitialized = true;
    }
    _checkAuthStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (mounted) {
      _updateDrawerState();
    }
  }

  void _updateDrawerState() {
    if (!mounted) return;

    final size = MediaQuery.of(context).size;
    final bool isLargeScreen = size.width >= 1024;
    final bool isMediumScreen = size.width >= 600 && size.width < 1024;

    setState(() {
      if (isLargeScreen) {
        _isDrawerExpanded = true;
      } else if (isMediumScreen) {
        _isDrawerExpanded = false;
      }
    });
  }

  void _onSelectItem(int index) {
    if (MediaQuery.of(context).size.width < 600) {
      Navigator.of(context).pop();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleSignOut() async {
    try {
      await _authService.logout();
      if (mounted) {
        setState(() {
          _isUserSignedIn = false;
        });
        context.router.replaceNamed('/auth');
      }
    } catch (e) {
      developer.log('Error during sign out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 600;
    final bool isMediumScreen = size.width >= 600 && size.width < 1024;
    final bool isLargeScreen = size.width >= 1024;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final appBgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardBgColor = Theme.of(context).cardColor;
    final primaryTextColor = Theme.of(context).colorScheme.onSurface;

    if (isLargeScreen && !_isDrawerExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isDrawerExpanded = true;
        });
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appBgColor,
      drawer: isSmallScreen ? _buildDrawer(context, ref) : null,
      body: Row(
        children: [
          if (!isSmallScreen)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isDrawerExpanded || isLargeScreen ? 200 : 70,
              child: _buildSidebarContent(
                context,
                ref,
                _selectedIndex,
                _onSelectItem,
                _isDrawerExpanded || isLargeScreen,
              ),
            ),
          Expanded(child: _buildMainContent(context, _selectedIndex)),
        ],
      ),
      floatingActionButton: isSmallScreen
          ? FloatingActionButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
              foregroundColor: primaryTextColor,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(
                  color:
                      isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: const Icon(Icons.menu, size: 28),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: _buildSidebarContent(
        context,
        ref,
        _selectedIndex,
        _onSelectItem,
        true,
      ),
    );
  }

  Widget _buildSidebarContent(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
    ValueChanged<int> onSelectItem,
    bool isExpanded,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final sidebarBgColor = AppColors.sidebarBackground;
    final sidebarTextColor = AppColors.sidebarTextMuted;
    final sidebarHighlightColor = AppColors.accentGreen.withValues(alpha: 0.15);
    final sidebarSelectedBgColor = AppColors.sidebarBackgroundHover;
    final sidebarHoverColor = AppColors.accentGreen.withValues(alpha: 0.08);
    final sidebarIndicatorColor = AppColors.accentGreen;
    final sidebarSelectedTextColor = AppColors.sidebarText;
    final sidebarSelectedIconColor = AppColors.accentGreen;
    final profileBgColor = AppColors.sidebarBackgroundHover;

    return Container(
      decoration: BoxDecoration(color: sidebarBgColor),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),

          // App Logo Section
          if (isExpanded)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: profileBgColor),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.phone_in_talk,
                      color: AppColors.sidebarBackground,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ringly',
                    style: TextStyle(
                      color: AppColors.sidebarText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Kenya Ad Intelligence',
                    style: TextStyle(
                      color: AppColors.sidebarTextMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: profileBgColor),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.phone_in_talk,
                      color: AppColors.sidebarBackground,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

          const Divider(color: AppColors.sidebarBackgroundHover, height: 1),

          // User Profile Section
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<Map<String, dynamic>?>(
                future: _authService.getUser(),
                builder: (context, snapshot) {
                  final userData = snapshot.data;
                  final name = userData?['name'] ?? 'User';
                  final email = userData?['email'] ?? '';

                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.sidebarBackgroundHover,
                        child: Icon(
                          Icons.person,
                          color: AppColors.sidebarText,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.sidebarText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (email.isNotEmpty)
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.sidebarTextMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _handleSignOut,
                        icon: const Icon(Icons.logout, size: 16),
                        label: const Text('Sign out'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.sidebarTextMuted,
                          minimumSize: const Size(double.infinity, 36),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          else
            InkWell(
              onTap: _handleSignOut,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.sidebarBackgroundHover,
                  child: Icon(
                    Icons.person,
                    color: AppColors.sidebarText,
                    size: 20,
                  ),
                ),
              ),
            ),

          const Divider(color: AppColors.sidebarBackgroundHover, height: 1),

          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final item = _navItems[index];
                return _buildMenuItem(
                  context: context,
                  text: item.label,
                  icon: item.icon,
                  index: index,
                  selectedIndex: selectedIndex,
                  onSelectItem: onSelectItem,
                  isExpanded: isExpanded,
                  sidebarTextColor: sidebarTextColor,
                  sidebarHighlightColor: sidebarHighlightColor,
                  sidebarHoverColor: sidebarHoverColor,
                  sidebarIndicatorColor: sidebarIndicatorColor,
                  sidebarSelectedTextColor: sidebarSelectedTextColor,
                  sidebarSelectedIconColor: sidebarSelectedIconColor,
                  sidebarSelectedBgColor: sidebarSelectedBgColor,
                  sidebarBgColor: sidebarBgColor,
                );
              },
            ),
          ),

          const Divider(color: AppColors.sidebarBackgroundHover, height: 1),

          // Collapse/Expand Button
          InkWell(
            onTap: () {
              setState(() {
                _isDrawerExpanded = !_isDrawerExpanded;
              });
            },
            child: Container(
              height: 44,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: sidebarBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: isExpanded
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  if (isExpanded) const SizedBox(width: 16),
                  Icon(
                    isExpanded ? Icons.chevron_left : Icons.chevron_right,
                    color: sidebarTextColor,
                    size: 20,
                  ),
                  if (isExpanded) ...[
                    const SizedBox(width: 12),
                    Text(
                      'Collapse',
                      style: TextStyle(
                        color: sidebarTextColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String text,
    required IconData icon,
    required int index,
    required int selectedIndex,
    required ValueChanged<int> onSelectItem,
    required bool isExpanded,
    required Color sidebarTextColor,
    required Color sidebarHighlightColor,
    required Color sidebarHoverColor,
    required Color sidebarIndicatorColor,
    required Color sidebarSelectedTextColor,
    required Color sidebarSelectedIconColor,
    required Color sidebarSelectedBgColor,
    required Color sidebarBgColor,
  }) {
    final bool isSelected = index == selectedIndex;
    final Color color =
        isSelected ? sidebarSelectedTextColor : sidebarTextColor;
    final Color iconColor =
        isSelected ? sidebarSelectedIconColor : sidebarIndicatorColor;
    final Color? tileColor = isSelected ? sidebarSelectedBgColor : null;
    final Widget leadingIndicator = isSelected
        ? Container(
            width: 4,
            height: 32,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: sidebarIndicatorColor,
              borderRadius: BorderRadius.circular(2),
            ),
          )
        : const SizedBox(width: 12);

    return Material(
      color: tileColor ?? sidebarBgColor,
      child: InkWell(
        onTap: () => onSelectItem(index),
        borderRadius: BorderRadius.circular(8),
        hoverColor: sidebarHoverColor,
        child: Container(
          height: 44,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              leadingIndicator,
              SizedBox(width: isExpanded ? 12 : 8),
              Icon(icon, color: iconColor, size: 20),
              if (isExpanded) ...[
                const SizedBox(width: 12),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight:
                        isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const DashboardPage();
      case 1:
        return const CallLogPage();
      case 2:
        return const WhatsAppPage();
      case 3:
        return const UtmBuilderPage();
      case 4:
        return const TrackingSetupPage();
      case 5:
        return const Ga4GuidePage();
      case 6:
        return const SettingsPage();
      default:
        return const DashboardPage();
    }
  }
}

class _NavItemData {
  final String id;
  final String label;
  final IconData icon;

  _NavItemData({
    required this.id,
    required this.label,
    required this.icon,
  });
}

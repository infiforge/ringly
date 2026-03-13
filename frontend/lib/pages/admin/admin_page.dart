import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ringly/services/auth_service.dart';
import 'package:ringly/theme/app_theme.dart';

@RoutePage()
class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  bool _isDrawerExpanded = false;
  bool _isSearchBarVisible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInitialized = false;

  final List<_AdminNavItem> _navItems = [
    _AdminNavItem(label: 'Dashboard', icon: Icons.dashboard),
    _AdminNavItem(label: 'Logs', icon: Icons.list_alt),
    _AdminNavItem(label: 'Server', icon: Icons.cloud),
    _AdminNavItem(label: 'Users', icon: Icons.people),
    _AdminNavItem(label: 'Tests', icon: Icons.science),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _updateDrawerState();
      _isInitialized = true;
    }
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
    setState(() {
      _selectedIndex = index;
      if (MediaQuery.of(context).size.width < 600) {
        Navigator.of(context).pop();
      }
    });
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerExpanded = !_isDrawerExpanded;
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _isSearchBarVisible = !_isSearchBarVisible;
    });
  }

  Future<void> _handleSignOut() async {
    await authServiceSingleton.logout();
    if (mounted) {
      context.router.replaceNamed('/auth');
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
    final secondaryTextColor =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    final searchBarFillColor = isDarkMode
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.4);
    final searchBarBorderColor =
        isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          !isLargeScreen && _isSearchBarVisible ? 112 : 56,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAppBar(context, isSmallScreen, isMediumScreen, isLargeScreen),
            if (!isLargeScreen && _isSearchBarVisible)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 56,
                decoration: BoxDecoration(
                  color: cardBgColor,
                  border: Border(
                    bottom: BorderSide(color: searchBarBorderColor, width: 1),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: secondaryTextColor,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: secondaryTextColor,
                              size: 20,
                            ),
                            filled: true,
                            fillColor: searchBarFillColor,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: searchBarBorderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: searchBarBorderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          autofocus: true,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _toggleSearchBar,
                        color: primaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
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
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    bool isSmallScreen,
    bool isMediumScreen,
    bool isLargeScreen,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = Theme.of(context).cardColor;
    final primaryTextColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    final searchBarFillColor = isDarkMode
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.4);
    final searchBarBorderColor =
        isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.router.pop(),
            color: primaryTextColor,
          ),
          Text(
            _getAppBarTitle(_selectedIndex),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryTextColor,
            ),
          ),
        ],
      ),
      backgroundColor: cardBgColor,
      elevation: 1,
      actions: [
        if (!isLargeScreen)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _toggleSearchBar,
            color: primaryTextColor,
          ),
        if (isLargeScreen)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: 250,
              height: 30,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(fontSize: 14, color: secondaryTextColor),
                  prefixIcon: Icon(
                    Icons.search,
                    color: secondaryTextColor,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: searchBarFillColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: searchBarBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: searchBarBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(width: 10),
        if (isSmallScreen)
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            color: primaryTextColor,
          ),
        if (isMediumScreen)
          IconButton(
            icon: Icon(_isDrawerExpanded ? Icons.menu_open : Icons.menu),
            onPressed: _toggleDrawer,
            color: primaryTextColor,
          ),
        const SizedBox(width: 8),
      ],
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sidebarBgColor = AppColors.sidebarBackground;
    final sidebarTextColor = AppColors.sidebarTextMuted;
    final sidebarHighlightColor = AppColors.accentGreen.withValues(alpha: 0.15);
    final sidebarSelectedBgColor = AppColors.sidebarBackgroundHover;
    final sidebarHoverColor = AppColors.accentGreen.withValues(alpha: 0.08);
    final sidebarIndicatorColor = AppColors.accentGreen;
    final sidebarSelectedTextColor = AppColors.sidebarText;
    final sidebarSelectedIconColor = AppColors.accentGreen;

    return Container(
      decoration: BoxDecoration(color: sidebarBgColor),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),

          // Admin Header
          if (isExpanded)
            Container(
              width: double.infinity,
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
                      Icons.admin_panel_settings,
                      color: AppColors.sidebarBackground,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Admin Portal',
                    style: TextStyle(
                      color: AppColors.sidebarText,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Ringly System',
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
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: AppColors.sidebarBackground,
                  size: 24,
                ),
              ),
            ),

          const Divider(color: AppColors.sidebarBackgroundHover, height: 1),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < _navItems.length; i++)
                    _buildMenuItem(
                      context: context,
                      text: _navItems[i].label,
                      icon: _navItems[i].icon,
                      index: i,
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
                    ),
                ],
              ),
            ),
          ),

          const Divider(color: AppColors.sidebarBackgroundHover, height: 1),

          // Back to App Button
          InkWell(
            onTap: () => context.router.replaceNamed('/'),
            borderRadius: BorderRadius.circular(8),
            hoverColor: sidebarHoverColor,
            child: Container(
              height: 44,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: sidebarBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(Icons.arrow_back, color: sidebarTextColor, size: 20),
                  if (isExpanded) ...[
                    const SizedBox(width: 12),
                    Text(
                      'Back to App',
                      style: TextStyle(
                        color: sidebarTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Sign Out Button
          InkWell(
            onTap: _handleSignOut,
            borderRadius: BorderRadius.circular(8),
            hoverColor: sidebarHoverColor,
            child: Container(
              height: 44,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: sidebarBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(Icons.logout, color: sidebarTextColor, size: 20),
                  if (isExpanded) ...[
                    const SizedBox(width: 12),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        color: sidebarTextColor,
                        fontSize: 14,
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
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: sidebarIndicatorColor.withValues(alpha: 0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
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

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Admin Dashboard';
      case 1:
        return 'System Logs';
      case 2:
        return 'Server Status';
      case 3:
        return 'User Management';
      case 4:
        return 'System Tests';
      default:
        return 'Admin Portal';
    }
  }

  Widget _buildMainContent(BuildContext context, int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return _buildDashboardScreen();
      case 1:
        return _buildLogsScreen();
      case 2:
        return _buildServerScreen();
      case 3:
        return _buildUsersScreen();
      case 4:
        return _buildTestsScreen();
      default:
        return _buildDashboardScreen();
    }
  }

  Widget _buildDashboardScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('System Overview'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildMetricCard(
                  'Total Calls', '1,234', Icons.phone, Colors.green),
              _buildMetricCard('Active Users', '56', Icons.people, Colors.blue),
              _buildMetricCard(
                  'Campaigns', '12', Icons.campaign, Colors.orange),
              _buildMetricCard(
                  'Conversion Rate', '8.5%', Icons.trending_up, Colors.purple),
            ],
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('Recent Activity'),
          const SizedBox(height: 16),
          _buildActivityList(),
        ],
      ),
    );
  }

  Widget _buildLogsScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('System Logs'),
          const SizedBox(height: 16),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final logTypes = ['INFO', 'WARN', 'ERROR', 'DEBUG'];
                final colors = [
                  Colors.blue,
                  Colors.orange,
                  Colors.red,
                  Colors.grey
                ];
                final type = logTypes[index % logTypes.length];
                final color = colors[index % colors.length];

                return ListTile(
                  leading: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text('Log entry ${index + 1}: System event occurred'),
                  subtitle: Text('2024-01-${15 + index} 10:${30 + index}:00'),
                  dense: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Server Status'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildStatusCard(
                  'API Server', 'Online', Colors.green, Icons.cloud_done),
              _buildStatusCard(
                  'Database', 'Online', Colors.green, Icons.storage),
              _buildStatusCard('WebSocket', 'Online', Colors.green, Icons.sync),
              _buildStatusCard(
                  'Redis Cache', 'Online', Colors.green, Icons.memory),
            ],
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('Resource Usage'),
          const SizedBox(height: 16),
          _buildResourceBars(),
        ],
      ),
    );
  }

  Widget _buildUsersScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('User Management'),
          const SizedBox(height: 16),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final names = [
                  'John Doe',
                  'Jane Smith',
                  'Bob Johnson',
                  'Alice Brown',
                  'Charlie Wilson'
                ];
                final emails = [
                  'john@example.com',
                  'jane@example.com',
                  'bob@example.com',
                  'alice@example.com',
                  'charlie@example.com'
                ];
                final roles = ['Admin', 'User', 'User', 'Manager', 'User'];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(names[index][0]),
                  ),
                  title: Text(names[index]),
                  subtitle: Text(emails[index]),
                  trailing: Chip(
                    label: Text(roles[index]),
                    backgroundColor: roles[index] == 'Admin'
                        ? Colors.red.withValues(alpha: 0.1)
                        : roles[index] == 'Manager'
                            ? Colors.orange.withValues(alpha: 0.1)
                            : Colors.blue.withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: roles[index] == 'Admin'
                          ? Colors.red
                          : roles[index] == 'Manager'
                              ? Colors.orange
                              : Colors.blue,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestsScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('System Tests'),
          const SizedBox(height: 16),
          _buildTestCard('Authentication Flow',
              'Test user login and token refresh', Icons.security),
          _buildTestCard('Database Connectivity',
              'Test database read/write operations', Icons.storage),
          _buildTestCard(
              'API Endpoints', 'Test all REST API endpoints', Icons.api),
          _buildTestCard(
              'WebSocket Connection', 'Test real-time connection', Icons.sync),
          _buildTestCard(
              'Email Notifications', 'Test email delivery system', Icons.email),
          _buildTestCard(
              'Call Tracking', 'Test GCLID attribution flow', Icons.phone),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return SizedBox(
      width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(
      String title, String status, Color color, IconData icon) {
    return SizedBox(
      width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final activities = [
            'New call received from +254712345678',
            'Campaign "Nairobi Real Estate" created',
            'User john@example.com logged in',
            'GCLID attributed to call ID 12345',
            'WhatsApp message sent to +254798765432',
          ];
          final times = [
            '2 min ago',
            '15 min ago',
            '1 hour ago',
            '2 hours ago',
            '3 hours ago'
          ];

          return ListTile(
            leading: const CircleAvatar(
              radius: 16,
              child: Icon(Icons.notifications, size: 16),
            ),
            title: Text(activities[index]),
            subtitle: Text(times[index]),
            dense: true,
          );
        },
      ),
    );
  }

  Widget _buildResourceBars() {
    return Column(
      children: [
        _buildResourceBar('CPU Usage', 0.45, Colors.blue),
        const SizedBox(height: 16),
        _buildResourceBar('Memory Usage', 0.62, Colors.orange),
        const SizedBox(height: 16),
        _buildResourceBar('Disk Usage', 0.28, Colors.green),
        const SizedBox(height: 16),
        _buildResourceBar('Network', 0.73, Colors.purple),
      ],
    );
  }

  Widget _buildResourceBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${(value * 100).toInt()}%'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: color.withValues(alpha: 0.1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildTestCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.accentGreen),
        title: Text(title),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: () {
            // Run test
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentGreen,
            foregroundColor: Colors.white,
          ),
          child: const Text('Run Test'),
        ),
      ),
    );
  }
}

class _AdminNavItem {
  final String label;
  final IconData icon;

  _AdminNavItem({required this.label, required this.icon});
}

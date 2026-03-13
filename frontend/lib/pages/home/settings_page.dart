import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAppearanceCard(context, ref, themeMode),
                      const SizedBox(height: AppSpacing.lg),
                      _buildNotificationsCard(context),
                      const SizedBox(height: AppSpacing.lg),
                      _buildIntegrationsCard(context),
                      const SizedBox(height: AppSpacing.lg),
                      _buildAgencyCard(context),
                      const SizedBox(height: AppSpacing.lg),
                      _buildAccountCard(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        border: Border(
          bottom: BorderSide(color: theme.dividerTheme.color!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: theme.textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Configure your Ringly account and preferences',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard(BuildContext context, WidgetRef ref, ThemeMode themeMode) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.palette,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Appearance',
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              title: const Text('Theme Mode'),
              subtitle: const Text('Choose your preferred theme'),
              trailing: DropdownButton<ThemeMode>(
                value: themeMode,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    final notifier = ref.read(themeModeProvider.notifier);
                    switch (value) {
                      case ThemeMode.light:
                        notifier.setLightMode();
                        break;
                      case ThemeMode.dark:
                        notifier.setDarkMode();
                        break;
                      case ThemeMode.system:
                        notifier.setSystemMode();
                        break;
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Notifications',
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive daily summary emails'),
              value: true,
              onChanged: (value) {},
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('SMS Alerts'),
              subtitle: const Text('Get SMS for high-value calls'),
              value: true,
              onChanged: (value) {},
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('WhatsApp Notifications'),
              subtitle: const Text('Receive alerts via WhatsApp'),
              value: false,
              onChanged: (value) {},
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Missed Call Alerts'),
              subtitle: const Text('Get notified about missed calls immediately'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationsCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.integration_instructions,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Integrations',
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.ads_click, size: 20, color: Colors.blue),
              ),
              title: const Text('Google Ads'),
              subtitle: const Text('Connected as admin@agency.co.ke'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Configure'),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.analytics, size: 20, color: Colors.orange),
              ),
              title: const Text('Google Analytics 4'),
              subtitle: const Text('Property ID: GA-XXXXXX-1'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Configure'),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.whatsappGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chat, size: 20, color: AppColors.whatsappGreen),
              ),
              title: const Text('WhatsApp Business'),
              subtitle: const Text('Connected'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Configure'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgencyCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.business,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Agency Settings',
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              title: const Text('Agency Name'),
              subtitle: const Text('Kenya Digital Marketing Ltd'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Timezone'),
              subtitle: const Text('Africa/Nairobi (EAT)'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Change'),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Currency'),
              subtitle: const Text('Kenyan Shilling (KES)'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Change'),
              ),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Multi-tenant Mode'),
              subtitle: const Text('Allow sub-accounts for clients'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Account',
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: const Text('Admin User'),
              subtitle: const Text('admin@ringly.co.ke'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Edit Profile'),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Change Password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Two-Factor Authentication'),
              subtitle: const Text('Not enabled'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Enable'),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Delete Account',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              trailing: Icon(Icons.chevron_right, color: theme.colorScheme.error),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

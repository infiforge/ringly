import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class TrackingSetupPage extends StatelessWidget {
  const TrackingSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDniSection(context),
                      const SizedBox(height: AppSpacing.lg),
                      _buildIntegrationCodeSection(context),
                      const SizedBox(height: AppSpacing.lg),
                      _buildNumberPoolSection(context),
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
            'Tracking Setup',
            style: theme.textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Configure Dynamic Number Insertion and website tracking',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDniSection(BuildContext context) {
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
                    color: AppColors.accentGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.phone_in_talk,
                    color: AppColors.accentGreen,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dynamic Number Insertion (DNI)',
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        'Automatically display unique phone numbers to each visitor',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SwitchListTile(
              title: const Text('Enable DNI'),
              subtitle: const Text('Show unique tracking numbers for each visitor'),
              value: true,
              onChanged: (value) {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Default Number Pool'),
              subtitle: const Text('nairobi_realestate_q1, mombasa_tours_feb'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Configure'),
              ),
            ),
            ListTile(
              title: const Text('Cookie Duration'),
              subtitle: const Text('30 days'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Change'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationCodeSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const integrationCode = '''<!-- Ringly Tracking Code -->
<script>
  (function(w, d, s, o) {
    var j = d.createElement(s);
    j.async = true;
    j.src = 'https://cdn.ringly.co/tracking.js';
    j.setAttribute('data-account', 'YOUR_ACCOUNT_ID');
    d.getElementsByTagName('head')[0].appendChild(j);
  })(window, document, 'script');
</script>''';

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
                    Icons.code,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Website Integration',
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        'Add this code to your website to enable tracking',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: theme.dividerTheme.color!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Copy this code',
                        style: theme.textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: integrationCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Code copied to clipboard')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: theme.dividerTheme.color!),
                    ),
                    child: SelectableText(
                      integrationCode,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Add this code to the <head> section of every page where you want to track calls.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPoolSection(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.whatsappGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Icon(
                        Icons.phone_forwarded,
                        color: AppColors.whatsappGreen,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'Number Pool',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add Number'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.phone, size: 16, color: AppColors.accentGreen),
              ),
              title: const Text('+254 712 345 678'),
              subtitle: const Text('Assigned to: nairobi_realestate_q1'),
              trailing: const Chip(
                label: Text('Active'),
                backgroundColor: AppColors.qualifiedBg,
                labelStyle: TextStyle(color: AppColors.qualifiedText, fontSize: 12),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.phone, size: 16, color: AppColors.accentGreen),
              ),
              title: const Text('+254 723 456 789'),
              subtitle: const Text('Assigned to: mombasa_tours_feb'),
              trailing: const Chip(
                label: Text('Active'),
                backgroundColor: AppColors.qualifiedBg,
                labelStyle: TextStyle(color: AppColors.qualifiedText, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

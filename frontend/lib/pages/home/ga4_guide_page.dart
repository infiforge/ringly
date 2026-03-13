import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class Ga4GuidePage extends StatelessWidget {
  const Ga4GuidePage({super.key});

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
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIntroductionCard(context),
                      const SizedBox(height: AppSpacing.lg),
                      _buildSetupStepsCard(context),
                      const SizedBox(height: AppSpacing.lg),
                      _buildEventTrackingCard(context),
                      const SizedBox(height: AppSpacing.lg),
                      _buildOfflineConversionCard(context),
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
            'GA4 Guide',
            style: theme.textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Google Analytics 4 integration guide for call tracking',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionCard(BuildContext context) {
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
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.analytics,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About GA4 Integration',
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        'Connect your call tracking data with Google Analytics 4',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Google Analytics 4 (GA4) is the latest version of Google Analytics that provides a more comprehensive view of user interactions across your website and apps. By integrating your call tracking data with GA4, you can:',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildBulletPoint(context, 'Track phone calls as conversion events'),
            _buildBulletPoint(context, 'Analyze call quality alongside website behavior'),
            _buildBulletPoint(context, 'Build audiences based on call interactions'),
            _buildBulletPoint(context, 'Create custom reports for call attribution'),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.accentGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupStepsCard(BuildContext context) {
    final theme = Theme.of(context);

    final steps = [
      {
        'title': 'Create a GA4 Property',
        'description': 'If you haven\'t already, create a new GA4 property in your Google Analytics account.',
        'action': 'Go to Google Analytics',
      },
      {
        'title': 'Enable Enhanced Measurement',
        'description': 'Turn on Enhanced Measurement to automatically track page views, scrolls, and outbound clicks.',
        'action': 'Configure',
      },
      {
        'title': 'Install GA4 Tag',
        'description': 'Add the GA4 tracking tag to your website alongside the Ringly tracking code.',
        'action': 'View Code',
      },
      {
        'title': 'Connect Ringly to GA4',
        'description': 'Link your Ringly account with your GA4 property for automatic event sending.',
        'action': 'Connect',
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Setup Steps',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return _buildStepItem(
                context,
                number: index + 1,
                title: step['title']!,
                description: step['description']!,
                action: step['action']!,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required int number,
    required String title,
    required String description,
    required String action,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerTheme.color!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: AppColors.accentGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(action),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTrackingCard(BuildContext context) {
    final theme = Theme.of(context);

    final events = [
      {'name': 'phone_call_initiated', 'description': 'User clicked on a phone number'},
      {'name': 'phone_call_connected', 'description': 'Call was successfully connected'},
      {'name': 'phone_call_qualified', 'description': 'Call marked as qualified lead'},
      {'name': 'phone_call_sale', 'description': 'Call resulted in a sale'},
      {'name': 'whatsapp_message_sent', 'description': 'WhatsApp message was sent'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Custom Events',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Ringly automatically sends these custom events to GA4:',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            ...events.map((event) => ListTile(
              dense: true,
              leading: const Icon(Icons.event_note, size: 20, color: AppColors.accentGreen),
              title: Text(
                event['name']!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(event['description']!),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineConversionCard(BuildContext context) {
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
                    Icons.sync,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Offline Conversion Import',
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        'Send call conversions to Google Ads',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Use Google Ads offline conversion import to attribute qualified calls and sales back to your ad campaigns. This requires capturing the GCLID (Google Click Identifier) and sending it back to Google Ads with the conversion data.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            SwitchListTile(
              title: const Text('Enable Offline Conversion Import'),
              subtitle: const Text('Automatically send qualified calls to Google Ads'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}

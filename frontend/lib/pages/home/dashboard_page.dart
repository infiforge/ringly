import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../providers/call_providers.dart';
import '../../models/call_models.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(callStatisticsProvider);
    final dateRange = ref.watch(dateRangeFilterProvider);
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context, ref, dateRange),
          
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards Row
                  _buildStatsCards(statistics),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Charts Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Call Volume Chart
                      Expanded(
                        flex: 2,
                        child: _buildCallVolumeCard(context),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      // Campaign Performance
                      Expanded(
                        flex: 1,
                        child: _buildCampaignPerformanceCard(context, statistics),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Bottom Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recent Calls
                      Expanded(
                        child: _buildRecentCallsCard(context, ref),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      // Geographic Distribution
                      Expanded(
                        child: _buildGeographicCard(context, statistics),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, DateRangeFilter dateRange) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        border: Border(
          bottom: BorderSide(color: theme.dividerTheme.color!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Google Ads call & WhatsApp attribution for Kenya',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          // Date Range Selector
          _buildDateRangeSelector(context, ref, dateRange),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector(BuildContext context, WidgetRef ref, DateRangeFilter currentRange) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: theme.dividerTheme.color!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DateRangeFilter>(
          value: currentRange,
          icon: const Icon(Icons.calendar_today_outlined, size: 16),
          isDense: true,
          items: DateRangeFilter.presets.map((filter) {
            return DropdownMenuItem(
              value: filter,
              child: Text(filter.label),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              ref.read(dateRangeFilterProvider.notifier).state = value;
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatsCards(CallStatistics stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 800;
        
        if (isSmall) {
          return Column(
            children: [
              _StatCard(
                title: 'Total Calls',
                value: stats.totalCalls.toString(),
                icon: Icons.phone_in_talk,
                color: AppColors.accentGreen,
              ),
              const SizedBox(height: AppSpacing.md),
              _StatCard(
                title: 'Conversion Rate',
                value: '${stats.conversionRate.toStringAsFixed(1)}%',
                icon: Icons.trending_up,
                color: AppColors.whatsappGreen,
              ),
              const SizedBox(height: AppSpacing.md),
              _StatCard(
                title: 'Qualified Leads',
                value: stats.qualifiedCalls.toString(),
                icon: Icons.check_circle_outline,
                color: Colors.blue,
              ),
              const SizedBox(height: AppSpacing.md),
              _StatCard(
                title: 'Sales Closed',
                value: stats.sales.toString(),
                icon: Icons.monetization_on_outlined,
                color: Colors.amber,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Total Calls',
                value: stats.totalCalls.toString(),
                icon: Icons.phone_in_talk,
                color: AppColors.accentGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatCard(
                title: 'Conversion Rate',
                value: '${stats.conversionRate.toStringAsFixed(1)}%',
                icon: Icons.trending_up,
                color: AppColors.whatsappGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatCard(
                title: 'Qualified Leads',
                value: stats.qualifiedCalls.toString(),
                icon: Icons.check_circle_outline,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatCard(
                title: 'Sales Closed',
                value: stats.sales.toString(),
                icon: Icons.monetization_on_outlined,
                color: Colors.amber,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCallVolumeCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Call Volume',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Last 30 days trend',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 200,
              child: _buildSimpleChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleChart() {
    // Simple placeholder chart using containers
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = (constraints.maxWidth - 60) / 7;
        final values = [45, 62, 38, 75, 55, 82, 68];
        final maxValue = values.reduce((a, b) => a > b ? a : b);
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 7; i++)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: barWidth - 8,
                    height: (values[i] / maxValue) * 150,
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i],
                    style: TextStyle(fontSize: 10, color: AppColors.textMutedLight),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildCampaignPerformanceCard(BuildContext context, CallStatistics stats) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campaign Performance',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            ...stats.callsByCampaign.entries.take(5).map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        entry.key,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${entry.value} calls',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentCallsCard(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final calls = ref.watch(filteredCallsProvider).take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Calls',
                  style: theme.textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    ref.read(selectedNavItemProvider.notifier).state = 'calls';
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (calls.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    'No recent calls',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              )
            else
              ...calls.map((call) => _RecentCallItem(call: call)),
          ],
        ),
      ),
    );
  }

  Widget _buildGeographicCard(BuildContext context, CallStatistics stats) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Geographic Distribution',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            ...stats.callsByCity.entries.take(5).map((entry) {
              final percentage = stats.totalCalls > 0 
                  ? (entry.value / stats.totalCalls * 100).toStringAsFixed(1)
                  : '0.0';
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        entry.key,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '$percentage%',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isDark ? color.withOpacity(0.2) : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentCallItem extends StatelessWidget {
  final Call call;

  const _RecentCallItem({required this.call});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: call.type == CallType.phone
                  ? (isDark ? AppColors.accentGreen.withOpacity(0.2) : AppColors.accentGreen.withOpacity(0.1))
                  : (isDark ? AppColors.whatsappGreen.withOpacity(0.2) : AppColors.whatsappGreen.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              call.type == CallType.phone ? Icons.phone : Icons.chat_bubble,
              size: 14,
              color: call.type == CallType.phone ? AppColors.accentGreen : AppColors.whatsappGreen,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  call.contactName,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  call.phoneNumber,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: _QualityBadge(quality: call.quality),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            DateFormat('MMM d, HH:mm').format(call.timestamp),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _QualityBadge extends StatelessWidget {
  final CallQuality quality;

  const _QualityBadge({required this.quality});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bgColor;
    Color textColor;
    String label;

    switch (quality) {
      case CallQuality.qualified:
        bgColor = isDark ? AppColors.qualifiedBgDark : AppColors.qualifiedBg;
        textColor = isDark ? AppColors.qualifiedTextDark : AppColors.qualifiedText;
        label = 'Qualified';
        break;
      case CallQuality.sale:
        bgColor = isDark ? AppColors.saleBgDark : AppColors.saleBg;
        textColor = isDark ? AppColors.saleTextDark : AppColors.saleText;
        label = 'Sale';
        break;
      case CallQuality.spam:
        bgColor = isDark ? AppColors.spamBgDark : AppColors.spamBg;
        textColor = isDark ? AppColors.spamTextDark : AppColors.spamText;
        label = 'Spam';
        break;
      default:
        bgColor = isDark ? AppColors.newBg.withOpacity(0.3) : AppColors.newBg;
        textColor = AppColors.newText;
        label = 'New';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

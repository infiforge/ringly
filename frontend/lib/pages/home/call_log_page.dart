import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../providers/call_providers.dart';
import '../../models/call_models.dart';

class CallLogPage extends ConsumerWidget {
  const CallLogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calls = ref.watch(filteredCallsProvider);
    final dateRange = ref.watch(dateRangeFilterProvider);
    final typeFilter = ref.watch(callTypeFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context, ref, dateRange),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Toolbar
                    _buildToolbar(context, ref, typeFilter, searchQuery),
                    
                    // Table
                    Expanded(
                      child: calls.isEmpty
                          ? _buildEmptyState(context)
                          : _buildDataTable(context, calls),
                    ),
                  ],
                ),
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
                'Call Log',
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
          style: theme.textTheme.bodyMedium,
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

  Widget _buildToolbar(BuildContext context, WidgetRef ref, CallTypeFilter typeFilter, String searchQuery) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 700;
          
          if (isSmall) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Call & WhatsApp Log',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.md),
                // Search
                _buildSearchField(context, ref, searchQuery),
                const SizedBox(height: AppSpacing.md),
                // Filter Chips
                _buildFilterChips(context, ref, typeFilter),
              ],
            );
          }

          return Row(
            children: [
              // Title
              Text(
                'Call & WhatsApp Log',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(width: AppSpacing.lg),
              // Search
              Expanded(
                flex: 2,
                child: _buildSearchField(context, ref, searchQuery),
              ),
              const SizedBox(width: AppSpacing.lg),
              // Filter Chips
              _buildFilterChips(context, ref, typeFilter),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, WidgetRef ref, String searchQuery) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: TextField(
        controller: TextEditingController(text: searchQuery)
          ..selection = TextSelection.collapsed(offset: searchQuery.length),
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                )
              : null,
        ),
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, WidgetRef ref, CallTypeFilter typeFilter) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FilterChip(
          label: 'All',
          isSelected: typeFilter == CallTypeFilter.all,
          onTap: () => ref.read(callTypeFilterProvider.notifier).state = CallTypeFilter.all,
        ),
        const SizedBox(width: AppSpacing.sm),
        _FilterChip(
          label: 'Calls',
          isSelected: typeFilter == CallTypeFilter.calls,
          onTap: () => ref.read(callTypeFilterProvider.notifier).state = CallTypeFilter.calls,
        ),
        const SizedBox(width: AppSpacing.sm),
        _FilterChip(
          label: 'WhatsApp',
          isSelected: typeFilter == CallTypeFilter.whatsapp,
          onTap: () => ref.read(callTypeFilterProvider.notifier).state = CallTypeFilter.whatsapp,
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: theme.textTheme.bodySmall?.color,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No calls found',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Try adjusting your filters or search query',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, List<Call> calls) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 900,
      columns: [
        DataColumn2(
          label: Text('Type', style: theme.dataTableTheme.headingTextStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Text('Contact', style: theme.dataTableTheme.headingTextStyle),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text('City', style: theme.dataTableTheme.headingTextStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Text('Duration', style: theme.dataTableTheme.headingTextStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Text('Quality', style: theme.dataTableTheme.headingTextStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Text('Campaign', style: theme.dataTableTheme.headingTextStyle),
          size: ColumnSize.M,
        ),
        DataColumn2(
          label: Text('GCLID', style: theme.dataTableTheme.headingTextStyle),
          size: ColumnSize.M,
        ),
      ],
      rows: calls.map((call) {
        return DataRow2(
          cells: [
            // Type
            DataCell(
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
                  size: 16,
                  color: call.type == CallType.phone ? AppColors.accentGreen : AppColors.whatsappGreen,
                ),
              ),
            ),
            // Contact
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    call.contactName,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    call.phoneNumber,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            // City
            DataCell(
              Text(
                call.city ?? '-',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            // Duration
            DataCell(
              Text(
                call.duration ?? '-',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            // Quality
            DataCell(
              _QualityBadge(quality: call.quality),
            ),
            // Campaign
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    call.campaignName,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    call.source ?? 'google/cpc',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            // GCLID
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      call.gclid.substring(0, 10),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 16),
                    onPressed: () {
                      // Copy GCLID to clipboard
                    },
                    tooltip: 'Copy GCLID',
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.accentGreen.withOpacity(0.2) : AppColors.accentGreen.withOpacity(0.1))
              : theme.chipTheme.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: AppColors.accentGreen.withOpacity(0.5))
              : Border.all(color: theme.dividerTheme.color!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.accentGreen : theme.textTheme.bodyMedium?.color,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
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
      case CallQuality.new_lead:
        bgColor = isDark ? AppColors.newBg.withOpacity(0.3) : AppColors.newBg;
        textColor = AppColors.newText;
        label = 'New';
        break;
      case CallQuality.followUp:
        bgColor = isDark ? AppColors.followUpBg.withOpacity(0.3) : AppColors.followUpBg;
        textColor = AppColors.followUpText;
        label = 'Follow Up';
        break;
      default:
        bgColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
        textColor = isDark ? Colors.grey.shade300 : Colors.grey.shade700;
        label = 'Unqualified';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

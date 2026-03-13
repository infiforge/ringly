import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme Provider
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setLightMode() => state = ThemeMode.light;
  void setDarkMode() => state = ThemeMode.dark;
  void setSystemMode() => state = ThemeMode.system;
}

// Navigation Provider
final selectedNavItemProvider = StateProvider<String>((ref) => 'dashboard');

// Sidebar Collapse Provider
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);

// Date Filter Provider
final dateRangeFilterProvider = StateProvider<DateRangeFilter>((ref) {
  return DateRangeFilter(
    label: 'Last 30 days',
    startDate: DateTime.now().subtract(const Duration(days: 30)),
    endDate: DateTime.now(),
  );
});

class DateRangeFilter {
  final String label;
  final DateTime startDate;
  final DateTime endDate;

  DateRangeFilter({
    required this.label,
    required this.startDate,
    required this.endDate,
  });

  static List<DateRangeFilter> get presets => [
        DateRangeFilter(
          label: 'Today',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
        ),
        DateRangeFilter(
          label: 'Yesterday',
          startDate: DateTime.now().subtract(const Duration(days: 1)),
          endDate: DateTime.now().subtract(const Duration(days: 1)),
        ),
        DateRangeFilter(
          label: 'Last 7 days',
          startDate: DateTime.now().subtract(const Duration(days: 7)),
          endDate: DateTime.now(),
        ),
        DateRangeFilter(
          label: 'Last 30 days',
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now(),
        ),
        DateRangeFilter(
          label: 'This month',
          startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
          endDate: DateTime.now(),
        ),
        DateRangeFilter(
          label: 'Last month',
          startDate: DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
          endDate: DateTime(DateTime.now().year, DateTime.now().month, 0),
        ),
      ];
}

// Search Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Call Type Filter Provider
final callTypeFilterProvider =
    StateProvider<CallTypeFilter>((ref) => CallTypeFilter.all);

enum CallTypeFilter {
  all,
  calls,
  whatsapp,
}

extension CallTypeFilterExtension on CallTypeFilter {
  String get label {
    switch (this) {
      case CallTypeFilter.all:
        return 'All';
      case CallTypeFilter.calls:
        return 'Calls';
      case CallTypeFilter.whatsapp:
        return 'WhatsApp';
    }
  }
}

// Call Quality Filter Provider
final callQualityFilterProvider =
    StateProvider<CallQualityFilter>((ref) => CallQualityFilter.all);

enum CallQualityFilter {
  all,
  qualified,
  sale,
  spam,
  newLead,
  followUp,
}

extension CallQualityFilterExtension on CallQualityFilter {
  String get label {
    switch (this) {
      case CallQualityFilter.all:
        return 'All';
      case CallQualityFilter.qualified:
        return 'Qualified';
      case CallQualityFilter.sale:
        return 'Sale';
      case CallQualityFilter.spam:
        return 'Spam';
      case CallQualityFilter.newLead:
        return 'New Lead';
      case CallQualityFilter.followUp:
        return 'Follow Up';
    }
  }
}

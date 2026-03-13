import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/call_models.dart';
import '../services/mock_data_service.dart';
import 'app_providers.dart';

// Mock data providers
final mockCallsProvider = Provider<List<Call>>((ref) {
  return MockDataService.generateMockCalls(count: 50);
});

final mockCampaignsProvider = Provider<List<Campaign>>((ref) {
  return MockDataService.generateMockCampaigns();
});

final mockContactsProvider = Provider<List<Contact>>((ref) {
  return MockDataService.generateMockContacts(count: 30);
});

final mockNumberPoolsProvider = Provider<List<NumberPool>>((ref) {
  return MockDataService.generateMockNumberPools(count: 20);
});

final mockWhatsAppMessagesProvider = Provider<List<WhatsAppMessage>>((ref) {
  return MockDataService.generateMockWhatsAppMessages(count: 30);
});

// Filtered calls provider
final filteredCallsProvider = Provider<List<Call>>((ref) {
  final allCalls = ref.watch(mockCallsProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final typeFilter = ref.watch(callTypeFilterProvider);
  final qualityFilter = ref.watch(callQualityFilterProvider);
  final dateRange = ref.watch(dateRangeFilterProvider);

  return allCalls.where((call) {
    // Search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      final matchesSearch = call.contactName.toLowerCase().contains(query) ||
          call.phoneNumber.toLowerCase().contains(query) ||
          call.campaignName.toLowerCase().contains(query) ||
          call.city?.toLowerCase().contains(query) == true ||
          call.gclid.toLowerCase().contains(query);
      if (!matchesSearch) return false;
    }

    // Type filter
    switch (typeFilter) {
      case CallTypeFilter.calls:
        if (call.type != CallType.phone) return false;
        break;
      case CallTypeFilter.whatsapp:
        if (call.type != CallType.whatsapp) return false;
        break;
      case CallTypeFilter.all:
        break;
    }

    // Quality filter
    if (qualityFilter != CallQualityFilter.all) {
      final expectedQuality = CallQuality.values.firstWhere(
        (q) => q.name == qualityFilter.name,
        orElse: () => call.quality,
      );
      if (call.quality != expectedQuality) return false;
    }

    // Date range filter
    if (call.timestamp.isBefore(dateRange.startDate) ||
        call.timestamp.isAfter(dateRange.endDate.add(const Duration(days: 1)))) {
      return false;
    }

    return true;
  }).toList();
});

// Call statistics provider
final callStatisticsProvider = Provider<CallStatistics>((ref) {
  final calls = ref.watch(filteredCallsProvider);
  
  int totalCalls = calls.length;
  int qualifiedCalls = calls.where((c) => c.quality == CallQuality.qualified).length;
  int sales = calls.where((c) => c.quality == CallQuality.sale).length;
  int spam = calls.where((c) => c.quality == CallQuality.spam).length;
  int whatsappMessages = calls.where((c) => c.type == CallType.whatsapp).length;
  
  double conversionRate = totalCalls > 0 ? (qualifiedCalls + sales) / totalCalls * 100 : 0;
  
  // Calculate average duration
  int totalSeconds = 0;
  int callsWithDuration = 0;
  for (final call in calls) {
    if (call.duration != null && call.duration!.isNotEmpty) {
      final parts = call.duration!.split(':');
      if (parts.length == 2) {
        totalSeconds += int.parse(parts[0]) * 60 + int.parse(parts[1]);
        callsWithDuration++;
      } else if (parts.length == 1) {
        totalSeconds += int.parse(parts[0]);
        callsWithDuration++;
      }
    }
  }
  String averageDuration = callsWithDuration > 0
      ? '${(totalSeconds / callsWithDuration / 60).floor()}:${((totalSeconds / callsWithDuration) % 60).toInt().toString().padLeft(2, '0')}'
      : '0:00';

  // Calls by campaign
  Map<String, int> callsByCampaign = {};
  for (final call in calls) {
    callsByCampaign[call.campaignName] = (callsByCampaign[call.campaignName] ?? 0) + 1;
  }

  // Calls by city
  Map<String, int> callsByCity = {};
  for (final call in calls) {
    if (call.city != null) {
      callsByCity[call.city!] = (callsByCity[call.city!] ?? 0) + 1;
    }
  }

  return CallStatistics(
    totalCalls: totalCalls,
    qualifiedCalls: qualifiedCalls,
    sales: sales,
    spam: spam,
    whatsappMessages: whatsappMessages,
    conversionRate: conversionRate,
    averageDuration: averageDuration,
    callsByCampaign: callsByCampaign,
    callsByCity: callsByCity,
  );
});

class CallStatistics {
  final int totalCalls;
  final int qualifiedCalls;
  final int sales;
  final int spam;
  final int whatsappMessages;
  final double conversionRate;
  final String averageDuration;
  final Map<String, int> callsByCampaign;
  final Map<String, int> callsByCity;

  CallStatistics({
    required this.totalCalls,
    required this.qualifiedCalls,
    required this.sales,
    required this.spam,
    required this.whatsappMessages,
    required this.conversionRate,
    required this.averageDuration,
    required this.callsByCampaign,
    required this.callsByCity,
  });
}

// Selected call provider (for detail view)
final selectedCallProvider = StateProvider<Call?>((ref) => null);

// Selected campaign provider
final selectedCampaignProvider = StateProvider<Campaign?>((ref) => null);

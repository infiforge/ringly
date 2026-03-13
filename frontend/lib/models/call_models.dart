import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'call_models.freezed.dart';
part 'call_models.g.dart';

enum CallType {
  phone,
  whatsapp,
}

enum CallQuality {
  qualified,
  sale,
  spam,
  new_lead,
  followUp,
  unqualified,
}

@freezed
class Call with _$Call {
  const factory Call({
    required String id,
    required CallType type,
    required String contactName,
    required String phoneNumber,
    String? city,
    String? duration,
    required CallQuality quality,
    required String campaignId,
    required String campaignName,
    required String gclid,
    required DateTime timestamp,
    String? notes,
    String? recordingUrl,
    String? source,
    String? medium,
    Map<String, dynamic>? metadata,
  }) = _Call;

  factory Call.fromJson(Map<String, Object?> json) => _$CallFromJson(json);
}

@freezed
class Campaign with _$Campaign {
  const factory Campaign({
    required String id,
    required String name,
    required String source,
    String? medium,
    String? description,
    required CampaignStatus status,
    double? budget,
    DateTime? startDate,
    DateTime? endDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    List<String>? assignedNumbers,
    String? targetUrl,
    Map<String, dynamic>? utmParams,
    Map<String, dynamic>? settings,
  }) = _Campaign;

  factory Campaign.fromJson(Map<String, Object?> json) =>
      _$CampaignFromJson(json);
}

enum CampaignStatus {
  active,
  paused,
  completed,
  draft,
}

@freezed
class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String name,
    required String phoneNumber,
    String? email,
    String? city,
    String? country,
    String? company,
    DateTime? lastContactDate,
    int? totalCalls,
    int? totalConversions,
    String? notes,
    List<String>? tags,
    Map<String, dynamic>? customFields,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Contact;

  factory Contact.fromJson(Map<String, Object?> json) =>
      _$ContactFromJson(json);
}

@freezed
class Agency with _$Agency {
  const factory Agency({
    required String id,
    required String name,
    String? description,
    String? logoUrl,
    String? primaryColor,
    required String timezone,
    required String currency,
    required AgencySettings settings,
    required DateTime createdAt,
    required DateTime updatedAt,
    List<String>? userIds,
    List<String>? campaignIds,
  }) = _Agency;

  factory Agency.fromJson(Map<String, Object?> json) => _$AgencyFromJson(json);
}

@freezed
class AgencySettings with _$AgencySettings {
  const factory AgencySettings({
    @Default(true) bool emailNotifications,
    @Default(true) bool smsNotifications,
    @Default(true) bool whatsappNotifications,
    @Default(30) int dataRetentionDays,
    @Default('Africa/Nairobi') String timezone,
    String? googleAdsAccountId,
    String? ga4PropertyId,
    Map<String, dynamic>? integrations,
  }) = _AgencySettings;

  factory AgencySettings.fromJson(Map<String, Object?> json) =>
      _$AgencySettingsFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    String? avatarUrl,
    required UserRole role,
    required String agencyId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? preferences,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}

enum UserRole {
  admin,
  manager,
  viewer,
}

@freezed
class NumberPool with _$NumberPool {
  const factory NumberPool({
    required String id,
    required String phoneNumber,
    required NumberType type,
    String? countryCode,
    String? areaCode,
    String? city,
    String? assignedCampaignId,
    String? assignedCampaignName,
    required NumberStatus status,
    DateTime? purchasedAt,
    DateTime? expiresAt,
    Map<String, dynamic>? configuration,
  }) = _NumberPool;

  factory NumberPool.fromJson(Map<String, Object?> json) =>
      _$NumberPoolFromJson(json);
}

enum NumberType {
  local,
  tollFree,
  mobile,
}

enum NumberStatus {
  active,
  inactive,
  assigned,
  reserved,
}

@freezed
class CallAnalytics with _$CallAnalytics {
  const factory CallAnalytics({
    required DateTime date,
    required int totalCalls,
    required int uniqueCallers,
    required int qualifiedCalls,
    required int sales,
    required int spam,
    required double averageDuration,
    required Map<String, int> callsByCampaign,
    required Map<String, int> callsByCity,
    required Map<String, int> callsByHour,
  }) = _CallAnalytics;

  factory CallAnalytics.fromJson(Map<String, Object?> json) =>
      _$CallAnalyticsFromJson(json);
}

@freezed
class WhatsAppMessage with _$WhatsAppMessage {
  const factory WhatsAppMessage({
    required String id,
    required String contactName,
    required String phoneNumber,
    required String message,
    required MessageDirection direction,
    required MessageStatus status,
    required DateTime timestamp,
    String? campaignId,
    String? gclid,
    String? mediaUrl,
    String? templateId,
    Map<String, dynamic>? metadata,
  }) = _WhatsAppMessage;

  factory WhatsAppMessage.fromJson(Map<String, Object?> json) =>
      _$WhatsAppMessageFromJson(json);
}

enum MessageDirection {
  inbound,
  outbound,
}

enum MessageStatus {
  sent,
  delivered,
  read,
  failed,
  pending,
}

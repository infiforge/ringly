// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CallImpl _$$CallImplFromJson(Map<String, dynamic> json) => _$CallImpl(
      id: json['id'] as String,
      type: $enumDecode(_$CallTypeEnumMap, json['type']),
      contactName: json['contactName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      city: json['city'] as String?,
      duration: json['duration'] as String?,
      quality: $enumDecode(_$CallQualityEnumMap, json['quality']),
      campaignId: json['campaignId'] as String,
      campaignName: json['campaignName'] as String,
      gclid: json['gclid'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
      recordingUrl: json['recordingUrl'] as String?,
      source: json['source'] as String?,
      medium: json['medium'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CallImplToJson(_$CallImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$CallTypeEnumMap[instance.type]!,
      'contactName': instance.contactName,
      'phoneNumber': instance.phoneNumber,
      'city': instance.city,
      'duration': instance.duration,
      'quality': _$CallQualityEnumMap[instance.quality]!,
      'campaignId': instance.campaignId,
      'campaignName': instance.campaignName,
      'gclid': instance.gclid,
      'timestamp': instance.timestamp.toIso8601String(),
      'notes': instance.notes,
      'recordingUrl': instance.recordingUrl,
      'source': instance.source,
      'medium': instance.medium,
      'metadata': instance.metadata,
    };

const _$CallTypeEnumMap = {
  CallType.phone: 'phone',
  CallType.whatsapp: 'whatsapp',
};

const _$CallQualityEnumMap = {
  CallQuality.qualified: 'qualified',
  CallQuality.sale: 'sale',
  CallQuality.spam: 'spam',
  CallQuality.new_lead: 'new_lead',
  CallQuality.followUp: 'followUp',
  CallQuality.unqualified: 'unqualified',
};

_$CampaignImpl _$$CampaignImplFromJson(Map<String, dynamic> json) =>
    _$CampaignImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      source: json['source'] as String,
      medium: json['medium'] as String?,
      description: json['description'] as String?,
      status: $enumDecode(_$CampaignStatusEnumMap, json['status']),
      budget: (json['budget'] as num?)?.toDouble(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      assignedNumbers: (json['assignedNumbers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      targetUrl: json['targetUrl'] as String?,
      utmParams: json['utmParams'] as Map<String, dynamic>?,
      settings: json['settings'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CampaignImplToJson(_$CampaignImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'source': instance.source,
      'medium': instance.medium,
      'description': instance.description,
      'status': _$CampaignStatusEnumMap[instance.status]!,
      'budget': instance.budget,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'assignedNumbers': instance.assignedNumbers,
      'targetUrl': instance.targetUrl,
      'utmParams': instance.utmParams,
      'settings': instance.settings,
    };

const _$CampaignStatusEnumMap = {
  CampaignStatus.active: 'active',
  CampaignStatus.paused: 'paused',
  CampaignStatus.completed: 'completed',
  CampaignStatus.draft: 'draft',
};

_$ContactImpl _$$ContactImplFromJson(Map<String, dynamic> json) =>
    _$ContactImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      company: json['company'] as String?,
      lastContactDate: json['lastContactDate'] == null
          ? null
          : DateTime.parse(json['lastContactDate'] as String),
      totalCalls: (json['totalCalls'] as num?)?.toInt(),
      totalConversions: (json['totalConversions'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      customFields: json['customFields'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ContactImplToJson(_$ContactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'city': instance.city,
      'country': instance.country,
      'company': instance.company,
      'lastContactDate': instance.lastContactDate?.toIso8601String(),
      'totalCalls': instance.totalCalls,
      'totalConversions': instance.totalConversions,
      'notes': instance.notes,
      'tags': instance.tags,
      'customFields': instance.customFields,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$AgencyImpl _$$AgencyImplFromJson(Map<String, dynamic> json) => _$AgencyImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      primaryColor: json['primaryColor'] as String?,
      timezone: json['timezone'] as String,
      currency: json['currency'] as String,
      settings:
          AgencySettings.fromJson(json['settings'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userIds:
          (json['userIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
      campaignIds: (json['campaignIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$AgencyImplToJson(_$AgencyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'logoUrl': instance.logoUrl,
      'primaryColor': instance.primaryColor,
      'timezone': instance.timezone,
      'currency': instance.currency,
      'settings': instance.settings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'userIds': instance.userIds,
      'campaignIds': instance.campaignIds,
    };

_$AgencySettingsImpl _$$AgencySettingsImplFromJson(Map<String, dynamic> json) =>
    _$AgencySettingsImpl(
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? true,
      whatsappNotifications: json['whatsappNotifications'] as bool? ?? true,
      dataRetentionDays: (json['dataRetentionDays'] as num?)?.toInt() ?? 30,
      timezone: json['timezone'] as String? ?? 'Africa/Nairobi',
      googleAdsAccountId: json['googleAdsAccountId'] as String?,
      ga4PropertyId: json['ga4PropertyId'] as String?,
      integrations: json['integrations'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AgencySettingsImplToJson(
        _$AgencySettingsImpl instance) =>
    <String, dynamic>{
      'emailNotifications': instance.emailNotifications,
      'smsNotifications': instance.smsNotifications,
      'whatsappNotifications': instance.whatsappNotifications,
      'dataRetentionDays': instance.dataRetentionDays,
      'timezone': instance.timezone,
      'googleAdsAccountId': instance.googleAdsAccountId,
      'ga4PropertyId': instance.ga4PropertyId,
      'integrations': instance.integrations,
    };

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      agencyId: json['agencyId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      preferences: json['preferences'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'role': _$UserRoleEnumMap[instance.role]!,
      'agencyId': instance.agencyId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'preferences': instance.preferences,
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.manager: 'manager',
  UserRole.viewer: 'viewer',
};

_$NumberPoolImpl _$$NumberPoolImplFromJson(Map<String, dynamic> json) =>
    _$NumberPoolImpl(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      type: $enumDecode(_$NumberTypeEnumMap, json['type']),
      countryCode: json['countryCode'] as String?,
      areaCode: json['areaCode'] as String?,
      city: json['city'] as String?,
      assignedCampaignId: json['assignedCampaignId'] as String?,
      assignedCampaignName: json['assignedCampaignName'] as String?,
      status: $enumDecode(_$NumberStatusEnumMap, json['status']),
      purchasedAt: json['purchasedAt'] == null
          ? null
          : DateTime.parse(json['purchasedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      configuration: json['configuration'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$NumberPoolImplToJson(_$NumberPoolImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'type': _$NumberTypeEnumMap[instance.type]!,
      'countryCode': instance.countryCode,
      'areaCode': instance.areaCode,
      'city': instance.city,
      'assignedCampaignId': instance.assignedCampaignId,
      'assignedCampaignName': instance.assignedCampaignName,
      'status': _$NumberStatusEnumMap[instance.status]!,
      'purchasedAt': instance.purchasedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'configuration': instance.configuration,
    };

const _$NumberTypeEnumMap = {
  NumberType.local: 'local',
  NumberType.tollFree: 'tollFree',
  NumberType.mobile: 'mobile',
};

const _$NumberStatusEnumMap = {
  NumberStatus.active: 'active',
  NumberStatus.inactive: 'inactive',
  NumberStatus.assigned: 'assigned',
  NumberStatus.reserved: 'reserved',
};

_$CallAnalyticsImpl _$$CallAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$CallAnalyticsImpl(
      date: DateTime.parse(json['date'] as String),
      totalCalls: (json['totalCalls'] as num).toInt(),
      uniqueCallers: (json['uniqueCallers'] as num).toInt(),
      qualifiedCalls: (json['qualifiedCalls'] as num).toInt(),
      sales: (json['sales'] as num).toInt(),
      spam: (json['spam'] as num).toInt(),
      averageDuration: (json['averageDuration'] as num).toDouble(),
      callsByCampaign: Map<String, int>.from(json['callsByCampaign'] as Map),
      callsByCity: Map<String, int>.from(json['callsByCity'] as Map),
      callsByHour: Map<String, int>.from(json['callsByHour'] as Map),
    );

Map<String, dynamic> _$$CallAnalyticsImplToJson(_$CallAnalyticsImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'totalCalls': instance.totalCalls,
      'uniqueCallers': instance.uniqueCallers,
      'qualifiedCalls': instance.qualifiedCalls,
      'sales': instance.sales,
      'spam': instance.spam,
      'averageDuration': instance.averageDuration,
      'callsByCampaign': instance.callsByCampaign,
      'callsByCity': instance.callsByCity,
      'callsByHour': instance.callsByHour,
    };

_$WhatsAppMessageImpl _$$WhatsAppMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$WhatsAppMessageImpl(
      id: json['id'] as String,
      contactName: json['contactName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      message: json['message'] as String,
      direction: $enumDecode(_$MessageDirectionEnumMap, json['direction']),
      status: $enumDecode(_$MessageStatusEnumMap, json['status']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      campaignId: json['campaignId'] as String?,
      gclid: json['gclid'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      templateId: json['templateId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$WhatsAppMessageImplToJson(
        _$WhatsAppMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contactName': instance.contactName,
      'phoneNumber': instance.phoneNumber,
      'message': instance.message,
      'direction': _$MessageDirectionEnumMap[instance.direction]!,
      'status': _$MessageStatusEnumMap[instance.status]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'campaignId': instance.campaignId,
      'gclid': instance.gclid,
      'mediaUrl': instance.mediaUrl,
      'templateId': instance.templateId,
      'metadata': instance.metadata,
    };

const _$MessageDirectionEnumMap = {
  MessageDirection.inbound: 'inbound',
  MessageDirection.outbound: 'outbound',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
  MessageStatus.pending: 'pending',
};

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Call _$CallFromJson(Map<String, dynamic> json) {
  return _Call.fromJson(json);
}

/// @nodoc
mixin _$Call {
  String get id => throw _privateConstructorUsedError;
  CallType get type => throw _privateConstructorUsedError;
  String get contactName => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get duration => throw _privateConstructorUsedError;
  CallQuality get quality => throw _privateConstructorUsedError;
  String get campaignId => throw _privateConstructorUsedError;
  String get campaignName => throw _privateConstructorUsedError;
  String get gclid => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get recordingUrl => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  String? get medium => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CallCopyWith<Call> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallCopyWith<$Res> {
  factory $CallCopyWith(Call value, $Res Function(Call) then) =
      _$CallCopyWithImpl<$Res, Call>;
  @useResult
  $Res call(
      {String id,
      CallType type,
      String contactName,
      String phoneNumber,
      String? city,
      String? duration,
      CallQuality quality,
      String campaignId,
      String campaignName,
      String gclid,
      DateTime timestamp,
      String? notes,
      String? recordingUrl,
      String? source,
      String? medium,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$CallCopyWithImpl<$Res, $Val extends Call>
    implements $CallCopyWith<$Res> {
  _$CallCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? contactName = null,
    Object? phoneNumber = null,
    Object? city = freezed,
    Object? duration = freezed,
    Object? quality = null,
    Object? campaignId = null,
    Object? campaignName = null,
    Object? gclid = null,
    Object? timestamp = null,
    Object? notes = freezed,
    Object? recordingUrl = freezed,
    Object? source = freezed,
    Object? medium = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CallType,
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String?,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as CallQuality,
      campaignId: null == campaignId
          ? _value.campaignId
          : campaignId // ignore: cast_nullable_to_non_nullable
              as String,
      campaignName: null == campaignName
          ? _value.campaignName
          : campaignName // ignore: cast_nullable_to_non_nullable
              as String,
      gclid: null == gclid
          ? _value.gclid
          : gclid // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      recordingUrl: freezed == recordingUrl
          ? _value.recordingUrl
          : recordingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      medium: freezed == medium
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CallImplCopyWith<$Res> implements $CallCopyWith<$Res> {
  factory _$$CallImplCopyWith(
          _$CallImpl value, $Res Function(_$CallImpl) then) =
      __$$CallImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      CallType type,
      String contactName,
      String phoneNumber,
      String? city,
      String? duration,
      CallQuality quality,
      String campaignId,
      String campaignName,
      String gclid,
      DateTime timestamp,
      String? notes,
      String? recordingUrl,
      String? source,
      String? medium,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$CallImplCopyWithImpl<$Res>
    extends _$CallCopyWithImpl<$Res, _$CallImpl>
    implements _$$CallImplCopyWith<$Res> {
  __$$CallImplCopyWithImpl(_$CallImpl _value, $Res Function(_$CallImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? contactName = null,
    Object? phoneNumber = null,
    Object? city = freezed,
    Object? duration = freezed,
    Object? quality = null,
    Object? campaignId = null,
    Object? campaignName = null,
    Object? gclid = null,
    Object? timestamp = null,
    Object? notes = freezed,
    Object? recordingUrl = freezed,
    Object? source = freezed,
    Object? medium = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$CallImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CallType,
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String?,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as CallQuality,
      campaignId: null == campaignId
          ? _value.campaignId
          : campaignId // ignore: cast_nullable_to_non_nullable
              as String,
      campaignName: null == campaignName
          ? _value.campaignName
          : campaignName // ignore: cast_nullable_to_non_nullable
              as String,
      gclid: null == gclid
          ? _value.gclid
          : gclid // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      recordingUrl: freezed == recordingUrl
          ? _value.recordingUrl
          : recordingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      medium: freezed == medium
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CallImpl with DiagnosticableTreeMixin implements _Call {
  const _$CallImpl(
      {required this.id,
      required this.type,
      required this.contactName,
      required this.phoneNumber,
      this.city,
      this.duration,
      required this.quality,
      required this.campaignId,
      required this.campaignName,
      required this.gclid,
      required this.timestamp,
      this.notes,
      this.recordingUrl,
      this.source,
      this.medium,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$CallImpl.fromJson(Map<String, dynamic> json) =>
      _$$CallImplFromJson(json);

  @override
  final String id;
  @override
  final CallType type;
  @override
  final String contactName;
  @override
  final String phoneNumber;
  @override
  final String? city;
  @override
  final String? duration;
  @override
  final CallQuality quality;
  @override
  final String campaignId;
  @override
  final String campaignName;
  @override
  final String gclid;
  @override
  final DateTime timestamp;
  @override
  final String? notes;
  @override
  final String? recordingUrl;
  @override
  final String? source;
  @override
  final String? medium;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Call(id: $id, type: $type, contactName: $contactName, phoneNumber: $phoneNumber, city: $city, duration: $duration, quality: $quality, campaignId: $campaignId, campaignName: $campaignName, gclid: $gclid, timestamp: $timestamp, notes: $notes, recordingUrl: $recordingUrl, source: $source, medium: $medium, metadata: $metadata)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Call'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('contactName', contactName))
      ..add(DiagnosticsProperty('phoneNumber', phoneNumber))
      ..add(DiagnosticsProperty('city', city))
      ..add(DiagnosticsProperty('duration', duration))
      ..add(DiagnosticsProperty('quality', quality))
      ..add(DiagnosticsProperty('campaignId', campaignId))
      ..add(DiagnosticsProperty('campaignName', campaignName))
      ..add(DiagnosticsProperty('gclid', gclid))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('notes', notes))
      ..add(DiagnosticsProperty('recordingUrl', recordingUrl))
      ..add(DiagnosticsProperty('source', source))
      ..add(DiagnosticsProperty('medium', medium))
      ..add(DiagnosticsProperty('metadata', metadata));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.campaignId, campaignId) ||
                other.campaignId == campaignId) &&
            (identical(other.campaignName, campaignName) ||
                other.campaignName == campaignName) &&
            (identical(other.gclid, gclid) || other.gclid == gclid) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.recordingUrl, recordingUrl) ||
                other.recordingUrl == recordingUrl) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.medium, medium) || other.medium == medium) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      contactName,
      phoneNumber,
      city,
      duration,
      quality,
      campaignId,
      campaignName,
      gclid,
      timestamp,
      notes,
      recordingUrl,
      source,
      medium,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CallImplCopyWith<_$CallImpl> get copyWith =>
      __$$CallImplCopyWithImpl<_$CallImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CallImplToJson(
      this,
    );
  }
}

abstract class _Call implements Call {
  const factory _Call(
      {required final String id,
      required final CallType type,
      required final String contactName,
      required final String phoneNumber,
      final String? city,
      final String? duration,
      required final CallQuality quality,
      required final String campaignId,
      required final String campaignName,
      required final String gclid,
      required final DateTime timestamp,
      final String? notes,
      final String? recordingUrl,
      final String? source,
      final String? medium,
      final Map<String, dynamic>? metadata}) = _$CallImpl;

  factory _Call.fromJson(Map<String, dynamic> json) = _$CallImpl.fromJson;

  @override
  String get id;
  @override
  CallType get type;
  @override
  String get contactName;
  @override
  String get phoneNumber;
  @override
  String? get city;
  @override
  String? get duration;
  @override
  CallQuality get quality;
  @override
  String get campaignId;
  @override
  String get campaignName;
  @override
  String get gclid;
  @override
  DateTime get timestamp;
  @override
  String? get notes;
  @override
  String? get recordingUrl;
  @override
  String? get source;
  @override
  String? get medium;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$CallImplCopyWith<_$CallImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Campaign _$CampaignFromJson(Map<String, dynamic> json) {
  return _Campaign.fromJson(json);
}

/// @nodoc
mixin _$Campaign {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String? get medium => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  CampaignStatus get status => throw _privateConstructorUsedError;
  double? get budget => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<String>? get assignedNumbers => throw _privateConstructorUsedError;
  String? get targetUrl => throw _privateConstructorUsedError;
  Map<String, dynamic>? get utmParams => throw _privateConstructorUsedError;
  Map<String, dynamic>? get settings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CampaignCopyWith<Campaign> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CampaignCopyWith<$Res> {
  factory $CampaignCopyWith(Campaign value, $Res Function(Campaign) then) =
      _$CampaignCopyWithImpl<$Res, Campaign>;
  @useResult
  $Res call(
      {String id,
      String name,
      String source,
      String? medium,
      String? description,
      CampaignStatus status,
      double? budget,
      DateTime? startDate,
      DateTime? endDate,
      DateTime createdAt,
      DateTime updatedAt,
      List<String>? assignedNumbers,
      String? targetUrl,
      Map<String, dynamic>? utmParams,
      Map<String, dynamic>? settings});
}

/// @nodoc
class _$CampaignCopyWithImpl<$Res, $Val extends Campaign>
    implements $CampaignCopyWith<$Res> {
  _$CampaignCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? source = null,
    Object? medium = freezed,
    Object? description = freezed,
    Object? status = null,
    Object? budget = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? assignedNumbers = freezed,
    Object? targetUrl = freezed,
    Object? utmParams = freezed,
    Object? settings = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      medium: freezed == medium
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CampaignStatus,
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as double?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      assignedNumbers: freezed == assignedNumbers
          ? _value.assignedNumbers
          : assignedNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      targetUrl: freezed == targetUrl
          ? _value.targetUrl
          : targetUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      utmParams: freezed == utmParams
          ? _value.utmParams
          : utmParams // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CampaignImplCopyWith<$Res>
    implements $CampaignCopyWith<$Res> {
  factory _$$CampaignImplCopyWith(
          _$CampaignImpl value, $Res Function(_$CampaignImpl) then) =
      __$$CampaignImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String source,
      String? medium,
      String? description,
      CampaignStatus status,
      double? budget,
      DateTime? startDate,
      DateTime? endDate,
      DateTime createdAt,
      DateTime updatedAt,
      List<String>? assignedNumbers,
      String? targetUrl,
      Map<String, dynamic>? utmParams,
      Map<String, dynamic>? settings});
}

/// @nodoc
class __$$CampaignImplCopyWithImpl<$Res>
    extends _$CampaignCopyWithImpl<$Res, _$CampaignImpl>
    implements _$$CampaignImplCopyWith<$Res> {
  __$$CampaignImplCopyWithImpl(
      _$CampaignImpl _value, $Res Function(_$CampaignImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? source = null,
    Object? medium = freezed,
    Object? description = freezed,
    Object? status = null,
    Object? budget = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? assignedNumbers = freezed,
    Object? targetUrl = freezed,
    Object? utmParams = freezed,
    Object? settings = freezed,
  }) {
    return _then(_$CampaignImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      medium: freezed == medium
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CampaignStatus,
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as double?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      assignedNumbers: freezed == assignedNumbers
          ? _value._assignedNumbers
          : assignedNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      targetUrl: freezed == targetUrl
          ? _value.targetUrl
          : targetUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      utmParams: freezed == utmParams
          ? _value._utmParams
          : utmParams // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      settings: freezed == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CampaignImpl with DiagnosticableTreeMixin implements _Campaign {
  const _$CampaignImpl(
      {required this.id,
      required this.name,
      required this.source,
      this.medium,
      this.description,
      required this.status,
      this.budget,
      this.startDate,
      this.endDate,
      required this.createdAt,
      required this.updatedAt,
      final List<String>? assignedNumbers,
      this.targetUrl,
      final Map<String, dynamic>? utmParams,
      final Map<String, dynamic>? settings})
      : _assignedNumbers = assignedNumbers,
        _utmParams = utmParams,
        _settings = settings;

  factory _$CampaignImpl.fromJson(Map<String, dynamic> json) =>
      _$$CampaignImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String source;
  @override
  final String? medium;
  @override
  final String? description;
  @override
  final CampaignStatus status;
  @override
  final double? budget;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<String>? _assignedNumbers;
  @override
  List<String>? get assignedNumbers {
    final value = _assignedNumbers;
    if (value == null) return null;
    if (_assignedNumbers is EqualUnmodifiableListView) return _assignedNumbers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? targetUrl;
  final Map<String, dynamic>? _utmParams;
  @override
  Map<String, dynamic>? get utmParams {
    final value = _utmParams;
    if (value == null) return null;
    if (_utmParams is EqualUnmodifiableMapView) return _utmParams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _settings;
  @override
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Campaign(id: $id, name: $name, source: $source, medium: $medium, description: $description, status: $status, budget: $budget, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt, assignedNumbers: $assignedNumbers, targetUrl: $targetUrl, utmParams: $utmParams, settings: $settings)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Campaign'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('source', source))
      ..add(DiagnosticsProperty('medium', medium))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('budget', budget))
      ..add(DiagnosticsProperty('startDate', startDate))
      ..add(DiagnosticsProperty('endDate', endDate))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt))
      ..add(DiagnosticsProperty('assignedNumbers', assignedNumbers))
      ..add(DiagnosticsProperty('targetUrl', targetUrl))
      ..add(DiagnosticsProperty('utmParams', utmParams))
      ..add(DiagnosticsProperty('settings', settings));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CampaignImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.medium, medium) || other.medium == medium) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._assignedNumbers, _assignedNumbers) &&
            (identical(other.targetUrl, targetUrl) ||
                other.targetUrl == targetUrl) &&
            const DeepCollectionEquality()
                .equals(other._utmParams, _utmParams) &&
            const DeepCollectionEquality().equals(other._settings, _settings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      source,
      medium,
      description,
      status,
      budget,
      startDate,
      endDate,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_assignedNumbers),
      targetUrl,
      const DeepCollectionEquality().hash(_utmParams),
      const DeepCollectionEquality().hash(_settings));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CampaignImplCopyWith<_$CampaignImpl> get copyWith =>
      __$$CampaignImplCopyWithImpl<_$CampaignImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CampaignImplToJson(
      this,
    );
  }
}

abstract class _Campaign implements Campaign {
  const factory _Campaign(
      {required final String id,
      required final String name,
      required final String source,
      final String? medium,
      final String? description,
      required final CampaignStatus status,
      final double? budget,
      final DateTime? startDate,
      final DateTime? endDate,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final List<String>? assignedNumbers,
      final String? targetUrl,
      final Map<String, dynamic>? utmParams,
      final Map<String, dynamic>? settings}) = _$CampaignImpl;

  factory _Campaign.fromJson(Map<String, dynamic> json) =
      _$CampaignImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get source;
  @override
  String? get medium;
  @override
  String? get description;
  @override
  CampaignStatus get status;
  @override
  double? get budget;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<String>? get assignedNumbers;
  @override
  String? get targetUrl;
  @override
  Map<String, dynamic>? get utmParams;
  @override
  Map<String, dynamic>? get settings;
  @override
  @JsonKey(ignore: true)
  _$$CampaignImplCopyWith<_$CampaignImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Contact _$ContactFromJson(Map<String, dynamic> json) {
  return _Contact.fromJson(json);
}

/// @nodoc
mixin _$Contact {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get company => throw _privateConstructorUsedError;
  DateTime? get lastContactDate => throw _privateConstructorUsedError;
  int? get totalCalls => throw _privateConstructorUsedError;
  int? get totalConversions => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  Map<String, dynamic>? get customFields => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContactCopyWith<Contact> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactCopyWith<$Res> {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) then) =
      _$ContactCopyWithImpl<$Res, Contact>;
  @useResult
  $Res call(
      {String id,
      String name,
      String phoneNumber,
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
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ContactCopyWithImpl<$Res, $Val extends Contact>
    implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phoneNumber = null,
    Object? email = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? company = freezed,
    Object? lastContactDate = freezed,
    Object? totalCalls = freezed,
    Object? totalConversions = freezed,
    Object? notes = freezed,
    Object? tags = freezed,
    Object? customFields = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      lastContactDate: freezed == lastContactDate
          ? _value.lastContactDate
          : lastContactDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalCalls: freezed == totalCalls
          ? _value.totalCalls
          : totalCalls // ignore: cast_nullable_to_non_nullable
              as int?,
      totalConversions: freezed == totalConversions
          ? _value.totalConversions
          : totalConversions // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      customFields: freezed == customFields
          ? _value.customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactImplCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$$ContactImplCopyWith(
          _$ContactImpl value, $Res Function(_$ContactImpl) then) =
      __$$ContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String phoneNumber,
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
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ContactImplCopyWithImpl<$Res>
    extends _$ContactCopyWithImpl<$Res, _$ContactImpl>
    implements _$$ContactImplCopyWith<$Res> {
  __$$ContactImplCopyWithImpl(
      _$ContactImpl _value, $Res Function(_$ContactImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phoneNumber = null,
    Object? email = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? company = freezed,
    Object? lastContactDate = freezed,
    Object? totalCalls = freezed,
    Object? totalConversions = freezed,
    Object? notes = freezed,
    Object? tags = freezed,
    Object? customFields = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ContactImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      lastContactDate: freezed == lastContactDate
          ? _value.lastContactDate
          : lastContactDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalCalls: freezed == totalCalls
          ? _value.totalCalls
          : totalCalls // ignore: cast_nullable_to_non_nullable
              as int?,
      totalConversions: freezed == totalConversions
          ? _value.totalConversions
          : totalConversions // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      customFields: freezed == customFields
          ? _value._customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactImpl with DiagnosticableTreeMixin implements _Contact {
  const _$ContactImpl(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      this.email,
      this.city,
      this.country,
      this.company,
      this.lastContactDate,
      this.totalCalls,
      this.totalConversions,
      this.notes,
      final List<String>? tags,
      final Map<String, dynamic>? customFields,
      required this.createdAt,
      required this.updatedAt})
      : _tags = tags,
        _customFields = customFields;

  factory _$ContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String phoneNumber;
  @override
  final String? email;
  @override
  final String? city;
  @override
  final String? country;
  @override
  final String? company;
  @override
  final DateTime? lastContactDate;
  @override
  final int? totalCalls;
  @override
  final int? totalConversions;
  @override
  final String? notes;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _customFields;
  @override
  Map<String, dynamic>? get customFields {
    final value = _customFields;
    if (value == null) return null;
    if (_customFields is EqualUnmodifiableMapView) return _customFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Contact(id: $id, name: $name, phoneNumber: $phoneNumber, email: $email, city: $city, country: $country, company: $company, lastContactDate: $lastContactDate, totalCalls: $totalCalls, totalConversions: $totalConversions, notes: $notes, tags: $tags, customFields: $customFields, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Contact'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('phoneNumber', phoneNumber))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('city', city))
      ..add(DiagnosticsProperty('country', country))
      ..add(DiagnosticsProperty('company', company))
      ..add(DiagnosticsProperty('lastContactDate', lastContactDate))
      ..add(DiagnosticsProperty('totalCalls', totalCalls))
      ..add(DiagnosticsProperty('totalConversions', totalConversions))
      ..add(DiagnosticsProperty('notes', notes))
      ..add(DiagnosticsProperty('tags', tags))
      ..add(DiagnosticsProperty('customFields', customFields))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.lastContactDate, lastContactDate) ||
                other.lastContactDate == lastContactDate) &&
            (identical(other.totalCalls, totalCalls) ||
                other.totalCalls == totalCalls) &&
            (identical(other.totalConversions, totalConversions) ||
                other.totalConversions == totalConversions) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._customFields, _customFields) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      phoneNumber,
      email,
      city,
      country,
      company,
      lastContactDate,
      totalCalls,
      totalConversions,
      notes,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_customFields),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      __$$ContactImplCopyWithImpl<_$ContactImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactImplToJson(
      this,
    );
  }
}

abstract class _Contact implements Contact {
  const factory _Contact(
      {required final String id,
      required final String name,
      required final String phoneNumber,
      final String? email,
      final String? city,
      final String? country,
      final String? company,
      final DateTime? lastContactDate,
      final int? totalCalls,
      final int? totalConversions,
      final String? notes,
      final List<String>? tags,
      final Map<String, dynamic>? customFields,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ContactImpl;

  factory _Contact.fromJson(Map<String, dynamic> json) = _$ContactImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get phoneNumber;
  @override
  String? get email;
  @override
  String? get city;
  @override
  String? get country;
  @override
  String? get company;
  @override
  DateTime? get lastContactDate;
  @override
  int? get totalCalls;
  @override
  int? get totalConversions;
  @override
  String? get notes;
  @override
  List<String>? get tags;
  @override
  Map<String, dynamic>? get customFields;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Agency _$AgencyFromJson(Map<String, dynamic> json) {
  return _Agency.fromJson(json);
}

/// @nodoc
mixin _$Agency {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get primaryColor => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  AgencySettings get settings => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<String>? get userIds => throw _privateConstructorUsedError;
  List<String>? get campaignIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AgencyCopyWith<Agency> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgencyCopyWith<$Res> {
  factory $AgencyCopyWith(Agency value, $Res Function(Agency) then) =
      _$AgencyCopyWithImpl<$Res, Agency>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? logoUrl,
      String? primaryColor,
      String timezone,
      String currency,
      AgencySettings settings,
      DateTime createdAt,
      DateTime updatedAt,
      List<String>? userIds,
      List<String>? campaignIds});

  $AgencySettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$AgencyCopyWithImpl<$Res, $Val extends Agency>
    implements $AgencyCopyWith<$Res> {
  _$AgencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? primaryColor = freezed,
    Object? timezone = null,
    Object? currency = null,
    Object? settings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userIds = freezed,
    Object? campaignIds = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryColor: freezed == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as AgencySettings,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userIds: freezed == userIds
          ? _value.userIds
          : userIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      campaignIds: freezed == campaignIds
          ? _value.campaignIds
          : campaignIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AgencySettingsCopyWith<$Res> get settings {
    return $AgencySettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AgencyImplCopyWith<$Res> implements $AgencyCopyWith<$Res> {
  factory _$$AgencyImplCopyWith(
          _$AgencyImpl value, $Res Function(_$AgencyImpl) then) =
      __$$AgencyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? logoUrl,
      String? primaryColor,
      String timezone,
      String currency,
      AgencySettings settings,
      DateTime createdAt,
      DateTime updatedAt,
      List<String>? userIds,
      List<String>? campaignIds});

  @override
  $AgencySettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$AgencyImplCopyWithImpl<$Res>
    extends _$AgencyCopyWithImpl<$Res, _$AgencyImpl>
    implements _$$AgencyImplCopyWith<$Res> {
  __$$AgencyImplCopyWithImpl(
      _$AgencyImpl _value, $Res Function(_$AgencyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? primaryColor = freezed,
    Object? timezone = null,
    Object? currency = null,
    Object? settings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userIds = freezed,
    Object? campaignIds = freezed,
  }) {
    return _then(_$AgencyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryColor: freezed == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as AgencySettings,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userIds: freezed == userIds
          ? _value._userIds
          : userIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      campaignIds: freezed == campaignIds
          ? _value._campaignIds
          : campaignIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AgencyImpl with DiagnosticableTreeMixin implements _Agency {
  const _$AgencyImpl(
      {required this.id,
      required this.name,
      this.description,
      this.logoUrl,
      this.primaryColor,
      required this.timezone,
      required this.currency,
      required this.settings,
      required this.createdAt,
      required this.updatedAt,
      final List<String>? userIds,
      final List<String>? campaignIds})
      : _userIds = userIds,
        _campaignIds = campaignIds;

  factory _$AgencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgencyImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? logoUrl;
  @override
  final String? primaryColor;
  @override
  final String timezone;
  @override
  final String currency;
  @override
  final AgencySettings settings;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<String>? _userIds;
  @override
  List<String>? get userIds {
    final value = _userIds;
    if (value == null) return null;
    if (_userIds is EqualUnmodifiableListView) return _userIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _campaignIds;
  @override
  List<String>? get campaignIds {
    final value = _campaignIds;
    if (value == null) return null;
    if (_campaignIds is EqualUnmodifiableListView) return _campaignIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Agency(id: $id, name: $name, description: $description, logoUrl: $logoUrl, primaryColor: $primaryColor, timezone: $timezone, currency: $currency, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt, userIds: $userIds, campaignIds: $campaignIds)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Agency'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('logoUrl', logoUrl))
      ..add(DiagnosticsProperty('primaryColor', primaryColor))
      ..add(DiagnosticsProperty('timezone', timezone))
      ..add(DiagnosticsProperty('currency', currency))
      ..add(DiagnosticsProperty('settings', settings))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt))
      ..add(DiagnosticsProperty('userIds', userIds))
      ..add(DiagnosticsProperty('campaignIds', campaignIds));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgencyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.primaryColor, primaryColor) ||
                other.primaryColor == primaryColor) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._userIds, _userIds) &&
            const DeepCollectionEquality()
                .equals(other._campaignIds, _campaignIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      logoUrl,
      primaryColor,
      timezone,
      currency,
      settings,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_userIds),
      const DeepCollectionEquality().hash(_campaignIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AgencyImplCopyWith<_$AgencyImpl> get copyWith =>
      __$$AgencyImplCopyWithImpl<_$AgencyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AgencyImplToJson(
      this,
    );
  }
}

abstract class _Agency implements Agency {
  const factory _Agency(
      {required final String id,
      required final String name,
      final String? description,
      final String? logoUrl,
      final String? primaryColor,
      required final String timezone,
      required final String currency,
      required final AgencySettings settings,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final List<String>? userIds,
      final List<String>? campaignIds}) = _$AgencyImpl;

  factory _Agency.fromJson(Map<String, dynamic> json) = _$AgencyImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get logoUrl;
  @override
  String? get primaryColor;
  @override
  String get timezone;
  @override
  String get currency;
  @override
  AgencySettings get settings;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<String>? get userIds;
  @override
  List<String>? get campaignIds;
  @override
  @JsonKey(ignore: true)
  _$$AgencyImplCopyWith<_$AgencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AgencySettings _$AgencySettingsFromJson(Map<String, dynamic> json) {
  return _AgencySettings.fromJson(json);
}

/// @nodoc
mixin _$AgencySettings {
  bool get emailNotifications => throw _privateConstructorUsedError;
  bool get smsNotifications => throw _privateConstructorUsedError;
  bool get whatsappNotifications => throw _privateConstructorUsedError;
  int get dataRetentionDays => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;
  String? get googleAdsAccountId => throw _privateConstructorUsedError;
  String? get ga4PropertyId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get integrations => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AgencySettingsCopyWith<AgencySettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgencySettingsCopyWith<$Res> {
  factory $AgencySettingsCopyWith(
          AgencySettings value, $Res Function(AgencySettings) then) =
      _$AgencySettingsCopyWithImpl<$Res, AgencySettings>;
  @useResult
  $Res call(
      {bool emailNotifications,
      bool smsNotifications,
      bool whatsappNotifications,
      int dataRetentionDays,
      String timezone,
      String? googleAdsAccountId,
      String? ga4PropertyId,
      Map<String, dynamic>? integrations});
}

/// @nodoc
class _$AgencySettingsCopyWithImpl<$Res, $Val extends AgencySettings>
    implements $AgencySettingsCopyWith<$Res> {
  _$AgencySettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailNotifications = null,
    Object? smsNotifications = null,
    Object? whatsappNotifications = null,
    Object? dataRetentionDays = null,
    Object? timezone = null,
    Object? googleAdsAccountId = freezed,
    Object? ga4PropertyId = freezed,
    Object? integrations = freezed,
  }) {
    return _then(_value.copyWith(
      emailNotifications: null == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      smsNotifications: null == smsNotifications
          ? _value.smsNotifications
          : smsNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      whatsappNotifications: null == whatsappNotifications
          ? _value.whatsappNotifications
          : whatsappNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      dataRetentionDays: null == dataRetentionDays
          ? _value.dataRetentionDays
          : dataRetentionDays // ignore: cast_nullable_to_non_nullable
              as int,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      googleAdsAccountId: freezed == googleAdsAccountId
          ? _value.googleAdsAccountId
          : googleAdsAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      ga4PropertyId: freezed == ga4PropertyId
          ? _value.ga4PropertyId
          : ga4PropertyId // ignore: cast_nullable_to_non_nullable
              as String?,
      integrations: freezed == integrations
          ? _value.integrations
          : integrations // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgencySettingsImplCopyWith<$Res>
    implements $AgencySettingsCopyWith<$Res> {
  factory _$$AgencySettingsImplCopyWith(_$AgencySettingsImpl value,
          $Res Function(_$AgencySettingsImpl) then) =
      __$$AgencySettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool emailNotifications,
      bool smsNotifications,
      bool whatsappNotifications,
      int dataRetentionDays,
      String timezone,
      String? googleAdsAccountId,
      String? ga4PropertyId,
      Map<String, dynamic>? integrations});
}

/// @nodoc
class __$$AgencySettingsImplCopyWithImpl<$Res>
    extends _$AgencySettingsCopyWithImpl<$Res, _$AgencySettingsImpl>
    implements _$$AgencySettingsImplCopyWith<$Res> {
  __$$AgencySettingsImplCopyWithImpl(
      _$AgencySettingsImpl _value, $Res Function(_$AgencySettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailNotifications = null,
    Object? smsNotifications = null,
    Object? whatsappNotifications = null,
    Object? dataRetentionDays = null,
    Object? timezone = null,
    Object? googleAdsAccountId = freezed,
    Object? ga4PropertyId = freezed,
    Object? integrations = freezed,
  }) {
    return _then(_$AgencySettingsImpl(
      emailNotifications: null == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      smsNotifications: null == smsNotifications
          ? _value.smsNotifications
          : smsNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      whatsappNotifications: null == whatsappNotifications
          ? _value.whatsappNotifications
          : whatsappNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      dataRetentionDays: null == dataRetentionDays
          ? _value.dataRetentionDays
          : dataRetentionDays // ignore: cast_nullable_to_non_nullable
              as int,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      googleAdsAccountId: freezed == googleAdsAccountId
          ? _value.googleAdsAccountId
          : googleAdsAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      ga4PropertyId: freezed == ga4PropertyId
          ? _value.ga4PropertyId
          : ga4PropertyId // ignore: cast_nullable_to_non_nullable
              as String?,
      integrations: freezed == integrations
          ? _value._integrations
          : integrations // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AgencySettingsImpl
    with DiagnosticableTreeMixin
    implements _AgencySettings {
  const _$AgencySettingsImpl(
      {this.emailNotifications = true,
      this.smsNotifications = true,
      this.whatsappNotifications = true,
      this.dataRetentionDays = 30,
      this.timezone = 'Africa/Nairobi',
      this.googleAdsAccountId,
      this.ga4PropertyId,
      final Map<String, dynamic>? integrations})
      : _integrations = integrations;

  factory _$AgencySettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgencySettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool emailNotifications;
  @override
  @JsonKey()
  final bool smsNotifications;
  @override
  @JsonKey()
  final bool whatsappNotifications;
  @override
  @JsonKey()
  final int dataRetentionDays;
  @override
  @JsonKey()
  final String timezone;
  @override
  final String? googleAdsAccountId;
  @override
  final String? ga4PropertyId;
  final Map<String, dynamic>? _integrations;
  @override
  Map<String, dynamic>? get integrations {
    final value = _integrations;
    if (value == null) return null;
    if (_integrations is EqualUnmodifiableMapView) return _integrations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AgencySettings(emailNotifications: $emailNotifications, smsNotifications: $smsNotifications, whatsappNotifications: $whatsappNotifications, dataRetentionDays: $dataRetentionDays, timezone: $timezone, googleAdsAccountId: $googleAdsAccountId, ga4PropertyId: $ga4PropertyId, integrations: $integrations)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AgencySettings'))
      ..add(DiagnosticsProperty('emailNotifications', emailNotifications))
      ..add(DiagnosticsProperty('smsNotifications', smsNotifications))
      ..add(DiagnosticsProperty('whatsappNotifications', whatsappNotifications))
      ..add(DiagnosticsProperty('dataRetentionDays', dataRetentionDays))
      ..add(DiagnosticsProperty('timezone', timezone))
      ..add(DiagnosticsProperty('googleAdsAccountId', googleAdsAccountId))
      ..add(DiagnosticsProperty('ga4PropertyId', ga4PropertyId))
      ..add(DiagnosticsProperty('integrations', integrations));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgencySettingsImpl &&
            (identical(other.emailNotifications, emailNotifications) ||
                other.emailNotifications == emailNotifications) &&
            (identical(other.smsNotifications, smsNotifications) ||
                other.smsNotifications == smsNotifications) &&
            (identical(other.whatsappNotifications, whatsappNotifications) ||
                other.whatsappNotifications == whatsappNotifications) &&
            (identical(other.dataRetentionDays, dataRetentionDays) ||
                other.dataRetentionDays == dataRetentionDays) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.googleAdsAccountId, googleAdsAccountId) ||
                other.googleAdsAccountId == googleAdsAccountId) &&
            (identical(other.ga4PropertyId, ga4PropertyId) ||
                other.ga4PropertyId == ga4PropertyId) &&
            const DeepCollectionEquality()
                .equals(other._integrations, _integrations));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      emailNotifications,
      smsNotifications,
      whatsappNotifications,
      dataRetentionDays,
      timezone,
      googleAdsAccountId,
      ga4PropertyId,
      const DeepCollectionEquality().hash(_integrations));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AgencySettingsImplCopyWith<_$AgencySettingsImpl> get copyWith =>
      __$$AgencySettingsImplCopyWithImpl<_$AgencySettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AgencySettingsImplToJson(
      this,
    );
  }
}

abstract class _AgencySettings implements AgencySettings {
  const factory _AgencySettings(
      {final bool emailNotifications,
      final bool smsNotifications,
      final bool whatsappNotifications,
      final int dataRetentionDays,
      final String timezone,
      final String? googleAdsAccountId,
      final String? ga4PropertyId,
      final Map<String, dynamic>? integrations}) = _$AgencySettingsImpl;

  factory _AgencySettings.fromJson(Map<String, dynamic> json) =
      _$AgencySettingsImpl.fromJson;

  @override
  bool get emailNotifications;
  @override
  bool get smsNotifications;
  @override
  bool get whatsappNotifications;
  @override
  int get dataRetentionDays;
  @override
  String get timezone;
  @override
  String? get googleAdsAccountId;
  @override
  String? get ga4PropertyId;
  @override
  Map<String, dynamic>? get integrations;
  @override
  @JsonKey(ignore: true)
  _$$AgencySettingsImplCopyWith<_$AgencySettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  String get agencyId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get preferences => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String email,
      String name,
      String? avatarUrl,
      UserRole role,
      String agencyId,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? lastLoginAt,
      Map<String, dynamic>? preferences});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? role = null,
    Object? agencyId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastLoginAt = freezed,
    Object? preferences = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      agencyId: null == agencyId
          ? _value.agencyId
          : agencyId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String name,
      String? avatarUrl,
      UserRole role,
      String agencyId,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? lastLoginAt,
      Map<String, dynamic>? preferences});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? role = null,
    Object? agencyId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastLoginAt = freezed,
    Object? preferences = freezed,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      agencyId: null == agencyId
          ? _value.agencyId
          : agencyId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preferences: freezed == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl with DiagnosticableTreeMixin implements _User {
  const _$UserImpl(
      {required this.id,
      required this.email,
      required this.name,
      this.avatarUrl,
      required this.role,
      required this.agencyId,
      required this.createdAt,
      required this.updatedAt,
      this.lastLoginAt,
      final Map<String, dynamic>? preferences})
      : _preferences = preferences;

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String name;
  @override
  final String? avatarUrl;
  @override
  final UserRole role;
  @override
  final String agencyId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? lastLoginAt;
  final Map<String, dynamic>? _preferences;
  @override
  Map<String, dynamic>? get preferences {
    final value = _preferences;
    if (value == null) return null;
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'User(id: $id, email: $email, name: $name, avatarUrl: $avatarUrl, role: $role, agencyId: $agencyId, createdAt: $createdAt, updatedAt: $updatedAt, lastLoginAt: $lastLoginAt, preferences: $preferences)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'User'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('avatarUrl', avatarUrl))
      ..add(DiagnosticsProperty('role', role))
      ..add(DiagnosticsProperty('agencyId', agencyId))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt))
      ..add(DiagnosticsProperty('lastLoginAt', lastLoginAt))
      ..add(DiagnosticsProperty('preferences', preferences));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.agencyId, agencyId) ||
                other.agencyId == agencyId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      name,
      avatarUrl,
      role,
      agencyId,
      createdAt,
      updatedAt,
      lastLoginAt,
      const DeepCollectionEquality().hash(_preferences));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      required final String email,
      required final String name,
      final String? avatarUrl,
      required final UserRole role,
      required final String agencyId,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? lastLoginAt,
      final Map<String, dynamic>? preferences}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get name;
  @override
  String? get avatarUrl;
  @override
  UserRole get role;
  @override
  String get agencyId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get lastLoginAt;
  @override
  Map<String, dynamic>? get preferences;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NumberPool _$NumberPoolFromJson(Map<String, dynamic> json) {
  return _NumberPool.fromJson(json);
}

/// @nodoc
mixin _$NumberPool {
  String get id => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  NumberType get type => throw _privateConstructorUsedError;
  String? get countryCode => throw _privateConstructorUsedError;
  String? get areaCode => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get assignedCampaignId => throw _privateConstructorUsedError;
  String? get assignedCampaignName => throw _privateConstructorUsedError;
  NumberStatus get status => throw _privateConstructorUsedError;
  DateTime? get purchasedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get configuration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NumberPoolCopyWith<NumberPool> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NumberPoolCopyWith<$Res> {
  factory $NumberPoolCopyWith(
          NumberPool value, $Res Function(NumberPool) then) =
      _$NumberPoolCopyWithImpl<$Res, NumberPool>;
  @useResult
  $Res call(
      {String id,
      String phoneNumber,
      NumberType type,
      String? countryCode,
      String? areaCode,
      String? city,
      String? assignedCampaignId,
      String? assignedCampaignName,
      NumberStatus status,
      DateTime? purchasedAt,
      DateTime? expiresAt,
      Map<String, dynamic>? configuration});
}

/// @nodoc
class _$NumberPoolCopyWithImpl<$Res, $Val extends NumberPool>
    implements $NumberPoolCopyWith<$Res> {
  _$NumberPoolCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phoneNumber = null,
    Object? type = null,
    Object? countryCode = freezed,
    Object? areaCode = freezed,
    Object? city = freezed,
    Object? assignedCampaignId = freezed,
    Object? assignedCampaignName = freezed,
    Object? status = null,
    Object? purchasedAt = freezed,
    Object? expiresAt = freezed,
    Object? configuration = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NumberType,
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      areaCode: freezed == areaCode
          ? _value.areaCode
          : areaCode // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedCampaignId: freezed == assignedCampaignId
          ? _value.assignedCampaignId
          : assignedCampaignId // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedCampaignName: freezed == assignedCampaignName
          ? _value.assignedCampaignName
          : assignedCampaignName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as NumberStatus,
      purchasedAt: freezed == purchasedAt
          ? _value.purchasedAt
          : purchasedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      configuration: freezed == configuration
          ? _value.configuration
          : configuration // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NumberPoolImplCopyWith<$Res>
    implements $NumberPoolCopyWith<$Res> {
  factory _$$NumberPoolImplCopyWith(
          _$NumberPoolImpl value, $Res Function(_$NumberPoolImpl) then) =
      __$$NumberPoolImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String phoneNumber,
      NumberType type,
      String? countryCode,
      String? areaCode,
      String? city,
      String? assignedCampaignId,
      String? assignedCampaignName,
      NumberStatus status,
      DateTime? purchasedAt,
      DateTime? expiresAt,
      Map<String, dynamic>? configuration});
}

/// @nodoc
class __$$NumberPoolImplCopyWithImpl<$Res>
    extends _$NumberPoolCopyWithImpl<$Res, _$NumberPoolImpl>
    implements _$$NumberPoolImplCopyWith<$Res> {
  __$$NumberPoolImplCopyWithImpl(
      _$NumberPoolImpl _value, $Res Function(_$NumberPoolImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phoneNumber = null,
    Object? type = null,
    Object? countryCode = freezed,
    Object? areaCode = freezed,
    Object? city = freezed,
    Object? assignedCampaignId = freezed,
    Object? assignedCampaignName = freezed,
    Object? status = null,
    Object? purchasedAt = freezed,
    Object? expiresAt = freezed,
    Object? configuration = freezed,
  }) {
    return _then(_$NumberPoolImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NumberType,
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      areaCode: freezed == areaCode
          ? _value.areaCode
          : areaCode // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedCampaignId: freezed == assignedCampaignId
          ? _value.assignedCampaignId
          : assignedCampaignId // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedCampaignName: freezed == assignedCampaignName
          ? _value.assignedCampaignName
          : assignedCampaignName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as NumberStatus,
      purchasedAt: freezed == purchasedAt
          ? _value.purchasedAt
          : purchasedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      configuration: freezed == configuration
          ? _value._configuration
          : configuration // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NumberPoolImpl with DiagnosticableTreeMixin implements _NumberPool {
  const _$NumberPoolImpl(
      {required this.id,
      required this.phoneNumber,
      required this.type,
      this.countryCode,
      this.areaCode,
      this.city,
      this.assignedCampaignId,
      this.assignedCampaignName,
      required this.status,
      this.purchasedAt,
      this.expiresAt,
      final Map<String, dynamic>? configuration})
      : _configuration = configuration;

  factory _$NumberPoolImpl.fromJson(Map<String, dynamic> json) =>
      _$$NumberPoolImplFromJson(json);

  @override
  final String id;
  @override
  final String phoneNumber;
  @override
  final NumberType type;
  @override
  final String? countryCode;
  @override
  final String? areaCode;
  @override
  final String? city;
  @override
  final String? assignedCampaignId;
  @override
  final String? assignedCampaignName;
  @override
  final NumberStatus status;
  @override
  final DateTime? purchasedAt;
  @override
  final DateTime? expiresAt;
  final Map<String, dynamic>? _configuration;
  @override
  Map<String, dynamic>? get configuration {
    final value = _configuration;
    if (value == null) return null;
    if (_configuration is EqualUnmodifiableMapView) return _configuration;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NumberPool(id: $id, phoneNumber: $phoneNumber, type: $type, countryCode: $countryCode, areaCode: $areaCode, city: $city, assignedCampaignId: $assignedCampaignId, assignedCampaignName: $assignedCampaignName, status: $status, purchasedAt: $purchasedAt, expiresAt: $expiresAt, configuration: $configuration)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NumberPool'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('phoneNumber', phoneNumber))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('countryCode', countryCode))
      ..add(DiagnosticsProperty('areaCode', areaCode))
      ..add(DiagnosticsProperty('city', city))
      ..add(DiagnosticsProperty('assignedCampaignId', assignedCampaignId))
      ..add(DiagnosticsProperty('assignedCampaignName', assignedCampaignName))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('purchasedAt', purchasedAt))
      ..add(DiagnosticsProperty('expiresAt', expiresAt))
      ..add(DiagnosticsProperty('configuration', configuration));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NumberPoolImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.areaCode, areaCode) ||
                other.areaCode == areaCode) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.assignedCampaignId, assignedCampaignId) ||
                other.assignedCampaignId == assignedCampaignId) &&
            (identical(other.assignedCampaignName, assignedCampaignName) ||
                other.assignedCampaignName == assignedCampaignName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.purchasedAt, purchasedAt) ||
                other.purchasedAt == purchasedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality()
                .equals(other._configuration, _configuration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      phoneNumber,
      type,
      countryCode,
      areaCode,
      city,
      assignedCampaignId,
      assignedCampaignName,
      status,
      purchasedAt,
      expiresAt,
      const DeepCollectionEquality().hash(_configuration));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NumberPoolImplCopyWith<_$NumberPoolImpl> get copyWith =>
      __$$NumberPoolImplCopyWithImpl<_$NumberPoolImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NumberPoolImplToJson(
      this,
    );
  }
}

abstract class _NumberPool implements NumberPool {
  const factory _NumberPool(
      {required final String id,
      required final String phoneNumber,
      required final NumberType type,
      final String? countryCode,
      final String? areaCode,
      final String? city,
      final String? assignedCampaignId,
      final String? assignedCampaignName,
      required final NumberStatus status,
      final DateTime? purchasedAt,
      final DateTime? expiresAt,
      final Map<String, dynamic>? configuration}) = _$NumberPoolImpl;

  factory _NumberPool.fromJson(Map<String, dynamic> json) =
      _$NumberPoolImpl.fromJson;

  @override
  String get id;
  @override
  String get phoneNumber;
  @override
  NumberType get type;
  @override
  String? get countryCode;
  @override
  String? get areaCode;
  @override
  String? get city;
  @override
  String? get assignedCampaignId;
  @override
  String? get assignedCampaignName;
  @override
  NumberStatus get status;
  @override
  DateTime? get purchasedAt;
  @override
  DateTime? get expiresAt;
  @override
  Map<String, dynamic>? get configuration;
  @override
  @JsonKey(ignore: true)
  _$$NumberPoolImplCopyWith<_$NumberPoolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CallAnalytics _$CallAnalyticsFromJson(Map<String, dynamic> json) {
  return _CallAnalytics.fromJson(json);
}

/// @nodoc
mixin _$CallAnalytics {
  DateTime get date => throw _privateConstructorUsedError;
  int get totalCalls => throw _privateConstructorUsedError;
  int get uniqueCallers => throw _privateConstructorUsedError;
  int get qualifiedCalls => throw _privateConstructorUsedError;
  int get sales => throw _privateConstructorUsedError;
  int get spam => throw _privateConstructorUsedError;
  double get averageDuration => throw _privateConstructorUsedError;
  Map<String, int> get callsByCampaign => throw _privateConstructorUsedError;
  Map<String, int> get callsByCity => throw _privateConstructorUsedError;
  Map<String, int> get callsByHour => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CallAnalyticsCopyWith<CallAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallAnalyticsCopyWith<$Res> {
  factory $CallAnalyticsCopyWith(
          CallAnalytics value, $Res Function(CallAnalytics) then) =
      _$CallAnalyticsCopyWithImpl<$Res, CallAnalytics>;
  @useResult
  $Res call(
      {DateTime date,
      int totalCalls,
      int uniqueCallers,
      int qualifiedCalls,
      int sales,
      int spam,
      double averageDuration,
      Map<String, int> callsByCampaign,
      Map<String, int> callsByCity,
      Map<String, int> callsByHour});
}

/// @nodoc
class _$CallAnalyticsCopyWithImpl<$Res, $Val extends CallAnalytics>
    implements $CallAnalyticsCopyWith<$Res> {
  _$CallAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalCalls = null,
    Object? uniqueCallers = null,
    Object? qualifiedCalls = null,
    Object? sales = null,
    Object? spam = null,
    Object? averageDuration = null,
    Object? callsByCampaign = null,
    Object? callsByCity = null,
    Object? callsByHour = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalCalls: null == totalCalls
          ? _value.totalCalls
          : totalCalls // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueCallers: null == uniqueCallers
          ? _value.uniqueCallers
          : uniqueCallers // ignore: cast_nullable_to_non_nullable
              as int,
      qualifiedCalls: null == qualifiedCalls
          ? _value.qualifiedCalls
          : qualifiedCalls // ignore: cast_nullable_to_non_nullable
              as int,
      sales: null == sales
          ? _value.sales
          : sales // ignore: cast_nullable_to_non_nullable
              as int,
      spam: null == spam
          ? _value.spam
          : spam // ignore: cast_nullable_to_non_nullable
              as int,
      averageDuration: null == averageDuration
          ? _value.averageDuration
          : averageDuration // ignore: cast_nullable_to_non_nullable
              as double,
      callsByCampaign: null == callsByCampaign
          ? _value.callsByCampaign
          : callsByCampaign // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      callsByCity: null == callsByCity
          ? _value.callsByCity
          : callsByCity // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      callsByHour: null == callsByHour
          ? _value.callsByHour
          : callsByHour // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CallAnalyticsImplCopyWith<$Res>
    implements $CallAnalyticsCopyWith<$Res> {
  factory _$$CallAnalyticsImplCopyWith(
          _$CallAnalyticsImpl value, $Res Function(_$CallAnalyticsImpl) then) =
      __$$CallAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      int totalCalls,
      int uniqueCallers,
      int qualifiedCalls,
      int sales,
      int spam,
      double averageDuration,
      Map<String, int> callsByCampaign,
      Map<String, int> callsByCity,
      Map<String, int> callsByHour});
}

/// @nodoc
class __$$CallAnalyticsImplCopyWithImpl<$Res>
    extends _$CallAnalyticsCopyWithImpl<$Res, _$CallAnalyticsImpl>
    implements _$$CallAnalyticsImplCopyWith<$Res> {
  __$$CallAnalyticsImplCopyWithImpl(
      _$CallAnalyticsImpl _value, $Res Function(_$CallAnalyticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalCalls = null,
    Object? uniqueCallers = null,
    Object? qualifiedCalls = null,
    Object? sales = null,
    Object? spam = null,
    Object? averageDuration = null,
    Object? callsByCampaign = null,
    Object? callsByCity = null,
    Object? callsByHour = null,
  }) {
    return _then(_$CallAnalyticsImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalCalls: null == totalCalls
          ? _value.totalCalls
          : totalCalls // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueCallers: null == uniqueCallers
          ? _value.uniqueCallers
          : uniqueCallers // ignore: cast_nullable_to_non_nullable
              as int,
      qualifiedCalls: null == qualifiedCalls
          ? _value.qualifiedCalls
          : qualifiedCalls // ignore: cast_nullable_to_non_nullable
              as int,
      sales: null == sales
          ? _value.sales
          : sales // ignore: cast_nullable_to_non_nullable
              as int,
      spam: null == spam
          ? _value.spam
          : spam // ignore: cast_nullable_to_non_nullable
              as int,
      averageDuration: null == averageDuration
          ? _value.averageDuration
          : averageDuration // ignore: cast_nullable_to_non_nullable
              as double,
      callsByCampaign: null == callsByCampaign
          ? _value._callsByCampaign
          : callsByCampaign // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      callsByCity: null == callsByCity
          ? _value._callsByCity
          : callsByCity // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      callsByHour: null == callsByHour
          ? _value._callsByHour
          : callsByHour // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CallAnalyticsImpl
    with DiagnosticableTreeMixin
    implements _CallAnalytics {
  const _$CallAnalyticsImpl(
      {required this.date,
      required this.totalCalls,
      required this.uniqueCallers,
      required this.qualifiedCalls,
      required this.sales,
      required this.spam,
      required this.averageDuration,
      required final Map<String, int> callsByCampaign,
      required final Map<String, int> callsByCity,
      required final Map<String, int> callsByHour})
      : _callsByCampaign = callsByCampaign,
        _callsByCity = callsByCity,
        _callsByHour = callsByHour;

  factory _$CallAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CallAnalyticsImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int totalCalls;
  @override
  final int uniqueCallers;
  @override
  final int qualifiedCalls;
  @override
  final int sales;
  @override
  final int spam;
  @override
  final double averageDuration;
  final Map<String, int> _callsByCampaign;
  @override
  Map<String, int> get callsByCampaign {
    if (_callsByCampaign is EqualUnmodifiableMapView) return _callsByCampaign;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_callsByCampaign);
  }

  final Map<String, int> _callsByCity;
  @override
  Map<String, int> get callsByCity {
    if (_callsByCity is EqualUnmodifiableMapView) return _callsByCity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_callsByCity);
  }

  final Map<String, int> _callsByHour;
  @override
  Map<String, int> get callsByHour {
    if (_callsByHour is EqualUnmodifiableMapView) return _callsByHour;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_callsByHour);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CallAnalytics(date: $date, totalCalls: $totalCalls, uniqueCallers: $uniqueCallers, qualifiedCalls: $qualifiedCalls, sales: $sales, spam: $spam, averageDuration: $averageDuration, callsByCampaign: $callsByCampaign, callsByCity: $callsByCity, callsByHour: $callsByHour)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CallAnalytics'))
      ..add(DiagnosticsProperty('date', date))
      ..add(DiagnosticsProperty('totalCalls', totalCalls))
      ..add(DiagnosticsProperty('uniqueCallers', uniqueCallers))
      ..add(DiagnosticsProperty('qualifiedCalls', qualifiedCalls))
      ..add(DiagnosticsProperty('sales', sales))
      ..add(DiagnosticsProperty('spam', spam))
      ..add(DiagnosticsProperty('averageDuration', averageDuration))
      ..add(DiagnosticsProperty('callsByCampaign', callsByCampaign))
      ..add(DiagnosticsProperty('callsByCity', callsByCity))
      ..add(DiagnosticsProperty('callsByHour', callsByHour));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallAnalyticsImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalCalls, totalCalls) ||
                other.totalCalls == totalCalls) &&
            (identical(other.uniqueCallers, uniqueCallers) ||
                other.uniqueCallers == uniqueCallers) &&
            (identical(other.qualifiedCalls, qualifiedCalls) ||
                other.qualifiedCalls == qualifiedCalls) &&
            (identical(other.sales, sales) || other.sales == sales) &&
            (identical(other.spam, spam) || other.spam == spam) &&
            (identical(other.averageDuration, averageDuration) ||
                other.averageDuration == averageDuration) &&
            const DeepCollectionEquality()
                .equals(other._callsByCampaign, _callsByCampaign) &&
            const DeepCollectionEquality()
                .equals(other._callsByCity, _callsByCity) &&
            const DeepCollectionEquality()
                .equals(other._callsByHour, _callsByHour));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      totalCalls,
      uniqueCallers,
      qualifiedCalls,
      sales,
      spam,
      averageDuration,
      const DeepCollectionEquality().hash(_callsByCampaign),
      const DeepCollectionEquality().hash(_callsByCity),
      const DeepCollectionEquality().hash(_callsByHour));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CallAnalyticsImplCopyWith<_$CallAnalyticsImpl> get copyWith =>
      __$$CallAnalyticsImplCopyWithImpl<_$CallAnalyticsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CallAnalyticsImplToJson(
      this,
    );
  }
}

abstract class _CallAnalytics implements CallAnalytics {
  const factory _CallAnalytics(
      {required final DateTime date,
      required final int totalCalls,
      required final int uniqueCallers,
      required final int qualifiedCalls,
      required final int sales,
      required final int spam,
      required final double averageDuration,
      required final Map<String, int> callsByCampaign,
      required final Map<String, int> callsByCity,
      required final Map<String, int> callsByHour}) = _$CallAnalyticsImpl;

  factory _CallAnalytics.fromJson(Map<String, dynamic> json) =
      _$CallAnalyticsImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get totalCalls;
  @override
  int get uniqueCallers;
  @override
  int get qualifiedCalls;
  @override
  int get sales;
  @override
  int get spam;
  @override
  double get averageDuration;
  @override
  Map<String, int> get callsByCampaign;
  @override
  Map<String, int> get callsByCity;
  @override
  Map<String, int> get callsByHour;
  @override
  @JsonKey(ignore: true)
  _$$CallAnalyticsImplCopyWith<_$CallAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WhatsAppMessage _$WhatsAppMessageFromJson(Map<String, dynamic> json) {
  return _WhatsAppMessage.fromJson(json);
}

/// @nodoc
mixin _$WhatsAppMessage {
  String get id => throw _privateConstructorUsedError;
  String get contactName => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  MessageDirection get direction => throw _privateConstructorUsedError;
  MessageStatus get status => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get campaignId => throw _privateConstructorUsedError;
  String? get gclid => throw _privateConstructorUsedError;
  String? get mediaUrl => throw _privateConstructorUsedError;
  String? get templateId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WhatsAppMessageCopyWith<WhatsAppMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WhatsAppMessageCopyWith<$Res> {
  factory $WhatsAppMessageCopyWith(
          WhatsAppMessage value, $Res Function(WhatsAppMessage) then) =
      _$WhatsAppMessageCopyWithImpl<$Res, WhatsAppMessage>;
  @useResult
  $Res call(
      {String id,
      String contactName,
      String phoneNumber,
      String message,
      MessageDirection direction,
      MessageStatus status,
      DateTime timestamp,
      String? campaignId,
      String? gclid,
      String? mediaUrl,
      String? templateId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$WhatsAppMessageCopyWithImpl<$Res, $Val extends WhatsAppMessage>
    implements $WhatsAppMessageCopyWith<$Res> {
  _$WhatsAppMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? contactName = null,
    Object? phoneNumber = null,
    Object? message = null,
    Object? direction = null,
    Object? status = null,
    Object? timestamp = null,
    Object? campaignId = freezed,
    Object? gclid = freezed,
    Object? mediaUrl = freezed,
    Object? templateId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as MessageDirection,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      campaignId: freezed == campaignId
          ? _value.campaignId
          : campaignId // ignore: cast_nullable_to_non_nullable
              as String?,
      gclid: freezed == gclid
          ? _value.gclid
          : gclid // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WhatsAppMessageImplCopyWith<$Res>
    implements $WhatsAppMessageCopyWith<$Res> {
  factory _$$WhatsAppMessageImplCopyWith(_$WhatsAppMessageImpl value,
          $Res Function(_$WhatsAppMessageImpl) then) =
      __$$WhatsAppMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String contactName,
      String phoneNumber,
      String message,
      MessageDirection direction,
      MessageStatus status,
      DateTime timestamp,
      String? campaignId,
      String? gclid,
      String? mediaUrl,
      String? templateId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$WhatsAppMessageImplCopyWithImpl<$Res>
    extends _$WhatsAppMessageCopyWithImpl<$Res, _$WhatsAppMessageImpl>
    implements _$$WhatsAppMessageImplCopyWith<$Res> {
  __$$WhatsAppMessageImplCopyWithImpl(
      _$WhatsAppMessageImpl _value, $Res Function(_$WhatsAppMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? contactName = null,
    Object? phoneNumber = null,
    Object? message = null,
    Object? direction = null,
    Object? status = null,
    Object? timestamp = null,
    Object? campaignId = freezed,
    Object? gclid = freezed,
    Object? mediaUrl = freezed,
    Object? templateId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$WhatsAppMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as MessageDirection,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      campaignId: freezed == campaignId
          ? _value.campaignId
          : campaignId // ignore: cast_nullable_to_non_nullable
              as String?,
      gclid: freezed == gclid
          ? _value.gclid
          : gclid // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WhatsAppMessageImpl
    with DiagnosticableTreeMixin
    implements _WhatsAppMessage {
  const _$WhatsAppMessageImpl(
      {required this.id,
      required this.contactName,
      required this.phoneNumber,
      required this.message,
      required this.direction,
      required this.status,
      required this.timestamp,
      this.campaignId,
      this.gclid,
      this.mediaUrl,
      this.templateId,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$WhatsAppMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$WhatsAppMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String contactName;
  @override
  final String phoneNumber;
  @override
  final String message;
  @override
  final MessageDirection direction;
  @override
  final MessageStatus status;
  @override
  final DateTime timestamp;
  @override
  final String? campaignId;
  @override
  final String? gclid;
  @override
  final String? mediaUrl;
  @override
  final String? templateId;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WhatsAppMessage(id: $id, contactName: $contactName, phoneNumber: $phoneNumber, message: $message, direction: $direction, status: $status, timestamp: $timestamp, campaignId: $campaignId, gclid: $gclid, mediaUrl: $mediaUrl, templateId: $templateId, metadata: $metadata)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WhatsAppMessage'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('contactName', contactName))
      ..add(DiagnosticsProperty('phoneNumber', phoneNumber))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('direction', direction))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('campaignId', campaignId))
      ..add(DiagnosticsProperty('gclid', gclid))
      ..add(DiagnosticsProperty('mediaUrl', mediaUrl))
      ..add(DiagnosticsProperty('templateId', templateId))
      ..add(DiagnosticsProperty('metadata', metadata));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WhatsAppMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.campaignId, campaignId) ||
                other.campaignId == campaignId) &&
            (identical(other.gclid, gclid) || other.gclid == gclid) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      contactName,
      phoneNumber,
      message,
      direction,
      status,
      timestamp,
      campaignId,
      gclid,
      mediaUrl,
      templateId,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WhatsAppMessageImplCopyWith<_$WhatsAppMessageImpl> get copyWith =>
      __$$WhatsAppMessageImplCopyWithImpl<_$WhatsAppMessageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WhatsAppMessageImplToJson(
      this,
    );
  }
}

abstract class _WhatsAppMessage implements WhatsAppMessage {
  const factory _WhatsAppMessage(
      {required final String id,
      required final String contactName,
      required final String phoneNumber,
      required final String message,
      required final MessageDirection direction,
      required final MessageStatus status,
      required final DateTime timestamp,
      final String? campaignId,
      final String? gclid,
      final String? mediaUrl,
      final String? templateId,
      final Map<String, dynamic>? metadata}) = _$WhatsAppMessageImpl;

  factory _WhatsAppMessage.fromJson(Map<String, dynamic> json) =
      _$WhatsAppMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get contactName;
  @override
  String get phoneNumber;
  @override
  String get message;
  @override
  MessageDirection get direction;
  @override
  MessageStatus get status;
  @override
  DateTime get timestamp;
  @override
  String? get campaignId;
  @override
  String? get gclid;
  @override
  String? get mediaUrl;
  @override
  String? get templateId;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$WhatsAppMessageImplCopyWith<_$WhatsAppMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

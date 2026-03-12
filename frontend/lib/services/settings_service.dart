import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage_service.dart';

class AppSettings {
  final bool setupCompleted;
  final String theme;
  final Map<String, dynamic> apiConfig;

  AppSettings({
    this.setupCompleted = false,
    this.theme = 'system',
    this.apiConfig = const {},
  });

  AppSettings copyWith({
    bool? setupCompleted,
    String? theme,
    Map<String, dynamic>? apiConfig,
  }) {
    return AppSettings(
      setupCompleted: setupCompleted ?? this.setupCompleted,
      theme: theme ?? this.theme,
      apiConfig: apiConfig ?? this.apiConfig,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setupCompleted': setupCompleted,
      'theme': theme,
      'apiConfig': apiConfig,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      setupCompleted: json['setupCompleted'] ?? false,
      theme: json['theme'] ?? 'system',
      apiConfig: json['apiConfig'] ?? {},
    );
  }
}

class SettingsService extends StateNotifier<AppSettings> {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal() : super(AppSettings());

  bool _initialized = false;
  final _storage = storageServiceSingleton;

  Future<void> initialize() async {
    if (_initialized) return;

    final box = await _storage.settingsBox;
    final settingsJson = box.get('app_settings') as Map<dynamic, dynamic>?;
    
    if (settingsJson != null) {
      state = AppSettings.fromJson(Map<String, dynamic>.from(settingsJson));
    }

    _initialized = true;
  }

  bool get isInitialized => _initialized;
  AppSettings get settings => state;
  bool get setupCompleted => state.setupCompleted;

  Future<void> updateSettings(AppSettings newSettings) async {
    state = newSettings;
    final box = await _storage.settingsBox;
    await box.put('app_settings', newSettings.toJson());
  }

  Future<void> setSetupCompleted(bool completed) async {
    final newSettings = state.copyWith(setupCompleted: completed);
    await updateSettings(newSettings);
  }

  Future<void> setTheme(String theme) async {
    final newSettings = state.copyWith(theme: theme);
    await updateSettings(newSettings);
  }

  Future<void> setApiConfig(Map<String, dynamic> config) async {
    final newSettings = state.copyWith(apiConfig: config);
    await updateSettings(newSettings);
  }
}

final settingsServiceProvider = StateNotifierProvider<SettingsService, AppSettings>((ref) {
  return settingsServiceSingleton;
});

final settingsServiceSingleton = SettingsService();

Future<void> initializeSettingsService() async {
  await settingsServiceSingleton.initialize();
}

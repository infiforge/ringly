import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final dbDir = await _getDbDirectory();
      Hive.init(dbDir.path);
    }

    // Open boxes
    await Hive.openBox('auth');
    await Hive.openBox('settings');
    await Hive.openBox('cache');

    _initialized = true;
  }

  Future<Directory> _getDbDirectory() async {
    String basePath;
    if (Platform.isWindows) {
      basePath = Platform.environment['APPDATA'] ??
          (await getApplicationSupportDirectory()).parent.path;
    } else if (Platform.isMacOS) {
      basePath = '${Platform.environment['HOME']}/Library/Application Support';
    } else if (Platform.isLinux) {
      basePath = '${Platform.environment['HOME']}/.config';
    } else if (Platform.isAndroid || Platform.isIOS) {
      basePath = (await getApplicationSupportDirectory()).path;
    } else {
      basePath = (await getApplicationSupportDirectory()).path;
    }
    final dbDir = Directory(p.join(basePath, 'Ringly', 'db'));
    await dbDir.create(recursive: true);
    return dbDir;
  }

  Future<Box> get authBox async {
    await initialize();
    return Hive.box('auth');
  }

  Future<Box> get settingsBox async {
    await initialize();
    return Hive.box('settings');
  }

  Future<Box> get cacheBox async {
    await initialize();
    return Hive.box('cache');
  }
}

final storageServiceSingleton = StorageService();

Future<void> initializeStorageService() async {
  await storageServiceSingleton.initialize();
}

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

enum LogLevel { debug, info, warning, error }

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;
  LoggerService._internal();

  late Logger _logger;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: kDebugMode ? Level.debug : Level.info,
    );

    _initialized = true;
  }

  void debug(String message, {String? source, Map<String, dynamic>? metadata}) {
    _logger.d('[${source ?? 'APP'}] $message', error: metadata);
  }

  void info(String message, {String? source, Map<String, dynamic>? metadata}) {
    _logger.i('[${source ?? 'APP'}] $message', error: metadata);
  }

  void warning(String message, {String? source, Map<String, dynamic>? metadata}) {
    _logger.w('[${source ?? 'APP'}] $message', error: metadata);
  }

  void error(String message, {String? source, Map<String, dynamic>? metadata, dynamic error, StackTrace? stackTrace}) {
    _logger.e('[${source ?? 'APP'}] $message', error: error, stackTrace: stackTrace);
  }
}

final loggerServiceSingleton = LoggerService();

Future<void> initializeLoggerService() async {
  await loggerServiceSingleton.initialize();
}

import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class Logger {
  static const String _prefix = '🎬 TikTok Clone';

  static void debug(String message, [dynamic data]) {
    _log(LogLevel.debug, message, data);
  }

  static void info(String message, [dynamic data]) {
    _log(LogLevel.info, message, data);
  }

  static void warning(String message, [dynamic data]) {
    _log(LogLevel.warning, message, data);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error);
    if (stackTrace != null && kDebugMode) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static void _log(LogLevel level, String message, [dynamic data]) {
    if (!kDebugMode) return;

    final emoji = _getEmoji(level);
    final levelName = level.name.toUpperCase();
    final timestamp = DateTime.now().toIso8601String();

    final logMessage = StringBuffer()
      ..write('$emoji $_prefix [$levelName] ')
      ..write('[$timestamp] ')
      ..write(message);

    if (data != null) {
      logMessage.write('\nData: $data');
    }

    debugPrint(logMessage.toString());
  }

  static String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }

  static void logApiRequest(String method, String endpoint, [dynamic body]) {
    debug('API Request: $method $endpoint', body);
  }

  static void logApiResponse(int statusCode, String endpoint, [dynamic data]) {
    info('API Response: $statusCode $endpoint', data);
  }

  static void logApiError(String endpoint, dynamic error) {
    Logger.error('API Error: $endpoint', error);
  }
}
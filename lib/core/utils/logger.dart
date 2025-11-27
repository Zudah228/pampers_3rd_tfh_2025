import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:simple_logger/simple_logger.dart';

Logger get logger => SimpleLoggerAdapter();

abstract interface class Logger {
  void debug(String message);
  void info(String message);
  void warn(String message);
  void error(
    String message, {
    required Object error,
    required StackTrace stackTrace,
  });
}

@reopen
class SimpleLoggerAdapter extends Logger {
  SimpleLoggerAdapter() {
    _logger = SimpleLogger()
      ..setLevel(
        kDebugMode ? .ALL : .OFF,
        includeCallerInfo: true,
        callerInfoFrameLevelOffset: 1,
      )
      ..formatter = (LogInfo info) {
        const divider = '------------------';
        final emoji = SimpleLogger().levelPrefixes[info.level] ?? '';
        final time = DateFormat('yyyy-MM-dd HH:mm').format(info.time);
        final callerFrame =
            '${info.callerFrame ?? 'caller info not available'}';
        final message = StringBuffer('$divider\n$emoji ${info.message}\n ');

        if (info.error != null) {
          message.write(
            '[ $time ]\n'
            '${info.error}\n'
            '${info.stackTrace}\n ',
          );
        } else {
          message.write('[ $time $callerFrame ]\n');
        }

        message.write('$divider${divider[0] * 9}\n　');

        return message.toString();
      };
  }

  late SimpleLogger _logger;

  @override
  void debug(String message) {
    _logger.fine(message);
  }

  @override
  void info(String message) {
    _logger.info(message);
  }

  @override
  void warn(String message) {
    _logger.warning(message);
  }

  @override
  void error(
    String message, {
    required Object error,
    required StackTrace stackTrace,
  }) {
    _logger.severe(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

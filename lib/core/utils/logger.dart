import 'package:flutter/material.dart';

class Logger {
  static LogMode _logMode = LogMode.debug;

  static void init(LogMode mode) {
    Logger._logMode = mode;
  }

  static void e(String tag, dynamic message) {
    if (_logMode == LogMode.debug) {
      debugPrint('[$tag] : $message');
    }
  }
}

enum LogMode { debug, live }

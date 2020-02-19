/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'package:logging/logging.dart';

class Log {
  final _log = Logger('gsheet_to_arb');
  bool _verbose;

  static final Log _singleton = Log._internal();

  Log._internal() {
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.message}');
    });
    verbose = false;
  }

  bool get verbose => _verbose;

  set verbose(bool isVerbose) {
    _verbose = isVerbose;
    if (_verbose) {
      Logger.root.level = Level.ALL;
    } else {
      Logger.root.level = Level.CONFIG;
    }
  }

  static void i(String text) {
    _singleton._log.config(text);
  }

  static void v(String text) {
    _singleton._log.info(text);
  }

  static void d(String text) {
    _singleton._log.warning(text);
  }

  static void e(String text) {
    _singleton._log.severe(text);
  }
}

extension LogExtensions on dynamic {
  void logi(String text, [dynamic error, StackTrace stackTrace]) {
    Log.i('[$this] text');
  }

  void logd(String text, [dynamic error, StackTrace stackTrace]) {
    Log.d('[$this] text');
  }

  void logv(String text, [dynamic error, StackTrace stackTrace]) {
    Log.v('[$this] text');
  }

  void loge(String text, [dynamic error, StackTrace stackTrace]) {
    Log.e('[$this] text');
  }
}

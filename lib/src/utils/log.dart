/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'package:logging/logging.dart';

class Log {
  final _log = Logger('gsheet_to_arb');
  late bool _verbose;

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

  final times = <DateTime>[];

  void _startTimeTracking() {
    times.add(DateTime.now());
  }

  String _stopTimeTracking() {
    if (times.isEmpty) {
      return '0ms';
    }
    final startTime = times.removeLast();
    var duration = DateTime.now().difference(startTime).inMilliseconds;
    final durationString = (duration.toDouble() / 1000.0).toStringAsFixed(1);

    return '${durationString}s';
  }

  static void startTimeTracking() {
    _singleton._startTimeTracking();
  }

  static String stopTimeTracking() {
    return _singleton._stopTimeTracking();
  }

  static void i(String text) {
    _singleton._log.config('[INFO] $text');
  }

  static void v(String text) {
    _singleton._log.info('[VERBOSE] $text');
  }

  static void d(String text) {
    _singleton._log.warning('[DEBUG] $text');
  }

  static void e(String text) {
    _singleton._log.severe('[ERROR] $text');
  }
}

extension LogExtensions on dynamic {
  void logi(String text, [dynamic error, StackTrace? stackTrace]) {
    Log.i('[$this] text');
  }

  void logd(String text, [dynamic error, StackTrace? stackTrace]) {
    Log.d('[$this] text');
  }

  void logv(String text, [dynamic error, StackTrace? stackTrace]) {
    Log.v('[$this] text');
  }

  void loge(String text, [dynamic error, StackTrace? stackTrace]) {
    Log.e('[$this] text');
  }
}

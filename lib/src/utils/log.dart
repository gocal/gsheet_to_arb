/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'package:logging/logging.dart';

class Log {
  bool get verbose => _verbose;

  set verbose(bool isVerbose) {
    _verbose = isVerbose;
    if (_verbose) {
      Logger.root.level = Level.ALL;
    } else {
      Logger.root.level = Level.CONFIG;
    }
  }

  final Logger _log = Logger('gsheet_to_arb');
  bool _verbose = false;

  static final Log _singleton = new Log._internal();

  Log._internal() {
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.message}');
    });
    verbose = false;
  }

  static i(String text) {
    _singleton._log.config(text);
  }

  static v(String text) {
    _singleton._log.info(text);
  }
}

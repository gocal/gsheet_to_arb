/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

#!/usr/bin/env dart
library gsheet_to_arb;

import 'dart:io';

import 'package:args/args.dart';

main(List<String> args) {
  var parser = new ArgParser();

  parser.parse(args);
  if (args.length == 0) {
    print('Imports ARB file from exisiting GSheet document');
    print('Usage: gsheet_to_arb [options] [files.dart]');
    print(parser.usage);
    exit(0);
  }
}
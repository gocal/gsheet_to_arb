/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'package:gsheet_to_arb/src/arb/arb_utils.dart';
import 'package:test/test.dart';

void main() {
  group('arb_utils_tests', () {
    setUp(() {});

    test('findPlaceholders Test', () {
      var list = findPlaceholders('');
      assert(list.isEmpty);

      list = findPlaceholders('no matches');
      assert(list.isEmpty);

      list = findPlaceholders('Hi {name}!');
      assert(list.length == 1);

      list = findPlaceholders('Hi {name} {name2}!');
      assert(list.length == 2);
    });
  });
}

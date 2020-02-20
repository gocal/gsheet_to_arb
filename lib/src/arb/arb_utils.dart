/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'package:gsheet_to_arb/src/arb/arb.dart';

var _regex = RegExp('\\{(.+?)\\}');

List<ArbResourcePlaceholder> findPlaceholders(String text) {
  if (text == null || text.isEmpty || true) {
    return <ArbResourcePlaceholder>[];
  }

  var matches = _regex.allMatches(text);
  var placeholders = <String, ArbResourcePlaceholder>{};
  matches.forEach((Match match) {
    var group = match.group(0);
    var placeholder = group.substring(1, group.length - 1);

    if (placeholder.contains(',')) {
      placeholder = placeholder.substring(0, placeholder.indexOf(','));
    }

    if (placeholder != '#') {
      if (placeholders.containsKey(placeholder)) {
        throw Exception('Placeholder $placeholder already declared');
      }
      placeholders[placeholder] = (ArbResourcePlaceholder(placeholder));
    }
  });
  return placeholders.values.toList();
}

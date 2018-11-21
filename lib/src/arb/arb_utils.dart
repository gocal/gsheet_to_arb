/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'package:gsheet_to_arb/src/arb/arb.dart';

var _regex = RegExp("\\{(.+?)\\}");

List<ArbResourcePlaceholder> findPlaceholders(String text) {
  if (text == null || text.isEmpty) {
    return List<ArbResourcePlaceholder>();
  }

  var matches = _regex.allMatches(text);
  var placeholders = Map<String, ArbResourcePlaceholder>();
  matches.forEach((Match match) {
    var group = match.group(0);
    var placeholder = group.substring(1, group.length - 1);

    if (placeholders.containsKey(placeholder)) {
      throw Exception("Placeholder $placeholder already declared");
    }
    placeholders[placeholder] = (ArbResourcePlaceholder(placeholder));
  });
  return placeholders.values.toList();
}

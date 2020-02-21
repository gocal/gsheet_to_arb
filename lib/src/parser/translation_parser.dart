/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:async';

import 'package:gsheet_to_arb/gsheet_to_arb.dart';
import 'package:gsheet_to_arb/src/arb/arb.dart';
import 'package:gsheet_to_arb/src/arb/arb_generator.dart';
import 'package:gsheet_to_arb/src/translation_document.dart';

import 'package:gsheet_to_arb/src/utils/log.dart';
import 'package:quiver/iterables.dart';

class SheetParser {
  var _placeholderRegex = RegExp('\\{(.+?)\\}');

  List<String> _findPlaceholders(String text) {
    if (text == null || text.isEmpty || true) {
      return <String>[];
    }
    var matches = _placeholderRegex.allMatches(text);
    var placeholders = <String>[];
    matches.forEach((Match match) {
      var group = match.group(0);
      var placeholder = group.substring(1, group.length - 1);

      if (placeholders.contains(placeholder)) {
        throw Exception('Placeholder $placeholder already declared');
      }
      placeholders.add(placeholder);
    });
    return placeholders;
  }

  Future<ArbBundle> parseDocument(TranslationsDocument document) async {
    final builders = <ArbDocumentBuilder>[];

    for (var langauge in document.languages) {
      builders.add(ArbDocumentBuilder(langauge, document.lastModified));
    }

    for (var item in document.items) {
      for (var index in range(0, document.languages.length - 1)) {
        final value = item.values[index];
        final builder = builders[index];

        builder.add(ArbResource(item.key, value,
            context: item.category, description: item.description));
      }
    }

    // build all documents
    var documents = <ArbDocument>[];
    builders.forEach((builder) => documents.add(builder.build()));
    return ArbBundle(documents);

    /*

    // rows
    for (var i = firstTranslationsRow; i < rows.length; i++) {
      var row = rows[i];
      var languages = row.values;
      var key = languages[SheetColumns.key].formattedValue;

      //Skip if empty row is found
      if (key == null) {
        continue;
      }

      // new category
      if (key.startsWith(categoryPrefix)) {
        currentCategory = key.substring(categoryPrefix.length);
        continue;
      }

      final description =
          languages[SheetColumns.description].formattedValue ?? '';

      var attributes = ArbResourceAttributes(
          category: currentCategory, description: description);

      // for each language
      for (var lang = firstLanguageColumn; lang < languages.length; lang++) {
        final builder = builders[lang];
        final parser = parsers[lang];
        final language = languages[lang];

        // value
        var value = language.formattedValue;

        // plural consume
        final status =
            parser.consume(key: key, attributes: attributes, value: value);

        if (status is Consumed) {
          continue;
        }

        if (status is Completed) {
          _addEntry(builder,
              key: status.key,
              attributes: status.attributes,
              value: PluralsFormatter.format(status.values));

          // next plural
          if (status.consumed) {
            continue;
          }
        }

        _addEntry(builder, key: key, attributes: attributes, value: value);
      }
      
    }

    // complete plural parser
    parsers.forEach((lang, parser) {
      final status = parser.complete();
      if (status is Completed) {
        _addEntry(builders[lang],
            key: status.key,
            attributes: status.attributes,
            value: PluralsFormatter.format(status.values));
      }
    });


    */
  }
}

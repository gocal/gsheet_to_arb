/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:async';
import 'package:gsheet_to_arb/src/arb/arb.dart';
import 'package:gsheet_to_arb/src/arb/arb_generator.dart';
import 'package:gsheet_to_arb/src/translation_document.dart';
import 'package:gsheet_to_arb/src/utils/log.dart';
import 'package:quiver/iterables.dart';

import 'plurals_parser.dart';

class SheetParser {
  Future<ArbBundle> parseDocument(TranslationsDocument document) async {
    final builders = <ArbDocumentBuilder>[];
    final parsers = <PluralsParser>[];

    for (var langauge in document.languages) {
      final builder = ArbDocumentBuilder(langauge, document.lastModified);
      final parser = PluralsParser();
      builders.add(builder);
      parsers.add(parser);
    }

    // for each row
    for (var item in document.items) {
      // for each language
      for (var index in range(0, document.languages.length - 1)) {
        final itemValue = item.values[index];
        final itemPlaceholders = _findPlaceholders(itemValue);

        final builder = builders[index];
        final parser = parsers[index];

        // plural consume
        final status = parser.consume(
            key: item.key, value: itemValue, placeholders: itemPlaceholders);

        if (status is Consumed) {
          continue;
        }

        if (status is Completed) {
          builder.add(ArbResource(
              status.key, PluralsFormatter.format(status.values),
              context: item.category,
              description: item.description,
              placeholders: status.placeholders));

          // next plural
          if (status.consumed) {
            continue;
          }
        }

        builder.add(ArbResource(item.key, itemValue,
            context: item.category,
            description: item.description,
            placeholders: itemPlaceholders));
      }
    }

    // finalizer
    /*
    for (var index in range(0, document.languages.length - 1)) {
      final parser = parsers[index];
      final status = parser.complete();
      if (status is Completed) {
        /*
        builder.add(ArbResource(
            status.key, PluralsFormatter.format(status.values),
            context: status.category,
            description: status.description,
            placeholders: status.placeholders));
            */
      }
    }*/

    // build all documents
    var documents = <ArbDocument>[];
    builders.forEach((builder) => documents.add(builder.build()));
    return ArbBundle(documents);
  }

  final _placeholderRegex = RegExp('\\{(.+?)\\}');

  // TODO add type parsing
  List<ArbResourcePlaceholder> _findPlaceholders(String text) {
    if (text == null || text.isEmpty) {
      return <ArbResourcePlaceholder>[];
    }

    var matches = _placeholderRegex.allMatches(text);
    var placeholders = <String, ArbResourcePlaceholder>{};
    matches.forEach((Match match) {
      var group = match.group(0);
      var placeholder = group.substring(1, group.length - 1);

      if (placeholders.containsKey(placeholder)) {
        throw Exception('Placeholder $placeholder already declared');
      }
      placeholders[placeholder] = (ArbResourcePlaceholder(name: placeholder));
    });
    return placeholders.values.toList();
  }
}

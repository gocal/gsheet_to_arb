/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:async';
import 'package:gsheet_to_arb/src/arb/arb.dart';
import 'package:gsheet_to_arb/src/translation_document.dart';

import 'package:quiver/iterables.dart' as iterables;

import '_plurals_parser.dart';

class TranslationParser {
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
      for (var index in iterables.range(0, document.languages.length)) {
        final itemValue = item.values[index];
        final itemPlaceholders = _findPlaceholders(itemValue);

        final builder = builders[index];
        final parser = parsers[index];

        // plural consume
        final status = parser.consume(ArbResource(item.key, itemValue,
            placeholders: itemPlaceholders,
            context: item.category,
            description: item.description));

        if (status is Consumed) {
          continue;
        }

        if (status is Completed) {
          builder.add(status.resource);

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
    for (var index in iterables.range(0, document.languages.length - 1)) {
      final builder = builders[index];
      final parser = parsers[index];
      final status = parser.complete();
      if (status is Completed) {
        builder.add(status.resource);
      }
    }

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
      var placeholderName = group.substring(1, group.length - 1);

      if (placeholders.containsKey(placeholderName)) {
        throw Exception('Placeholder $placeholderName already declared');
      }
      placeholders[placeholderName] = (ArbResourcePlaceholder(
          name: placeholderName, type: 'text')); // TODO extract text
    });
    return placeholders.values.toList();
  }
}

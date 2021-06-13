/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:async';
import 'package:gsheet_to_arb/src/arb/arb.dart';
import 'package:gsheet_to_arb/src/translation_document.dart';
import 'package:gsheet_to_arb/src/utils/log.dart';

import '_plurals_parser.dart';

class TranslationParser {
  final bool addContextPrefix;
  final String? caseType;

  TranslationParser({required this.addContextPrefix, this.caseType});

  Future<ArbBundle> parseDocument(TranslationsDocument document) async {
    final builders = <ArbDocumentBuilder>[];
    final parsers = <PluralsParser>[];

    for (var langauge in document.languages) {
      final builder = ArbDocumentBuilder(langauge, document.lastModified);
      final parser = PluralsParser(addContextPrefix, caseType);
      builders.add(builder);
      parsers.add(parser);
    }

    // for each row
    for (var item in document.items) {
      // for each language
      for (var index in Iterable<int>.generate(document.languages.length)) {
        var itemValue;
        //incase value does not exist
        if (index < item.values.length) {
          itemValue = item.values[index];
        } else {
          itemValue = '';
        }

        if (itemValue == '') {
          Log.i('WARNING: empty string in lang: ' +
              document.languages[index] +
              ', key: ' +
              item.key);
        }

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

        final key = PluralsParser.reCase(
            addContextPrefix && item.category.isNotEmpty
                ? item.category + '_' + item.key
                : item.key,
            caseType);

        // add resource
        builder.add(ArbResource(key, itemValue,
            context: item.category,
            description: item.description,
            placeholders: itemPlaceholders));
      }
    }

    // finalizer
    for (var index in Iterable<int>.generate(document.languages.length - 1)) {
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

  List<ArbResourcePlaceholder> _findPlaceholders(String? text) {
    if (text == null || text.isEmpty) {
      return <ArbResourcePlaceholder>[];
    }

    var matches = _placeholderRegex.allMatches(text);
    var placeholders = <String, ArbResourcePlaceholder>{};
    matches.forEach((Match match) {
      var group = match.group(0);

      if (group != null) {
        var placeholderName = group.substring(1, group.length - 1);

        if (placeholders.containsKey(placeholderName)) {
          throw Exception('Placeholder $placeholderName already declared');
        }
        placeholders[placeholderName] =
            (ArbResourcePlaceholder(name: placeholderName, type: 'text'));
      }
    });
    return placeholders.values.toList();
  }
}

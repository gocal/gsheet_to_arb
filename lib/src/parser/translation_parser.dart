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

class SheetParser {
  Future<ArbBundle> parseDocument(TranslationsDocument document) async {
    return null;

    /*
    Log.i('Opening ${spreadsheet.spreadsheetUrl}');

    var sheet = spreadsheet.sheets[0];
    var rows = sheet.data[0].rowData;
    var header = rows[0];

    final parsers = <int, PluralsParser>{};
    final builders = <int, ArbDocumentBuilder>{};

    var headerValues = header.values;

    var lastModified = DateTime.now();

    var firstLanguageColumn = SheetColumns.first_language_key;

    var firstTranslationsRow = SheetRows.first_translation_row;
    var currentCategory = '';

    // Store languages
    for (var lang = firstLanguageColumn; lang < headerValues.length; lang++) {
      //Ignore empty header columns
      if (headerValues[lang].formattedValue != null) {
        var languageKey = headerValues[lang].formattedValue;
        builders[lang] = (ArbDocumentBuilder(languageKey, lastModified));
        parsers[lang] = PluralsParser();
      }
    }

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

    // build all documents
    var documents = <ArbDocument>[];
    builders.forEach((_, builder) => documents.add(builder.build()));
    return ArbBundle(documents);
    */
  }

  void _addEntry(ArbDocumentBuilder builder,
      {String key, ArbResourceAttributes attributes, String value}) {
    Log.i('Add entry $key -> $value');

    final entry = ArbResource(key, value)
      ..attributes['context'] = attributes.category
      ..attributes['description'] = attributes.description;

    // add entry for language
    builder.add(entry);
  }
}

///
/// resource attributes
///
class ArbResourceAttributes {
  final String category;
  final String description;

  ArbResourceAttributes({this.category, this.description});
}

///
/// Plurals
///
enum PluralCase { zero, one, two, few, many, other }

abstract class PluralsStatus {}

class Skip extends PluralsStatus {}

class Consumed extends PluralsStatus {}

class Completed extends PluralsStatus {
  final String key;
  final ArbResourceAttributes attributes;
  final Map<PluralCase, String> values;
  final bool consumed;

  Completed({this.key, this.attributes, this.values, this.consumed = false});
}

class PluralsParser {
  final _pluralSeparator = '=';

  final _pluralKeywords = {
    'zero': PluralCase.zero,
    'one': PluralCase.one,
    'two': PluralCase.two,
    'few': PluralCase.few,
    'many': PluralCase.many,
    'other': PluralCase.other
  };

  String _key;
  ArbResourceAttributes _attributes;
  final _values = <PluralCase, String>{};

  PluralsStatus consume(
      {String key, ArbResourceAttributes attributes, String value}) {
    final pluralCase = _getCase(key);

    // normal item
    if (pluralCase == null) {
      if (_values.isNotEmpty) {
        final status = Completed(
            attributes: attributes,
            consumed: false,
            key: _key,
            values: Map.from(_values));
        _key = null;
        _attributes = null;
        _values.clear();
        return status;
      } else {
        _key = null;
        _attributes = null;
        return Skip();
      }
    }

    // plural item
    final caseKey = _getCaseKey(key);

    if (_key == caseKey) {
      // same plural
      _values[pluralCase] = value;
      return Consumed();
    } else if (_key == null) {
      // first plural
      _key = caseKey;
      _attributes = attributes;
      _values[pluralCase] = value;
      return Consumed();
    } else {
      // another plural
      PluralsStatus status;
      if (_values.isNotEmpty) {
        status = Completed(
            attributes: _attributes,
            consumed: true,
            key: _key,
            values: Map.from(_values));
      } else {
        status = Consumed();
      }
      _key = caseKey;
      _attributes = attributes;
      _values.clear();
      _values[pluralCase] = value;
      return status;
    }
  }

  PluralsStatus complete() {
    if (_values.isNotEmpty) {
      return Completed(key: _key, attributes: _attributes, values: _values);
    }

    return Skip();
  }

  PluralCase _getCase(String key) {
    if (key.contains(_pluralSeparator)) {
      for (var plural in _pluralKeywords.keys) {
        if (key.endsWith('$_pluralSeparator$plural')) {
          return _pluralKeywords[plural];
        }
      }
    }
    return null;
  }

  String _getCaseKey(String key) {
    return key.substring(0, key.lastIndexOf(_pluralSeparator));
  }
}

class PluralsFormatter {
  static final String _countConst = 'count';

  static final _icuPluralFormats = {
    PluralCase.zero: '=zero',
    PluralCase.one: '=one',
    PluralCase.two: '=two',
    PluralCase.few: 'few',
    PluralCase.many: 'many',
    PluralCase.other: 'other'
  };

  static String format(Map<PluralCase, String> plural) {
    final builder = StringBuffer();
    builder.write('{$_countConst, plural,');
    plural.forEach((key, value) {
      if (value != null) {
        builder.write(
            ' ${_icuPluralFormats[key]} {${value.replaceAll("\{#\}", "\{$_countConst\}")}}');
      }
    });
    builder.write('}');
    return builder.toString();
  }
}

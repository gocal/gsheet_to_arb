/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:async';

import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:gsheet_to_arb/gsheet_to_arb.dart';
import 'package:gsheet_to_arb/src/arb/arb.dart';
import 'package:gsheet_to_arb/src/arb/arb_generator.dart';
import 'package:gsheet_to_arb/src/utils/log.dart';

class SheetColumns {
  static int key = 0;
  static int description = 1;
  static int first_language_key = 2;
}

class SheetRows {
  static int first_translation_row = 1;
}

class SheetParser {
  final AuthConfig auth;
  final String categoryPrefix;

  SheetParser({this.auth, this.categoryPrefix});

  final _languages = <ArbDocumentBuilder>[];

  Future<ArbBundle> parseSheet(String documentId) async {
    var authClient = await _getAuthClient(auth);

    var arbBundle = await _parseSheetWithAuth(authClient, documentId);
    return arbBundle;
  }

  Future<AuthClient> _getAuthClient(AuthConfig auth) async {
    final scopes = [SheetsApi.SpreadsheetsReadonlyScope];
    var authClient;
    if (auth.oauthClientId != null) {
      void clientAuthPrompt(String url) {
        Log.i(
            'Please go to the following URL and grant Google Spreadsheet access:\n\t=> $url\n');
      }

      final client = auth.oauthClientId;
      var id = ClientId(client.clientId, client.clientSecret);
      authClient = await clientViaUserConsent(id, scopes, clientAuthPrompt);
    } else if (auth.serviceAccountKey != null) {
      final service = auth.serviceAccountKey;
      var credentials = ServiceAccountCredentials(service.clientEmail,
          ClientId(service.clientId, null), service.privateKey);
      authClient = await clientViaServiceAccount(credentials, scopes);
    }
    return authClient;
  }

  Future<ArbBundle> _parseSheetWithAuth(
      AuthClient client, String documentId) async {
    var sheetsApi = SheetsApi(client);
    var spreadsheet =
        await sheetsApi.spreadsheets.get(documentId, includeGridData: true);

    var bundle = _parseSpreadsheet(spreadsheet);

    client.close();

    return bundle;
  }

  ArbBundle _parseSpreadsheet(Spreadsheet spreadsheet) {
    Log.i('Opening ${spreadsheet.spreadsheetUrl}');

    var sheet = spreadsheet.sheets[0];
    var rows = sheet.data[0].rowData;
    var header = rows[0];
    var langToPlural = <int, PluralsParser>{};

    var headerValues = header.values;

    var lastModified = DateTime.now();

    var firstLanguageColumn = SheetColumns.first_language_key;

    // Store languages
    for (var lang = firstLanguageColumn; lang < headerValues.length; lang++) {
      //Ignore empty header columns
      if (headerValues[lang].formattedValue != null) {
        var languageKey = headerValues[lang].formattedValue;
        _languages.add(ArbDocumentBuilder(languageKey, lastModified));
      }
    }

    // Skip header row
    var firstTranslationsRow = SheetRows.first_translation_row;
    var currentCategory = '';
    for (var i = firstTranslationsRow; i < rows.length; i++) {
      var row = rows[i];
      var values = row.values;
      var key = values[0].formattedValue;

      //Skip if empty row is found
      if (key == null) {
        continue;
      }
      if (key.startsWith(categoryPrefix)) {
        currentCategory = key.substring(categoryPrefix.length);
        continue;
      }

      //Stop if empty row is found
      if (values[0].formattedValue == null) {
        break;
      }

      var description = values[1].formattedValue ?? '';

      for (var language = firstLanguageColumn;
          language < values.length;
          language++) {
        var value = values[language].formattedValue;
        var pluralParser = langToPlural[language];
        var pluralStatus = pluralParser.parse(key, value);
        if (pluralStatus == PluralsParserStatus.consumed) {
          continue;
        } else if (pluralStatus == PluralsParserStatus.completed) {
          var entry = ArbResource(pluralParser.key, pluralParser.value);
          entry.attributes['context'] = '';
          entry.attributes['description'] = '';
          _languages[language - firstLanguageColumn].add(entry);
        }

        var entry = ArbResource(key, value);
        entry.attributes['context'] = currentCategory;
        entry.attributes['description'] = description;
        _languages[language - firstLanguageColumn].add(entry);
      }
    }

    // build all documents
    var documents = <ArbDocument>[];
    _languages.forEach((builder) => documents.add(builder.build()));
    return ArbBundle(documents);
  }
}

class PluralsParser {
  static final _regex = RegExp('\\{(.+?), plural\\}'); // {(.+?), plural\s?}

  final pluralKeywords = ['zero', 'one', 'two', 'few', 'many', 'other'];

  bool _parsing = false;

  String _key;
  String _keyValue;
  String _value;

  final _plurals = <String, String>{};

  String get key => _key;

  String get value => _value;

  PluralsParserStatus parse(String key, String value) {
    // Already parsing
    if (_parsing) {
      if (key.startsWith(_key)) {
        var pluralPrefix = key.substring(_key.length + 1);
        _plurals[pluralPrefix] = value;
        return PluralsParserStatus.consumed;
      } else {
        if (_plurals.isEmpty) {
          throw Exception('Expected at least one plural element');
        }

        var builder = StringBuffer();
        _plurals.forEach((String prefix, String value) {
          builder.write(' $prefix: {$value}');
        });
        _value =
            _keyValue.replaceAll('plural}', 'plural,${builder.toString()}}');

        return PluralsParserStatus.completed;
      }
    }

    var matches = _regex.allMatches(value);

    if (matches.isEmpty) {
      _key = null;
      _plurals.clear();
      _parsing = false;
      return PluralsParserStatus.notFound;
    }

    if (matches.length > 1) {
      throw Exception('Only single plural parameter allowed');
    }

    // Start parsing
    _key = key;
    _keyValue = value;
    _parsing = true;
    return PluralsParserStatus.consumed;
  }
}

enum PluralsParserStatus {
  notFound,
  consumed,
  completed,
}

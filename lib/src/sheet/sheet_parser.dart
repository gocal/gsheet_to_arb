/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:async';

import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:gsheet_to_arb/gsheet_to_arb.dart';
import 'package:gsheet_to_arb/src/arb/arb.dart';
import 'package:gsheet_to_arb/src/utils/log.dart';

class SheetParser {
  final Auth auth;
  final String categoryPrefix;

  SheetParser({this.auth, this.categoryPrefix});

  var _languages = List<ArbDocumentBuilder>();
  var _scopes = [SheetsApi.SpreadsheetsReadonlyScope];

  Future<ArbBundle> parseSheet(String documentId) async {
    var authClient = await _authClient(auth);

    var arbBundle = await _handleSheetsAuth(authClient, documentId);
    return arbBundle;
  }

  Future<AuthClient> _authClient(Auth auth) async {
    var authClient;

    if (auth.serviceAccountKey != null) {
      var accountCredentials = ServiceAccountCredentials(
          auth.serviceAccountKey.clientEmail,
          ClientId(auth.serviceAccountKey.clientId, null),
          auth.serviceAccountKey.privateKey);
      authClient = await clientViaServiceAccount(accountCredentials, _scopes);
    } else if (auth.oauthClientId != null) {
      var id = new ClientId(
          auth.oauthClientId.clientId, auth.oauthClientId.clientSecret);
      authClient = await clientViaUserConsent(id, _scopes, _prompt);
    }
    return authClient;
  }

  void _prompt(String url) {
    Log.i("Please go to the following URL and grant Google Spreasheet access:");
    Log.i("  => $url");
    Log.i("");
  }

  Future<ArbBundle> _handleSheetsAuth(AuthClient client,
      String documentId) async {
    var sheetsApi = SheetsApi(client);
    var spreadsheet =
    await sheetsApi.spreadsheets.get(documentId, includeGridData: true);

    var bundle = _handleSpreadsheet(spreadsheet);

    client.close();

    return bundle;
  }

  ArbBundle _handleSpreadsheet(Spreadsheet spreadsheet) {
    Log.i("Opening ${spreadsheet.spreadsheetUrl}");

    var sheet = spreadsheet.sheets[0];
    var rows = sheet.data[0].rowData;
    var header = rows[0];
    var langToPlural = Map<int, PluralsParser>();

    var headerValues = header.values;

    var lastModified = DateTime.now();

    var firstLanguageColumn = 2; // key, description

    // Store languages
    for (var lang = firstLanguageColumn; lang < headerValues.length; lang++) {
      //Ignore empty header columns
      if(headerValues[lang].formattedValue != null) {
        var language = headerValues[lang].formattedValue;
        _languages.add(ArbDocumentBuilder(language, lastModified));

      }
    }

    // Skip header row
    var firstTranslationsRow = 1;

    var currentCategory = "";

    for (var i = firstTranslationsRow; i < rows.length; i++) {
      var row = rows[i];
      var columns = row.values;

      var key = columns[0].formattedValue;

      if (key.startsWith(categoryPrefix)) {
        currentCategory = key.substring(categoryPrefix.length);
        continue;
      }

      //Stop if empty row is found
      if(columns[0].formattedValue == null) {
        break;
      }

      var description = columns[1].formattedValue ?? "";

      for (var language = firstLanguageColumn;
      language < columns.length;
      language++) {
        var value = columns[language].formattedValue;
        var pluralParser = langToPlural[language];
        var pluralStatus = pluralParser.parse(key, value);
        if (pluralStatus == PluralsParserStatus.consumed) {
          continue;
        } else if (pluralStatus == PluralsParserStatus.completed) {
          var entry = ArbResource(pluralParser.key, pluralParser.value);
          entry.attributes['context'] = ""; // TODO
          entry.attributes['description'] = ""; // TODO
          _languages[language - firstLanguageColumn].add(entry);
        }

        var entry = ArbResource(key, value);
        entry.attributes['context'] = currentCategory;
        entry.attributes['description'] = description;
        _languages[language - firstLanguageColumn].add(entry);
      }
    }

    // build all documents
    var documents = List<ArbDocument>();
    _languages.forEach((builder) => documents.add(builder.build()));
    return ArbBundle(documents);
  }
}

class PluralsParser {
  static final _regex = RegExp("\\{(.+?), plural\\}"); // {(.+?), plural\s?}

  final pluralKeywords = ["zero", "one", "two", "few", "many", "other"];

  bool _parsing = false;

  String _key;
  String _keyValue;
  String _value;

  var _plurals = Map<String, String>();

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
          throw Exception("Expected at least one plural element");
        }

        var builder = StringBuffer();
        _plurals.forEach((String prefix, String value) {
          builder.write(" $prefix: {$value}");
        });
        _value =
            _keyValue.replaceAll("plural}", "plural,${builder.toString()}}");

        return PluralsParserStatus.completed;
      }
    }

    var matches = _regex.allMatches(value);

    if (matches.length == 0) {
      _key = null;
      _plurals.clear();
      _parsing = false;
      return PluralsParserStatus.notFound;
    }

    if (matches.length > 1) {
      throw Exception("Only single plural parameter allowed");
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

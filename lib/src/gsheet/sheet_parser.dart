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
import 'package:gsheet_to_arb/src/utils/log.dart';

class SheetParser {
  final AuthConfig auth;
  final String categoryPrefix;

  SheetParser({this.auth, this.categoryPrefix});

  final _languages = <ArbDocumentBuilder>[];
  final _scopes = [SheetsApi.SpreadsheetsReadonlyScope];

  Future<ArbBundle> parseSheet(String documentId) async {
    var authClient = await _authClient(auth);

    var arbBundle = await _handleSheetsAuth(authClient, documentId);
    return arbBundle;
  }

  Future<AuthClient> _authClient(AuthConfig auth) async {
    var authClient;

    if (auth.serviceAccountKey != null) {
      var accountCredentials = ServiceAccountCredentials(
          auth.serviceAccountKey.clientEmail,
          ClientId(auth.serviceAccountKey.clientId, null),
          auth.serviceAccountKey.privateKey);
      authClient = await clientViaServiceAccount(accountCredentials, _scopes);
    } else if (auth.oauthClientId != null) {
      var id = ClientId(
          auth.oauthClientId.clientId, auth.oauthClientId.clientSecret);
      authClient = await clientViaUserConsent(id, _scopes, _prompt);
    }
    return authClient;
  }

  void _prompt(String url) {
    Log.i(
        'Please go to the following URL and grant Google Spreadsheet access:');
    Log.i('  => $url');
    Log.i('');
  }

  Future<ArbBundle> _handleSheetsAuth(
      AuthClient client, String documentId) async {
    var sheetsApi = SheetsApi(client);
    var spreadsheet =
        await sheetsApi.spreadsheets.get(documentId, includeGridData: true);

    var bundle = _handleSpreadsheet(spreadsheet);

    client.close();

    return bundle;
  }

  ArbBundle _handleSpreadsheet(Spreadsheet spreadsheet) {
    Log.i('Opening ${spreadsheet.spreadsheetUrl}');

    var sheet = spreadsheet.sheets[0];
    var rows = sheet.data[0].rowData;
    var header = rows[0];

    var headerValues = header.values;

    var lastModified = DateTime.now();

    var firstLanguageColumn = 2; // key, description

    // Store languages
    for (var lang = firstLanguageColumn; lang < headerValues.length; lang++) {
      //Ignore empty header columns
      if (headerValues[lang].formattedValue != null) {
        var languageKey = headerValues[lang].formattedValue;
        _languages.add(ArbDocumentBuilder(languageKey, lastModified));
      }
    }

    // Skip header row
    var firstTranslationsRow = 1;

    var currentCategory = '';

    for (var i = firstTranslationsRow; i < rows.length; i++) {
      var row = rows[i];
      var values = row.values;

      //Stop if empty row is found
      if (values[0].formattedValue == null) {
        break;
      }

      if (values[0].formattedValue.startsWith(categoryPrefix)) {
        currentCategory =
            values[0].formattedValue.substring(categoryPrefix.length);
        continue;
      }

      var key = values[0].formattedValue;
      var description = values[1].formattedValue;
      description ??= '';

      for (var langValue = 0; langValue < _languages.length; langValue++) {
        var value = values[langValue + firstLanguageColumn].formattedValue;
        var builder = _languages[langValue];
        var entry = ArbResource(key, value);
        entry.attributes['context'] = currentCategory;
        entry.attributes['description'] = description;
        builder.add(entry);
      }
    }
    var documents = <ArbDocument>[];
    _languages.forEach((builder) => documents.add(builder.build()));
    return ArbBundle(documents);
  }
}

/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:async';

import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:gsheet_to_arb/gsheet_to_arb.dart';

class SheetParser {
  var _languages = List<ArbDocumentBuilder>();
  var _scopes = [SheetsApi.SpreadsheetsReadonlyScope];

  Future<ArbBundle> parseSheet(GoogleSheetConfig config) async {
    var id = new ClientId(config.clientId, config.clientSecret);

    var authClient = await clientViaUserConsent(id, _scopes, _prompt);
    var arbBundle = await _handleSheetsAuth(authClient, config.documentId);
    return arbBundle;
  }

  void _prompt(String url) {
    print("Please go to the following URL and grant Google Spreasheet access:");
    print("  => $url");
    print("");
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
    print("Opening ${spreadsheet.spreadsheetUrl}");

    var sheet = spreadsheet.sheets[0];
    var rows = sheet.data[0].rowData;
    var header = rows[0];

    var headerValues = header.values;

    var lastModified = DateTime.now();

    var firstLanguageColumn = 2; // key, description

    // Store languages
    for (var lang = firstLanguageColumn; lang < headerValues.length; lang++) {
      var languageKey = headerValues[lang].formattedValue;
      _languages.add(ArbDocumentBuilder(languageKey, lastModified));
    }

    // Skip header row
    var firstTranslationsRow = 1;

    var currentContext = "";

    for (var i = firstTranslationsRow; i < rows.length; i++) {
      var row = rows[i];
      var values = row.values;

      if (values.length == 1) {
        currentContext = values[0].formattedValue;
        continue;
      }

      var key = values[0].formattedValue;
      var description = values[1].formattedValue;
      if (description == null) {
        description = "";
      }

      for (var langValue = firstLanguageColumn; langValue < values.length;
      langValue++) {
        var value = values[langValue].formattedValue;
        var builder = _languages[langValue - firstLanguageColumn];

        var entry = ArbEntry(key, value);

        entry.attributes['context'] = currentContext;
        entry.attributes['description'] = description;

        builder.add(entry);
      }
    }

    var documents = List<ArbDocument>();

    _languages.forEach((builder) => documents.add(builder.build()));

    return ArbBundle(documents);
  }
}

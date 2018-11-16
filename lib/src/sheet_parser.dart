/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:io';

import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:gsheet_to_arb/gsheet_to_arb.dart';

class SheetParser {
  PluginConfig config;

  var languages = List<ArbBundleBuilder>();

  void parseSheet(PluginConfig config) {
    this.config = config;
    var id = new ClientId(config.clientId, config.clientSecret);
    var scopes = [SheetsApi.SpreadsheetsReadonlyScope];

    clientViaUserConsent(id, scopes, prompt).then(
        (AuthClient client) => handleSheetsAuth(client, config.documentId));
  }

  void prompt(String url) {
    print("Please go to the following URL and grant Google Spreasheet access:");
    print("  => $url");
    print("");
  }

  void handleSheetsAuth(AuthClient client, String documentId) {
    var sheetsApi = SheetsApi(client);
    sheetsApi.spreadsheets
        .get(documentId, includeGridData: true)
        .then(handleSpreadsheet, onError: handleSpreadsheetError);

    client.close();
  }

  void handleSpreadsheet(Spreadsheet spreadsheet) {
    print("Opening ${spreadsheet.spreadsheetUrl}");

    var sheet = spreadsheet.sheets[0];
    var rows = sheet.data[0].rowData;
    var header = rows[0];

    var headerValues = header.values;

    var lastModified = DateTime.now();

    // Store languages
    for (var lang = 1; lang < headerValues.length; lang++) {
      var languageKey = headerValues[lang].formattedValue;
      languages.add(ArbBundleBuilder(languageKey, lastModified));
    }

    // Skip header row
    for (var i = 1; i < rows.length; i++) {
      var row = rows[i];
      var values = row.values;

      var key = values[0].formattedValue;

      for (var langValue = 1; langValue < values.length; langValue++) {
        var value = values[langValue].formattedValue;
        languages[langValue - 1].add(key, value);
      }
    }

    saveArbFiles();
  }

  void handleSpreadsheetError() {
    print("handleSpreadsheetError");
  }

  void saveArbFiles() {
    print("save arb files in ${config.outputDirectoryPath}");
    var targetDir = Directory(config.outputDirectoryPath);
    targetDir.createSync();
    languages.forEach(
        (builder) => saveArb(builder.build(), targetDir, builder.locale));
  }

  void saveArb(ArbBundle bundle, Directory directory, String name) {
    var filePath = "${directory.path}/${config.arbFilePrefix}_${name}.arb";
    print("  => $filePath");
    var file = File(filePath);
    file.createSync();
    var encoder = new JsonEncoder.withIndent('  ');
    var arbContent = encoder.convert(bundle.toJson());
    file.writeAsString(arbContent);
  }
}

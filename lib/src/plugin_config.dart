/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

class PluginConfig {
  var outputDirectoryPath = "lib/src/i18n";
  var arbFilePrefix = "intl";

  GoogleSheetConfig sheetConfig;

  PluginConfig.fromYaml(Map<String, dynamic> yaml) {
    arbFilePrefix = yaml['arb_file_prefix'];
    outputDirectoryPath = yaml['output_directory'];

    var sheetConfigYaml = yaml['gsheet'];
    var clientId = sheetConfigYaml['client_id'];
    var clientSecret = sheetConfigYaml['client_secret'];
    var documentId = sheetConfigYaml['document_id'];

    sheetConfig = GoogleSheetConfig(
        clientId: clientId, clientSecret: clientSecret, documentId: documentId);
  }

  PluginConfig();
}

class GoogleSheetConfig {
  String clientId;
  String clientSecret;
  String documentId;
  String sheetId;

  GoogleSheetConfig(
      {this.clientId, this.clientSecret, this.documentId, this.sheetId = '0'});
}

/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:io';
import 'package:yaml/yaml.dart';

class PluginConfig {
  var outputDirectoryPath = "lib/src/i18n";
  var arbFilePrefix = "intl";

  GoogleSheetConfig sheetConfig;

  PluginConfig.fromYamlFile(String filePath) {
    var yaml = _loadYamlFile(filePath);
    PluginConfig.fromYaml(yaml);
  }

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
}

class GoogleSheetConfig {
  String clientId;
  String clientSecret;
  String documentId;
  String sheetId;

  GoogleSheetConfig(
      {this.clientId, this.clientSecret, this.documentId, this.sheetId = '0'});
}

Map<String, dynamic> _loadYamlFile(String path) {
  var configFile = File(path);
  var configText = configFile.readAsStringSync();
  var configYaml = loadYaml(configText);
  var yaml = configYaml['gsheet_to_arb'];
  return yaml;
}

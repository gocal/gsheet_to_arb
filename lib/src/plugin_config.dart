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
    _fromYaml(yaml);
  }

  _fromYaml(Map<dynamic, dynamic> yaml) {
    var config = yaml['gsheet_to_arb'];

    arbFilePrefix = config['arb_file_prefix'];
    outputDirectoryPath = config['output_directory'];

    var sheetConfigYaml = config['gsheet'];
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

YamlMap _loadYamlFile(String path) {
  var configFile = File(path);
  var configText = configFile.readAsStringSync();
  var yaml = loadYaml(configText);
  return yaml;
}

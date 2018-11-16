/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

library gsheet_to_arb;

import 'dart:io';

import 'package:args/args.dart';
import 'package:gsheet_to_arb/gsheet_to_arb.dart';
import 'package:yaml/yaml.dart';

main(List<String> args) {
  var parser = new ArgParser();
  var config = PluginConfig();
  var sheetParser = SheetParser();

  parser.addOption("config",
      defaultsTo: config.configFilePath,
      callback: (x) => config.configFilePath = x,
      help: 'config yaml file name');

  parser.addOption("output-dir",
      defaultsTo: config.outputDirectoryPath,
      callback: (x) => config.outputDirectoryPath = x,
      help: 'output directory path');

  parser.addOption("file-prefix",
      defaultsTo: config.arbFilePrefix,
      callback: (x) => config.arbFilePrefix = x, help: 'arb file prefix');

  parser.parse(args);
  if (args.length == 0) {
    print('Imports ARB file from exisiting GSheet document');
    print('Usage: gsheet_to_arb [options]');
    print(parser.usage);
    exit(0);
  }

  var configFile = File(config.configFilePath);
  var configText = configFile.readAsStringSync();
  var configYaml = loadYaml(configText);

  var yaml = configYaml['gsheet_to_arb'];

  var sheetConfig = yaml['gsheet'];

  config.clientId = sheetConfig['client_id'];
  config.clientSecret = sheetConfig['client_secret'];
  config.documentId = sheetConfig['document_id'];

  sheetParser.parseSheet(config);
}


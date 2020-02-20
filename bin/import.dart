/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

library gsheet_to_arb;

import 'dart:io';

import 'package:args/args.dart';
import 'package:gsheet_to_arb/gsheet_to_arb.dart';
import 'package:gsheet_to_arb/src/config/plugin_config_manager.dart';
import 'package:gsheet_to_arb/src/utils/log.dart';

void main(List<String> args) async {
  var parser = ArgParser();

  bool showHelp;
  bool generateCode;
  bool createConfig;

  parser.addFlag('help',
      negatable: false,
      callback: (value) => showHelp = value,
      help: 'show help');
  parser.addFlag('generate-code',
      negatable: false,
      callback: (value) => generateCode = value,
      help: 'generate dart code');
  parser.addFlag('create-config',
      negatable: false,
      callback: (value) => createConfig = value,
      help: 'generate configuration files');

  parser.parse(args);

  final configManager = PluginConfigManager();

  if (createConfig) {
    configManager.createConfig();
    return;
  }

  if (showHelp) {
    Log.i('Imports ARB file from exisiting GSheet document');
    Log.i('Usage: gsheet_to_arb [options]');
    Log.i(parser.usage);
    exit(0);
  }

  final config = await configManager.getConfig();
  if (config == null) {
    Log.i('Config not found - please create config first');
    exit(1);
  }

  if (config.gsheet.auth == null) {
    Log.i(
        'Authetnication config not found - please add config to ${config.gsheet.authFile} file');
    exit(1);
  }

  final auth = config.gsheet.auth;

  if (auth.oauthClientId == null && auth.serviceAccountKey == null) {
    Log.i(
        'Authetnication config is invalid - please add config to ${config.gsheet.authFile} file');
    exit(1);
  }

  //final config = PluginConfigHelper().fromYamlFile(configFilePath);
  //final sheetConfig = config.sheetConfig;

  /*
  final sheetParser = SheetParser(
      auth: sheetConfig.auth, categoryPrefix: sheetConfig.categoryPrefix);
  final bundle = await sheetParser.parseSheet(sheetConfig.documentId);
  final arbSerializer = ArbSerializer();
  arbSerializer.saveArbBundle(bundle, config.outputDirectoryPath);

  if (generateCode) {
    final document = arbSerializer
        .loadArbDocument('${config.outputDirectoryPath}/intl_en.arb');
    final localizationFileName = config.localizationFileName;
    final generator = TranslationsGenerator();
    generator.buildTranslations(
        document, config.outputDirectoryPath, localizationFileName);

    final helper = IntlTranslationHelper();
    helper.aaa(config.outputDirectoryPath, config.localizationFileName);
  }
  */
}

/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

library gsheet_to_arb;

import 'dart:io';

import 'package:args/args.dart';
import 'package:gsheet_to_arb/gsheet_to_arb.dart';
import 'package:gsheet_to_arb/src/utils/log.dart';

void main(List<String> args) async {
  var parser = ArgParser();

  var configFilePath = './gsheet_to_arb.yaml';
  var generateCode = false;
  var createConfig = false;

  parser.addOption('config',
      defaultsTo: configFilePath,
      callback: (x) => configFilePath = x,
      help: 'config yaml file name');

  parser.addFlag('generate-code',
      callback: (value) => generateCode = value, help: 'config yaml file name');

  parser.addFlag('create-config',
      callback: (value) => createConfig = value, help: 'config yaml file name');

  parser.parse(args);
  if (args.isEmpty) {
    Log.i('Imports ARB file from exisiting GSheet document');
    Log.i('Usage: gsheet_to_arb [options]');
    Log.i(parser.usage);
    exit(0);
  }

  final config = PluginConfigHelper().fromYamlFile(configFilePath);
  final sheetConfig = config.sheetConfig;
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
}

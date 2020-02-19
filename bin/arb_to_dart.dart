/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

library gsheet_to_arb;

import 'dart:io';

import 'package:args/args.dart';
import 'package:gsheet_to_arb/gsheet_to_arb.dart';

main(List<String> args) async {
  var parser = new ArgParser();
  var configFilePath = "./gsheet_to_arb.yaml";

  parser.addOption("config",
      defaultsTo: configFilePath,
      callback: (x) => configFilePath = x,
      help: 'config yaml file name');

  parser.addFlag("help", help: 'show helps');

  parser.parse(args);
  if (args.length == 0) {
    Log.i('Converts ARB file to Dart i18n');
    Log.i('Usage: gsheet_to_arb [options]');
    Log.i(parser.usage);
    exit(0);
  }

  final config = PluginConfigHelper().fromYamlFile(configFilePath);
  final serializer = ArbSerializer();
  final document =
      serializer.loadArbDocument("${config.outputDirectoryPath}/intl_en.arb");
  final localizationFileName = config.localizationFileName;
  final generator = TranslationsGenerator();
  generator.buildTranslations(
      document, config.outputDirectoryPath, localizationFileName);

  final helper = IntlTranslationHelper();
  helper.aaa(config.outputDirectoryPath, config.localizationFileName);
}

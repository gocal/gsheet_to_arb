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

  var showHelp = false;
  var createConfig = false;

  parser.addFlag('help',
      negatable: false,
      callback: (value) => showHelp = value,
      help: 'show help');
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
    Log.i(
        'Config not found - please create config first with the --create-config flag');
    exit(1);
  }

  _checkAuthConfig(config.gsheet);

  final gsheetToArb = GSheetToArb(config: config);
  gsheetToArb.build();
}

void _checkAuthConfig(GoogleSheetConfig config) {
  final placeholder = 'TODO';
  final auth = config.auth;

  if (auth == null) {
    Log.i(
        'Authetnication config not found - please add config to ${config.authFile} file');
    exit(1);
  }

  final oauthClientId = auth.oauthClientId;
  final serviceAccountKey = auth.serviceAccountKey;

  if (oauthClientId == null && serviceAccountKey == null) {
    Log.i(
        'Authetnication config is invalid - please add config to ${config.authFile} file');
    exit(1);
  }

  if (oauthClientId != null) {
    if (oauthClientId.clientId == placeholder ||
        oauthClientId.clientSecret == placeholder) {
      Log.i('Please use valid auth client configuration');
      exit(1);
    }
  } else if (serviceAccountKey != null) {
    if (serviceAccountKey.privateKey == placeholder) {
      Log.i('Please use valid auth server configuration');
      exit(1);
    }
  }
}

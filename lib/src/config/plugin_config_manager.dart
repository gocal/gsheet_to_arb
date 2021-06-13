/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'package:gsheet_to_arb/src/utils/file_utils.dart';
import 'package:gsheet_to_arb/src/utils/log.dart';
import 'package:gsheet_to_arb/src/utils/yaml_utils.dart';

import 'plugin_config.dart';

final authFileName = 'gsheet_to_arb.yaml';
final configFileName = 'pubspec.yaml';
final _gitignore = '.gitignore';

class PluginConfigManager {
  Future<GsheetToArbConfig?> getConfig() async {
    final pubspec = YamlUtils.load(configFileName);
    final config = PluginConfigRoot.fromJson(pubspec).content;

    if (config == null) {
      return null;
    }

    if (!FileUtils.exists(config.gsheet.authFile)) {
      return null;
    }

    final authConfig = YamlUtils.load(config.gsheet.authFile);
    config.gsheet.auth = AuthConfig.fromJson(authConfig);

    config.generateCode = config.generateCode;
    config.addContextPrefix = config.addContextPrefix;

    return config;
  }

  void createConfig() {
    final pubspec = YamlUtils.load(configFileName);
    if (PluginConfigRoot.fromJson(pubspec).content != null) {
      Log.i('Config already exists, please check your $configFileName');
    } else {
      final config = GsheetToArbConfig(
        addContextPrefix: false,
        generateCode: true,
        outputDirectoryPath: 'lib/l10n',
        arbFilePrefix: 'intl',
        localizationFileName: 'l10n',
        gsheet: GoogleSheetConfig(
          categoryPrefix: '# ',
          sheetId: '0',
          documentId: '<ADD_DOCUMENT_ID_HERE>',
          authFile: './' + authFileName,
          sheetColumns: SheetColumns(),
          sheetRows: SheetRows(),
        ),
      );

      final root = PluginConfigRoot(config).toJson();
      final yamlString = '\n' + YamlUtils.toYamlString(root);

      FileUtils.append(configFileName, yamlString);

      Log.i('Config has been added to the $configFileName');
    }

    if (FileUtils.exists(authFileName)) {
      Log.i('Authentication config already exists $authFileName');
    } else {
      final authConfig = AuthConfig(
        oauthClientId: OAuthClientId(clientId: 'TODO', clientSecret: 'TODO'),
        serviceAccountKey: ServiceAccountKey(
          clientId: 'TODO',
          clientEmail: 'TODO',
          privateKey: 'TODO',
        ),
      );

      final authYaml = YamlUtils.toYamlString(authConfig.toJson());
      FileUtils.storeContent(authFileName, authYaml);
      Log.i('Auth config has been added to the $authFileName');
      Log.i('More info:');
      Log.i(
          'https://github.com/gocal/gsheet_to_arb/blob/develop/doc/Authentication.md');
    }
    _checkAuthIgonre(authFileName);
  }

  void _checkAuthIgonre(String fileName) {
    if (FileUtils.exists(_gitignore)) {
      final content = FileUtils.getContent(_gitignore);

      if (!content.contains(fileName)) {
        Log.i(
            'It looks like your $_gitignore does not contain confidential gsheet config $fileName');
        FileUtils.append(_gitignore, fileName);
        Log.i('$fileName has been added to the $_gitignore');
      }
    }
  }
}

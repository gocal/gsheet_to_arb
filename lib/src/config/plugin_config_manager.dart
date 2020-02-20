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
  Future<GsheetToArbConfig> getConfig() async {
    final pubspec = YamlUtils.load(configFileName);
    final config = PluginConfigRoot.fromJson(pubspec).content;

    if (config?.gsheet?.authFile != null) {
      final authConfig = YamlUtils.load(config.gsheet.authFile);
      config.gsheet.auth = AuthConfig.fromJson(authConfig);
    }

    return config;
  }

  void createConfig() {
    final pubspec = YamlUtils.load(configFileName);
    if (PluginConfigRoot.fromJson(pubspec).content != null) {
      Log.i('Config already exists, please check your $configFileName');
    } else {
      final config = GsheetToArbConfig(
          outputDirectoryPath: 'intl',
          arbFilePrefix: 'lib/src/i18n',
          localizationFileName: 'S',
          gsheet: GoogleSheetConfig(
              categoryPrefix: '# ',
              sheetId: '0',
              documentId: 'TODO',
              authFile: './' + authFileName));

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
          clientEmail: 'TODO',
          privateKey: 'TODO',
          privateKeyId: 'TODO',
          projectId: 'TODO',
          authProviderX509CertUrl: 'TODO',
          authUri: 'TODO',
          clientId: 'TODO',
          clientX509CertUrl: 'TODO',
          tokenUri: 'TODO',
          type: 'TODO',
        ),
      );

      final authYaml = YamlUtils.toYamlString(authConfig.toJson());
      FileUtils.storeContent(authFileName, authYaml);
      Log.i('Auth config has been added to the $authFileName');
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

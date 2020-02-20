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

class PluginConfigManager {
  String createConfig() {
    final pubspec = YamlUtils.load(configFileName);
    if (PluginConfigRoot.fromJson(pubspec).content != null) {
      Log.i('Config already exists, please check your $configFileName');
    } else {
      final config = GsheetToArbConfig(
          outputDirectoryPath: '',
          arbFilePrefix: '',
          localizationFileName: '',
          sheetConfig: GoogleSheetConfig(
              categoryPrefix: '# ',
              documentId: 'TODO',
              sheetId: '0',
              authFile: configFileName));

      final root = PluginConfigRoot(config).toJson();
      final yamlString = '\n\n' + YamlUtils.toYamlString(root);

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

    /*
    var config = PluginConfig(
        'lib/src/i18n',
        'intl',
        GoogleSheetConfig(
            auth: Auth(
                serviceAccountKeyPath:
                    '~/.ssh/gsheet-to-arb-server-config.json'),
            documentId: '<DOCUMENT_ID>',
            sheetId: '0',
            categoryPrefix: '#_'));

    return jsonEncode(PluginConfigRoot(config).toJson());
    */
    return "";
  }
}

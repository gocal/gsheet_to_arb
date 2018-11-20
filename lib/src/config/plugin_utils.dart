/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import 'plugin_config.dart';

class PluginUtils {
  PluginConfig fromYamlFile(String filePath) {
    var yaml = _loadYamlFile(filePath);
    var map = jsonDecode(jsonEncode(yaml));
    return PluginConfigRoot.fromJson(map).config;
  }

  YamlMap _loadYamlFile(String path) {
    var configFile = File(path);
    var configText = configFile.readAsStringSync();
    var yaml = loadYaml(configText);
    return yaml;
  }
}

/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:io';

import 'package:gsheet_to_arb/src/arb/arb_generator.dart';
import 'package:gsheet_to_arb/src/plugin_config.dart';

class ArbSerializer {
  void saveArbBundle(ArbBundle bundle, PluginConfig config) {
    print("save arb files in ${config.outputDirectoryPath}");
    var targetDir = Directory(config.outputDirectoryPath);
    targetDir.createSync();
    bundle.documents
        .forEach((document) => _saveArbDocument(document, targetDir));
  }

  void _saveArbDocument(ArbDocument document, Directory directory) {
    var filePath = "${directory.path}/intl_${document.locale}.arb";
    print("  => $filePath");
    var file = File(filePath);
    file.createSync();
    var encoder = new JsonEncoder.withIndent('  ');
    var arbContent = encoder.convert(document.toJson());
    file.writeAsString(arbContent);
  }
}

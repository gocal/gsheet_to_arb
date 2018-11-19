/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:io';

import 'package:gsheet_to_arb/src/arb/arb_generator.dart';

class ArbSerializer {

  String serialize(ArbDocument document) {
    var encoder = new JsonEncoder.withIndent('  ');
    var arbContent = encoder.convert(document.toJson());
    return arbContent;
  }

  ArbDocument deserialize(String json) {
    var decoder = new JsonDecoder();
    ArbDocument arbContent = ArbDocument.fromJson(decoder.convert(json));
    return arbContent;
  }

  void saveArbBundle(ArbBundle bundle, String directory) {
    print("save arb files in ${directory}");
    var targetDir = Directory(directory);
    targetDir.createSync();
    bundle.documents
        .forEach((document) => _saveArbDocument(document, targetDir));
  }

  void _saveArbDocument(ArbDocument document, Directory directory) {
    var filePath = "${directory.path}/intl_${document.locale}.arb";
    print("  => $filePath");
    var file = File(filePath);
    file.createSync();
    var arbContent = serialize(document);
    file.writeAsString(arbContent);
  }

  ArbDocument loadArbDocument(String filePath) {
    var file = File(filePath);
    var content = file.readAsStringSync();
    return deserialize(content);
  }

}

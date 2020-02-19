/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:io';

import '../utils/log.dart';
import 'arb.dart';
import 'arb_generator.dart';

class ArbSerializer {
  String serialize(ArbDocument document) {
    var encoder = JsonEncoder.withIndent('  ');
    var arbContent = encoder.convert(document.toJson());
    return arbContent;
  }

  ArbDocument deserialize(String json) {
    final decoder = JsonDecoder();
    final arbContent = ArbDocument.fromJson(decoder.convert(json));
    return arbContent;
  }

  void saveArbBundle(ArbBundle bundle, String directory) {
    Log.i('save arb files in ${directory}');
    var targetDir = Directory(directory);
    targetDir.createSync(recursive: true);
    bundle.documents
        .forEach((document) => _saveArbDocument(document, targetDir));
  }

  void _saveArbDocument(ArbDocument document, Directory directory) {
    var filePath = '${directory.path}/intl_${document.locale}.arb';
    Log.i('  => $filePath');
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

/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:io';

import 'package:gsheet_to_arb/src/plugin_config.dart';

class ArbBundle {
  final List<ArbDocument> documents;

  ArbBundle(this.documents);
}

class ArbDocument {
  String locale;
  List<ArbEntry> resources;

  ArbDocument(this.locale, this.resources);

  Map<String, Object> toJson() {
    final Map<String, Object> _json = Map<String, Object>();

    for (int i = 0; i < resources.length; i++) {
      _json[resources[i].key] = resources[i].value;
    }

    return _json;
  }
}

class ArbEntry {
  final String key;
  final String value;
  final Map<String, String> attributes = Map();

  ArbEntry(this.key, this.value);

  Map<String, Object> toJson() {
    final Map<String, Object> _json = Map<String, Object>();
    _json[key] = value;
    return _json;
  }
}

class ArbDocumentBuilder {
  String locale;
  DateTime lastModified;
  List<ArbEntry> resources = List();

  ArbDocumentBuilder(this.locale, this.lastModified) {
    resources.add(LocaleArbResource(locale));
    resources.add(LastModifiedArbResource(lastModified));
  }

  ArbDocument build() {
    ArbDocument bundle = ArbDocument(locale, resources);
    return bundle;
  }

  ArbDocumentBuilder add(String key, String value) {
    resources.add(ArbEntry(key, value));
    return this;
  }
}

class LocaleArbResource extends ArbEntry {
  LocaleArbResource(String value) : super("_locale", value);
}

class LastModifiedArbResource extends ArbEntry {
  LastModifiedArbResource(DateTime lastModified)
      : super("@@last_modified", lastModified.toIso8601String());
}

class ArbSerializer {
  void saveArbBundle(ArbBundle bundle, PluginConfig config) {
    print("save arb files in ${config.outputDirectoryPath}");
    var targetDir = Directory(config.outputDirectoryPath);
    targetDir.createSync();
    bundle.documents
        .forEach((document) => _saveArbDocument(document, targetDir));
  }

  void _saveArbDocument(ArbDocument document, Directory directory) {
    var filePath = "${directory.path}/${document.locale}.arb";
    print("  => $filePath");
    var file = File(filePath);
    file.createSync();
    var encoder = new JsonEncoder.withIndent('  ');
    var arbContent = encoder.convert(document.toJson());
    file.writeAsString(arbContent);
  }
}

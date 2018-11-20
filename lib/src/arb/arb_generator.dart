/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

class ArbBundle {
  final List<ArbDocument> documents;

  ArbBundle(this.documents);
}

class ArbDocument {
  String locale;
  DateTime lastModified;
  List<ArbEntry> entries;

  ArbDocument(this.locale, this.lastModified, this.entries);

  Map<String, Object> toJson() {
    final Map<String, Object> _json = Map<String, Object>();

    _json['_locale'] = locale;
    _json['@@last_modified'] = lastModified.toIso8601String();

    entries.forEach((ArbEntry entry) {
      _json[entry.key] = entry.value;
      if (entry.hasAttributes) {
        _json["@@${entry.key}"] = entry.attributes;
      }
    });

    return _json;
  }

  ArbDocument.fromJson(Map<String, dynamic> _json) {
    var entriesMap = Map<String, ArbEntry>();
    entries = List<ArbEntry>();

    _json.forEach((key, value) {
      if ("_locale" == key) {
        locale = value;
      } else if ("@@last_modified" == key) {
        lastModified = DateTime.parse(value);
      } else if (key.startsWith("@@")) {
        var entry = entriesMap[key.substring(2)];
        entry.attributes.addAll(value);
      } else {
        var entry = ArbEntry(key, value);
        entries.add(entry);
        entriesMap[key] = entry;
      }
    });
  }
}

class ArbEntry {
  final String key;
  final String value;
  final Map<String, Object> attributes = Map();

  final bool hasAttributes;

  ArbEntry(this.key, this.value, [this.hasAttributes = true]) {
    if (hasAttributes) {
      attributes['type'] = "Text";
      attributes['placeholders'] = Map<String, Object>();
    }
  }
}

class ArbDocumentBuilder {
  String locale;
  DateTime lastModified;
  List<ArbEntry> entries = List();

  ArbDocumentBuilder(this.locale, this.lastModified) {}

  ArbDocument build() {
    ArbDocument bundle = ArbDocument(locale, lastModified, entries);
    return bundle;
  }

  ArbDocumentBuilder add(ArbEntry entry) {
    entries.add(entry);
    return this;
  }
}

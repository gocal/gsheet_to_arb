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
  List<ArbEntry> resources;

  ArbDocument(this.locale, this.resources);

  Map<String, Object> toJson() {
    final Map<String, Object> _json = Map<String, Object>();

    resources.forEach((ArbEntry entry) {
      _json[entry.key] = entry.value;
      if (entry.hasAttributes) {
        _json["@@${entry.key}"] = entry.attributes;
      }
    });

    return _json;
  }

  ArbDocument.fromJson(Map _json) {
    _json.forEach((key, value) {});
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
  LocaleArbResource(String value) : super("_locale", value, false);
}

class LastModifiedArbResource extends ArbEntry {
  LastModifiedArbResource(DateTime lastModified)
      : super("@@last_modified", lastModified.toIso8601String(), false);
}

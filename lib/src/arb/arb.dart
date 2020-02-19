/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'package:gsheet_to_arb/src/arb/arb_utils.dart';

class ArbDocument {
  String locale;
  DateTime lastModified;
  List<ArbResource> entries;

  ArbDocument(this.locale, this.lastModified, this.entries);

  Map<String, Object> toJson() {
    final Map<String, Object> _json = Map<String, Object>();

    _json['_locale'] = locale;
    _json['@@last_modified'] = lastModified.toIso8601String();

    entries.forEach((ArbResource resource) {
      _json[resource.id.text] = resource.value.text;
      if (resource.hasAttributes) {
        _json["@@${resource.id.text}"] = resource.attributes;
      }
    });

    return _json;
  }

  ArbDocument.fromJson(Map<String, dynamic> _json) {
    var entriesMap = Map<String, ArbResource>();
    entries = List<ArbResource>();

    _json.forEach((key, value) {
      if ("_locale" == key) {
        locale = value;
      } else if ("@@last_modified" == key) {
        lastModified = DateTime.parse(value);
      } else if (key.startsWith("@@")) {
        var entry = entriesMap[key.substring(2)];
        entry.attributes.addAll(value);
      } else {
        var entry = ArbResource(key, value);
        entries.add(entry);
        entriesMap[key] = entry;
      }
    });
  }
}

class ArbResource {
  final ArbResourceId id;
  final ArbResourceValue value;
  final Map<String, Object> attributes = Map();

  final bool hasAttributes;

  ArbResource(String id, String value, [this.hasAttributes = true])
      : this.id = ArbResourceId(id),
        this.value = ArbResourceValue(value) {
    if (hasAttributes) {
      attributes['type'] = "Text";
      attributes['placeholders'] = Map<String, Object>();
    }
  }
}

class ArbResourceId {
  final String text;

  ArbResourceId(this.text);
}

class ArbResourceValue {
  final String text;
  final placeholders = List<ArbResourcePlaceholder>();

  bool get hasPlaceholders => placeholders.isNotEmpty;

  ArbResourceValue(this.text) {
    var placeholders = findPlaceholders(text);
    if (placeholders.isNotEmpty) {
      this.placeholders.addAll(placeholders);
    }
  }
}

class ArbResourcePlaceholder {
  final String name;

  ArbResourcePlaceholder(this.name);
}

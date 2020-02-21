/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

class ArbDocument {
  String locale;
  DateTime lastModified;
  List<ArbResource> entries;

  ArbDocument(this.locale, this.lastModified, this.entries);

  Map<String, Object> toJson() {
    final _json = <String, Object>{};

    _json['@@locale'] = locale;
    _json['@@last_modified'] = lastModified.toIso8601String();

    entries.forEach((ArbResource resource) {
      _json[resource.key] = resource.value;
      if (resource.attributes.isNotEmpty) {
        _json['@${resource.key}'] = resource.attributes;
      }
    });

    return _json;
  }

  ArbDocument.fromJson(Map<String, dynamic> _json) {
    var entriesMap = <String, ArbResource>{};
    entries = <ArbResource>[];

    _json.forEach((key, value) {
      if ('_locale' == key) {
        locale = value;
      } else if ('@@last_modified' == key) {
        lastModified = DateTime.parse(value);
      } else if (key.startsWith('@@')) {
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
  final String key;
  final String value;
  final Map<String, Object> attributes = {};
  final List<ArbResourcePlaceholder> placeholders;
  final String description;
  final String context;

  ArbResource(String key, String value,
      {this.description = '', this.context = '', this.placeholders = const []})
      : key = key,
        value = value {
    attributes['type'] = 'Text'; // Possible values are "text", "image", "css"
    if (placeholders != null) {
      attributes['placeholders'] = _formatPlaceholders(placeholders);
    }

    if (description != null && description.isNotEmpty) {
      attributes['description'] = description;
    }

    if (context != null && context.isNotEmpty) {
      attributes['context'] = context;
    }
  }

  Map<String, Object> _formatPlaceholders(
      List<ArbResourcePlaceholder> placeholders) {
    final map = <String, Object>{};
    placeholders.forEach((placeholder) => {map[placeholder.name] = {}});
    return map;
  }
}

class ArbResourcePlaceholder {
  final String name;
  final String type;
  final String description;
  final String example;

  ArbResourcePlaceholder({
    this.name,
    this.type,
    this.description,
    this.example,
  });
}

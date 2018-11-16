/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

class ArbBundle {
  List<ArbResource> resources;

  ArbBundle(this.resources);

  Map<String, Object> toJson() {
    final Map<String, Object> _json = Map<String, Object>();

    for (int i = 0; i < resources.length; i++) {
      _json[resources[i].key] = resources[i].value;
    }

    return _json;
  }
}

class ArbResource {
  final String key;
  final String value;
  final Map<String, String> attributes = Map();

  ArbResource(this.key, this.value);

  Map<String, Object> toJson() {
    final Map<String, Object> _json = Map<String, Object>();
    _json[key] = value;
    return _json;
  }
}

class ArbBundleBuilder {
  String locale;
  DateTime lastModified;
  List<ArbResource> resources = List();

  ArbBundleBuilder(this.locale, this.lastModified) {
    resources.add(LocaleArbResource(locale));
    resources.add(LastModifiedArbResource(lastModified));
  }

  ArbBundle build() {
    ArbBundle bundle = ArbBundle(resources);
    return bundle;
  }

  ArbBundleBuilder add(String key, String value) {
    resources.add(ArbResource(key, value));
    return this;
  }
}

class LocaleArbResource extends ArbResource {
  LocaleArbResource(String value) : super("_locale", value);
}

class LastModifiedArbResource extends ArbResource {
  LastModifiedArbResource(DateTime lastModified)
      : super("@@last_modified", lastModified.toIso8601String());
}

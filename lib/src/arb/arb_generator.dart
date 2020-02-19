/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'arb.dart';

class ArbBundle {
  final List<ArbDocument> documents;

  ArbBundle(this.documents);
}

class ArbDocumentBuilder {
  String locale;
  DateTime lastModified;
  List<ArbResource> entries = [];

  ArbDocumentBuilder(this.locale, this.lastModified);

  ArbDocument build() {
    var bundle = ArbDocument(locale, lastModified, entries);
    return bundle;
  }

  ArbDocumentBuilder add(ArbResource entry) {
    entries.add(entry);
    return this;
  }
}

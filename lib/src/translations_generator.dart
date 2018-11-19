/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:io';

import 'package:gsheet_to_arb/src/arb/arb_generator.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

class TranslationsGenerator {

  void buildTranslations(ArbBundle arbBundle, Directory directory) {

    var document = arbBundle.documents[0];

    var classBuilder = ClassBuilder();
    classBuilder.name = "Strings";

    var translationClass = classBuilder.build();

    final emitter = DartEmitter();

    var emitted = translationClass.accept(emitter);

    var formatted = DartFormatter().format('${emitted}');

    var filePath = "${directory.path}/Strings.dart";
    var file = File(filePath);
    file.writeAsString(formatted);
  }
}

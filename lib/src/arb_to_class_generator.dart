/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:gsheet_to_arb/src/arb/arb_generator.dart';

class TranslationsGenerator {
  void buildTranslations(ArbDocument document, String directory,
      String className) {
    var translationClass = Class((ClassBuilder builder) {
      builder.name = className;
      builder.docs.add(
          "\n//ignore_for_file: type_annotate_public_apis, non_constant_identifier_names");
      document.entries.forEach((ArbEntry entry) {
        var method = _getFieldGetter(entry);
        builder.methods.add(method);
      });
    });

    final library = Library((LibraryBuilder builder) {
      builder.directives.add(Directive.import("package:intl/intl.dart"));
      builder.body.add(translationClass);
    });

    var emitter = DartEmitter(Allocator.simplePrefixing());
    var emitted = library.accept(emitter);
    var formatted = DartFormatter().format('${emitted}');

    var file = File("${directory}/${className.toLowerCase()}.dart");
    file.createSync();
    file.writeAsStringSync(formatted);
  }

  Method _getFieldGetter(ArbEntry entry) {
    Method method = Method((MethodBuilder builder) {
      var context = entry.attributes['context'];
      var description = entry.attributes['description'];
      if (description == null) {
        description = entry.key;
      }

      var key;

      if (context != null) {
        key = "${context}_${entry.key}";
      } else {
        key = "${entry.key}";
      }

      builder.name = key;
      builder.type = MethodType.getter;
      builder.lambda = true;
      builder.body =
          Code("""Intl.message("${entry
              .value}", name: "${key}", desc: "${description}")""");
      builder.docs.add("\t/// ${description}");

    });
    return method;
  }
}

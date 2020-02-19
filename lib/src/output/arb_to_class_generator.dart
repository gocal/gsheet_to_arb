/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:gsheet_to_arb/src/arb/arb.dart';
import 'package:recase/recase.dart';

class TranslationsGenerator {
  void buildTranslations(
      ArbDocument document, String directory, String className) {
    var translationClass = Class((ClassBuilder builder) {
      builder.name = className;
      builder.docs.add(
          "\n//ignore_for_file: type_annotate_public_apis, non_constant_identifier_names");
      document.entries.forEach((ArbResource entry) {
        var method = _getResourceMethod(entry);
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

  Method _getResourceMethod(ArbResource resource) {
    if (resource.value.hasPlaceholders) {
      Method method = Method((MethodBuilder builder) {
        var description = resource.attributes['description'];
        if (description == null) {
          description = resource.id.text;
        }

        var key = resource.id.text;
        var value = resource.value.text;

        builder.name = _getMethodName(key);

        var args = List<String>();
        resource.value.placeholders
            .forEach((ArbResourcePlaceholder placeholder) {
          builder.requiredParameters.add(Parameter((ParameterBuilder builder) {
            args.add(placeholder.name);
            builder.name = placeholder.name;
            builder.type = const Reference('String');
          }));
        });

        builder.returns = const Reference('String');
        builder.lambda = true;
        builder.body = Code(
            """Intl.message("${value}", name: "${key}", args: [${args.join(", ")}], desc: "${description}")""");
        builder.docs.add("\t/// ${description}");
      });
      return method;
    } else {
      return _getResourceGetter(resource);
    }
  }

  Method _getResourceGetter(ArbResource resource) {
    Method method = Method((MethodBuilder builder) {
      var description = resource.attributes['description'];
      if (description == null) {
        description = resource.id.text;
      }

      var key = resource.id.text;
      var value = resource.value.text;

      builder.name = _getMethodName(key);
      builder.type = MethodType.getter;
      builder.returns = const Reference('String');
      builder.lambda = true;
      builder.body = Code(
          """Intl.message("${value}", name: "${key}", desc: "${description}")""");
      builder.docs.add("\t/// ${description}");
    });
    return method;
  }

  String _getMethodName(String key) {
    return ReCase(key).camelCase;
  }
}

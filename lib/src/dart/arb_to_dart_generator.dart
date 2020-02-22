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

// TODO internal/transitive dependency
import 'package:intl_translation/src/icu_parser.dart';
import 'package:intl_translation/src/intl_message.dart';
import 'package:intl_translation/generate_localized.dart';
import 'package:petitparser/petitparser.dart';

import '_intl_translation_generator.dart';

class ArbToDartGenerator {
  final intlTranslation = IntlTranslationGenerator();

  void generateDartClasses(
      ArbBundle bundle, String outputDirectoryPath, String className) {
    _buildIntlListFile(bundle.documents.first, outputDirectoryPath, className);

    intlTranslation.generateLookupTables(outputDirectoryPath, className);
  }

  void _buildIntlListFile(
      ArbDocument document, String directory, String className) {
    var translationClass = Class((ClassBuilder builder) {
      builder.name = ReCase(className).pascalCase;
      builder.docs.add(
          '\n//ignore_for_file: type_annotate_public_apis, non_constant_identifier_names');
      document.entries.forEach((ArbResource entry) {
        var method = _getResourceMethod(entry);
        builder.methods.add(method);
      });
    });

    final library = Library((LibraryBuilder builder) {
      builder.directives.add(Directive.import('package:intl/intl.dart'));
      builder.body.add(translationClass);
    });

    var emitter = DartEmitter(Allocator.simplePrefixing());
    var emitted = library.accept(emitter);
    var formatted = DartFormatter().format('${emitted}');

    var file = File('${directory}/${className.toLowerCase()}.dart');
    file.createSync();
    file.writeAsStringSync(formatted);
  }

  Method _getResourceMethod(ArbResource resource) {
    if (resource.placeholders.isNotEmpty) {
      return _getResourceFullMethod(resource);
    } else {
      return _getResourceGetter(resource);
    }
  }

  Method _getResourceFullMethod(ArbResource resource) {
    var method = Method((MethodBuilder builder) {
      final description = resource.attributes['description'] ??= resource.key;

      var key = resource.key;
      var value = resource.value;

      builder.name = _getMethodName(key);

      var args = <String>[];
      resource.placeholders.forEach((ArbResourcePlaceholder placeholder) {
        builder.requiredParameters.add(Parameter((ParameterBuilder builder) {
          args.add(placeholder.name);
          builder.name = placeholder.name;
          builder.type = const Reference('String');
        }));
      });

      builder.returns = const Reference('String');
      builder.lambda = true;
      builder.body = Code(
          """Intl.message('${value}', name: '${key}', args: [${args.join(", ")}], desc: '${description}')""");
      builder.docs.add('\t/// ${description}');
    });
    return method;
  }

  Method _getResourceGetter(ArbResource resource) {
    final method = Method((MethodBuilder builder) {
      var description = resource.attributes['description'];
      description ??= resource.key;

      var key = resource.key;
      var value = resource.value;

      builder
        ..name = _getMethodName(key)
        ..type = MethodType.getter
        ..returns = const Reference('String')
        ..lambda = true
        ..body = Code(
            '''Intl.message('${value}', name: '${key}', desc: '${description}')''')
        ..docs.add('\t/// ${description}');
    });
    return method;
  }

  String _getMethodName(String key) => ReCase(key).camelCase;
}

///
///
///
final Parser<dynamic> _pluralParser = IcuParser().message;
final Parser<dynamic> _plainParser = IcuParser().nonIcuMessage;

BasicTranslatedMessage _getTranslatedMessage(String id, String data) {
  if (id.startsWith('@')) return null;
  if (data == null) return null;
  var parsed = _pluralParser.parse(data).value;
  if (parsed is LiteralString && parsed.string.isEmpty) {
    parsed = _plainParser.parse(data).value;
  }
  return BasicTranslatedMessage(id, parsed);
}

class BasicTranslatedMessage extends TranslatedMessage {
  BasicTranslatedMessage(String name, translated) : super(name, translated);

  @override
  List<MainMessage> get originalMessages => super.originalMessages;
}

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
import '_icu_parser.dart';
import '_intl_translation_generator.dart';
import 'package:intl_translation/src/intl_message.dart';
import 'package:petitparser/petitparser.dart';

class ArbToDartGenerator {
  final bool addContextPrefix;

  final intlTranslation = IntlTranslationGenerator();

  ArbToDartGenerator({this.addContextPrefix = false});

  void generateDartClasses(
      ArbBundle bundle, String outputDirectoryPath, String className,
      {bool addContextPrefix}) {
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

    final emitter = DartEmitter(Allocator.simplePrefixing());
    final emitted = library.accept(emitter);
    final formatted = DartFormatter().format('${emitted}');

    final file = File('${directory}/${className.toLowerCase()}.dart');
    file.createSync();
    file.writeAsStringSync(formatted);
  }

  Method _getResourceMethod(ArbResource resource) {
    return Method((MethodBuilder builder) {
      final key = resource.key;
      final description =
          _fixSpecialCharacters(resource.attributes['description'] ??= key);

      final methodName =
          (addContextPrefix ? '${resource.context.toLowerCase()}_' : '') +
              ReCase(key).camelCase;

      builder
        ..name = methodName
        ..returns = const Reference('String')
        ..lambda = true
        ..docs.add('/// ${description.replaceAll("\\n", "\n/// ")}');

      if (resource.placeholders.isNotEmpty) {
        return _getResourceFullMethod(resource, builder);
      } else {
        return _getResourceGetter(resource, builder);
      }
    });
  }

  void _getResourceFullMethod(ArbResource resource, MethodBuilder builder) {
    final key = resource.key;
    final value = _fixSpecialCharacters(resource.value);
    final description =
        _fixSpecialCharacters(resource.attributes['description'] ??= key);

    var args = <String>[];
    resource.placeholders.forEach((ArbResourcePlaceholder placeholder) {
      builder.requiredParameters.add(Parameter((ParameterBuilder builder) {
        args.add(placeholder.name);
        final argumentType = placeholder.type == ArbResourcePlaceholder.typeNum
            ? 'int'
            : 'String';
        builder
          ..name = placeholder.name
          ..type = Reference(argumentType);
      }));
    });

    builder
      ..body =
          Code(_getCode(value, key: key, args: args, description: description));
  }

  void _getResourceGetter(ArbResource resource, MethodBuilder builder) {
    final key = resource.key;
    final value = _fixSpecialCharacters(resource.value);
    final description =
        _fixSpecialCharacters(resource.attributes['description'] ??= key);

    builder
      ..type = MethodType.getter
      ..body = Code(
          '''Intl.message('${value}', name: '${key}', desc: '${description}')''');
  }

  ///
  /// intl_translation
  ///
  final Parser<dynamic> _pluralParser = CustomIcuParser().message;
  final Parser<dynamic> _plainParser = CustomIcuParser().nonIcuMessage;

  String _getCode(String value, {String key, String description, List args}) {
    Message message = _pluralParser.parse(value).value;
    if (message is LiteralString && message.string.isEmpty) {
      message = _plainParser.parse(value).value;
    }

    if (message is Plural) {
      final pluralBuilder = StringBuffer();
      pluralBuilder.write('Intl.plural(count,');
      void addIfNotNull(String key, Message message) {
        if (message != null) {
          final val = _getMessageCode(message);
          pluralBuilder.write('$key:\'$val\',');
        }
      }

      addIfNotNull('zero', message.zero);
      addIfNotNull('one', message.one);
      addIfNotNull('two', message.two);
      addIfNotNull('few', message.few);
      addIfNotNull('other', message.other);
      addIfNotNull('many', message.many);

      pluralBuilder.write(
        'args: [${args.join(", ")}],',
      );
      pluralBuilder.write(
        'desc: \'${description}\'',
      );
      pluralBuilder.write(')');

      final code = pluralBuilder.toString();

      return code;
    }
    final code = _getMessageCode(message);
    return """Intl.message('${code}', name: '$key', args: [${args.join(", ")}], desc: '${description}')""";
  }

  String _getMessageCode(Message message) {
    final builder = StringBuffer();

    if (message is LiteralString) {
      return message.string;
    }

    if (message is CustomVariableSubstitution) {
      return '\$${message.variable}';
    }

    if (message is Plural) {}

    if (message is CompositeMessage) {
      return _getComositeMessageCode(message);
    }

    return builder.toString();
  }

  String _getComositeMessageCode(CompositeMessage composite) {
    final builder = StringBuffer();
    for (var message in composite.pieces) {
      builder.write(_getMessageCode(message));
    }
    return builder.toString();
  }

  String _fixSpecialCharacters(String value) {
    if (value == null) {
      return value;
    }
    // fix breaking line chars
    return value.replaceAll('\n', '\\n');
  }
}

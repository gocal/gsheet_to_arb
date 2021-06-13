/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:gsheet_to_arb/src/arb/arb.dart';
import 'package:gsheet_to_arb/src/utils/log.dart';
import 'package:recase/recase.dart';
import '_icu_parser.dart';
import '_intl_translation_generator.dart';
import 'package:intl_translation/src/intl_message.dart';
import 'package:petitparser/petitparser.dart';

class ArbToDartGenerator {
  final intlTranslation = IntlTranslationGenerator();

  ArbToDartGenerator();

  void generateDartClasses(
      ArbBundle bundle, String outputDirectoryPath, String className,
      {bool? addContextPrefix}) {
    Log.i('Genrating Dart classes from ARB...');
    Log.startTimeTracking();
    _buildIntlListFile(bundle.documents.first, outputDirectoryPath, className);

    intlTranslation.generateLookupTables(outputDirectoryPath, className);
    Log.i(
        'Genrating Dart classes from ARB completed, took ${Log.stopTimeTracking()}');
  }

  void _buildIntlListFile(
    ArbDocument document,
    String directory,
    String className,
  ) {
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

    final emitter = DartEmitter(allocator: Allocator.simplePrefixing());
    final emitted = library.accept(emitter);
    final formatted = DartFormatter().format('$emitted');

    final file = File('$directory/${className.toLowerCase()}.dart');
    file.createSync();
    file.writeAsStringSync(formatted);
  }

  Method _getResourceMethod(ArbResource resource) {
    return Method((MethodBuilder builder) {
      final key = resource.key;
      final docs = _fixSpecialCharacters(
              (resource.attributes['description'] ??= '') as String)
          .replaceAll('\\n', '\n/// ');

      final methodName = key;
      // (addContextPrefix ? '${resource.context.toLowerCase()}_' : '') + ReCase(key).camelCase;

      builder
        ..name = methodName
        ..returns = const Reference('String')
        ..lambda = true
        ..docs.add('/// $docs');

      if (resource.placeholders?.isNotEmpty ?? false) {
        return _getResourceFullMethod(resource, builder);
      } else {
        return _getResourceGetter(resource, builder);
      }
    });
  }

  void _getResourceFullMethod(ArbResource resource, MethodBuilder builder) {
    final key = resource.key;
    final value = _escapeString(resource.value);
    final description =
        _escapeString((resource.attributes['description'] ??= '') as String);

    var args = <String>[];
    resource.placeholders?.forEach((ArbResourcePlaceholder placeholder) {
      builder.requiredParameters.add(
        Parameter((ParameterBuilder builder) {
          args.add(placeholder.name);
          final argumentType =
              placeholder.type == ArbResourcePlaceholder.typeNum
                  ? 'int'
                  : 'String';
          builder
            ..name = placeholder.name
            ..type = Reference(argumentType);
        }),
      );
    });

    builder.body = Code(
      _getCode(value, key: key, args: args, description: description),
    );
  }

  void _getResourceGetter(ArbResource resource, MethodBuilder builder) {
    final key = resource.key;
    final value = _escapeString(resource.value);
    final description =
        _escapeString((resource.attributes['description'] ??= key) as String);

    builder
      ..type = MethodType.getter
      ..body = Code(
          '''Intl.message('$value', name: '$key', desc: '$description')''');
  }

  ///
  /// intl_translation
  ///
  final Parser<dynamic> _pluralParser = CustomIcuParser().message;
  final Parser<dynamic> _plainParser = CustomIcuParser().nonIcuMessage;

  String _getCode(String value,
      {required String key, required String description, required List args}) {
    Message message = _pluralParser.parse(value).value;
    if (message is LiteralString && message.string.isEmpty) {
      message = _plainParser.parse(value).value;
    }
    if (message is Plural) {
      final pluralBuilder = StringBuffer();
      pluralBuilder.write('Intl.plural(count,');
      void addIfNotNull(String key, Message? message) {
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
        'name: \'$key\',',
      );
      pluralBuilder.write(
        'args: [${args.join(", ")}],',
      );
      pluralBuilder.write(
        'desc: \'$description\'',
      );
      pluralBuilder.write(')');

      final code = pluralBuilder.toString();

      return code;
    }
    final code = _getMessageCode(message);
    return """Intl.message('$code', name: '$key', args: [${args.join(", ")}], desc: '$description')""";
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
    return value.replaceAll('\n', '\\n');
  }
}

const int _ASCII_END = 0x7f;
const int _ASCII_START = 0x0;
const int _UNICODE_END = 0x10ffff;
const int _C0_START = 0x00;
const int _C0_END = 0x1f;

String _escapeString(String string) {
  if (string.isEmpty) {
    return string;
  }

  var sb = StringBuffer();
  var i = 0;
  for (var c in string.runes) {
    if (c >= _C0_START && c <= _C0_END) {
      switch (c) {
        case 9:
          sb.write('\\t');
          break;
        case 10:
          sb.write('\\n');
          break;
        case 13:
          sb.write('\\r');
          break;
        default:
          sb.write(toUnicode(c));
      }
    } else if (c >= _ASCII_START && c <= _ASCII_END) {
      switch (c) {
        case 34:
          sb.write('\\\"');
          break;
        case 36:
          sb.write('\\\$');
          break;
        case 39:
          sb.write("\\\'");
          break;
        case 92:
          sb.write('\\\\');
          break;
        default:
          sb.write(string[i]);
      }
    } else if (_isPrintable(c)) {
      sb.write(string[i]);
    } else {
      sb.write(toUnicode(c));
    }

    i++;
  }

  return sb.toString();
}

String toUnicode(int? charCode) {
  if (charCode == null || charCode < 0 || charCode > _UNICODE_END) {
    throw ArgumentError('charCode: $charCode');
  }

  var hex = charCode.toRadixString(16);
  var length = hex.length;
  if (length < 4) {
    hex = hex.padLeft(4, '0');
  }

  return '\\u$hex';
}

bool _isPrintable(int character) {
  return true;
}

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
import 'package:intl_translation/src/intl_message.dart';
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
    return Method((MethodBuilder builder) {
      final key = resource.key;
      final value = resource.value;
      final description = resource.attributes['description'] ??= key;

      var args = <String>[];
      resource.placeholders.forEach((ArbResourcePlaceholder placeholder) {
        builder.requiredParameters.add(Parameter((ParameterBuilder builder) {
          args.add(placeholder.name);
          final argumentType = placeholder.type == 'num' ? 'int' : 'String';
          builder
            ..name = placeholder.name
            ..type = Reference(argumentType);
        }));
      });

      builder
        ..name = _getMethodName(key)
        ..returns = const Reference('String')
        ..lambda = true
        ..docs.add('\t/// ${description}')
        ..body = Code(
            _getCode(value, key: key, args: args, description: description));
    });
  }

// """Intl.message('${value}', name: '$key', args: [${args.join(", ")}], desc: '${description}')"""

  Method _getResourceGetter(ArbResource resource) {
    return Method((MethodBuilder builder) {
      final key = resource.key;
      final value = resource.value;
      final description = resource.attributes['description'] ??= key;

      builder
        ..name = _getMethodName(key)
        ..type = MethodType.getter
        ..returns = const Reference('String')
        ..lambda = true
        ..body = Code(
            '''Intl.message('${value}', name: '${key}', desc: '${description}')''')
        ..docs.add('\t/// ${description}');
    });
  }

  String _getMethodName(String key) => ReCase(key).camelCase;

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
}

class CustomIcuParser {
  dynamic get openCurly => char('{');

  dynamic get closeCurly => char('}');
  dynamic get quotedCurly => (string("'{'") | string("'}'")).map((x) => x[1]);

  dynamic get icuEscapedText => quotedCurly | twoSingleQuotes;
  dynamic get curly => (openCurly | closeCurly);
  dynamic get notAllowedInIcuText => curly | char('<');
  dynamic get icuText => notAllowedInIcuText.neg();
  dynamic get notAllowedInNormalText => char('{');
  dynamic get normalText => notAllowedInNormalText.neg();
  dynamic get messageText =>
      (icuEscapedText | icuText).plus().map((x) => x.join());
  dynamic get nonIcuMessageText => normalText.plus().map((x) => x.join());
  dynamic get twoSingleQuotes => string("''").map((x) => "'");
  dynamic get number => digit().plus().flatten().trim().map(int.parse);
  dynamic get id => (letter() & (word() | char('_')).star()).flatten().trim();
  dynamic get comma => char(',').trim();

  /// Given a list of possible keywords, return a rule that accepts any of them.
  /// e.g., given ["male", "female", "other"], accept any of them.
  dynamic asKeywords(list) =>
      list.map(string).reduce((a, b) => a | b).flatten().trim();

  dynamic get pluralKeyword => asKeywords(
      ['=0', '=1', '=2', 'zero', 'one', 'two', 'few', 'many', 'other']);
  dynamic get genderKeyword => asKeywords(['female', 'male', 'other']);

  var interiorText = undefined();

  dynamic get preface => (openCurly & id & comma).map((values) => values[1]);

  dynamic get pluralLiteral => string('plural');
  dynamic get pluralClause =>
      (pluralKeyword & openCurly & interiorText & closeCurly)
          .trim()
          .map((result) => [result[0], result[2]]);
  dynamic get plural =>
      preface & pluralLiteral & comma & pluralClause.plus() & closeCurly;
  dynamic get intlPlural =>
      plural.map((values) => Plural.from(values.first, values[3], null));

  dynamic get selectLiteral => string('select');
  dynamic get genderClause =>
      (genderKeyword & openCurly & interiorText & closeCurly)
          .trim()
          .map((result) => [result[0], result[2]]);
  dynamic get gender =>
      preface & selectLiteral & comma & genderClause.plus() & closeCurly;
  dynamic get intlGender =>
      gender.map((values) => Gender.from(values.first, values[3], null));
  dynamic get selectClause =>
      (id & openCurly & interiorText & closeCurly).map((x) => [x.first, x[2]]);
  dynamic get generalSelect =>
      preface & selectLiteral & comma & selectClause.plus() & closeCurly;
  dynamic get intlSelect =>
      generalSelect.map((values) => Select.from(values.first, values[3], null));

  dynamic get pluralOrGenderOrSelect => intlPlural | intlGender | intlSelect;

  dynamic get contents => pluralOrGenderOrSelect | parameter | messageText;
  dynamic get simpleText => (nonIcuMessageText | parameter | openCurly).plus();
  dynamic get empty => epsilon().map((_) => '');

  dynamic get parameter => (openCurly & id & closeCurly)
      .map((param) => CustomVariableSubstitution.named(param[1], null));

  /// The primary entry point for parsing. Accepts a string and produces
  /// a parsed representation of it as a Message.
  Parser get message => (pluralOrGenderOrSelect | empty)
      .map((chunk) => Message.from(chunk, null));

  /// Represents an ordinary message, i.e. not a plural/gender/select, although
  /// it may have parameters.
  Parser get nonIcuMessage =>
      (simpleText | empty).map((chunk) => Message.from(chunk, null));

  dynamic get stuff => (pluralOrGenderOrSelect | empty)
      .map((chunk) => Message.from(chunk, null));

  CustomIcuParser() {
    // There is a cycle here, so we need the explicit set to avoid
    // infinite recursion.
    interiorText.set(contents.plus() | empty);
  }
}

class CustomVariableSubstitution extends VariableSubstitution {
  final String variable;
  CustomVariableSubstitution.named(String name, Message parent)
      : variable = name,
        super.named(name, parent);
}

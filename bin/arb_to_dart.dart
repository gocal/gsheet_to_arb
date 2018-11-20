/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

library gsheet_to_arb;

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:gsheet_to_arb/gsheet_to_arb.dart';
import 'package:intl_translation/extract_messages.dart';
import 'package:intl_translation/generate_localized.dart';
import 'package:intl_translation/src/icu_parser.dart';
import 'package:intl_translation/src/intl_message.dart';
import 'package:path/path.dart' as path;

main(List<String> args) async {
  var parser = new ArgParser();
  var configFilePath = "./.gsheet_to_arb.yaml";

  parser.addOption("config",
      defaultsTo: configFilePath,
      callback: (x) => configFilePath = x,
      help: 'config yaml file name');

  parser.parse(args);
  if (args.length == 0) {
    print('Imports ARB file from exisiting GSheet document');
    print('Usage: gsheet_to_arb [options]');
    print(parser.usage);
    exit(0);
  }

  var config = PluginUtils().fromYamlFile(configFilePath);

  var serializer = ArbSerializer();

  var document =
  serializer.loadArbDocument("${config.outputDirectoryPath}/intl_en.arb");

  var generator = TranslationsGenerator();

  generator.buildTranslations(document, config.outputDirectoryPath, "L10n");

  var extraction = new MessageExtraction();
  var generation = new MessageGeneration();

  generation.generatedFilePrefix = "_";

  var dartFiles = ["${config.outputDirectoryPath}/l10n.dart"];

  var jsonFiles = Directory(config.outputDirectoryPath).listSync().where((file) => file.path.endsWith(".arb")).map<String>((file) => file.path);

  var targetDir = config.outputDirectoryPath;

  extraction.suppressWarnings = true;
  var allMessages = dartFiles
      .map((each) => extraction.parseFile(new File(each)));

  messages = new Map();
  for (var eachMap in allMessages) {
    eachMap.forEach(
            (key, value) => messages.putIfAbsent(key, () => []).add(value));
  }
  for (var arg in jsonFiles) {
    var file = new File(arg);
    generateLocaleFile(file, targetDir, generation);
  }

  var mainImportFile = new File(path.join(
      targetDir, '${generation.generatedFilePrefix}messages_all.dart'));
  mainImportFile.writeAsStringSync(generation.generateMainImportFile());

}


/// *********************
///
/// *********************



/// Keeps track of all the messages we have processed so far, keyed by message
/// name.
Map<String, List<MainMessage>> messages;

const jsonDecoder = const JsonCodec();

/// Create the file of generated code for a particular locale. We read the ARB
/// data and create [BasicTranslatedMessage] instances from everything,
/// excluding only the special _locale attribute that we use to indicate the
/// locale. If that attribute is missing, we try to get the locale from the last
/// section of the file name.
void generateLocaleFile(
    File file, String targetDir, MessageGeneration generation) {
  var src = file.readAsStringSync();
  var data = jsonDecoder.decode(src);
  var locale = data["@@locale"] ?? data["_locale"];
  if (locale == null) {
    // Get the locale from the end of the file name. This assumes that the file
    // name doesn't contain any underscores except to begin the language tag
    // and to separate language from country. Otherwise we can't tell if
    // my_file_fr.arb is locale "fr" or "file_fr".
    var name = path.basenameWithoutExtension(file.path);
    locale = name.split("_").skip(1).join("_");
    print("No @@locale or _locale field found in $name, "
        "assuming '$locale' based on the file name.");
  }
  generation.allLocales.add(locale);

  List<TranslatedMessage> translations = [];
  data.forEach((id, messageData) {
    TranslatedMessage message = recreateIntlObjects(id, messageData);
    if (message != null) {
      translations.add(message);
    }
  });
  generation.generateIndividualMessageFile(locale, translations, targetDir);
}

/// Regenerate the original IntlMessage objects from the given [data]. For
/// things that are messages, we expect [id] not to start with "@" and
/// [data] to be a String. For metadata we expect [id] to start with "@"
/// and [data] to be a Map or null. For metadata we return null.
BasicTranslatedMessage recreateIntlObjects(String id, data) {
  if (id.startsWith("@")) return null;
  if (data == null) return null;
  var parsed = pluralAndGenderParser.parse(data).value;
  if (parsed is LiteralString && parsed.string.isEmpty) {
    parsed = plainParser.parse(data).value;
  }
  return new BasicTranslatedMessage(id, parsed);
}

/// A TranslatedMessage that just uses the name as the id and knows how to look
/// up its original messages in our [messages].
class BasicTranslatedMessage extends TranslatedMessage {
  BasicTranslatedMessage(String name, translated) : super(name, translated);

  List<MainMessage> get originalMessages => (super.originalMessages == null)
      ? _findOriginals()
      : super.originalMessages;

  // We know that our [id] is the name of the message, which is used as the
  //key in [messages].
  List<MainMessage> _findOriginals() => originalMessages = messages[id];
}

final pluralAndGenderParser = new IcuParser().message;
final plainParser = new IcuParser().nonIcuMessage;
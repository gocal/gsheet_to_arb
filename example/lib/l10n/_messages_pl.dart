// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pl locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pl';

  static String m0(count) =>
      "${Intl.plural(count, one: '${count} dolar kanadyjski', other: '${count} dolarów kanadyjskich')}";

  static String m1(count) =>
      "${Intl.plural(count, zero: 'Nie znaleziono piosenek.', one: 'Znaleziono jedną piosenkę.', two: 'Znaleziono ${count} piosenki.', few: 'Znaleziono ${count} piosenek.', many: 'Znaleziono ${count} piosenek.', other: 'Znaleziono ${count} piosenek.')}";

  static String m2(name) => "Pojedynczy argument  ${name} ";

  static String m3(first, second) => "Dwa argumenty: ${first} i ${second}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "amountDollars": m0,
        "appName": MessageLookupByLibrary.simpleMessage("Aplikacja"),
        "login": MessageLookupByLibrary.simpleMessage("Zaloguj"),
        "longText": MessageLookupByLibrary.simpleMessage(
            "lina a\nlina b\nlina c\nlorem\nipsum"),
        "message": MessageLookupByLibrary.simpleMessage("Wiadomość"),
        "numberOfSongsAvailable": m1,
        "register": MessageLookupByLibrary.simpleMessage("Zarejestruj"),
        "singleArgument": m2,
        "specialCharacters":
            MessageLookupByLibrary.simpleMessage("special: ąęśćż"),
        "title": MessageLookupByLibrary.simpleMessage("Tytuł"),
        "twoArguments": m3
      };
}

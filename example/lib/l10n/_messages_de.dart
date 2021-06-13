// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static String m0(count) =>
      "${Intl.plural(count, one: '${count} kanadische Dollar', other: '${count} kanadischen Dollar')}";

  static String m1(count) =>
      "${Intl.plural(count, zero: 'Keine Lieder gefunden.', one: 'Ein Lied gefunden.', two: '${count} Songs gefunden.', few: '${count} Songs gefunden.', many: '${count} Songs gefunden.', other: '${count} Lied gefunden.')}";

  static String m2(name) => "Einzel ${name} Argument";

  static String m3(first, second) => "Dwa argumenty: ${first} i ${second}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "amountDollars": m0,
        "appName": MessageLookupByLibrary.simpleMessage("Anwendung"),
        "login": MessageLookupByLibrary.simpleMessage("Einloggen"),
        "longText": MessageLookupByLibrary.simpleMessage(
            "Linie ein\nLinie b\nLinie c\nlorem\nipsum"),
        "message": MessageLookupByLibrary.simpleMessage("Nachricht"),
        "numberOfSongsAvailable": m1,
        "register": MessageLookupByLibrary.simpleMessage("Registrieren"),
        "singleArgument": m2,
        "specialCharacters":
            MessageLookupByLibrary.simpleMessage("special: äöüß"),
        "title": MessageLookupByLibrary.simpleMessage("Titel"),
        "twoArguments": m3
      };
}

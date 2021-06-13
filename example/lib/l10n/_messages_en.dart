// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(count) =>
      "${Intl.plural(count, one: '${count} Canadian dollar', other: '${count} Canadian dollars')}";

  static String m1(count) =>
      "${Intl.plural(count, zero: 'No songs found.', one: 'One song found.', two: '${count} songs found.', few: '${count} songs found.', many: '${count} songs found.', other: '${count} song found.')}";

  static String m2(name) => "Single ${name} argument";

  static String m3(first, second) => "Argument ${first} and ${second}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "amountDollars": m0,
        "appName": MessageLookupByLibrary.simpleMessage("Sample Application"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "longText": MessageLookupByLibrary.simpleMessage(
            "line a\nline b\nline c\nlorem\nipsum"),
        "message": MessageLookupByLibrary.simpleMessage("Message"),
        "numberOfSongsAvailable": m1,
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "singleArgument": m2,
        "specialCharacters":
            MessageLookupByLibrary.simpleMessage("special: !@#\$%^&*()"),
        "title": MessageLookupByLibrary.simpleMessage("Title"),
        "twoArguments": m3
      };
}

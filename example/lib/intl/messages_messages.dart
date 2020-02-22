// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
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
  String get localeName => 'messages';

  static m0(x) => "Another message with parameter ${x}";

  static m1(number, gen) => "${Intl.plural(number, other: '')}";

  static m2(currency, amount) => "${Intl.select(currency, {'CDN': '${Intl.plural(amount, one: '${amount} Canadian dollar', other: '${amount} Canadian dollars')}', 'other': 'Whatever', })}";

  static m3(g) => "${Intl.gender(g, female: 'f', male: 'm', other: 'o')}";

  static m4(n) => "${Intl.plural(n, zero: 'none', one: 'one', other: 'some')}";

  static m5(currency, amount) => "${Intl.select(currency, {'CDN': '${amount} Canadian dollars', 'other': '${amount} some currency or other.', })}";

  static m6(noOfThings) => "${Intl.plural(noOfThings, one: '1 thing:', other: '${noOfThings} things:')}";

  static m7(s) => "Interpolation is tricky when it ends a sentence like ${s}.";

  static m8(a, b, c) => "${a}, ${b}, ${c}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "\"So-called\"" : MessageLookupByLibrary.simpleMessage("\"So-called\""),
    "\'<>{}= +-_\$()&^%\$#@!~`\'" : MessageLookupByLibrary.simpleMessage("\'<>{}= +-_\$()&^%\$#@!~`\'"),
    "Ancient Greek hangman characters: 𐅆𐅇." : MessageLookupByLibrary.simpleMessage("Ancient Greek hangman characters: 𐅆𐅇."),
    "This string extends across multiple lines." : MessageLookupByLibrary.simpleMessage("This string extends across multiple lines."),
    "alwaysTranslated" : MessageLookupByLibrary.simpleMessage("This string is always translated"),
    "differentNameSameContents" : MessageLookupByLibrary.simpleMessage("Hello World"),
    "escapable" : MessageLookupByLibrary.simpleMessage("Escapable characters here: "),
    "extractable" : MessageLookupByLibrary.simpleMessage("This message should be extractable"),
    "literalDollar" : MessageLookupByLibrary.simpleMessage("Five cents is US\$0.05"),
    "message1" : MessageLookupByLibrary.simpleMessage("This is a message"),
    "message2" : m0,
    "nestedOuter" : m1,
    "nestedSelect" : m2,
    "notAlwaysTranslated" : MessageLookupByLibrary.simpleMessage("This is missing some translations"),
    "outerGender" : m3,
    "outerPlural" : m4,
    "outerSelect" : m5,
    "pluralThatFailsParsing" : m6,
    "rentAsVerb" : MessageLookupByLibrary.simpleMessage("rent"),
    "rentToBePaid" : MessageLookupByLibrary.simpleMessage("rent"),
    "sameContentsDifferentName" : MessageLookupByLibrary.simpleMessage("Hello World"),
    "trickyInterpolation" : m7,
    "types" : m8
  };
}

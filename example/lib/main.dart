import 'package:intl/intl.dart';

void main() {}

// Used to verify intl_translation behaviour
class IntlTranslations {
  String message1() =>
      Intl.message("This is a message", name: 'message1', desc: 'foo');

  String message2(x) => Intl.message("Another message with parameter $x",
      name: 'mess' 'age2',
      desc: 'Description ' '2',
      args: [x],
      examples: const {'x': 3});

// A string with multiple adjacent strings concatenated together, verify
// that the parser handles this properly.
  String multiLine() => Intl.message(
      'This '
      'string '
      'extends '
      'across '
      'multiple '
      'lines.',
      desc: 'multi-line');

  String get interestingCharactersNoName =>
      Intl.message("'<>{}= +-_\$()&^%\$#@!~`'", desc: "interesting characters");

// Have types on the enclosing function's arguments.
  String types(int a, String b, List c) =>
      Intl.message("$a, $b, $c", name: 'types', args: [a, b, c], desc: 'types');

// This string will be printed with a French locale, so it will always show
// up in the French version, regardless of the current locale.
  String alwaysTranslated() => Intl.message("This string is always translated",
      locale: 'fr', name: 'alwaysTranslated', desc: 'always translated');

// Test interpolation with curly braces around the expression, but it must
// still be just a variable reference.
  String trickyInterpolation(s) =>
      Intl.message("Interpolation is tricky when it ends a sentence like ${s}.",
          name: 'trickyInterpolation', args: [s], desc: 'interpolation');

  String get leadingQuotes => Intl.message("\"So-called\"", desc: "so-called");

// A message with characters not in the basic multilingual plane.
  String originalNotInBMP() =>
      Intl.message("Ancient Greek hangman characters: 𐅆𐅇.", desc: "non-BMP");

// A string for which we don't provide all translations.
  String notAlwaysTranslated() =>
      Intl.message("This is missing some translations",
          name: "notAlwaysTranslated", desc: "Not always translated");

// This is unremarkable in English, but the translated versions will contain
// characters that ought to be escaped during code generation.
  String escapable() => Intl.message("Escapable characters here: ",
      name: "escapable", desc: "Escapable characters");

  String outerPlural(n) => Intl.plural(n,
      zero: 'none',
      one: 'one',
      other: 'some',
      name: 'outerPlural',
      desc: 'A plural with no enclosing message',
      args: [n]);

  String outerGender(g) => Intl.gender(g,
      male: 'm',
      female: 'f',
      other: 'o',
      name: 'outerGender',
      desc: 'A gender with no enclosing message',
      args: [g]);

  String pluralThatFailsParsing(noOfThings) => Intl.plural(noOfThings,
      one: "1 thing:",
      other: "$noOfThings things:",
      name: "pluralThatFailsParsing",
      args: [noOfThings],
      desc: "How many things are there?");

// A general select
  String outerSelect(currency, amount) => Intl.select(
      currency,
      {
        "CDN": "$amount Canadian dollars",
        "other": "$amount some currency or other."
      },
      name: "outerSelect",
      desc: "Select",
      args: [currency, amount]);

// A select with a plural inside the expressions.
  String nestedSelect(currency, amount) => Intl.select(
      currency,
      {
        "CDN":
            """${Intl.plural(amount, one: '$amount Canadian dollar', other: '$amount Canadian dollars')}""",
        "other": "Whatever",
      },
      name: "nestedSelect",
      args: [currency, amount],
      desc: "Plural inside select");

// A trivial nested plural/gender where both are done directly rather than
// in interpolations.
  String nestedOuter(number, gen) => Intl.plural(number,
      other: Intl.gender(gen, male: "$number male", other: "$number other"),
      name: 'nestedOuter',
      args: [number, gen],
      desc: "Gender inside plural");

  String sameContentsDifferentName() => Intl.message("Hello World",
      name: "sameContentsDifferentName",
      desc: "One of two messages with the same contents, but different names");

  String differentNameSameContents() => Intl.message("Hello World",
      name: "differentNameSameContents",
      desc: "One of two messages with the same contents, but different names");

  /// Distinguish two messages with identical text using the meaning parameter.
  String rentToBePaid() => Intl.message("rent",
      name: "rentToBePaid",
      meaning: 'Money for rent',
      desc: "Money to be paid for rent");

  String rentAsVerb() => Intl.message("rent",
      name: "rentAsVerb",
      meaning: 'rent as a verb',
      desc: "The action of renting, as in rent a car");

  String literalDollar() => Intl.message("Five cents is US\$0.05",
      name: "literalDollar", desc: "Literal dollar sign with valid number");

  /// Messages for testing the skip flag.
  String extractable() => Intl.message('This message should be extractable',
      name: "extractable", skip: false, desc: "Not skipped message");
}

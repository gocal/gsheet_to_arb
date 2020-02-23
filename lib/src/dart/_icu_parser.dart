import 'package:intl_translation/src/intl_message.dart';
import 'package:petitparser/petitparser.dart';

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

import 'package:intl/intl.dart';

//ignore_for_file: type_annotate_public_apis, non_constant_identifier_names
class L10n {
  /// number of songs plural
  String numberOfSongsAvailable(int count) => Intl.plural(count,
      zero: 'No songs found.',
      one: 'One song found.',
      two: '$count songs found.',
      few: '$count songs found.',
      other: '$count song found.',
      many: '$count songs found.',
      name: 'numberOfSongsAvailable',
      args: [count],
      desc: 'number of songs plural');

  /// currency dolars
  String amountDollars(int count) => Intl.plural(count,
      one: '$count Canadian dollar',
      other: '$count Canadian dollars',
      name: 'amountDollars',
      args: [count],
      desc: 'currency dolars');

  /// test special characters
  String get specialCharacters => Intl.message('special: !@#\$%^&*()',
      name: 'specialCharacters', desc: 'test special characters');

  /// contains title
  String get title =>
      Intl.message('Title', name: 'title', desc: 'contains title');

  /// contains message
  String get message =>
      Intl.message('Message', name: 'message', desc: 'contains message');

  /// contains app name
  String get appName => Intl.message('Sample Application',
      name: 'appName', desc: 'contains app name');

  /// contains login
  String get login =>
      Intl.message('Login', name: 'login', desc: 'contains login');

  /// contains registration
  String get register =>
      Intl.message('Register', name: 'register', desc: 'contains registration');

  /// Single named argument
  String singleArgument(String name) => Intl.message('Single $name argument',
      name: 'singleArgument', args: [name], desc: 'Single named argument');

  /// Two named arguments
  String twoArguments(String first, String second) =>
      Intl.message('Argument $first and $second',
          name: 'twoArguments',
          args: [first, second],
          desc: 'Two named arguments');

  /// long
  /// description
  ///
  /// new
  /// line
  String get longText => Intl.message('line a\nline b\nline c\nlorem\nipsum',
      name: 'longText', desc: 'long\ndescription\n\nnew\nline');
}

import 'package:intl/intl.dart';

//ignore_for_file: type_annotate_public_apis, non_constant_identifier_names
class L10n {
  /// contains title
  String get title =>
      Intl.message('Title', name: 'title', desc: 'contains title');

  /// contains message
  String get message =>
      Intl.message('Message', name: 'message', desc: 'contains message');

  /// contains app name
  String get appName => Intl.message('Sample Application',
      name: 'app_name', desc: 'contains app name');

  /// contains login
  String get login =>
      Intl.message('Login', name: 'login', desc: 'contains login');

  /// contains registration
  String get register =>
      Intl.message('Register', name: 'register', desc: 'contains registration');

  /// number of songs plural
  String numberOfSongsAvailable(String count) => Intl.plural(count,
      zero: 'No songs found.',
      one: 'One song found.',
      other: '$count song found.',
      args: [count],
      desc: 'number of songs plural');

  /// Single named argument
  String singleArgument(String name) => Intl.message('Single $name argument',
      name: 'single_argument', args: [name], desc: 'Single named argument');

  /// Two named arguments
  String twoArguments(String first, String second) =>
      Intl.message('Argument $first and $second',
          name: 'two_arguments',
          args: [first, second],
          desc: 'Two named arguments');
}

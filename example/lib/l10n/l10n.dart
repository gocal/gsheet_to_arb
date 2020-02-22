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

  /// Single named argument
  String singleArgument(String name) => Intl.message('Single {name} argument',
      name: 'single_argument', args: [name], desc: 'Single named argument');

  /// Two named arguments
  String twoArguments(String first, String second) =>
      Intl.message('Argument {first} and {second}',
          name: 'two_arguments',
          args: [first, second],
          desc: 'Two named arguments');

  /// number of songs plural
  String numberOfSongsAvailable(String count) => Intl.message(
      '{count, plural, =0 {No songs found.} =1 {One song found.} other {{count} song found.}}',
      name: 'number_of_songs_available',
      args: [count],
      desc: 'number of songs plural');
}

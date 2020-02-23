import 'package:intl/intl.dart';

import 'l10n/_messages_all.dart';
import 'l10n/l10n.dart';

void main() async {
  print('MAIN');

  Intl.defaultLocale = 'pl';
  await initializeMessages(Intl.defaultLocale);

  final l10n = L10n();

  print(l10n.title);
  print(l10n.login);
  print(l10n.singleArgument('arg'));
  print(l10n.twoArguments('arg1', 'arg2'));

  // plurals
  print(l10n.numberOfSongsAvailable(0));
  print(l10n.numberOfSongsAvailable(1));
  print(l10n.numberOfSongsAvailable(2));
  print(l10n.numberOfSongsAvailable(5));
  print(l10n.numberOfSongsAvailable(10));

  
}

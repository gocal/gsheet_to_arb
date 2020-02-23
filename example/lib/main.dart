import 'l10n/_messages_all.dart';
import 'l10n/l10n.dart';

void main() async {
  print('MAIN');

  await initializeMessages('de');

  final l10n = L10n();

  print(l10n.title);
  print(l10n.login);
  print(l10n.singleArgument('arg'));
  print(l10n.twoArguments('arg1', 'arg2'));
}

# Scripts

Import ARB files from Google Sheets:

```
pub run gsheet_to_arb:import
```


Generate ARB
```
pub run intl_translation:extract_to_arb --output-dir=lib/l10n/ lib/l10n/l10n.dart
```

Generate Code
```
pub run intl_translation:generate_from_arb lib/l10n/l10n.dart lib/l10n/intl_messages.arb
```
# Scripts

Import ARB files from Google Sheets:

```
pub run gsheet_to_arb:import
```


Generate ARB
```
pub run intl_translation:extract_to_arb --output-dir=lib/l10n/ lib/main.dart
```

Generate Code
```
pub run intl_translation:generate_from_arb lib/main.dart lib/l10n/intl_messages.arb
```
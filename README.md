# GSheet to arb

Imports Application Resource Bundle (arb) from Google Sheets 

## Plugin configuration

```yaml
gsheet_to_arb:
  gsheet:
    client_id: '<google_api_client_id>'
    client_secret: '<google_api_secret>'
    document_id: '<google_sheet_id>'
```

## Import ARB files from the Google Sheet

To import arb files from Google Sheet run the `import` program.

```
pub run gsheet_to_arb:import
```

## Export ARB files to the Google Sheet

To import arb files from Google Sheet run the `export` program.

```
pub run gsheet_to_arb:export
```
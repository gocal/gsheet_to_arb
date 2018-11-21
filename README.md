# GSheet to ARB

Imports Application Resource Bundle (ARB) from Google Sheets 

https://github.com/googlei18n/app-resource-bundle/wiki/ApplicationResourceBundleSpecification

## Setup

### Google Sheet API key

1. Create a new project in 'Google Cloud Platform' console (you can use existing one) 
    - https://console.cloud.google.com/projectcreate 
2. Select "ENABLE APIS AND SERVICES" button and make sure "Google Sheets API" is enabled
3. Open "Credentials" tab of the project
4. Create credentials -> Create OAuth client ID ->  Other 
    - you may need to configure consent screen
5. Save your `client_id` and `client_secret`

### Create Google Sheet from the template

1. Open sample Google spreadsheet available at:
    - https://docs.google.com/spreadsheets/d/1CwFRjtiCmCl8yvP55yBT70h-Yt00CcigD816hsGo7KU/edit?usp=sharing

2. Copy sample to your Drive account 
    - File -> Make a copy

3. Save `document_id` of the Google spreadsheet
    - https://docs.google.com/spreadsheets/d/`<document_id>`/edit#gid=0

### Configure your Dart project

1. Add gsheet_to_arb dev dependency to the pubspec.yaml
    ```yaml
    dev_dependencies:
      gsheet_to_arb: ^0.0.4
    ```

2. ```pub update```

3. Create plugin configuration e.g. ```gsheet_to_arb.yaml```
    ```yaml
    gsheet_to_arb:
      arb_file_prefix: 'intl'
      output_directory: 'build'
      gsheet:
        document_id: '<document_id>'
        sheet_id: '0'
        auth:
          service_account_key_path: "~/.ssh/gsheet-to-arb-server-config.json"
    ```

## Import ARB files from the Google Sheet

1. To import ARB files from Google Sheet run the `gsheet_to_arb:import` program.

    ```
    pub run gsheet_to_arb:import --config gsheet_to_arb.yaml
    ```

2. If need - authenticate Google Sheet Access

## Create Google Sheet template from existing ARB file

Not implemented yet.


## TODO

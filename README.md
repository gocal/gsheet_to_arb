# GSheet to ARB - Import ARB Translation files from Google Sheet 

[![pub package](https://img.shields.io/pub/v/gsheet_to_arb.svg)](https://pub.dartlang.org/packages/gsheet_to_arb)

 ![](doc/gsheet.png) 


Imports Application Resource Bundle (ARB) from Google Sheets 

https://github.com/googlei18n/app-resource-bundle/wiki/ApplicationResourceBundleSpecification

## Usage

### Import ARB files from the Google Sheet

1. [Setup](#setup) plugin configuration yaml file - you only need to do it once.

2. To import ARB files from Google Sheet run the `gsheet_to_arb:import` program.

    ```
    pub run gsheet_to_arb:import --config gsheet_to_arb.yaml
    ```

## Setup

### 1. Copy Google Sheet template

1. Open sample Google spreadsheet template available at:
    - https://docs.google.com/spreadsheets/d/1CwFRjtiCmCl8yvP55yBT70h-Yt00CcigD816hsGo7KU/edit?usp=sharing

2. Copy sample to your Drive account 
    - File -> Make a copy

3. Save `DOCUMENT_ID` of the Google spreadsheet
    - https://docs.google.com/spreadsheets/d/DOCUMENT_ID/edit#gid=0

### 2. Authenticate

Create [Google Sheets API credentials](doc/Authentication.md) either by using Client or Server authentication.

### 3. Configure your Dart project

1. Add gsheet_to_arb dev dependency to the pubspec.yaml
    ```yaml
    dev_dependencies:
      gsheet_to_arb: ^0.1.0
    ```

2. Updated dependencies
    ```pub update```

3. Create plugin configuration
    ```yaml
    pub run gsheet_to_arb:import --create-config
    ```
It will create `gsheet_to_arb.yaml` file in the root directory

4. Update plugin configuration  ```gsheet_to_arb.yaml``` e.g.
    ```yaml
    gsheet_to_arb:
      arb_file_prefix: 'intl'
      output_directory: 'lib/src/i18n'
      gsheet:
        document_id: '<DOCUMENT_ID>'
        sheet_id: '0'
        auth:
          service_account_key_path: "~/.ssh/gsheet-to-arb-server-config.json"
    ```

## TODO

- Support ARB plurals
# Import Arb and Dart intl translations from Google Sheet 

Imports Application Resource Bundle (ARB) from Google Sheets 

https://github.com/googlei18n/app-resource-bundle/wiki/ApplicationResourceBundleSpecification

[![pub package](https://img.shields.io/pub/v/gsheet_to_arb.svg)](https://pub.dartlang.org/packages/gsheet_to_arb)

## Usage

### Import ARB files from the Google Sheet

1. [Setup](#setup) plugin configuration yaml file - you only need to do it once.

2. To import ARB files from Google Sheet simply run the `gsheet_to_arb:import` program.

    ```
    pub run gsheet_to_arb:import
    ```

 ![](doc/gsheet.png) 




## Setup

### 1. Copy Google Sheet template

1. Reference Google Sheet is avaliable at:
    - https://docs.google.com/spreadsheets/d/1CwFRjtiCmCl8yvP55yBT70h-Yt00CcigD816hsGo7KU/edit?usp=sharing

2. Copy the template to your Drive account 
    - File -> Make a copy

3. Save `DOCUMENT_ID` of the Google spreadsheet
    - https://docs.google.com/spreadsheets/d/DOCUMENT_ID/edit#gid=0

### 2. Authenticate - Create [Google Sheets API credentials](doc/Authentication.md) either by using Client or Server authentication.

### 3. Configure your Dart project

1. Add gsheet_to_arb dev dependency to the pubspec.yaml
    ```yaml
    dev_dependencies:
      gsheet_to_arb: ^0.1.1
    ```

2. Updated dependencies
    ```pub update```

3. Create plugin configuration
    ```yaml
    pub run gsheet_to_arb:import --create-config
    ```
- It will add plugin configuration to the `pubspec.yaml` file and create `gsheet_to_arb.yaml` authentication file for the gsheet credentials

4. Update plugin configuration created in ```pubspec.yaml``` e.g.
    ```yaml
    gsheet_to_arb: 
        arb_file_prefix: 'intl'
        localization_file_name: 'l10n'
        output_directory: 'lib/l10n'
        add_context_prefix: false
        gsheet: 
            auth_file: './gsheet_to_arb.yaml'
            category_prefix: "# "
            document_id: 'TODO'
            sheet_id: '0'
    ```

5. Update gsheet authentication configuration created in ```gsheet_to_arb.yaml```
- either add client
    ```yaml
    oauth_client_id: 
        client_id: "TODO"
        client_secret: "TODO"
    ```
- or server credentials
    ```yaml
    service_account_key: 
        client_id: "TODO"
        client_email: "TODO"
        private_key: "TODO"
    ```
    
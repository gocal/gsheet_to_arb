# GSheet to ARB

Imports Application Resource Bundle (ARB) from Google Sheets 

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
      gsheet_to_arb: ^0.0.2
    ```

2. ```pub update```

3. Create plugin configuration e.g. ```gsheet_to_arb.yaml```
    ```yaml
    gsheet_to_arb:
      gsheet:
        client_id: '<google_api_client_id>'
        client_secret: '<google_api_secret>'
        document_id: '<google_sheet_id>'
    ```

 You shouldn't share API secrets in VCSs, so add it to the .gitingore list

## Import ARB files from the Google Sheet

1. To import ARB files from Google Sheet run the `gsheet_to_arb:import` program.

    ```
    pub run gsheet_to_arb:import --config gsheet_to_arb.yaml --output-dir=lib/src/i18n
    ```

2. Click on the link displayed in the console 

    ```
    Please go to the following URL and grant Google Spreasheet access:
      => https://accounts.google.com/o/oauth2/auth?response_type=code&...
    ```

3. Log-in to the Google Account

4. Accept permissions to read the Google Spreadsheet

## Create Google Sheet template from existing ARB file

Not implemented yet.


## TODO

### Milestone 1 - 0.1.x

- [ ] Support translations sections
- [ ] Generate dart code from ARB files (via intl dependency)

### Milestone 2 - 0.2.x

- [ ] Server side authentication (for CI)

### Milestone 3 - 0.3.x

- [ ] Export as Android XML resource 
- [ ] Import Google Sheet from ARB file
# Authenticate

gsheet_to_arb plugin requires Google Sheets API access in order to fetch the data from Google Spreadsheet document.
There two possible options to provide such a access:

### Client Authentication (OAuthClientId)
- Used from the local environment
- Requires to login via browser


### Server Authentication (ServiceAccountKey) - CI/CD login
- Used for automatic CI/CD deployment
- Requires Service Account Key

## Client Authentication

1. Open Google Cloud Platform console - https://console.cloud.google.com/
2. Create a new project or you the existing one
3. From the side menu select `APIs & Services -> Dashboard`
4. Select `ENABLE APIS AND SERVICES` button and make sure `Google Sheets API` is enabled
5. Open `Credentials` tab on the left
6. `Create credentials -> Create OAuth client ID ->  Other` 
    - you may need to configure consent screen
7. Save your `client_id`, `client_secret` as a local json file (e.g. `~/.ssh/gsheet-to-arb-client-config.json`)
    ```json
    {
       "client_id": "<client_id>",
       "client_secret": "<client_secret>" 
    }
    ```
8. Update gsheet_to_arb.yaml configuration
    ```yaml
    (...)
        auth:
          oauth_client_id_path: '~/.ssh/gsheet-to-arb-client-config.json'
    ``` 
     

## Server Authentication

1. Open Google Cloud Platform console - https://console.cloud.google.com/
2. Create a new project or you the existing one
3. From the side menu select `APIs & Services -> Dashboard`
4. Select `ENABLE APIS AND SERVICES` button and make sure `Google Sheets API` is enabled
5. Open `Credentials` tab on the left
6. `Create credentials -> Service account key`
7. Select `Service account` or create new if not created yest
8. Select `JSON` key type.
9. Select Create
10. Save the *.json file on your local drive (e.g. `~/.ssh/gsheet-to-arb-server-config.json`)
    - do not share it with others
11. Update gsheet_to_arb.yaml configuration
    - service_account_key_path: '~/.ssh/gsheet-to-arb-server-config.json' 
12. Open "gsheet-to-arb-server-config.json" and copy value of the "email" field
13. Open GSheet Translations document
14. Select `Share` and enter above "email" address
15. Update gsheet_to_arb.yaml configuration
    ```yaml
    (...)
        auth:
          service_account_key_path: '~/.ssh/gsheet-to-arb-server-config.json'
    ``` 
     
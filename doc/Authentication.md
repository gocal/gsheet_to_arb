# Authenticate

gsheet_to_arb plugin requires Google Sheets API access in order to fetch the data from Google Spreadsheet document.
There are two possible options to provide such a access:

### Client Authentication (oauth) - local development
- Used from the local environment
- Requires to login via browser

### Server Authentication (private key) - e.g. for CI/CD login
- Used for automatic CI/CD deployment
- Requires Service Account Private Key

## Client Authentication

1. Open Google Cloud Platform console - https://console.cloud.google.com/
2. Create a new project or use the existing one
3. From the side menu select `APIs & Services -> Dashboard`
4. Select `ENABLE APIS AND SERVICES` button and make sure `Google Sheets API` is enabled
5. Open `Credentials` tab on the left
6. `Create credentials -> Create OAuth client ID ->  Other` 
    - you may need to configure consent screen
7. Update `gsheet_to_arb.yaml` file with the client configuration
    ```yaml
        oauth_client_id: 
            client_id: "<client_id>",
            client_secret: "<client_secret>" 
    ```


## Server Authentication

1. Open Google Cloud Platform console - https://console.cloud.google.com/
2. Create a new project or you the existing one
3. From the side menu select `APIs & Services -> Dashboard`
4. Select `ENABLE APIS AND SERVICES` button and make sure `Google Sheets API` is enabled
5. Open `Credentials` tab on the left
6. `Create credentials -> Service account key`
7. Select `Service account` or create new if not created yet
8. Select `JSON` key type.
9. Select Create
10. Download the *.json file on your local drive  - do not share it with others
11. Update `gsheet_to_arb.yaml` file with the downloaded json configuration
    ```yaml
    service_account_key: 
        client_id: "<client_id>"
        client_email: "<private_key>"
        private_key: "<private_key>"
      ```
12. Make sure the `gsheet_to_arb.yaml` is *not* added to the git repository as it contains your private key data.
import 'package:gsheet_to_arb/gsheet_to_arb.dart';

import 'package:gsheet_to_arb/src/translation_document.dart';

import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';

class _SheetColumns {
  static int key = 0;
  static int description = 1;
  static int first_language_key = 2;
}

class _SheetRows {
  static int header_row = 0;
  static int first_translation_row = 1;
}

class GSheetImporter {
  final AuthConfig auth;
  final String categoryPrefix;

  GSheetImporter({this.auth, this.categoryPrefix});

  Future<TranslationsDocument> import(String documentId) async {
    var authClient = await _getAuthClient(auth);
    var sheetsApi = SheetsApi(authClient);
    var spreadsheet =
        await sheetsApi.spreadsheets.get(documentId, includeGridData: true);
    final document = _importFrom(spreadsheet);
    authClient.close();
    return document;
  }

  Future<AuthClient> _getAuthClient(AuthConfig auth) async {
    final scopes = [SheetsApi.SpreadsheetsReadonlyScope];
    var authClient;
    if (auth.oauthClientId != null) {
      void clientAuthPrompt(String url) {
        Log.i(
            'Please go to the following URL and grant Google Spreadsheet access:\n\t=> $url\n');
      }

      final client = auth.oauthClientId;
      var id = ClientId(client.clientId, client.clientSecret);
      authClient = await clientViaUserConsent(id, scopes, clientAuthPrompt);
    } else if (auth.serviceAccountKey != null) {
      final service = auth.serviceAccountKey;
      var credentials = ServiceAccountCredentials(service.clientEmail,
          ClientId(service.clientId, null), service.privateKey);
      authClient = await clientViaServiceAccount(credentials, scopes);
    }
    return authClient;
  }

  Future<TranslationsDocument> _importFrom(Spreadsheet spreadsheet) async {
    Log.i('Opening ${spreadsheet.spreadsheetUrl}');

    var sheet = spreadsheet.sheets[0];
    var rows = sheet.data[0].rowData;
    var header = rows[0];
    var headerValues = header.values;

    final languages = List<String>();

    for (var column = _SheetRows.first_translation_row;
        column < headerValues.length;
        column++) {
      final language = headerValues[column].formattedValue;
      languages.add(language);
    }

    return TranslationsDocument(
        languages: languages, //
        items: null // TODO
        );
  }
}

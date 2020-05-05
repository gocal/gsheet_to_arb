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
    Log.i('Importing ARB from Google sheet...');
    var authClient = await _getAuthClient(auth);
    Log.startTimeTracking();
    var sheetsApi = SheetsApi(authClient);
    var spreadsheet =
        await sheetsApi.spreadsheets.get(documentId, includeGridData: true);
    final document = await _importFrom(spreadsheet);
    authClient.close();

    Log.i('Loaded document ${document.describe()}');
    Log.i(
        'Importing ARB from Google sheet completed, took ${Log.stopTimeTracking()}');

    return document;
  }

  Future<AuthClient> _getAuthClient(AuthConfig auth) async {
    final scopes = [SheetsApi.SpreadsheetsReadonlyScope];
    var authClient;
    if (auth.oauthClientId != null) {
      void clientAuthPrompt(String url) {
        Log.i(
            'Please go to the following URL and grant Google Spreadsheet access:\n$url\n');
      }

      final client = auth.oauthClientId;

      if (client.clientId == null || client.clientSecret == null) {
        throw Exception('Auth client config is invalid');
      }

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
    final sheet = spreadsheet.sheets[0];
    final rows = sheet.data[0].rowData;
    final header = rows[0];
    final headerValues = header.values;

    final languages = <String>[];
    final items = <TranslationRow>[];

    var firstLanguageColumn = _SheetColumns.first_language_key;
    var firstTranslationsRow = _SheetRows.first_translation_row;

    var currentCategory = '';

    for (var column = firstLanguageColumn;
        column < headerValues.length;
        column++) {
      //Stop parsing on first empty language code
      if(headerValues[column].formattedValue == null) {
        break;
      }
      final language = headerValues[column].formattedValue;
      languages.add(language);
    }

    // rows
    for (var i = firstTranslationsRow; i < rows.length; i++) {
      var row = rows[i];
      var languages = row.values;

      //Skip empty rows
      if(languages == null) {
        continue;
      }

      var key = languages[_SheetColumns.key].formattedValue;

      //Skip rows with missing key value
      if(key == null) {
        continue;
      }

      if (key.startsWith(categoryPrefix)) {
        currentCategory = key.substring(categoryPrefix.length);
        continue;
      }

      final description =
          languages[_SheetColumns.description].formattedValue ?? '';

      final values = row.values
          .sublist(firstLanguageColumn, row.values.length)
          .map((data) => data.formattedValue ?? '')
          .toList();

      final item = TranslationRow(
          key: key,
          category: currentCategory,
          description: description,
          values: values);

      items.add(item);
    }

    final document = TranslationsDocument(
        lastModified: DateTime.now(),
        languages: languages, //
        items: items);
    return document;
  }
}

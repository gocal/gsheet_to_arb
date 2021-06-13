import 'package:gsheet_to_arb/gsheet_to_arb.dart';

import 'package:gsheet_to_arb/src/translation_document.dart';

import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';

class GSheetImporter {
  final GoogleSheetConfig config;

  GSheetImporter({required this.config});

  Future<TranslationsDocument> import(String documentId) async {
    Log.i('Importing ARB from Google sheet...');
    var authClient = await _getAuthClient(config.auth!);
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
    final scopes = [SheetsApi.spreadsheetsReadonlyScope];
    var authClient;
    final service = auth.serviceAccountKey;

    if (auth.oauthClientId != null) {
      void clientAuthPrompt(String url) {
        Log.i(
            'Please go to the following URL and grant Google Spreadsheet access:\n$url\n');
      }

      final client = auth.oauthClientId;
      final clientId = client?.clientId;
      final clientSecret = client?.clientSecret;

      if (clientId == null || clientSecret == null) {
        throw Exception('Auth client config is invalid');
      }

      var id = ClientId(clientId, clientSecret);
      authClient = await clientViaUserConsent(id, scopes, clientAuthPrompt);
    } else if (service != null) {
      var credentials = ServiceAccountCredentials(service.clientEmail,
          ClientId(service.clientId, null), service.privateKey);
      authClient = await clientViaServiceAccount(credentials, scopes);
    }
    return authClient;
  }

  Future<TranslationsDocument> _importFrom(Spreadsheet spreadsheet) async {
    final sheet = spreadsheet.sheets?[0];
    final rows = sheet?.data?[0].rowData;
    final header = rows?[0];
    final headerValues = header?.values;

    final languages = <String>[];
    final items = <TranslationRow>[];

    var firstLanguageColumn = config.sheetColumns.first_language_key;
    var firstTranslationsRow = config.sheetRows.first_translation_row;

    var currentCategory = '';

    for (var column = firstLanguageColumn;
        column < (headerValues?.length ?? 0);
        column++) {
      //Stop parsing on first empty language code
      final formattedValue = headerValues?[column].formattedValue;
      if (formattedValue == null) {
        break;
      }
      languages.add(formattedValue);
    }

    // rows
    for (var i = firstTranslationsRow; i < (rows?.length ?? 0); i++) {
      final row = rows?[i];
      final languages = row?.values;

      //Skip empty rows
      if (languages == null) {
        continue;
      }

      var key = languages[config.sheetColumns.key].formattedValue;

      //Skip rows with missing key value
      if (key == null) {
        continue;
      }

      if (key.startsWith(config.categoryPrefix)) {
        currentCategory = key.substring(config.categoryPrefix.length);
        continue;
      }

      final description =
          languages[config.sheetColumns.description].formattedValue ?? '';

      final values = languages
          .sublist(firstLanguageColumn, row?.values?.length)
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

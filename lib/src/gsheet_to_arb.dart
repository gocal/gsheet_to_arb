import '../gsheet_to_arb.dart';
import 'arb/arb_serializer.dart';
import 'arb/intl_translation_helper.dart';
import 'gsheet/sheet_parser.dart';

class GSheetToArb {
  final GsheetToArbConfig config;

  final _arbSerializer = ArbSerializer();

  GSheetToArb({this.config});

  void build({bool generateDartCode = false}) async {
    Log.i('build');

    final gsheet = config.gsheet;
    final auth = gsheet.auth;
    final documentId = gsheet.documentId;

    final sheetParser =
        SheetParser(auth: auth, categoryPrefix: gsheet.categoryPrefix);

    // Parse ARB
    final arbBundle = await sheetParser.parseSheet(documentId);

    // Save ARB
    _arbSerializer.saveArbBundle(arbBundle, config.outputDirectoryPath);

    if (generateDartCode) {
      /*
    final document = _arbSerializer
        .loadArbDocument('${config.outputDirectoryPath}/intl_en.arb');
    final localizationFileName = config.localizationFileName;
    final generator = TranslationsGenerator();
    generator.buildTranslations(
        document, config.outputDirectoryPath, localizationFileName);

    final helper = IntlTranslationHelper();
    helper.generateDartClasses(
        config.outputDirectoryPath, config.localizationFileName);
      */
    }
  }
}

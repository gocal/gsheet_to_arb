import 'package:gsheet_to_arb/src/parser/translation_parser.dart';
import 'package:gsheet_to_arb/src/utils/log.dart';

import 'arb/arb_serializer.dart';
import 'config/plugin_config.dart';
import 'gsheet/ghseet_importer.dart';

class GSheetToArb {
  final GsheetToArbConfig config;

  final _arbSerializer = ArbSerializer();

  GSheetToArb({this.config});

  void build({bool generateDartCode = false}) async {
    Log.i('build');

    final gsheet = config.gsheet;
    final auth = gsheet.auth;
    final documentId = gsheet.documentId;

    //
    final importer =
        GSheetImporter(auth: auth, categoryPrefix: gsheet.categoryPrefix);
    final document = await importer.import(documentId);

    // Parse ARB
    final sheetParser = SheetParser();
    final arbBundle = await sheetParser.parseDocument(document);

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

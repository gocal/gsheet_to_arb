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
    Log.i('importing gsheet from arb');

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

    if (generateDartCode || true) {
      /*
      final document = _arbSerializer.loadArbDocument('${config.outputDirectoryPath}/intl_all_messages.arb');
      final localizationFileName = config.localizationFileName;
 
      final generator = ArbToDartGenerator();
      generator.buildTranslations(
          document, config.outputDirectoryPath, localizationFileName);
          */

      //final helper = IntlTranslationGenerator();
      //helper.generateDartClasses(config.outputDirectoryPath);
    }
  }
}

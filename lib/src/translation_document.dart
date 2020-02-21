class TranslationsDocument {
  final List<String> languages;
  final List<TranslationRow> items;

  TranslationsDocument({this.languages, this.items});
}

class TranslationRow {
  final String key;
  final String description;
  final String category;
  final List<String> values;

  TranslationRow({this.key, this.description, this.category, this.values});
}

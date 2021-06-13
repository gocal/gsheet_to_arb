class TranslationsDocument {
  final DateTime lastModified;
  final List<String> languages;
  final List<TranslationRow> items;

  TranslationsDocument(
      {required this.lastModified,
      required this.languages,
      required this.items});

  String describe() =>
      '[ lastModified:$lastModified languages: ${languages.join(', ')}} items:${items.length} ]';
}

class TranslationRow {
  final String key;
  final String description;
  final String category;
  final List<String> values;

  TranslationRow(
      {required this.key,
      required this.description,
      required this.category,
      required this.values});
}

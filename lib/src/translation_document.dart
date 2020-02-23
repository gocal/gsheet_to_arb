class TranslationsDocument {
  final DateTime lastModified;
  final List<String> languages;
  final List<TranslationRow> items;

  TranslationsDocument({this.lastModified, this.languages, this.items});

  String describe() =>
      '[ lastModified:$lastModified languages: ${languages.join(', ')}} items:${items.length} ]';
}

class TranslationRow {
  final String key;
  final String description;
  final String category;
  final List<String> values;

  TranslationRow({this.key, this.description, this.category, this.values});
}

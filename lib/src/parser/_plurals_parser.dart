import 'package:gsheet_to_arb/src/arb/arb.dart';

///
/// Plurals
///
enum PluralCase { zero, one, two, few, many, other }

abstract class PluralsStatus {}

class Skip extends PluralsStatus {}

class Consumed extends PluralsStatus {}

class Completed extends PluralsStatus {
  final ArbResource resource;
  final bool consumed;

  Completed(this.resource, {this.consumed = false});
}

class PluralsParser {
  final _pluralSeparator = '=';

  final _pluralKeywords = {
    'zero': PluralCase.zero,
    'one': PluralCase.one,
    'two': PluralCase.two,
    'few': PluralCase.few,
    'many': PluralCase.many,
    'other': PluralCase.other
  };

  String _key;
  ArbResource _resource;
  final _placeholders = <String, ArbResourcePlaceholder>{};
  final _values = <PluralCase, String>{};

  PluralsStatus consume(ArbResource resource) {
    final pluralCase = _getCase(resource.key);

    // normal item
    if (pluralCase == null) {
      if (_values.isNotEmpty) {
        final status = _getCompleted();
        _key = null;
        _resource = null;
        _placeholders.clear();
        _values.clear();
        return status;
      } else {
        _key = null;
        _resource = null;
        _placeholders.clear();
        return Skip();
      }
    }

    // plural item
    final caseKey = _getCaseKey(resource.key);

    if (_key == caseKey) {
      // same plural - another entry
      _values[pluralCase] = resource.value;
      return Consumed();
    } else if (_key == null) {
      // first plural
      _key = caseKey;
      _resource = resource;
      _placeholders[_countPlaceholder] = ArbResourcePlaceholder(
          name: _countPlaceholder, description: 'plural count', type: 'num');
      addPlaceholders(resource.placeholders);
      _values[pluralCase] = resource.value;
      return Consumed();
    } else {
      // another plural
      PluralsStatus status;
      if (_values.isNotEmpty) {
        status = _getCompleted(consumed: true);
      } else {
        status = Consumed();
      }

      _key = caseKey;
      _resource = resource;
      _placeholders.clear();
      _values.clear();
      _values[pluralCase] = resource.value;

      return status;
    }
  }

  PluralsStatus complete() {
    if (_values.isNotEmpty) {
      return _getCompleted();
    }

    return Skip();
  }

  PluralCase _getCase(String key) {
    if (key.contains(_pluralSeparator)) {
      for (var plural in _pluralKeywords.keys) {
        if (key.endsWith('$_pluralSeparator$plural')) {
          return _pluralKeywords[plural];
        }
      }
    }
    return null;
  }

  String _getCaseKey(String key) {
    return key.substring(0, key.lastIndexOf(_pluralSeparator));
  }

  Completed _getCompleted({bool consumed = false}) {
    return Completed(
        ArbResource(_key, PluralsFormatter.format(Map.from(_values)),
            placeholders: _placeholders.values.toList(),
            context: _resource.context,
            description: _resource.description),
        consumed: consumed);
  }

  void addPlaceholders(List<ArbResourcePlaceholder> placeholders) {
    for (var placeholder in placeholders) {
      if (!_placeholders.containsKey(placeholder.name)) {
        _placeholders[placeholder.name] = placeholder;
      }
    }
  }
}

final String _countPlaceholder = 'count';

class PluralsFormatter {
  static final _icuPluralFormats = {
    PluralCase.zero: '=0',
    PluralCase.one: '=1',
    PluralCase.two: '=2',
    PluralCase.few: 'few',
    PluralCase.many: 'many',
    PluralCase.other: 'other'
  };

  static String format(Map<PluralCase, String> plural) {
    final builder = StringBuffer();
    builder.write('{$_countPlaceholder, plural,');
    plural.forEach((key, value) {
      if (value != null && value.isNotEmpty) {
        builder.write(' ${_icuPluralFormats[key]} {$value}');
      }
    });
    builder.write('}');
    return builder.toString();
  }
}

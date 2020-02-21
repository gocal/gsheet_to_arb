import 'package:gsheet_to_arb/src/arb/arb.dart';

///
/// Plurals
///
enum PluralCase { zero, one, two, few, many, other }

abstract class PluralsStatus {}

class Skip extends PluralsStatus {}

class Consumed extends PluralsStatus {}

class Completed extends PluralsStatus {
  final String key;
  final ArbResource attributes;
  final Map<PluralCase, String> values;
  final bool consumed;

  Completed({this.key, this.attributes, this.values, this.consumed = false});
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
  ArbResource _attributes;
  final _values = <PluralCase, String>{};

  PluralsStatus consume({String key, ArbResource attributes, String value}) {
    final pluralCase = _getCase(key);

    // normal item
    if (pluralCase == null) {
      if (_values.isNotEmpty) {
        final status = Completed(
            attributes: attributes,
            consumed: false,
            key: _key,
            values: Map.from(_values));
        _key = null;
        _attributes = null;
        _values.clear();
        return status;
      } else {
        _key = null;
        _attributes = null;
        return Skip();
      }
    }

    // plural item
    final caseKey = _getCaseKey(key);

    if (_key == caseKey) {
      // same plural
      _values[pluralCase] = value;
      return Consumed();
    } else if (_key == null) {
      // first plural
      _key = caseKey;
      _attributes = attributes;
      _values[pluralCase] = value;
      return Consumed();
    } else {
      // another plural
      PluralsStatus status;
      if (_values.isNotEmpty) {
        status = Completed(
            attributes: _attributes,
            consumed: true,
            key: _key,
            values: Map.from(_values));
      } else {
        status = Consumed();
      }
      _key = caseKey;
      _attributes = attributes;
      _values.clear();
      _values[pluralCase] = value;
      return status;
    }
  }

  PluralsStatus complete() {
    if (_values.isNotEmpty) {
      return Completed(key: _key, attributes: _attributes, values: _values);
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
}

class PluralsFormatter {
  static final String _countConst = 'count';

  static final _icuPluralFormats = {
    PluralCase.zero: '=zero',
    PluralCase.one: '=one',
    PluralCase.two: '=two',
    PluralCase.few: 'few',
    PluralCase.many: 'many',
    PluralCase.other: 'other'
  };

  static String format(Map<PluralCase, String> plural) {
    final builder = StringBuffer();
    builder.write('{$_countConst, plural,');
    plural.forEach((key, value) {
      if (value != null) {
        builder.write(
            ' ${_icuPluralFormats[key]} {${value.replaceAll("\{#\}", "\{$_countConst\}")}}');
      }
    });
    builder.write('}');
    return builder.toString();
  }
}

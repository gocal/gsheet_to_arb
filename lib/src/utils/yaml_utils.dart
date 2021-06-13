import 'package:yaml/yaml.dart';
import 'dart:convert';
import 'dart:io';

class YamlUtils {
  static String toYamlString(Map<String, dynamic> json) {
    final map = jsonDecode(jsonEncode(json));
    final yaml = _toYamlString(map);
    return yaml;
  }

  static Map<String, dynamic> load(String filePath) {
    var yaml = _loadYamlFile(filePath);
    var map = jsonDecode(jsonEncode(yaml));
    return map;
  }

  static YamlMap _loadYamlFile(String path) {
    final yamlFile = File(path);
    final yamlContent = yamlFile.readAsStringSync();
    final yaml = loadYaml(yamlContent);
    return yaml;
  }
}

// Copyright (c) 2015, Anders Holmgren. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Serializes [node] into a String and returns it.
String _toYamlString(node) {
  var sb = StringBuffer();
  writeYamlString(node, sb);
  return sb.toString();
}

/// Serializes [node] into a String and writes it to the [sink].
void writeYamlString(dynamic node, StringSink sink) {
  _writeYamlString(node, 0, sink, true);
}

void _writeYamlString(
    dynamic node, int indent, StringSink ss, bool isTopLevel) {
  if (node is Map) {
    _mapToYamlString(node, indent, ss, isTopLevel);
  } else if (node is Iterable) {
    _listToYamlString(node, indent, ss, isTopLevel);
  } else if (node is String) {
    ss.writeln('"${_escapeString(node)}"');
  } else if (node is double) {
    ss.writeln('!!float $node');
  } else {
    ss.writeln(node);
  }
}

String _escapeString(String s) =>
    s.replaceAll('"', r'\"').replaceAll('\n', r'\n');

void _mapToYamlString(Map node, int indent, StringSink ss, bool isTopLevel) {
  if (!isTopLevel) {
    ss.writeln();
    indent += 2;
  }

  if (node is Map<String, dynamic>) {
    final keys = _sortKeys(node);

    keys.forEach((k) {
      final v = node[k];
      _writeIndent(indent, ss);
      ss..write(k)..write(': ');
      _writeYamlString(v, indent, ss, false);
    });
  }
}

Iterable<String> _sortKeys(Map<String, dynamic> m) {
  final simple = <String>[];
  final maps = <String>[];
  final other = <String>[];

  m.forEach((k, v) {
    if (v is String) {
      simple.add(k);
    } else if (v is Map) {
      maps.add(k);
    } else {
      other.add(k);
    }
  });

  final keys = concat([simple..sort(), maps..sort(), other..sort()]);
  return keys;
}

void _listToYamlString(
    Iterable node, int indent, StringSink ss, bool isTopLevel) {
  if (!isTopLevel) {
    ss.writeln();
    indent += 2;
  }

  node.forEach((v) {
    _writeIndent(indent, ss);
    ss.write('- ');
    _writeYamlString(v, indent, ss, false);
  });
}

Iterable<T> concat<T>(Iterable<Iterable<T>> iterables) =>
    iterables.expand<T>((x) => x);

void _writeIndent(int indent, StringSink ss) => ss.write(' ' * indent);

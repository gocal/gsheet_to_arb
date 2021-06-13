/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:io';

import 'package:file_utils/file_utils.dart';

class FileUtils {
  static bool exists(String filePath) {
    final expandedFilePath = FilePath.expand(filePath);
    final file = File(expandedFilePath);
    return file.existsSync();
  }

  static String getContent(String filePath) {
    final expandedFilePath = FilePath.expand(filePath);
    final file = File(expandedFilePath);
    assert(file.existsSync(), "filePath $filePath doesn't exist");
    final content = file.readAsStringSync();
    return content;
  }

  static void storeContent(String filePath, String content) {
    final expandedFilePath = FilePath.expand(filePath);
    final file = File(expandedFilePath);
    if (!file.existsSync()) {
      file.createSync();
    }
    file.writeAsStringSync(content);
  }

  static void append(String filePath, String content) {
    final expandedFilePath = FilePath.expand(filePath);
    final file = File(expandedFilePath);
    assert(file.existsSync(), "filePath $filePath doesn't exist");
    file.writeAsString(content, mode: FileMode.append);
  }
}

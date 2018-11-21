/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:io';

import 'package:file_utils/file_utils.dart';

class FileUtils {
  static String getFileContentSync(String filePath) {
    var expandedFilePath = FilePath.expand(filePath);
    var file = File(expandedFilePath);
    assert(file.existsSync(), "filePath ${filePath} doesn't exist");
    var content = file.readAsStringSync();
    return content;
  }
}

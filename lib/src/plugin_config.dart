/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

class PluginConfig {
  var configFilePath = "gsheet_to_arb.yaml";
  var outputDirectoryPath = "build";
  var arbFilePrefix = "intl";

  String clientId;
  String clientSecret;
  String documentId;

  PluginConfig();
}

/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'package:json_annotation/json_annotation.dart';

part 'plugin_config.g.dart';

///
/// PluginConfig
///
@JsonSerializable()
class PluginConfigRoot {

  @JsonKey(name: 'gsheet_to_arb', nullable: false)
  PluginConfig config;

  PluginConfigRoot(this.config);

  factory PluginConfigRoot.fromJson(Map<String, dynamic> json) =>
      _$PluginConfigRootFromJson(json);

  Map<String, dynamic> toJson() => _$PluginConfigRootToJson(this);
}

///
/// PluginConfig
///
@JsonSerializable()
class PluginConfig {
  var outputDirectoryPath = "lib/src/i18n";
  var arbFilePrefix = "intl";

  @JsonKey(name: 'gsheet', nullable: false)
  GoogleSheetConfig sheetConfig;

  PluginConfig(this.outputDirectoryPath, this.arbFilePrefix, this.sheetConfig);

  factory PluginConfig.fromJson(Map<String, dynamic> json) =>
      _$PluginConfigFromJson(json);

  Map<String, dynamic> toJson() => _$PluginConfigToJson(this);
}

///
/// PluginConfig
///
@JsonSerializable()
class GoogleSheetConfig {

  @JsonKey(name: 'secret_auth', nullable: true)
  SecretAuth secretAuth;

  @JsonKey(name: 'key_auth', nullable: true)
  KeyAuth keyAuth;

  @JsonKey(name: 'document_id')
  String documentId;

  @JsonKey(name: 'sheetId', defaultValue: "0")
  String sheetId;

  GoogleSheetConfig(this.secretAuth, this.keyAuth, this.documentId,
      this.sheetId);

  factory GoogleSheetConfig.fromJson(Map<String, dynamic> json) =>
      _$GoogleSheetConfigFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleSheetConfigToJson(this);
}

///
/// PluginConfig
///
@JsonSerializable()
class SecretAuth {
  @JsonKey(name: 'client_id', nullable: false)
  String clientId;

  @JsonKey(name: 'client_secret', nullable: false)
  String clientSecret;

  SecretAuth(this.clientId, this.clientSecret);

  factory SecretAuth.fromJson(Map<String, dynamic> json) =>
      _$SecretAuthFromJson(json);

  Map<String, dynamic> toJson() => _$SecretAuthToJson(this);
}

///
/// PluginConfig
///
@JsonSerializable()
class KeyAuth {

  @JsonKey(name: 'client_id')
  String clientId;

  @JsonKey(name: 'sheet_id')
  String clientSecret;


  KeyAuth(this.clientId, this.clientSecret);

  factory KeyAuth.fromJson(Map<String, dynamic> json) =>
      _$KeyAuthFromJson(json);

  Map<String, dynamic> toJson() => _$KeyAuthToJson(this);
}

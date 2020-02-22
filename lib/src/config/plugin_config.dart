/*
 * Copyright (c) 2020, Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'plugin_config.g.dart';

///
/// PluginConfigRoot
///
@JsonSerializable()
class PluginConfigRoot {
  @JsonKey(name: 'gsheet_to_arb')
  GsheetToArbConfig content;

  PluginConfigRoot(this.content);

  factory PluginConfigRoot.fromJson(Map<String, dynamic> json) =>
      _$PluginConfigRootFromJson(json);

  Map<String, dynamic> toJson() => _$PluginConfigRootToJson(this);
}

///
/// GsheetToArbConfig
///
@JsonSerializable()
class GsheetToArbConfig {
  @JsonKey(name: 'output_directory')
  String outputDirectoryPath;

  @JsonKey(name: 'arb_file_prefix')
  String arbFilePrefix;

  @JsonKey(name: 'localization_file_name')
  String localizationFileName;

  @JsonKey(name: 'generate_code')
  bool generateCode;

  @JsonKey(name: 'gsheet')
  GoogleSheetConfig gsheet;

  GsheetToArbConfig(
      {this.outputDirectoryPath,
      this.arbFilePrefix,
      this.gsheet,
      this.localizationFileName,
      this.generateCode});

  factory GsheetToArbConfig.fromJson(Map<String, dynamic> json) =>
      _$GsheetToArbConfigFromJson(json);

  Map<String, dynamic> toJson() => _$GsheetToArbConfigToJson(this);
}

///
/// PluginConfig
///
@JsonSerializable()
class GoogleSheetConfig {
  @JsonKey(name: 'document_id')
  String documentId;

  @JsonKey(name: 'sheet_id')
  String sheetId;

  @JsonKey(name: 'category_prefix')
  String categoryPrefix;

  @JsonKey(name: 'auth_file')
  String authFile;

  @JsonKey(ignore: true)
  AuthConfig auth;

  GoogleSheetConfig(
      {this.authFile, this.documentId, this.sheetId, this.categoryPrefix});

  factory GoogleSheetConfig.fromJson(Map<String, dynamic> json) =>
      _$GoogleSheetConfigFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleSheetConfigToJson(this);
}

///
/// Auth config
///
@JsonSerializable()
class AuthConfig {
  @JsonKey(name: 'oauth_client_id')
  OAuthClientId oauthClientId;

  @JsonKey(name: 'service_account_key')
  ServiceAccountKey serviceAccountKey;

  AuthConfig({this.oauthClientId, this.serviceAccountKey});

  factory AuthConfig.fromJson(Map<String, dynamic> json) =>
      _$AuthConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AuthConfigToJson(this);
}

///
/// OAuthClientId
///
@JsonSerializable()
class OAuthClientId {
  @JsonKey(name: 'client_id')
  String clientId;

  @JsonKey(name: 'client_secret')
  String clientSecret;

  OAuthClientId({@required this.clientId, @required this.clientSecret});

  factory OAuthClientId.fromJson(Map<String, dynamic> json) =>
      _$OAuthClientIdFromJson(json);

  Map<String, dynamic> toJson() => _$OAuthClientIdToJson(this);
}

///
/// ServiceAccountKey
///
@JsonSerializable()
class ServiceAccountKey {
  @JsonKey(name: 'client_id', nullable: false)
  String clientId;

  @JsonKey(name: 'client_email', nullable: false)
  String clientEmail;

  @JsonKey(name: 'private_key', nullable: false)
  String privateKey;

  ServiceAccountKey({
    @required this.clientId,
    @required this.clientEmail,
    @required this.privateKey,
  });

  factory ServiceAccountKey.fromJson(Map<String, dynamic> json) =>
      _$ServiceAccountKeyFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceAccountKeyToJson(this);
}

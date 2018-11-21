/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'package:json_annotation/json_annotation.dart';

part 'plugin_config.g.dart';

///
/// PluginConfigRoot
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
  @JsonKey(name: 'output_directory', defaultValue: "lib/src/i18n")
  String outputDirectoryPath;

  @JsonKey(name: 'arb_file_prefix', defaultValue: "intl")
  String arbFilePrefix;

  @JsonKey(name: 'localization_file_name', defaultValue: "S")
  String localizationFileName;

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
  @JsonKey(name: 'auth')
  Auth auth;

  @JsonKey(name: 'document_id')
  String documentId;

  @JsonKey(name: 'sheet_id', defaultValue: "0")
  String sheetId;

  GoogleSheetConfig(this.auth, this.documentId, this.sheetId);

  factory GoogleSheetConfig.fromJson(Map<String, dynamic> json) =>
      _$GoogleSheetConfigFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleSheetConfigToJson(this);
}

@JsonSerializable()
class Auth {
  @JsonKey(name: 'oauth_client_id', nullable: true)
  OAuthClientId oauthClientId;

  @JsonKey(name: 'oauth_client_id_path', nullable: true)
  String oauthClientIdPath;

  @JsonKey(name: 'service_account_key', nullable: true)
  ServiceAccountKey serviceAccountKey;

  @JsonKey(name: 'service_account_key_path', nullable: true)
  String serviceAccountKeyPath;

  Auth(this.oauthClientId, this.oauthClientIdPath, this.serviceAccountKey,
      this.serviceAccountKeyPath);

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  Map<String, dynamic> toJson() => _$AuthToJson(this);
}

///
/// OAuthClientId
///
@JsonSerializable()
class OAuthClientId {

  @JsonKey(name: 'clientId', nullable: false)
  String clientId;

  @JsonKey(name: 'clientSecret', nullable: false)
  String clientSecret;

  OAuthClientId(this.clientId, this.clientSecret);

  factory OAuthClientId.fromJson(Map<String, dynamic> json) =>
      _$OAuthClientIdFromJson(json);

  Map<String, dynamic> toJson() => _$OAuthClientIdToJson(this);
}

///
/// ServiceAccountKey
///
@JsonSerializable()
class ServiceAccountKey {
  @JsonKey(name: 'type', nullable: false)
  String type;

  @JsonKey(name: 'project_id', nullable: false)
  String projectId;

  @JsonKey(name: 'private_key_id', nullable: false)
  String privateKeyId;

  @JsonKey(name: 'private_key', nullable: false)
  String privateKey;

  @JsonKey(name: 'client_email', nullable: false)
  String clientEmail;

  @JsonKey(name: 'client_id', nullable: false)
  String clientId;

  @JsonKey(name: 'auth_uri', nullable: false)
  String authUri;

  @JsonKey(name: 'token_uri', nullable: false)
  String tokenUri;

  @JsonKey(name: 'auth_provider_x509_cert_url', nullable: false)
  String authProviderX509CertUrl;

  @JsonKey(name: 'client_x509_cert_url', nullable: false)
  String clientX509CertUrl;

  ServiceAccountKey(this.type, this.projectId, this.privateKeyId,
      this.privateKey, this.clientEmail, this.clientId, this.authUri,
      this.tokenUri, this.authProviderX509CertUrl, this.clientX509CertUrl);

  factory ServiceAccountKey.fromJson(Map<String, dynamic> json) =>
      _$ServiceAccountKeyFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceAccountKeyToJson(this);
}

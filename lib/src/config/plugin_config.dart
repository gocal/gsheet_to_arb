/*
 * Copyright (c) 2020, Marek Gocał
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
  @JsonKey(name: 'gsheet_to_arb')
  GsheetToArbConfig? content;

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
  bool? generateCode;

  @JsonKey(name: 'add_context_prefix')
  bool addContextPrefix;

  @JsonKey(name: 'caseType')
  String? caseType;

  @JsonKey(name: 'gsheet')
  GoogleSheetConfig gsheet;

  GsheetToArbConfig(
      {required this.outputDirectoryPath,
      required this.arbFilePrefix,
      required this.gsheet,
      required this.localizationFileName,
      required this.generateCode,
      required this.addContextPrefix,
      this.caseType});

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

  @JsonKey(name: 'columns', fromJson: SheetColumns.generateFromJson)
  SheetColumns sheetColumns;

  @JsonKey(name: 'rows', fromJson: SheetRows.generateFromJson)
  SheetRows sheetRows;

  @JsonKey(ignore: true)
  AuthConfig? auth;

  GoogleSheetConfig({
    required this.authFile,
    required this.documentId,
    required this.sheetId,
    required this.categoryPrefix,
    required this.sheetColumns,
    required this.sheetRows,
  });

  factory GoogleSheetConfig.fromJson(Map<String, dynamic> json) =>
      _$GoogleSheetConfigFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleSheetConfigToJson(this);
}

class DefaultSheetColumns {
  static const int key = 0;
  static const int description = 1;
  static const int first_language_key = 2;
}

@JsonSerializable()
class SheetColumns {
  @JsonKey(name: 'key', defaultValue: DefaultSheetColumns.key)
  final int key;

  @JsonKey(name: 'description', defaultValue: DefaultSheetColumns.description)
  final int description;

  @JsonKey(
      name: 'first_language_key',
      defaultValue: DefaultSheetColumns.first_language_key)
  final int first_language_key;

  SheetColumns({
    this.key = DefaultSheetColumns.key,
    this.description = DefaultSheetColumns.description,
    this.first_language_key = DefaultSheetColumns.first_language_key,
  });

  static SheetColumns generateFromJson(json) {
    if (json == null) {
      return SheetColumns();
    }
    return SheetColumns.fromJson(Map<String, dynamic>.from(json));
  }

  factory SheetColumns.fromJson(Map<String, dynamic> json) {
    return _$SheetColumnsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SheetColumnsToJson(this);
}

class DefaultSheetRows {
  static const int header_row = 0;
  static const int first_translation_row = 1;
}

@JsonSerializable()
class SheetRows {
  @JsonKey(name: 'header_row', defaultValue: DefaultSheetRows.header_row)
  final int header_row;

  @JsonKey(
      name: 'first_translation_row',
      defaultValue: DefaultSheetRows.first_translation_row)
  final int first_translation_row;

  SheetRows({
    this.header_row = DefaultSheetRows.header_row,
    this.first_translation_row = DefaultSheetRows.first_translation_row,
  });

  static SheetRows generateFromJson(json) {
    if (json == null) {
      return SheetRows();
    }
    return SheetRows.fromJson(Map<String, dynamic>.from(json));
  }

  factory SheetRows.fromJson(Map<String, dynamic> json) =>
      _$SheetRowsFromJson(json);

  Map<String, dynamic> toJson() => _$SheetRowsToJson(this);
}

///
/// Auth config
///
@JsonSerializable()
class AuthConfig {
  @JsonKey(name: 'oauth_client_id')
  OAuthClientId? oauthClientId;

  @JsonKey(name: 'service_account_key')
  ServiceAccountKey? serviceAccountKey;

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
  String? clientId;

  @JsonKey(name: 'client_secret')
  String? clientSecret;

  OAuthClientId({this.clientId, this.clientSecret});

  factory OAuthClientId.fromJson(Map<String, dynamic> json) =>
      _$OAuthClientIdFromJson(json);

  Map<String, dynamic> toJson() => _$OAuthClientIdToJson(this);
}

///
/// ServiceAccountKey
///
@JsonSerializable()
class ServiceAccountKey {
  @JsonKey(name: 'client_id')
  String clientId;

  @JsonKey(name: 'client_email')
  String clientEmail;

  @JsonKey(name: 'private_key')
  String privateKey;

  ServiceAccountKey({
    required this.clientId,
    required this.clientEmail,
    required this.privateKey,
  });

  factory ServiceAccountKey.fromJson(Map<String, dynamic> json) =>
      _$ServiceAccountKeyFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceAccountKeyToJson(this);
}

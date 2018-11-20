/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PluginConfigRoot _$PluginConfigRootFromJson(Map<String, dynamic> json) {
  return PluginConfigRoot(
      PluginConfig.fromJson(json['gsheet_to_arb'] as Map<String, dynamic>));
}

Map<String, dynamic> _$PluginConfigRootToJson(PluginConfigRoot instance) =>
    <String, dynamic>{'gsheet_to_arb': instance.config};

PluginConfig _$PluginConfigFromJson(Map<String, dynamic> json) {
  return PluginConfig(
      json['outputDirectoryPath'] as String,
      json['arbFilePrefix'] as String,
      GoogleSheetConfig.fromJson(json['gsheet'] as Map<String, dynamic>));
}

Map<String, dynamic> _$PluginConfigToJson(PluginConfig instance) =>
    <String, dynamic>{
      'outputDirectoryPath': instance.outputDirectoryPath,
      'arbFilePrefix': instance.arbFilePrefix,
      'gsheet': instance.sheetConfig
    };

GoogleSheetConfig _$GoogleSheetConfigFromJson(Map<String, dynamic> json) {
  return GoogleSheetConfig(
      json['secret_auth'] == null
          ? null
          : SecretAuth.fromJson(json['secret_auth'] as Map<String, dynamic>),
      json['key_auth'] == null
          ? null
          : KeyAuth.fromJson(json['key_auth'] as Map<String, dynamic>),
      json['document_id'] as String,
      json['sheetId'] as String ?? '0');
}

Map<String, dynamic> _$GoogleSheetConfigToJson(GoogleSheetConfig instance) =>
    <String, dynamic>{
      'secret_auth': instance.secretAuth,
      'key_auth': instance.keyAuth,
      'document_id': instance.documentId,
      'sheetId': instance.sheetId
    };

SecretAuth _$SecretAuthFromJson(Map<String, dynamic> json) {
  return SecretAuth(
      json['client_id'] as String, json['client_secret'] as String);
}

Map<String, dynamic> _$SecretAuthToJson(SecretAuth instance) =>
    <String, dynamic>{
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret
    };

KeyAuth _$KeyAuthFromJson(Map<String, dynamic> json) {
  return KeyAuth(json['client_id'] as String, json['sheet_id'] as String);
}

Map<String, dynamic> _$KeyAuthToJson(KeyAuth instance) => <String, dynamic>{
      'client_id': instance.clientId,
      'sheet_id': instance.clientSecret
    };

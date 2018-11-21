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
      json['output_directory'] as String ?? 'lib/src/i18n',
      json['arb_file_prefix'] as String ?? 'intl',
      GoogleSheetConfig.fromJson(json['gsheet'] as Map<String, dynamic>))
    ..localizationFileName = json['localization_file_name'] as String ?? 'S';
}

Map<String, dynamic> _$PluginConfigToJson(PluginConfig instance) =>
    <String, dynamic>{
      'output_directory': instance.outputDirectoryPath,
      'arb_file_prefix': instance.arbFilePrefix,
      'localization_file_name': instance.localizationFileName,
      'gsheet': instance.sheetConfig
    };

GoogleSheetConfig _$GoogleSheetConfigFromJson(Map<String, dynamic> json) {
  return GoogleSheetConfig(
      json['auth'] == null
          ? null
          : Auth.fromJson(json['auth'] as Map<String, dynamic>),
      json['document_id'] as String,
      json['sheetId'] as String ?? '0');
}

Map<String, dynamic> _$GoogleSheetConfigToJson(GoogleSheetConfig instance) =>
    <String, dynamic>{
      'auth': instance.auth,
      'document_id': instance.documentId,
      'sheetId': instance.sheetId
    };

Auth _$AuthFromJson(Map<String, dynamic> json) {
  return Auth(
      json['oauth_client_id'] == null
          ? null
          : OAuthClientId.fromJson(
              json['oauth_client_id'] as Map<String, dynamic>),
      json['oauth_client_id_path'] as String,
      json['service_account_key'] == null
          ? null
          : ServiceAccountKey.fromJson(
              json['service_account_key'] as Map<String, dynamic>),
      json['service_account_key_path'] as String);
}

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
      'oauth_client_id': instance.oauthClientId,
      'oauth_client_id_path': instance.oauthClientIdPath,
      'service_account_key': instance.serviceAccountKey,
      'service_account_key_path': instance.serviceAccountKeyPath
    };

OAuthClientId _$OAuthClientIdFromJson(Map<String, dynamic> json) {
  return OAuthClientId(
      json['clientId'] as String, json['clientSecret'] as String);
}

Map<String, dynamic> _$OAuthClientIdToJson(OAuthClientId instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'clientSecret': instance.clientSecret
    };

ServiceAccountKey _$ServiceAccountKeyFromJson(Map<String, dynamic> json) {
  return ServiceAccountKey(
      json['type'] as String,
      json['project_id'] as String,
      json['private_key_id'] as String,
      json['private_key'] as String,
      json['client_email'] as String,
      json['client_id'] as String,
      json['auth_uri'] as String,
      json['token_uri'] as String,
      json['auth_provider_x509_cert_url'] as String,
      json['client_x509_cert_url'] as String);
}

Map<String, dynamic> _$ServiceAccountKeyToJson(ServiceAccountKey instance) =>
    <String, dynamic>{
      'type': instance.type,
      'project_id': instance.projectId,
      'private_key_id': instance.privateKeyId,
      'private_key': instance.privateKey,
      'client_email': instance.clientEmail,
      'client_id': instance.clientId,
      'auth_uri': instance.authUri,
      'token_uri': instance.tokenUri,
      'auth_provider_x509_cert_url': instance.authProviderX509CertUrl,
      'client_x509_cert_url': instance.clientX509CertUrl
    };

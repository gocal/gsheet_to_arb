// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PluginConfigRoot _$PluginConfigRootFromJson(Map<String, dynamic> json) {
  return PluginConfigRoot(
    json['gsheet_to_arb'] == null
        ? null
        : GsheetToArbConfig.fromJson(
            json['gsheet_to_arb'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PluginConfigRootToJson(PluginConfigRoot instance) =>
    <String, dynamic>{
      'gsheet_to_arb': instance.content,
    };

GsheetToArbConfig _$GsheetToArbConfigFromJson(Map<String, dynamic> json) {
  return GsheetToArbConfig(
    outputDirectoryPath: json['output_directory'] as String,
    arbFilePrefix: json['arb_file_prefix'] as String,
    gsheet: json['gsheet'] == null
        ? null
        : GoogleSheetConfig.fromJson(json['gsheet'] as Map<String, dynamic>),
    localizationFileName: json['localization_file_name'] as String,
  );
}

Map<String, dynamic> _$GsheetToArbConfigToJson(GsheetToArbConfig instance) =>
    <String, dynamic>{
      'output_directory': instance.outputDirectoryPath,
      'arb_file_prefix': instance.arbFilePrefix,
      'localization_file_name': instance.localizationFileName,
      'gsheet': instance.gsheet,
    };

GoogleSheetConfig _$GoogleSheetConfigFromJson(Map<String, dynamic> json) {
  return GoogleSheetConfig(
    authFile: json['auth_file'] as String,
    documentId: json['document_id'] as String,
    sheetId: json['sheet_id'] as String,
    categoryPrefix: json['category_prefix'] as String,
  );
}

Map<String, dynamic> _$GoogleSheetConfigToJson(GoogleSheetConfig instance) =>
    <String, dynamic>{
      'document_id': instance.documentId,
      'sheet_id': instance.sheetId,
      'category_prefix': instance.categoryPrefix,
      'auth_file': instance.authFile,
    };

AuthConfig _$AuthConfigFromJson(Map<String, dynamic> json) {
  return AuthConfig(
    oauthClientId: json['oauth_client_id'] == null
        ? null
        : OAuthClientId.fromJson(
            json['oauth_client_id'] as Map<String, dynamic>),
    serviceAccountKey: json['service_account_key'] == null
        ? null
        : ServiceAccountKey.fromJson(
            json['service_account_key'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AuthConfigToJson(AuthConfig instance) =>
    <String, dynamic>{
      'oauth_client_id': instance.oauthClientId,
      'service_account_key': instance.serviceAccountKey,
    };

OAuthClientId _$OAuthClientIdFromJson(Map<String, dynamic> json) {
  return OAuthClientId(
    clientId: json['client_id'] as String,
    clientSecret: json['client_secret'] as String,
  );
}

Map<String, dynamic> _$OAuthClientIdToJson(OAuthClientId instance) =>
    <String, dynamic>{
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
    };

ServiceAccountKey _$ServiceAccountKeyFromJson(Map<String, dynamic> json) {
  return ServiceAccountKey(
    type: json['type'] as String,
    projectId: json['project_id'] as String,
    privateKeyId: json['private_key_id'] as String,
    privateKey: json['private_key'] as String,
    clientEmail: json['client_email'] as String,
    clientId: json['client_id'] as String,
    authUri: json['auth_uri'] as String,
    tokenUri: json['token_uri'] as String,
    authProviderX509CertUrl: json['auth_provider_x509_cert_url'] as String,
    clientX509CertUrl: json['client_x509_cert_url'] as String,
  );
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
      'client_x509_cert_url': instance.clientX509CertUrl,
    };

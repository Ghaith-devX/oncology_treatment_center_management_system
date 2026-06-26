// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => AuthSession(
  userId: (json['userId'] as num).toInt(),
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  roleId: (json['roleId'] as num).toInt(),
  roleName: json['roleName'] as String,
  token: json['token'] as String,
  expiresAt: json['expiresAt'] as String,
);

Map<String, dynamic> _$AuthSessionToJson(AuthSession instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'email': instance.email,
      'roleId': instance.roleId,
      'roleName': instance.roleName,
      'token': instance.token,
      'expiresAt': instance.expiresAt,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleModel _$RoleModelFromJson(Map<String, dynamic> json) => RoleModel(
  roleId: (json['roleId'] as num).toInt(),
  roleName: json['roleName'] as String,
);

Map<String, dynamic> _$RoleModelToJson(RoleModel instance) => <String, dynamic>{
  'roleId': instance.roleId,
  'roleName': instance.roleName,
};

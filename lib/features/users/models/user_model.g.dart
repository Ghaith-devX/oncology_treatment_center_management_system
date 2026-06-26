// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: (json['userId'] as num).toInt(),
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  roleId: (json['roleId'] as num).toInt(),
  roleName: json['roleName'] as String?,
  employeeId: (json['employeeId'] as num?)?.toInt(),
  patientId: (json['patientId'] as num?)?.toInt(),
  isActive: json['isActive'] as bool? ?? true,
  lastLogin: json['lastLogin'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'userId': instance.userId,
  'fullName': instance.fullName,
  'email': instance.email,
  'roleId': instance.roleId,
  'roleName': instance.roleName,
  'employeeId': instance.employeeId,
  'patientId': instance.patientId,
  'isActive': instance.isActive,
  'lastLogin': instance.lastLogin,
  'createdAt': instance.createdAt,
};

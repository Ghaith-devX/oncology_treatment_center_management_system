import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int userId;
  final String fullName;
  final String email;
  final int roleId;
  final String? roleName;
  final int? employeeId;
  final int? patientId;
  final bool isActive;
  final String? lastLogin;
  final String? createdAt;

  const UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.roleId,
    this.roleName,
    this.employeeId,
    this.patientId,
    this.isActive = true,
    this.lastLogin,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

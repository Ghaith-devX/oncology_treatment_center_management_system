import 'package:json_annotation/json_annotation.dart';

part 'role_model.g.dart';

@JsonSerializable()
class RoleModel {
  final int roleId;
  final String roleName;

  const RoleModel({required this.roleId, required this.roleName});

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleModelToJson(this);
}

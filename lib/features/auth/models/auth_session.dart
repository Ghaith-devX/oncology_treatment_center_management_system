import 'package:json_annotation/json_annotation.dart';
import '../../../core/constants/role_constants.dart';

part 'auth_session.g.dart';

@JsonSerializable()
class AuthSession {
  final int userId;
  final String fullName;
  final String email;
  final int roleId;
  final String roleName;
  final String token;
  final String expiresAt;

  const AuthSession({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.roleId,
    required this.roleName,
    required this.token,
    required this.expiresAt,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);

  Map<String, dynamic> toJson() => _$AuthSessionToJson(this);

  RoleType get roleType => RoleType.fromRoleName(roleName);
}

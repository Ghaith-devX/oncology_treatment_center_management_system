import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService() : _storage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _fullNameKey = 'full_name';
  static const _emailKey = 'email';
  static const _roleIdKey = 'role_id';
  static const _roleNameKey = 'role_name';
  static const _expiresAtKey = 'expires_at';

  Future<void> saveSession({
    required String token,
    required int userId,
    required String fullName,
    required String email,
    required int roleId,
    required String roleName,
    required String expiresAt,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userIdKey, value: userId.toString());
    await _storage.write(key: _fullNameKey, value: fullName);
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _roleIdKey, value: roleId.toString());
    await _storage.write(key: _roleNameKey, value: roleName);
    await _storage.write(key: _expiresAtKey, value: expiresAt);
  }

  Future<Map<String, String?>> readSession() async {
    final results = await _storage.readAll();
    return {
      'token': results[_tokenKey],
      'userId': results[_userIdKey],
      'fullName': results[_fullNameKey],
      'email': results[_emailKey],
      'roleId': results[_roleIdKey],
      'roleName': results[_roleNameKey],
      'expiresAt': results[_expiresAtKey],
    };
  }

  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<void> clearSession() async {
    await _storage.deleteAll();
  }
}

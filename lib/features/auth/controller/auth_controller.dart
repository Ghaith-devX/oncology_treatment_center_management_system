import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/role_constants.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../shared/utils/date_time_parsing.dart';
import '../../../shared/utils/result.dart';
import '../api/auth_api.dart';
import '../models/auth_session.dart';
import '../models/login_request.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final AuthSession? session;
  final String? error;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.session,
    this.error,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  RoleType get roleType => session?.roleType ?? RoleType.unknown;
  bool get isAuthenticated => status == AuthStatus.authenticated;
}

class AuthController extends StateNotifier<AuthState> {
  final AuthApi _authApi;
  final SecureStorageService _secureStorage;

  AuthController({
    required AuthApi authApi,
    required SecureStorageService secureStorage,
  })  : _authApi = authApi,
        _secureStorage = secureStorage,
        super(const AuthState());

  Future<void> tryAutoLogin() async {
    final sessionData = await _secureStorage.readSession();
    final token = sessionData['token'];
    final expiresAt = sessionData['expiresAt'];

    if (token == null ||
        token.isEmpty ||
        expiresAt == null ||
        DateTimeParsing.isExpired(expiresAt)) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }

    state = state.copyWith(
      status: AuthStatus.authenticated,
      session: AuthSession(
        userId: int.tryParse(sessionData['userId'] ?? '0') ?? 0,
        fullName: sessionData['fullName'] ?? '',
        email: sessionData['email'] ?? '',
        roleId: int.tryParse(sessionData['roleId'] ?? '0') ?? 0,
        roleName: sessionData['roleName'] ?? '',
        token: token,
        expiresAt: expiresAt,
      ),
    );
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final request = LoginRequest(email: email, password: password);
    final result = await _authApi.login(request);

    switch (result) {
      case Success<AuthSession>():
        final session = result.data;
        await _secureStorage.saveSession(
          token: session.token,
          userId: session.userId,
          fullName: session.fullName,
          email: session.email,
          roleId: session.roleId,
          roleName: session.roleName,
          expiresAt: session.expiresAt,
        );
        state = state.copyWith(
          status: AuthStatus.authenticated,
          session: session,
          isLoading: false,
          error: null,
        );
      case Failure<AuthSession>():
        state = state.copyWith(
          isLoading: false,
          error: result.message,
          status: AuthStatus.unauthenticated,
        );
    }
  }

  Future<void> logout() async {
    await _secureStorage.clearSession();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: secureStorage);
});

final authApiProvider = Provider<AuthApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthApi(apiClient);
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final authApi = ref.watch(authApiProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthController(
    authApi: authApi,
    secureStorage: secureStorage,
  );
});

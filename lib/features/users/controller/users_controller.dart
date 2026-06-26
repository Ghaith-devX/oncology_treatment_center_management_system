import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/utils/result.dart';
import '../../auth/controller/auth_controller.dart';
import '../api/roles_api.dart';
import '../api/users_api.dart';
import '../models/role_model.dart';
import '../models/user_model.dart';

enum UsersStatus { initial, loading, loaded, error }

class UsersState {
  final UsersStatus status;
  final List<UserModel> users;
  final List<RoleModel> roles;
  final String? error;
  final bool isSubmitting;

  const UsersState({
    this.status = UsersStatus.initial,
    this.users = const [],
    this.roles = const [],
    this.error,
    this.isSubmitting = false,
  });

  UsersState copyWith({
    UsersStatus? status,
    List<UserModel>? users,
    List<RoleModel>? roles,
    String? error,
    bool? isSubmitting,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      roles: roles ?? this.roles,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class UsersController extends StateNotifier<UsersState> {
  final UsersApi _usersApi;
  final RolesApi _rolesApi;

  UsersController({
    required UsersApi usersApi,
    required RolesApi rolesApi,
  })  : _usersApi = usersApi,
        _rolesApi = rolesApi,
        super(const UsersState());

  Future<void> loadAll() async {
    state = state.copyWith(status: UsersStatus.loading);

    final usersResult = await _usersApi.getAll();
    final rolesResult = await _rolesApi.getAll();

    List<UserModel> users = [];
    List<RoleModel> roles = [];
    String? error;

    if (usersResult is Success<List<UserModel>>) {
      users = usersResult.data;
    } else if (usersResult is Failure<List<UserModel>>) {
      error = usersResult.message;
    }

    if (rolesResult is Success<List<RoleModel>>) {
      roles = rolesResult.data;
    }

    state = UsersState(
      status: error != null ? UsersStatus.error : UsersStatus.loaded,
      users: users,
      roles: roles,
      error: error,
    );
  }

  Future<String?> create(Map<String, dynamic> data) async {
    state = state.copyWith(isSubmitting: true);
    final result = await _usersApi.create(data);
    state = state.copyWith(isSubmitting: false);
    if (result is Success<UserModel>) {
      state = state.copyWith(
        users: [...state.users, result.data],
        error: null,
      );
      return null;
    } else if (result is Failure<UserModel>) {
      state = state.copyWith(error: result.message);
      return result.message;
    }
    return 'Unknown error';
  }

  Future<String?> update(int id, Map<String, dynamic> data) async {
    state = state.copyWith(isSubmitting: true);
    final result = await _usersApi.update(id, data);
    state = state.copyWith(isSubmitting: false);
    if (result is Success<UserModel>) {
      state = state.copyWith(
        users: state.users.map((u) {
          return u.userId == id ? result.data : u;
        }).toList(),
        error: null,
      );
      return null;
    } else if (result is Failure<UserModel>) {
      state = state.copyWith(error: result.message);
      return result.message;
    }
    return 'Unknown error';
  }

  Future<String?> delete(int id) async {
    final result = await _usersApi.delete(id);
    if (result is Success<void>) {
      state = state.copyWith(
        users: state.users.where((u) => u.userId != id).toList(),
        error: null,
      );
      return null;
    } else if (result is Failure<void>) {
      state = state.copyWith(error: result.message);
      return result.message;
    }
    return 'Unknown error';
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final usersApiProvider = Provider<UsersApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UsersApi(apiClient);
});

final rolesApiProvider = Provider<RolesApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RolesApi(apiClient);
});

final usersControllerProvider =
    StateNotifierProvider<UsersController, UsersState>((ref) {
  return UsersController(
    usersApi: ref.watch(usersApiProvider),
    rolesApi: ref.watch(rolesApiProvider),
  );
});

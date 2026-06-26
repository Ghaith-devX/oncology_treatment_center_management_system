import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/utils/result.dart';
import '../../auth/controller/auth_controller.dart';
import '../api/employees_api.dart';
import '../models/employee_model.dart';

enum EmployeesStatus { initial, loading, loaded, error }

class EmployeesState {
  final EmployeesStatus status;
  final List<EmployeeModel> employees;
  final EmployeeModel? selectedEmployee;
  final String? error;
  final bool isSubmitting;
  final String searchQuery;

  const EmployeesState({
    this.status = EmployeesStatus.initial,
    this.employees = const [],
    this.selectedEmployee,
    this.error,
    this.isSubmitting = false,
    this.searchQuery = '',
  });

  EmployeesState copyWith({
    EmployeesStatus? status,
    List<EmployeeModel>? employees,
    EmployeeModel? selectedEmployee,
    String? error,
    bool? isSubmitting,
    String? searchQuery,
  }) {
    return EmployeesState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
      selectedEmployee: selectedEmployee ?? this.selectedEmployee,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<EmployeeModel> get filteredEmployees {
    if (searchQuery.isEmpty) return employees;
    final query = searchQuery.toLowerCase();
    return employees.where((e) {
      return e.fullName.toLowerCase().contains(query) ||
          (e.position?.toLowerCase().contains(query) ?? false) ||
          (e.department?.toLowerCase().contains(query) ?? false);
    }).toList();
  }
}

class EmployeesController extends StateNotifier<EmployeesState> {
  final EmployeesApi _api;

  EmployeesController({required EmployeesApi api})
      : _api = api,
        super(const EmployeesState());

  Future<void> loadAll() async {
    state = state.copyWith(status: EmployeesStatus.loading);
    final result = await _api.getAll();
    switch (result) {
      case Success<List<EmployeeModel>>():
        state = state.copyWith(
          status: EmployeesStatus.loaded,
          employees: result.data,
          error: null,
        );
      case Failure<List<EmployeeModel>>():
        state = state.copyWith(
          status: EmployeesStatus.error,
          error: result.message,
        );
    }
  }

  Future<void> loadById(int id) async {
    state = state.copyWith(status: EmployeesStatus.loading);
    final result = await _api.getById(id);
    switch (result) {
      case Success<EmployeeModel>():
        state = state.copyWith(
          status: EmployeesStatus.loaded,
          selectedEmployee: result.data,
          error: null,
        );
      case Failure<EmployeeModel>():
        state = state.copyWith(
          status: EmployeesStatus.error,
          error: result.message,
        );
    }
  }

  Future<String?> create(EmployeeModel employee) async {
    state = state.copyWith(isSubmitting: true);
    final result = await _api.create(employee);
    state = state.copyWith(isSubmitting: false);
    switch (result) {
      case Success<EmployeeModel>():
        state = state.copyWith(
          employees: [...state.employees, result.data],
          error: null,
        );
        return null;
      case Failure<EmployeeModel>():
        state = state.copyWith(error: result.message);
        return result.message;
    }
  }

  Future<String?> update(int id, EmployeeModel employee) async {
    state = state.copyWith(isSubmitting: true);
    final result = await _api.update(id, employee);
    state = state.copyWith(isSubmitting: false);
    switch (result) {
      case Success<EmployeeModel>():
        state = state.copyWith(
          employees: state.employees.map((e) {
            return e.employeeId == id ? result.data : e;
          }).toList(),
          error: null,
        );
        return null;
      case Failure<EmployeeModel>():
        state = state.copyWith(error: result.message);
        return result.message;
    }
  }

  Future<String?> delete(int id) async {
    final result = await _api.delete(id);
    switch (result) {
      case Success<void>():
        state = state.copyWith(
          employees: state.employees.where((e) => e.employeeId != id).toList(),
          error: null,
        );
        return null;
      case Failure<void>():
        state = state.copyWith(error: result.message);
        return result.message;
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final employeesApiProvider = Provider<EmployeesApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EmployeesApi(apiClient);
});

final employeesControllerProvider =
    StateNotifierProvider<EmployeesController, EmployeesState>((ref) {
  final api = ref.watch(employeesApiProvider);
  return EmployeesController(api: api);
});

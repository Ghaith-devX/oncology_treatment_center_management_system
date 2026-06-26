import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/utils/result.dart';
import '../../auth/controller/auth_controller.dart';
import '../../employees/api/employees_api.dart';
import '../../employees/models/employee_model.dart';
import '../../patients/api/patients_api.dart';
import '../../patients/models/patient_model.dart';

class DashboardStats {
  final int patientCount;
  final int employeeCount;
  final int activeEmployeeCount;
  final bool isLoading;
  final String? error;

  const DashboardStats({
    this.patientCount = 0,
    this.employeeCount = 0,
    this.activeEmployeeCount = 0,
    this.isLoading = false,
    this.error,
  });
}

class DashboardController extends StateNotifier<DashboardStats> {
  final PatientsApi _patientsApi;
  final EmployeesApi _employeesApi;

  DashboardController({
    required PatientsApi patientsApi,
    required EmployeesApi employeesApi,
  })  : _patientsApi = patientsApi,
        _employeesApi = employeesApi,
        super(const DashboardStats());

  Future<void> loadStats() async {
    state = const DashboardStats(isLoading: true);

    final patientsResult = await _patientsApi.getAll();
    final employeesResult = await _employeesApi.getAll();

    int patientCount = 0;
    int employeeCount = 0;
    String? error;

    if (patientsResult is Success<List<PatientModel>>) {
      patientCount = patientsResult.data.length;
    } else if (patientsResult is Failure<List<PatientModel>>) {
      error = patientsResult.message;
    }

    if (employeesResult is Success<List<EmployeeModel>>) {
      employeeCount = employeesResult.data.length;
    } else if (employeesResult is Failure<List<EmployeeModel>>) {
      error ??= employeesResult.message;
    }

    state = DashboardStats(
      patientCount: patientCount,
      employeeCount: employeeCount,
      isLoading: false,
      error: error,
    );
  }
}

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardStats>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DashboardController(
    patientsApi: PatientsApi(apiClient),
    employeesApi: EmployeesApi(apiClient),
  );
});

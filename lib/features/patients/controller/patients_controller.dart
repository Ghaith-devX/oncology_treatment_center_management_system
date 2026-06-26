import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/utils/result.dart';
import '../../auth/controller/auth_controller.dart';
import '../api/patients_api.dart';
import '../models/patient_model.dart';

enum PatientsStatus { initial, loading, loaded, error }

class PatientsState {
  final PatientsStatus status;
  final List<PatientModel> patients;
  final PatientModel? selectedPatient;
  final String? error;
  final bool isSubmitting;
  final String searchQuery;

  const PatientsState({
    this.status = PatientsStatus.initial,
    this.patients = const [],
    this.selectedPatient,
    this.error,
    this.isSubmitting = false,
    this.searchQuery = '',
  });

  PatientsState copyWith({
    PatientsStatus? status,
    List<PatientModel>? patients,
    PatientModel? selectedPatient,
    String? error,
    bool? isSubmitting,
    String? searchQuery,
  }) {
    return PatientsState(
      status: status ?? this.status,
      patients: patients ?? this.patients,
      selectedPatient: selectedPatient ?? this.selectedPatient,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<PatientModel> get filteredPatients {
    if (searchQuery.isEmpty) return patients;
    final query = searchQuery.toLowerCase();
    return patients.where((p) {
      return p.fullName.toLowerCase().contains(query) ||
          (p.phone?.toLowerCase().contains(query) ?? false) ||
          (p.identityNumber?.toLowerCase().contains(query) ?? false);
    }).toList();
  }
}

class PatientsController extends StateNotifier<PatientsState> {
  final PatientsApi _api;

  PatientsController({required PatientsApi api})
      : _api = api,
        super(const PatientsState());

  Future<void> loadAll() async {
    state = state.copyWith(status: PatientsStatus.loading);
    final result = await _api.getAll();
    switch (result) {
      case Success<List<PatientModel>>():
        state = state.copyWith(
          status: PatientsStatus.loaded,
          patients: result.data,
          error: null,
        );
      case Failure<List<PatientModel>>():
        state = state.copyWith(
          status: PatientsStatus.error,
          error: result.message,
        );
    }
  }

  Future<void> loadById(int id) async {
    state = state.copyWith(status: PatientsStatus.loading);
    final result = await _api.getById(id);
    switch (result) {
      case Success<PatientModel>():
        state = state.copyWith(
          status: PatientsStatus.loaded,
          selectedPatient: result.data,
          error: null,
        );
      case Failure<PatientModel>():
        state = state.copyWith(
          status: PatientsStatus.error,
          error: result.message,
        );
    }
  }

  Future<String?> create(PatientModel patient) async {
    state = state.copyWith(isSubmitting: true);
    final result = await _api.create(patient);
    state = state.copyWith(isSubmitting: false);
    switch (result) {
      case Success<PatientModel>():
        state = state.copyWith(
          patients: [...state.patients, result.data],
          error: null,
        );
        return null;
      case Failure<PatientModel>():
        state = state.copyWith(error: result.message);
        return result.message;
    }
  }

  Future<String?> update(int id, PatientModel patient) async {
    state = state.copyWith(isSubmitting: true);
    final result = await _api.update(id, patient);
    state = state.copyWith(isSubmitting: false);
    switch (result) {
      case Success<PatientModel>():
        state = state.copyWith(
          patients: state.patients.map((p) {
            return p.patientId == id ? result.data : p;
          }).toList(),
          error: null,
        );
        return null;
      case Failure<PatientModel>():
        state = state.copyWith(error: result.message);
        return result.message;
    }
  }

  Future<String?> delete(int id) async {
    final result = await _api.delete(id);
    switch (result) {
      case Success<void>():
        state = state.copyWith(
          patients: state.patients.where((p) => p.patientId != id).toList(),
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

final patientsApiProvider = Provider<PatientsApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PatientsApi(apiClient);
});

final patientsControllerProvider =
    StateNotifierProvider<PatientsController, PatientsState>((ref) {
  final api = ref.watch(patientsApiProvider);
  return PatientsController(api: api);
});

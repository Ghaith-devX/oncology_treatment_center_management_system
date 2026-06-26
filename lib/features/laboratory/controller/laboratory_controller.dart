import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/utils/result.dart';
import '../../auth/controller/auth_controller.dart';
import '../api/laboratory_api.dart';
import '../models/lab_model.dart';

enum LabStatus { initial, loading, loaded, error }

class LabState {
  final LabStatus status;
  final List<LabModel> labs;
  final LabModel? selectedLab;
  final String? error;
  final bool isSubmitting;
  final String searchQuery;

  const LabState({
    this.status = LabStatus.initial,
    this.labs = const [],
    this.selectedLab,
    this.error,
    this.isSubmitting = false,
    this.searchQuery = '',
  });

  LabState copyWith({
    LabStatus? status,
    List<LabModel>? labs,
    LabModel? selectedLab,
    String? error,
    bool? isSubmitting,
    String? searchQuery,
  }) {
    return LabState(
      status: status ?? this.status,
      labs: labs ?? this.labs,
      selectedLab: selectedLab ?? this.selectedLab,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<LabModel> get filteredLabs {
    if (searchQuery.isEmpty) return labs;
    final query = searchQuery.toLowerCase();
    return labs.where((l) {
      return l.testType?.toLowerCase().contains(query) ?? false;
    }).toList();
  }
}

class LaboratoryController extends StateNotifier<LabState> {
  final LaboratoryApi _api;

  LaboratoryController({required LaboratoryApi api})
      : _api = api,
        super(const LabState());

  Future<void> loadAll() async {
    state = state.copyWith(status: LabStatus.loading);
    final result = await _api.getAll();
    if (result is Success<List<LabModel>>) {
      state = state.copyWith(
        status: LabStatus.loaded,
        labs: result.data,
        error: null,
      );
    } else if (result is Failure<List<LabModel>>) {
      state = state.copyWith(status: LabStatus.error, error: result.message);
    }
  }

  Future<void> loadById(int id) async {
    state = state.copyWith(status: LabStatus.loading);
    final result = await _api.getById(id);
    if (result is Success<LabModel>) {
      state = state.copyWith(
        status: LabStatus.loaded,
        selectedLab: result.data,
        error: null,
      );
    } else if (result is Failure<LabModel>) {
      state = state.copyWith(status: LabStatus.error, error: result.message);
    }
  }

  Future<String?> create(LabModel lab) async {
    state = state.copyWith(isSubmitting: true);
    final result = await _api.create(lab);
    state = state.copyWith(isSubmitting: false);
    if (result is Success<LabModel>) {
      state = state.copyWith(labs: [...state.labs, result.data], error: null);
      return null;
    } else if (result is Failure<LabModel>) {
      state = state.copyWith(error: result.message);
      return result.message;
    }
    return 'Unknown error';
  }

  Future<String?> update(int id, LabModel lab) async {
    state = state.copyWith(isSubmitting: true);
    final result = await _api.update(id, lab);
    state = state.copyWith(isSubmitting: false);
    if (result is Success<LabModel>) {
      state = state.copyWith(
        labs: state.labs.map((l) => l.labId == id ? result.data : l).toList(),
        error: null,
      );
      return null;
    } else if (result is Failure<LabModel>) {
      state = state.copyWith(error: result.message);
      return result.message;
    }
    return 'Unknown error';
  }

  Future<String?> delete(int id) async {
    final result = await _api.delete(id);
    if (result is Success<void>) {
      state = state.copyWith(
        labs: state.labs.where((l) => l.labId != id).toList(),
        error: null,
      );
      return null;
    } else if (result is Failure<void>) {
      state = state.copyWith(error: result.message);
      return result.message;
    }
    return 'Unknown error';
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final laboratoryApiProvider = Provider<LaboratoryApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LaboratoryApi(apiClient);
});

final laboratoryControllerProvider =
    StateNotifierProvider<LaboratoryController, LabState>((ref) {
  return LaboratoryController(api: ref.watch(laboratoryApiProvider));
});

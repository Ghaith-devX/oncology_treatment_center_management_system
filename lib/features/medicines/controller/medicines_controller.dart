import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/utils/result.dart';
import '../../auth/controller/auth_controller.dart';
import '../api/medicines_api.dart';
import '../models/medicine_model.dart';

enum MedicinesStatus { initial, loading, loaded, error }

class MedicinesState {
  final MedicinesStatus status;
  final List<MedicineModel> medicines;
  final MedicineModel? selectedMedicine;
  final String? error;
  final bool isSubmitting;
  final String searchQuery;

  const MedicinesState({
    this.status = MedicinesStatus.initial,
    this.medicines = const [],
    this.selectedMedicine,
    this.error,
    this.isSubmitting = false,
    this.searchQuery = '',
  });

  MedicinesState copyWith({
    MedicinesStatus? status,
    List<MedicineModel>? medicines,
    MedicineModel? selectedMedicine,
    String? error,
    bool? isSubmitting,
    String? searchQuery,
  }) {
    return MedicinesState(
      status: status ?? this.status,
      medicines: medicines ?? this.medicines,
      selectedMedicine: selectedMedicine ?? this.selectedMedicine,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<MedicineModel> get filteredMedicines {
    if (searchQuery.isEmpty) return medicines;
    final q = searchQuery.toLowerCase();
    return medicines.where((m) {
      return (m.tradeName?.toLowerCase().contains(q) ?? false) ||
          (m.activeIngredient?.toLowerCase().contains(q) ?? false);
    }).toList();
  }
}

class MedicinesController extends StateNotifier<MedicinesState> {
  final MedicinesApi _api;

  MedicinesController({required MedicinesApi api})
      : _api = api,
        super(const MedicinesState());

  Future<void> loadAll() async {
    state = state.copyWith(status: MedicinesStatus.loading);
    final result = await _api.getAll();
    if (result is Success<List<MedicineModel>>) {
      state = state.copyWith(
        status: MedicinesStatus.loaded,
        medicines: result.data,
        error: null,
      );
    } else if (result is Failure<List<MedicineModel>>) {
      state = state.copyWith(
          status: MedicinesStatus.error, error: result.message);
    }
  }

  Future<String?> create(MedicineModel medicine) async {
    state = state.copyWith(isSubmitting: true);
    final result = await _api.create(medicine);
    state = state.copyWith(isSubmitting: false);
    if (result is Success<MedicineModel>) {
      state = state.copyWith(
          medicines: [...state.medicines, result.data], error: null);
      return null;
    } else if (result is Failure<MedicineModel>) {
      state = state.copyWith(error: result.message);
      return result.message;
    }
    return 'Unknown error';
  }

  Future<String?> delete(int id) async {
    final result = await _api.delete(id);
    if (result is Success<void>) {
      state = state.copyWith(
        medicines: state.medicines.where((m) => m.medicineId != id).toList(),
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

final medicinesApiProvider = Provider<MedicinesApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MedicinesApi(apiClient);
});

final medicinesControllerProvider =
    StateNotifierProvider<MedicinesController, MedicinesState>((ref) {
  return MedicinesController(api: ref.watch(medicinesApiProvider));
});

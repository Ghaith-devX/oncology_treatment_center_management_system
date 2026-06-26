import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/utils/result.dart';
import '../../auth/controller/auth_controller.dart';
import '../api/treatment_sessions_api.dart';
import '../models/treatment_session_model.dart';

enum SessionsStatus { initial, loading, loaded, error }

class SessionsState {
  final SessionsStatus status;
  final List<TreatmentSessionModel> sessions;
  final TreatmentSessionModel? selectedSession;
  final String? error;
  final bool isSubmitting;
  final String searchQuery;

  const SessionsState({
    this.status = SessionsStatus.initial,
    this.sessions = const [],
    this.selectedSession,
    this.error,
    this.isSubmitting = false,
    this.searchQuery = '',
  });

  SessionsState copyWith({
    SessionsStatus? status,
    List<TreatmentSessionModel>? sessions,
    TreatmentSessionModel? selectedSession,
    String? error,
    bool? isSubmitting,
    String? searchQuery,
  }) {
    return SessionsState(
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      selectedSession: selectedSession ?? this.selectedSession,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<TreatmentSessionModel> get filteredSessions {
    if (searchQuery.isEmpty) return sessions;
    final q = searchQuery.toLowerCase();
    return sessions.where((s) {
      return (s.sessionType?.toLowerCase().contains(q) ?? false) ||
          (s.status?.toLowerCase().contains(q) ?? false);
    }).toList();
  }
}

class TreatmentSessionsController extends StateNotifier<SessionsState> {
  final TreatmentSessionsApi _api;

  TreatmentSessionsController({required TreatmentSessionsApi api})
      : _api = api,
        super(const SessionsState());

  Future<void> loadAll() async {
    state = state.copyWith(status: SessionsStatus.loading);
    final result = await _api.getAll();
    if (result is Success<List<TreatmentSessionModel>>) {
      state = state.copyWith(
        status: SessionsStatus.loaded,
        sessions: result.data,
        error: null,
      );
    } else if (result is Failure<List<TreatmentSessionModel>>) {
      state = state.copyWith(
          status: SessionsStatus.error, error: result.message);
    }
  }

  Future<String?> create(TreatmentSessionModel session) async {
    state = state.copyWith(isSubmitting: true);
    final result = await _api.create(session);
    state = state.copyWith(isSubmitting: false);
    if (result is Success<TreatmentSessionModel>) {
      state = state.copyWith(
          sessions: [...state.sessions, result.data], error: null);
      return null;
    } else if (result is Failure<TreatmentSessionModel>) {
      state = state.copyWith(error: result.message);
      return result.message;
    }
    return 'Unknown error';
  }

  Future<String?> delete(int id) async {
    final result = await _api.delete(id);
    if (result is Success<void>) {
      state = state.copyWith(
        sessions:
            state.sessions.where((s) => s.sessionId != id).toList(),
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

final treatmentSessionsApiProvider = Provider<TreatmentSessionsApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TreatmentSessionsApi(apiClient);
});

final treatmentSessionsControllerProvider =
    StateNotifierProvider<TreatmentSessionsController, SessionsState>((ref) {
  return TreatmentSessionsController(
      api: ref.watch(treatmentSessionsApiProvider));
});

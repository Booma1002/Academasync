import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/backend_service.dart';
import 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final BackendService _backend = BackendService();

  AnalyticsCubit() : super(const AnalyticsState());

  Future<void> analyzeCurrentPace({
    required double delta,
  }) async {
    emit(state.copyWith(isLoading: true));
    
    final result = await _backend.analyzePace(delta: delta);

    if (result != null) {
      emit(state.copyWith(
        status: result['status'] ?? 'ON PACE',
        recommendation: result['recommendation'] ?? 'System stable.',
        isConnected: true,
        isLoading: false,
      ));
    } else {
      emit(state.copyWith(
        status: 'OFFLINE',
        isConnected: false,
        isLoading: false,
      ));
    }
  }

  Future<void> checkStatus() async {
    final result = await _backend.getStatus();
    emit(state.copyWith(isConnected: result != null));
  }
}

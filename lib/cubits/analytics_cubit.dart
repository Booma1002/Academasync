import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/backend_service.dart';

class AnalyticsState extends Equatable {
  final String status;
  final String recommendation;
  final bool isConnected;
  final bool isLoading;

  const AnalyticsState({
    this.status = 'OFFLINE',
    this.recommendation = 'Connect to Logic Engine for system state.',
    this.isConnected = false,
    this.isLoading = false,
  });

  AnalyticsState copyWith({
    String? status,
    String? recommendation,
    bool? isConnected,
    bool? isLoading,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      recommendation: recommendation ?? this.recommendation,
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [status, recommendation, isConnected, isLoading];
}

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

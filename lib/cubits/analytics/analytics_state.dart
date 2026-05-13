import 'package:equatable/equatable.dart';

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
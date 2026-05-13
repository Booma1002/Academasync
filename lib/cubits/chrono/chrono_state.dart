/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Represents the current time remaining and     |
|  the active mode of the Pomodoro timer.        |
\*----------------------------------------------*/
class ChronoState {
  final int remainingSeconds;
  final bool isRunning;
  final String mode;

  ChronoState({required this.remainingSeconds, this.isRunning = false, this.mode = 'focus'});

  ChronoState copyWith({int? remainingSeconds, bool? isRunning, String? mode}) {
    return ChronoState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      mode: mode ?? this.mode,
    );
  }
}
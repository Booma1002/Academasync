import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chrono_state.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Engine for the countdown timer, handling      |
|  ticks, pauses, and mode switches.             |
\*----------------------------------------------*/
class ChronoCubit extends Cubit<ChronoState> {
  Timer? _timer;

  ChronoCubit() : super(ChronoState(remainingSeconds: 25 * 60));

  void startTimer() {
    if (_timer != null && _timer!.isActive) return;

    emit(state.copyWith(isRunning: true));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
      } else {
        timer.cancel();
        emit(state.copyWith(isRunning: false));
        /*----------------------------------------------*\
        |  Note: We'll trigger the audio ring from the   |
        |  UI listener when this hits 0                  |
        \*----------------------------------------------*/
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    emit(state.copyWith(isRunning: false));
  }

  void resetTimer(int minutes, String mode) {
    _timer?.cancel();
    emit(ChronoState(remainingSeconds: minutes * 60, isRunning: false, mode: mode));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
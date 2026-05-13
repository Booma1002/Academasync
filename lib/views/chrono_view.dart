import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/chrono/chrono_cubit.dart';
import '../cubits/chrono/chrono_state.dart';

class ChronoView extends StatelessWidget {
  const ChronoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      /*----------------------------------------------*\
      |  Listens to the timer ticks                    |
      \*----------------------------------------------*/
      child: BlocBuilder<ChronoCubit, ChronoState>(
        builder: (context, state) {
          /*----------------------------------------------*\
          |  Math to convert total seconds to MM:SS        |
          |  format                                        |
          \*----------------------------------------------*/
          final minutes = (state.remainingSeconds / 60).floor().toString().padLeft(2, '0');
          final seconds = (state.remainingSeconds % 60).toString().padLeft(2, '0');

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '${state.mode.toUpperCase()} MODE',
                  style: const TextStyle(fontSize: 20, letterSpacing: 4, color: Colors.grey)
              ),
              const SizedBox(height: 20),

              /*----------------------------------------------*\
              |  MASSIVE TIMER TEXT                            |
              \*----------------------------------------------*/
              Text(
                '$minutes:$seconds',
                style: TextStyle(
                  fontSize: 90,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  /*----------------------------------------------*\
                  |  Turns red if it hits 0                        |
                  \*----------------------------------------------*/
                  color: state.remainingSeconds == 0 ? Colors.redAccent : Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 50),

              /*----------------------------------------------*\
              |  CONTROLS                                      |
              \*----------------------------------------------*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)
                    ),
                    /*----------------------------------------------*\
                    |  Disable button if already running             |
                    \*----------------------------------------------*/
                    onPressed: state.isRunning ? null : () => context.read<ChronoCubit>().startTimer(),
                    child: const Text('START', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)
                    ),
                    /*----------------------------------------------*\
                    |  Disable button if already paused              |
                    \*----------------------------------------------*/
                    onPressed: !state.isRunning ? null : () => context.read<ChronoCubit>().pauseTimer(),
                    child: const Text('PAUSE', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              /*----------------------------------------------*\
              |  PRESETS                                       |
              \*----------------------------------------------*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => context.read<ChronoCubit>().resetTimer(25, 'focus'),
                    child: const Text('25M FOCUS', style: TextStyle(color: Colors.grey)),
                  ),
                  const Text('|', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () => context.read<ChronoCubit>().resetTimer(5, 'break'),
                    child: const Text('5M BREAK', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
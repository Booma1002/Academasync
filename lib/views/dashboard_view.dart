import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/roadmap/roadmap_cubit.dart';
import '../cubits/todo/todo_cubit.dart';
import '../cubits/todo/todo_state.dart';
import '../cubits/analytics/analytics_cubit.dart';
import '../cubits/analytics/analytics_state.dart';
import '../models/roadmap_model.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  The Main Command Center. Integrates with the  |
|  Stateless Logic Engine for sync checks.       |
\*----------------------------------------------*/
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapCubit, RoadmapData>(
      builder: (context, roadmap) {
        return BlocBuilder<TodoCubit, TodoState>(
          builder: (context, todoState) {
            
            // MATH ENGINE
            double delta = 0.0;
            double paceCar = 0.0;
            int activeTasks = todoState.todos.where((t) => !t.isDone).length;

            if (roadmap.startDate != null) {
              final start = DateTime.parse(roadmap.startDate!);
              final target = DateTime(2028, 1, 1);
              final now = DateTime.now();

              final totalCalendarDays = target.difference(start).inDays > 0 ? target.difference(start).inDays : 1;
              final dynamicRatio = 360 / totalCalendarDays;

              final daysPassed = now.difference(start).inDays >= 0 ? now.difference(start).inDays : 0;
              paceCar = daysPassed * dynamicRatio;
              delta = roadmap.burnedTokens.length - paceCar;
            }

            Color deltaColor = Colors.white;
            if (delta > 0.5) deltaColor = Theme.of(context).primaryColor;
            if (delta < -0.5) deltaColor = Colors.redAccent;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('JADE || CORE', style: TextStyle(fontSize: 24, letterSpacing: 2, color: Colors.grey)),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 20),

                  // THE DELTA DISPLAY
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                      color: Theme.of(context).cardColor.withValues(alpha: 0.05),
                    ),
                    child: Column(
                      children: [
                        const Text('THE DELTA', style: TextStyle(fontSize: 18, letterSpacing: 4)),
                        Text(
                          roadmap.startDate == null ? 'SETUP REQ' : '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)}',
                          style: TextStyle(
                              fontSize: roadmap.startDate == null ? 40 : 80,
                              fontWeight: FontWeight.bold,
                              color: deltaColor,
                              fontFamily: 'monospace'
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // STATS ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatBox(title: 'BURNED', value: '${roadmap.burnedTokens.length}', color: Theme.of(context).primaryColor),
                      _StatBox(title: 'PACE', value: paceCar.toStringAsFixed(1), color: Colors.white),
                      _StatBox(title: 'TASKS', value: activeTasks.toString(), color: Colors.amber),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /*----------------------------------------------*\
                  |  STATELESS LOGIC ENGINE PANEL                  |
                  \*----------------------------------------------*/
                  _AnalyticsEnginePanel(currentDelta: delta),

                  const SizedBox(height: 40),

                  const Text(
                    '"Don\'t count the days, make the days count."',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _AnalyticsEnginePanel extends StatelessWidget {
  final double currentDelta;
  const _AnalyticsEnginePanel({required this.currentDelta});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        final primary = Theme.of(context).primaryColor;

        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: state.isConnected ? primary.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.3)),
            color: Colors.black.withValues(alpha: 0.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('LOGIC ENGINE ANALYTICS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: state.isConnected ? primary : Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              if (state.isLoading)
                const LinearProgressIndicator(minHeight: 2)
              else ...[
                Text(
                  'SYSTEM STATE: ${state.status}',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: state.status == 'BEHIND PACE' ? Colors.red : (state.status == 'AHEAD OF PACE' ? primary : Colors.amber),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  state.recommendation,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<AnalyticsCubit>().analyzeCurrentPace(
                      delta: currentDelta,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: state.isConnected ? primary : Colors.grey),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('ANALYZE PACE (SERVER)', style: TextStyle(fontFamily: 'monospace', fontSize: 10)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatBox({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color, fontFamily: 'monospace')),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontSize: 8, color: Colors.grey, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }
}

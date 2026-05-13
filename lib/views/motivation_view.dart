import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/roadmap/roadmap_cubit.dart';
import '../models/roadmap_model.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  The psychological core of the app. Calculates |
|  the Delta between real time and token burn.   |
\*----------------------------------------------*/
class MotivationView extends StatelessWidget {
  const MotivationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapCubit, RoadmapData>(
      builder: (context, state) {
        final math = _calculateDelta(state);
        
        final delta = math['delta'] ?? 0.0;
        final paceCar = math['paceCar'] ?? 0.0;
        final daysLeft = math['daysLeft'] ?? 0.0;
        final totalCalendarDays = math['totalCalendarDays'] ?? 1.0;

        final primary = Theme.of(context).primaryColor;
        final isAhead = delta >= 0.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*----------------------------------------------*\
              |  Hacker Header                                 |
              \*----------------------------------------------*/
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'MOTIVATION || ANALYTICS',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primary,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(height: 1, color: Colors.grey.withOpacity(0.2)),
              const SizedBox(height: 40),

              /*----------------------------------------------*\
              |  Quote Section                                 |
              \*----------------------------------------------*/
              const Icon(Icons.format_quote, size: 40, color: Colors.grey),
              const SizedBox(height: 10),
              const Text(
                '"Don\'t count the days,\nmake the days count."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '— Muhammad Ali',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 50),

              /*----------------------------------------------*\
              |  The Delta Display                             |
              \*----------------------------------------------*/
              Text(
                'THE DELTA',
                style: TextStyle(
                  fontFamily: 'monospace',
                  letterSpacing: 4,
                  fontSize: 14,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                (isAhead ? '+' : '') + delta.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: isAhead ? primary : Colors.redAccent,
                  shadows: [
                    Shadow(
                      blurRadius: 20,
                      color: (isAhead ? primary : Colors.redAccent).withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 50),

              /*----------------------------------------------*\
              |  Stats Grid                                    |
              \*----------------------------------------------*/
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                children: [
                  _StatItem(label: 'TOKENS BURNED', value: state.burnedTokens.length.toString()),
                  _StatItem(label: 'PACE CAR', value: paceCar.toStringAsFixed(1)),
                  _StatItem(label: 'DAYS REMAINING', value: daysLeft.toInt().toString()),
                  _StatItem(label: 'TARGET DATE', value: '2028-01-01'),
                ],
              ),

              const SizedBox(height: 30),
              Text(
                'Ratio: 360d work / ${totalCalendarDays.toInt()}d total',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, double> _calculateDelta(RoadmapData state) {
    if (state.startDate == null) {
      return {'delta': 0.0, 'paceCar': 0.0, 'daysLeft': 0.0, 'totalCalendarDays': 1.0};
    }

    final now = DateTime.now();
    final start = DateTime.parse(state.startDate!);
    final target = DateTime(2028, 1, 1);
    
    final totalCalendarDays = target.difference(start).inDays.toDouble();
    if (totalCalendarDays <= 0) return {'delta': 0.0, 'paceCar': 0.0, 'daysLeft': 0.0, 'totalCalendarDays': 1.0};

    final dynamicRatio = 360 / totalCalendarDays;
    final daysPassed = now.difference(start).inDays.toDouble();
    final daysLeft = target.difference(now).inDays.toDouble();

    final paceCar = daysPassed * dynamicRatio;
    final burnedCount = state.burnedTokens.length.toDouble();
    final delta = burnedCount - paceCar;

    return {
      'delta': delta,
      'paceCar': paceCar,
      'daysLeft': daysLeft,
      'totalCalendarDays': totalCalendarDays,
    };
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
        ),
      ],
    );
  }
}

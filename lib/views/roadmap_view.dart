import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/roadmap_cubit.dart';
import '../models/roadmap_model.dart';
import '../cubits/navigation/nav_cubit.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Displays the 12-month overview of the system. |
|  FIXED: Increased grid density for better fit. |
\*----------------------------------------------*/
class RoadmapView extends StatelessWidget {
  const RoadmapView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapCubit, RoadmapData>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*----------------------------------------------*\
              |  Hacker Header                                 |
              \*----------------------------------------------*/
              Text(
                'SYSTEM ROADMAP || 360 DAYS',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 2,
                width: double.infinity,
                color: Theme.of(context).dividerColor,
              ),
              const SizedBox(height: 20),

              /*----------------------------------------------*\
              |  The 12-Month Grid                             |
              |  Switched to 3 columns for desktop/wide.       |
              \*----------------------------------------------*/
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Increased from 2 to 3 for better density
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final monthIndex = index + 1;
                    final monthTokens = state.burnedTokens
                        .where((t) => t.startsWith('m$monthIndex-'))
                        .length;
                    
                    final progress = monthTokens / 30;

                    return _MonthCard(
                      monthIndex: monthIndex,
                      burned: monthTokens,
                      progress: progress,
                      onTap: () {
                        context.read<NavCubit>().changeView(9, extraData: monthIndex);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MonthCard extends StatelessWidget {
  final int monthIndex;
  final int burned;
  final double progress;
  final VoidCallback onTap;

  const _MonthCard({
    required this.monthIndex,
    required this.burned,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          color: Theme.of(context).cardColor.withValues(alpha: 0.1),
        ),
        padding: const EdgeInsets.all(8), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'M${monthIndex.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14, // Smaller font
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.terminal, size: 12, color: primary),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$burned/30',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10, // Smaller font
                    color: burned > 0 ? primary : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(primary),
                    minHeight: 2, // Thinner bar
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

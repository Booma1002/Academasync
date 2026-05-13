import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/roadmap/roadmap_cubit.dart';
import '../cubits/navigation/nav_cubit.dart';
import '../models/roadmap_model.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  The high-density 30-day grid for a specific   |
|  month.                                        |
\*----------------------------------------------*/
class MonthDetailView extends StatelessWidget {
  const MonthDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavCubit, NavState>(
      builder: (context, navState) {
        final monthIndex = navState.extraData as int? ?? 1;

        return BlocBuilder<RoadmapCubit, RoadmapData>(
          builder: (context, roadmapState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*----------------------------------------------*\
                  |  Breadcrumb / Header                           |
                  \*----------------------------------------------*/
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 16),
                        onPressed: () => context.read<NavCubit>().changeView(1),
                        tooltip: 'Back to Roadmap',
                      ),
                      Text(
                        'MONTH ${monthIndex.toString().padLeft(2, '0')} || DETAILED GRID',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /*----------------------------------------------*\
                  |  30-Day Grid                                   |
                  \*----------------------------------------------*/
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        final dayIndex = index + 1;
                        final tokenId = 'm$monthIndex-d$dayIndex';
                        final isBurned = roadmapState.burnedTokens.contains(tokenId);

                        return _DayBox(
                          dayIndex: dayIndex,
                          isBurned: isBurned,
                          onTap: () {
                            context.read<RoadmapCubit>().toggleToken(tokenId);
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
      },
    );
  }
}

class _DayBox extends StatefulWidget {
  final int dayIndex;
  final bool isBurned;
  final VoidCallback onTap;

  const _DayBox({
    required this.dayIndex,
    required this.isBurned,
    required this.onTap,
  });

  @override
  State<_DayBox> createState() => _DayBoxState();
}

class _DayBoxState extends State<_DayBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0).then((_) => _controller.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        /*----------------------------------------------*\
        |  Simple shake/shock effect logic               |
        \*----------------------------------------------*/
        final dx = (0.5 - _controller.value).abs() * 10 * (widget.isBurned ? -1 : 1);
        
        return Transform.translate(
          offset: Offset(dx, 0),
          child: child,
        );
      },
      child: InkWell(
        onTap: _handleTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.isBurned ? primary : Colors.grey.withOpacity(0.3),
              width: widget.isBurned ? 2 : 1,
            ),
            color: widget.isBurned 
                ? primary.withOpacity(0.2) 
                : Colors.transparent,
          ),
          child: Center(
            child: Text(
              widget.dayIndex.toString(),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.isBurned ? primary : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

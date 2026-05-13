import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/navigation/nav_cubit.dart';

/*----------------------------------------------*\
|  The main 4-tab bar at the bottom of the       |
|  screen.                                       |
\*----------------------------------------------*/
class CoreBottomNav extends StatelessWidget {
  const CoreBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    /*----------------------------------------------*\
    |  Listens to the current index to highlight     |
    |  the active tab.                               |
    \*----------------------------------------------*/
    return BlocBuilder<NavCubit, NavState>(
      builder: (context, state) {
        final currentIndex = state.currentIndex;
        /*----------------------------------------------*\
        |  Hide the bottom nav entirely if we are on a   |
        |  Drawer page (index > 3) or special view.      |
        \*----------------------------------------------*/
        if (currentIndex > 3) return const SizedBox.shrink();

        return BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          /*----------------------------------------------*\
          |  Triggers the cubit to swap the view without   |
          |  using setState.                               |
          \*----------------------------------------------*/
          onTap: (index) => context.read<NavCubit>().changeView(index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Core'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_view_month), label: 'Roadmap'),
            BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Chrono'),
            BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Todo DB'),
          ],
        );
      },
    );
  }
}
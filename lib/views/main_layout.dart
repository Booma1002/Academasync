// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubits/navigation/nav_cubit.dart';
// import '../widgets/core_bottom_nav.dart';
// import '../widgets/core_drawer.dart';
// import 'dashboard_view.dart';
// import 'roadmap_view.dart';
// import 'chrono_view.dart';
// import 'todo_view.dart';
// import 'audio_engine_view.dart';
import 'motivation_view.dart';
import 'launchpad_view.dart';
import 'data_ops_view.dart';
// import 'launchpad_view.dart';
// import 'motivation_view.dart';
// import 'data_ops_view.dart';
// import 'settings_view.dart';
// import 'month_detail_view.dart';
//
// /*----------------------------------------------*\
// |  <Sla7ef (2Z2H1G)>                             |
// |  The skeleton frame that persists while the    |
// |  internal body swaps out.                      |
// \*----------------------------------------------*/
// class MainLayout extends StatelessWidget {
//   const MainLayout({super.key});
//
//   /*----------------------------------------------*\
//   |  Map integer states (0-9) to actual screen     |
//   |  widgets.                                      |
//   \*----------------------------------------------*/
//   final List<Widget> _views = const [
//     Center(child: Text('Dashboard View')), // 0
//     Center(child: Text('Roadmap View')),   // 1
//     Center(child: Text('Chrono View')),    // 2
//     Center(child: Text('Todo View')),      // 3
//     Center(child: Text('Audio Engine')),   // 4
//     Center(child: Text('Launchpad')),      // 5
//     Center(child: Text('Motivation')),     // 6
//     Center(child: Text('Data Ops')),       // 7
//     Center(child: Text('Settings')),       // 8
//     Center(child: Text('Month Detail')),   // 9
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('JADE || CORE', style: TextStyle(letterSpacing: 2)),
//         elevation: 0,
//         /*----------------------------------------------*\
//         |  Looks cleaner with dark/cyber themes.         |
//         \*----------------------------------------------*/
//         backgroundColor: Colors.transparent,
//       ),
//       /*----------------------------------------------*\
//       |  Rebuilds ONLY the body when the NavCubit      |
//       |  emits a new integer.                          |
//       \*----------------------------------------------*/
//       drawer: const CoreDrawer(),
//       body: BlocBuilder<NavCubit, int>(
//         builder: (context, currentIndex) {
//           return _views[currentIndex];
//         },
//       ),
//       bottomNavigationBar: const CoreBottomNav(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/navigation/nav_cubit.dart';
import '../widgets/core_bottom_nav.dart';
import '../widgets/core_drawer.dart';

// The actual UI engines we have built
import 'dashboard_view.dart';
import 'chrono_view.dart';
import 'todo_view.dart';
import 'settings_view.dart';
import 'roadmap_view.dart';
import 'month_detail_view.dart';
import 'audio_engine_view.dart';
import 'motivation_view.dart';
import 'launchpad_view.dart';
import 'data_ops_view.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  The skeleton frame that persists while the    |
|  internal body swaps out.                      |
\*----------------------------------------------*/
class MainLayout extends StatelessWidget {
  MainLayout({super.key}); // Removed const so we can hold dynamic views

  /*----------------------------------------------*\
  |  Map integer states (0-9) to actual screens.   |
  |  The list itself is NOT const anymore!         |
  \*----------------------------------------------*/
  final List<Widget> _views = [
    const DashboardView(),                       // 0: Core
    const RoadmapView(),                         // 1: Roadmap
    const ChronoView(),                          // 2: Chrono
    TodoView(),                                  // 3: Todo DB (Not const)
    const AudioEngineView(),                     // 4: Drawer 1
    LaunchpadView(),                       // 5: Drawer 2
    const MotivationView(),                      // 6: Drawer 3
    const DataOpsView(),                         // 7: Drawer 4
    const SettingsView(),                        // 8: Drawer 5
    const MonthDetailView(),                     // 9: Hidden push route
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JADE || CORE', style: TextStyle(letterSpacing: 2)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () => context.read<NavCubit>().changeView(0),
            tooltip: 'Dashboard',
          ),
        ],
      ),
      drawer: const CoreDrawer(),
      body: BlocBuilder<NavCubit, NavState>(
        builder: (context, state) {
          return _views[state.currentIndex];
        },
      ),
      bottomNavigationBar: const CoreBottomNav(),
    );
  }
}
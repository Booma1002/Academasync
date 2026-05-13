import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/storage_service.dart';
import 'cubits/theme/theme_cubit.dart';
import 'cubits/navigation/nav_cubit.dart';
import 'cubits/todo/todo_cubit.dart';
import 'cubits/chrono/chrono_cubit.dart';
import 'cubits/roadmap/roadmap_cubit.dart';
import 'cubits/audio/audio_cubit.dart';
import 'cubits/analytics/analytics_cubit.dart';
import 'views/main_layout.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  The async main function allows us to read     |
|  from the disk before the UI boots.            |
\*----------------------------------------------*/
void main() async {
  /*----------------------------------------------*\
  |  Required by Flutter when executing native     |
  |  code (like shared_prefs) before runApp.       |
  \*----------------------------------------------*/
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  await storage.init();

  runApp(JadeCoreApp(storage: storage));
}

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Injects all state engines at the highest      |
|  level so any widget can access them.          |
\*----------------------------------------------*/
class JadeCoreApp extends StatelessWidget {
  final StorageService storage;

  const JadeCoreApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(storage)),
        BlocProvider(create: (_) => NavCubit()),
        BlocProvider(create: (_) => TodoCubit(storage)),
        BlocProvider(create: (_) => ChronoCubit()),
        BlocProvider(create: (_) => RoadmapCubit(storage)),
        BlocProvider(create: (_) => AudioCubit()),
        BlocProvider(create: (_) => AnalyticsCubit()),
      ],
      /*----------------------------------------------*\
      |  BlocBuilder listens to ThemeCubit to repaint  |
      |  the entire app when cycled.                   |
      \*----------------------------------------------*/
      child: BlocBuilder<ThemeCubit, String>(
        builder: (context, themeName) {
          return MaterialApp(
            title: 'JADE || CORE',
            theme: _getTheme(themeName),
            home: MainLayout(),
            /*----------------------------------------------*\
            |  Hides the debug banner.                       |
            \*----------------------------------------------*/
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  /*----------------------------------------------*\
  |  A custom mapper to turn string states         |
  |  into actual Flutter ThemeData.                |
  \*----------------------------------------------*/
  ThemeData _getTheme(String themeName) {
    if (themeName == 'light') return ThemeData.light();
    if (themeName == 'cyber') {
      return ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A2A),
        primaryColor: const Color(0xFFFF00FF),
        colorScheme: const ColorScheme.dark(primary: Color(0xFFFF00FF)),
      );
    }
    /*----------------------------------------------*\
    |  Default Dark Theme                            |
    \*----------------------------------------------*/
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      primaryColor: const Color(0xFF00FF41),
      colorScheme: const ColorScheme.dark(primary: Color(0xFF00FF41)),
    );
  }
}

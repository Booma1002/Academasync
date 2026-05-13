import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/roadmap_cubit.dart';
import '../cubits/theme/theme_cubit.dart';
import '../models/roadmap_model.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('SYSTEM SETTINGS', style: TextStyle(fontSize: 24, letterSpacing: 2, color: Colors.grey)),
          const Divider(color: Colors.grey),
          const SizedBox(height: 20),

          /*----------------------------------------------*\
          |  <Sla7ef (2Z2H1G)>                             |
          |  THEME OVERRIDE                                |
          \*----------------------------------------------*/
          ListTile(
            title: const Text('CYCLE THEME', style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.palette, color: Theme.of(context).primaryColor),
            tileColor: Colors.black.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            /*----------------------------------------------*\
            |  Triggers the global theme rebuild             |
            \*----------------------------------------------*/
            onTap: () => context.read<ThemeCubit>().cycleTheme(),
          ),

          const SizedBox(height: 20),

          /*----------------------------------------------*\
          |  <Sla7ef (2Z2H1G)>                             |
          |  ROADMAP INITIALIZATION                        |
          \*----------------------------------------------*/
          BlocBuilder<RoadmapCubit, RoadmapData>(
            builder: (context, roadmap) {
              final hasDate = roadmap.startDate != null;
              final displayDate = hasDate ? roadmap.startDate!.split('T')[0] : 'NOT SET';

              return ListTile(
                title: const Text('SET START DATE', style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                subtitle: Text('Current: $displayDate', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'monospace')),
                trailing: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                tileColor: Colors.black.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
                onTap: () async {
                  /*----------------------------------------------*\
                  |  Halts execution until user picks a date       |
                  \*----------------------------------------------*/
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2028),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: Theme.of(context).primaryColor,
                            onPrimary: Colors.black,
                            surface: Theme.of(context).scaffoldBackgroundColor,
                            onSurface: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (picked != null) {
                    /*----------------------------------------------*\
                    |  Fires event to Cubit, saves to flash mem      |
                    \*----------------------------------------------*/
                    context.read<RoadmapCubit>().setStartDate(picked);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
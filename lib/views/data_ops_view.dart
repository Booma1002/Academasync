import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../services/storage_service.dart';
import '../cubits/roadmap/roadmap_cubit.dart';
import '../cubits/todo/todo_cubit.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  The data maintenance panel for JADE || CORE.  |
|  FIXED: Android-safe export using Share Sheet. |
\*----------------------------------------------*/
class DataOpsView extends StatelessWidget {
  const DataOpsView({super.key});

  Future<void> _exportData(BuildContext context) async {
    try {
      final storage = StorageService();
      final jsonString = storage.exportFullState();
      
      // 1. Get the safe internal sandbox directory (Android/iOS safe)
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/jade_backup.json');
      
      // 2. Write the JSON to the sandbox
      await file.writeAsString(jsonString);

      // 3. Trigger the native Share Sheet to extract it
      if (context.mounted) {
        await Share.shareXFiles(
          [XFile(file.path, mimeType: 'application/json')], 
          text: 'JADE || CORE Backup JSON'
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('BACKUP READY FOR EXPORT')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('EXPORT ERROR: $e')),
        );
      }
    }
  }

  Future<void> _importData(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        
        await StorageService().importFullState(content);
        
        if (context.mounted) {
          context.read<RoadmapCubit>().refresh();
          context.read<TodoCubit>().refresh();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SYSTEM RESTORED: DATA LOADED')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('RESTORE FAILED: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DATA OPERATIONS || OPS',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 5),
          Container(height: 1, color: Colors.grey.withValues(alpha: 0.3)),
          const SizedBox(height: 40),

          _OpsCard(
            title: 'BACKUP DATA',
            description: 'Save your progress via the system share sheet.',
            icon: Icons.share,
            color: primary,
            onTap: () => _exportData(context),
          ),
          const SizedBox(height: 20),

          _OpsCard(
            title: 'LOAD FROM DISK',
            description: 'Restore progress from a backup file.',
            icon: Icons.file_open,
            color: Colors.blueAccent,
            onTap: () => _importData(context),
          ),
          const SizedBox(height: 40),

          const Text(
            'DANGER ZONE',
            style: TextStyle(color: Colors.redAccent, fontFamily: 'monospace', fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _OpsCard(
            title: 'WIPE ALL DATA',
            description: 'PERMANENTLY purge the local database.',
            icon: Icons.delete_forever,
            color: Colors.redAccent,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF111111),
                  title: const Text('PURGE SYSTEM?'),
                  content: const Text('All local tokens and tasks will be erased.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('PURGE', style: TextStyle(color: Colors.red))),
                  ],
                ),
              );
              if (confirm == true) {
                await StorageService().wipeData();
                if (context.mounted) {
                   context.read<RoadmapCubit>().refresh();
                   context.read<TodoCubit>().refresh();
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SYSTEM PURGED')));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _OpsCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _OpsCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.5)),
          color: color.withValues(alpha: 0.05),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 11, color: Colors.grey.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

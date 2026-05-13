import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import '../services/storage_service.dart';
import '../cubits/roadmap_cubit.dart';
import '../cubits/todo/todo_cubit.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  FIXED: Switching to official file_selector    |
|  to fix Windows Explorer crashes.              |
\*----------------------------------------------*/
class DataOpsView extends StatelessWidget {
  const DataOpsView({super.key});

  Future<void> _exportData(BuildContext context) async {
    try {
      final storage = StorageService();
      final jsonString = storage.exportFullState();
      
      // Define location and name suggestions
      const String fileName = 'jade_backup.json';
      final FileSaveLocation? result = await getSaveLocation(
        suggestedName: fileName,
        acceptedTypeGroups: [
          const XTypeGroup(label: 'JSON', extensions: ['json']),
        ],
      );

      if (result == null) return; // User cancelled

      // Manual write using dart:io for maximum stability
      final File file = File(result.path);
      await file.writeAsString(jsonString);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('BACKUP SAVED TO DISK')),
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
        
        // Flexible import call
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
        // Show actual error details to help debug the JSON structure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('RESTORE FAILED: $e')),
        );
        debugPrint('Import Error: $e');
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
            title: 'SAVE TO DISK',
            description: 'Export all state to a backup file.',
            icon: Icons.save_alt,
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

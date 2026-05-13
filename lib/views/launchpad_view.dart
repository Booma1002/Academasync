import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/backend_service.dart';
/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Mission Control for external apps and tools.  |
\*----------------------------------------------*/
class LaunchpadView extends StatelessWidget {
  LaunchpadView({super.key});

  final BackendService _backend = BackendService();

  Future<void> _triggerBackendLaunch(BuildContext context, String target) async {
    // Show a loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Triggering $target on Host OS...'), duration: const Duration(seconds: 1)),
    );

    final success = await _backend.launchSystemTool(target);

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Launch Failed. Check Network or Server Logs.', style: TextStyle(color: Colors.red))),
      );
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
          /*----------------------------------------------*\
          |  Header                                        |
          \*----------------------------------------------*/
          Text(
            'SYSTEM LAUNCHPAD || TOOLS',
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
          const SizedBox(height: 30),

          /*----------------------------------------------*\
          |  Launcher Grid                                 |
          \*----------------------------------------------*/
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.3,
              children: [
                _LaunchButton(
                  title: 'CODE BASE',
                  subtitle: 'VS CODE',
                  icon: Icons.code,
                  color: primary,
                  onTap: () => _triggerBackendLaunch(context, 'code'),
                ),
                _LaunchButton(
                  title: 'ML RIZZ',
                  subtitle: 'LOCAL FOLDER',
                  icon: Icons.folder_open,
                  color: Colors.blueAccent,
                  onTap: () => _triggerBackendLaunch(context, 'mlrizz'),
                ),
                _LaunchButton(
                  title: 'REC',
                  subtitle: 'OBS STUDIO',
                  icon: Icons.videocam,
                  color: Colors.redAccent,
                  onTap: () => _triggerBackendLaunch(context, 'obs'),
                ),
                _LaunchButton(
                  title: 'GEMINI',
                  subtitle: 'AI BRAIN',
                  icon: Icons.psychology,
                  color: const Color(0xFF8AB4F8),
                  onTap: () => launchUrl(Uri.parse('https://gemini.google.com/app')),
                ),
              ],
            ),
          ),

          /*----------------------------------------------*\
          |  Footer Note                                   |
          \*----------------------------------------------*/
          Center(
            child: Text(
              'External apps require URI protocol registration.',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: Colors.grey.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LaunchButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _LaunchButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
          color: color.withValues(alpha: 0.05),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: Colors.grey.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

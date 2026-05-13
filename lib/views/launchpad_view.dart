import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Mission Control for external apps and tools.  |
\*----------------------------------------------*/
class LaunchpadView extends StatelessWidget {
  const LaunchpadView({super.key});

  Future<void> _launch(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      // In a real app, we might show a snackbar here
      debugPrint('Could not launch $urlString');
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
                  onTap: () => _launch('jade://'),
                ),
                _LaunchButton(
                  title: 'ML RIZZ',
                  subtitle: 'LOCAL FOLDER',
                  icon: Icons.folder_open,
                  color: Colors.blueAccent,
                  onTap: () => _launch('mlrizz://'),
                ),
                _LaunchButton(
                  title: 'REC',
                  subtitle: 'OBS STUDIO',
                  icon: Icons.videocam,
                  color: Colors.redAccent,
                  onTap: () => _launch('obs://'),
                ),
                _LaunchButton(
                  title: 'GEMINI',
                  subtitle: 'AI BRAIN',
                  icon: Icons.psychology,
                  color: const Color(0xFF8AB4F8),
                  onTap: () => _launch('https://gemini.google.com/app'),
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

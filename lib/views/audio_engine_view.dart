import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/audio_cubit.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Controls for System Noise and MP3 Playback.   |
|  FIXED: Added SingleChildScrollView to prevent |
|  overflow on smaller screens.                  |
\*----------------------------------------------*/
class AudioEngineView extends StatelessWidget {
  const AudioEngineView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        final primary = Theme.of(context).primaryColor;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*----------------------------------------------*\
              |  Header                                        |
              \*----------------------------------------------*/
              Text(
                'AUDIO ENGINE || CORE',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 5),
              Container(height: 1, color: Colors.grey.withValues(alpha: 0.3)),
              const SizedBox(height: 30),

              /*----------------------------------------------*\
              |  SYSTEM NOISE SECTION                          |
              \*----------------------------------------------*/
              _SectionHeader(title: 'SYSTEM NOISE', icon: Icons.waves),
              const SizedBox(height: 15),
              _AudioControlRow(
                isActive: state.isNoisePlaying,
                title: 'Background Hum',
                volume: state.noiseVolume,
                onToggle: () => context.read<AudioCubit>().toggleNoise(),
                onVolumeChanged: (val) => context.read<AudioCubit>().setNoiseVolume(val),
              ),

              const SizedBox(height: 40),

              /*----------------------------------------------*\
              |  MP3 / QURAN SECTION                           |
              \*----------------------------------------------*/
              _SectionHeader(title: 'LOCAL PLAYER', icon: Icons.library_music),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  color: Theme.of(context).cardColor.withValues(alpha: 0.05),
                ),
                child: Column(
                  children: [
                    Text(
                      state.currentTrackName ?? 'NO TRACK LOADED',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: state.isMusicPlaying ? primary : Colors.grey,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            state.isMusicPlaying ? Icons.pause_circle : Icons.play_circle,
                            size: 48,
                            color: primary,
                          ),
                          onPressed: () => context.read<AudioCubit>().toggleMusic(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, size: 32),
                          onPressed: () => context.read<AudioCubit>().nextTrack(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: state.musicVolume,
                      activeColor: primary,
                      inactiveColor: Colors.grey.withValues(alpha: 0.2),
                      onChanged: (val) => context.read<AudioCubit>().setMusicVolume(val),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.folder_open),
                      label: const Text('LOAD FOLDER / MP3s', style: TextStyle(fontFamily: 'monospace')),
                      onPressed: () => context.read<AudioCubit>().loadPlaylist(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.withValues(alpha: 0.5)),
                      ),
                    ),
                  ],
                ),
              ),
              
              if (state.playlist.isNotEmpty) ...[
                const SizedBox(height: 15),
                Text(
                  'Playlist: ${state.playlist.length} files detected',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _AudioControlRow extends StatelessWidget {
  final bool isActive;
  final String title;
  final double volume;
  final VoidCallback onToggle;
  final ValueChanged<double> onVolumeChanged;

  const _AudioControlRow({
    required this.isActive,
    required this.title,
    required this.volume,
    required this.onToggle,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Row(
      children: [
        IconButton(
          icon: Icon(
            isActive ? Icons.volume_up : Icons.volume_off,
            color: isActive ? primary : Colors.grey,
          ),
          onPressed: onToggle,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              Slider(
                value: volume,
                activeColor: primary,
                inactiveColor: Colors.grey.withValues(alpha: 0.2),
                onChanged: onVolumeChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

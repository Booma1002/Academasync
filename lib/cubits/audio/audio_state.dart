import 'package:file_picker/file_picker.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  State class for the Audio Engine.             |
\*----------------------------------------------*/
class AudioState {
  final bool isNoisePlaying;
  final double noiseVolume;
  final bool isMusicPlaying;
  final double musicVolume;
  final String? currentTrackName;
  final List<PlatformFile> playlist;

  const AudioState({
    this.isNoisePlaying = false,
    this.noiseVolume = 0.5,
    this.isMusicPlaying = false,
    this.musicVolume = 0.5,
    this.currentTrackName,
    this.playlist = const [],
  });

  AudioState copyWith({
    bool? isNoisePlaying,
    double? noiseVolume,
    bool? isMusicPlaying,
    double? musicVolume,
    String? currentTrackName,
    List<PlatformFile>? playlist,
  }) {
    return AudioState(
      isNoisePlaying: isNoisePlaying ?? this.isNoisePlaying,
      noiseVolume: noiseVolume ?? this.noiseVolume,
      isMusicPlaying: isMusicPlaying ?? this.isMusicPlaying,
      musicVolume: musicVolume ?? this.musicVolume,
      currentTrackName: currentTrackName ?? this.currentTrackName,
      playlist: playlist ?? this.playlist,
    );
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:math';

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

class AudioCubit extends Cubit<AudioState> {
  final AudioPlayer _noisePlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();
  
  AudioCubit() : super(const AudioState()) {
    /*----------------------------------------------*\
    |  Setting up loops and volume listeners         |
    \*----------------------------------------------*/
    _noisePlayer.setReleaseMode(ReleaseMode.loop);
    _musicPlayer.onPlayerComplete.listen((_) {
      _playRandomFromPlaylist();
    });
  }

  /*----------------------------------------------*\
  |  Noise Controls (System Hum)                   |
  \*----------------------------------------------*/
  void toggleNoise() async {
    if (state.isNoisePlaying) {
      await _noisePlayer.stop();
    } else {
      /*----------------------------------------------*\
      |  In the HTML version, this uses an oscillator  |
      |  or a static white noise generator.            |
      |  In Flutter, we play a local looping asset.    |
      \*----------------------------------------------*/
      try {
        await _noisePlayer.setVolume(state.noiseVolume);
        // Note: Requires 'assets/audio/system_hum.mp3' in pubspec.yaml
        await _noisePlayer.play(AssetSource('audio/system_hum.mp3'));
      } catch (e) {
        // Fallback for missing asset during development
        print('Hum Error: $e');
      }
    }
    emit(state.copyWith(isNoisePlaying: !state.isNoisePlaying));
  }

  void setNoiseVolume(double volume) {
    _noisePlayer.setVolume(volume);
    emit(state.copyWith(noiseVolume: volume));
  }

  /*----------------------------------------------*\
  |  Music/Quran Controls                          |
  \*----------------------------------------------*/
  void loadPlaylist() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );

    if (result != null) {
      emit(state.copyWith(playlist: result.files));
      _playRandomFromPlaylist();
    }
  }

  void _playRandomFromPlaylist() async {
    if (state.playlist.isEmpty) return;
    
    final random = Random();
    final file = state.playlist[random.nextInt(state.playlist.length)];
    
    if (file.path != null) {
      await _musicPlayer.play(DeviceFileSource(file.path!));
      await _musicPlayer.setVolume(state.musicVolume);
      emit(state.copyWith(
        isMusicPlaying: true,
        currentTrackName: file.name,
      ));
    }
  }

  void toggleMusic() async {
    if (state.isMusicPlaying) {
      await _musicPlayer.pause();
    } else {
      if (state.playlist.isNotEmpty) {
        await _musicPlayer.resume();
      } else {
        loadPlaylist();
        return;
      }
    }
    emit(state.copyWith(isMusicPlaying: !state.isMusicPlaying));
  }

  void setMusicVolume(double volume) {
    _musicPlayer.setVolume(volume);
    emit(state.copyWith(musicVolume: volume));
  }

  void nextTrack() {
    _playRandomFromPlaylist();
  }

  @override
  Future<void> close() {
    _noisePlayer.dispose();
    _musicPlayer.dispose();
    return super.close();
  }
}

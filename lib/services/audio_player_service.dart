import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../models/track.dart';

class AudioPlayerService {
  AudioPlayerService();

  final AudioPlayer _player = AudioPlayer();
  final ConcatenatingAudioSource _playlist =
      ConcatenatingAudioSource(children: []);

  List<Track> _tracks = const [];
  bool _initialized = false;

  AudioPlayer get player => _player;

  List<Track> get tracks => _tracks;

  LoopMode get repeatMode => _player.loopMode;

  bool get isShuffling => _player.shuffleModeEnabled;

  Future<void> initialize(List<Track> tracks) async {
    _tracks = tracks;
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _playlist.clear();
    for (final track in tracks) {
      _playlist.add(
        AudioSource.asset(
          track.assetPath,
          tag: MediaItem(
            id: track.id,
            title: track.title,
            artist: track.artist,
            album: track.category,
            artUri: Uri.parse('asset://${track.imagePath}'),
          ),
        ),
      );
    }

    await _player.setAudioSource(_playlist);
    _initialized = true;
  }

  Future<void> playTrack(Track track) async {
    if (!_initialized) return;
    final index = _tracks.indexWhere((t) => t.id == track.id);
    if (index == -1) return;
    await _player.seek(Duration.zero, index: index);
    await _player.play();
  }

  Future<void> play() => _player.play();

  Future<void> pause() => _player.pause();

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> next() async {
    if (!_player.hasNext) return;
    await _player.seekToNext();
    await _player.play();
  }

  Future<void> previous() async {
    if (!_player.hasPrevious) return;
    await _player.seekToPrevious();
    await _player.play();
  }

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> setShuffle(bool enabled) async {
    await _player.setShuffleModeEnabled(enabled);
    if (enabled) {
      await _player.shuffle();
    }
  }

  Future<void> cycleRepeatMode() async {
    switch (_player.loopMode) {
      case LoopMode.off:
        await _player.setLoopMode(LoopMode.all);
        break;
      case LoopMode.all:
        await _player.setLoopMode(LoopMode.one);
        break;
      case LoopMode.one:
        await _player.setLoopMode(LoopMode.off);
        break;
    }
  }

  void dispose() {
    _player.dispose();
  }
}


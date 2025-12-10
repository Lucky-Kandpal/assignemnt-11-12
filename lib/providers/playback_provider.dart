import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../models/track.dart';
import '../services/audio_player_service.dart';

class PlaybackProvider extends ChangeNotifier {
  PlaybackProvider(this._service, this.tracks);

  final AudioPlayerService _service;
  final List<Track> tracks;

  late final AudioPlayer _player = _service.player;

  Track? _currentTrack;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLoading = false;

  StreamSubscription<int?>? _indexSub;
  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<bool>? _shuffleSub;
  StreamSubscription<LoopMode>? _loopSub;
  StreamSubscription<SequenceState?>? _sequenceSub;

  Track? get currentTrack => _currentTrack;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isPlaying => _player.playing;
  bool get isShuffling => _player.shuffleModeEnabled;
  LoopMode get repeatMode => _player.loopMode;
  bool get isLoading => _isLoading;
  bool get hasNext => _player.hasNext;
  bool get hasPrevious => _player.hasPrevious;

  bool get shouldShowMiniPlayer => _currentTrack != null;

  Future<void> init() async {
    await _service.initialize(tracks);

    _indexSub = _player.currentIndexStream.listen((index) {
      if (index == null || index < 0 || index >= tracks.length) return;
      _currentTrack = tracks[index];
      notifyListeners();
    });

    _stateSub = _player.playerStateStream.listen((state) {
      _isLoading = state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering;
      notifyListeners();
    });

    _durationSub = _player.durationStream.listen((d) {
      if (d != null) {
        _duration = d;
        notifyListeners();
      }
    });

    _sequenceSub = _player.sequenceStateStream.listen((state) {
      final newDuration = state?.currentSource?.duration;
      if (newDuration != null) {
        _duration = newDuration;
        notifyListeners();
      }
    });

    _positionSub = _player.positionStream.listen((p) {
      _position = p;
      notifyListeners();
    });

    _shuffleSub = _player.shuffleModeEnabledStream.listen((_) {
      notifyListeners();
    });

    _loopSub = _player.loopModeStream.listen((_) {
      notifyListeners();
    });
  }

  Future<void> playTrack(Track track) => _service.playTrack(track);

  Future<void> togglePlayPause() => _service.togglePlayPause();

  Future<void> play() => _service.play();

  Future<void> pause() => _service.pause();

  Future<void> next() => _service.next();

  Future<void> previous() => _service.previous();

  Future<void> seek(Duration position) => _service.seek(position);

  Future<void> toggleShuffle() => _service.setShuffle(!isShuffling);

  Future<void> cycleRepeatMode() => _service.cycleRepeatMode();

  @override
  void dispose() {
    _indexSub?.cancel();
    _stateSub?.cancel();
    _durationSub?.cancel();
    _positionSub?.cancel();
    _shuffleSub?.cancel();
    _loopSub?.cancel();
    _sequenceSub?.cancel();
    _service.dispose();
    super.dispose();
  }
}


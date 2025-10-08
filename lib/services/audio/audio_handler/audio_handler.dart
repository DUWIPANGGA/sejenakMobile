import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class SejenakAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  final _completer = Completer<void>();
  bool _isDisposed = false;

  SejenakAudioHandler() {
    _init().then((_) => _completer.complete());
  }

  Future<void> get initialized => _completer.future;

  // Custom dispose method since BaseAudioHandler doesn't have one
  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    await _player.dispose();
    // Don't call super.dispose() as it doesn't exist
  }

  Future<void> _init() async {
    try {
      // Configure audio session for playback
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      // Listen to player state changes
      _player.playbackEventStream.listen(_broadcastPlaybackState);

      // Setup player event forwarding
      _player.positionStream.listen((position) {
        if (_isDisposed) return;
        final oldState = playbackState.value;
        playbackState.add(
          oldState.copyWith(
            updatePosition: position,
          ),
        );
      });

      _player.durationStream.listen((duration) {
        if (_isDisposed) return;
        final currentItem = mediaItem.value;
        if (currentItem != null) {
          mediaItem.add(currentItem.copyWith(duration: duration));
        }
      });

      _player.currentIndexStream.listen((index) {
        // Handle playlist index changes if needed
      });

      print('✅ SejenakAudioHandler initialized successfully');
    } catch (e) {
      print('❌ Error initializing SejenakAudioHandler: $e');
      rethrow;
    }
  }

  void _broadcastPlaybackState(PlaybackEvent event) {
    if (_isDisposed) return;
    
    final playing = _player.playing;
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    ));
  }

  /// Play audio from URL
  @override
  Future<void> play() {
    if (_isDisposed) return Future.value();
    return _player.play();
  }

  @override
  Future<void> pause() {
    if (_isDisposed) return Future.value();
    return _player.pause();
  }

  @override
  Future<void> stop() {
    if (_isDisposed) return Future.value();
    return _player.stop();
  }

  @override
  Future<void> seek(Duration position) {
    if (_isDisposed) return Future.value();
    return _player.seek(position);
  }

  @override
  Future<void> skipToNext() {
    if (_isDisposed) return Future.value();
    return _player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() {
    if (_isDisposed) return Future.value();
    return _player.seekToPrevious();
  }

  /// Custom method untuk play dari URL
  Future<void> playFromUrl(String url, String title) async {
    if (_isDisposed) {
      throw Exception('AudioHandler has been disposed');
    }

    try {
      // Wait for initialization to complete
      await initialized;

      // Set media item untuk notifikasi
      mediaItem.add(MediaItem(
        id: url,
        album: "Sejenak Meditation",
        title: title,
        artist: "Sejenak",
        artUri: Uri.parse("https://example.com/meditation.jpg"),
      ));

      // Stop current playback
      await _player.stop();
      
      // Set audio source
      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));

      // Start playing
      await _player.play();
    } catch (e) {
      print('❌ Error playing audio: $e');
      throw e;
    }
  }

  /// Cleanup resources - override audio_service lifecycle methods
  @override
  Future<void> onTaskRemoved() async {
    await dispose();
    return super.onTaskRemoved();
  }

  @override
  Future<void> onClose() async {
    await dispose();
    return onClose();
  }
}
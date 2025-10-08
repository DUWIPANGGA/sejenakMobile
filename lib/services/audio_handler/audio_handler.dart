import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class SejenakAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);

  SejenakAudioHandler() {
    _init();
  }
  Future<void> dispose() async {
    await _player.dispose();
  }

  Future<void> _init() async {
    // Configure audio session for playback
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    // Listen to player state changes
    _player.playbackEventStream.listen(_broadcastPlaybackState);

    // Setup player event forwarding
    _player.positionStream.listen((position) {
      final oldState = playbackState.value;
      playbackState.add(
        oldState.copyWith(
          updatePosition: position, // Bukan `position`
        ),
      );
    });
    

    // ✅ Getter untuk UI

    _player.durationStream.listen((duration) {
      mediaItem.add(mediaItem.value?.copyWith(duration: duration));
    });

    _player.currentIndexStream.listen((index) {
      if (index != null) {
        // Update media item if needed
      }
    });
  }
final _playbackStateController = BehaviorSubject<PlaybackState>.seeded(
      PlaybackState(
        controls: [],
        playing: false,
        processingState: AudioProcessingState.idle,
      ),
    );
  Stream<PlaybackState> get playbackStateStream {
    return _playbackStateController.stream;
  }

  void _broadcastPlaybackState(PlaybackEvent event) {
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
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await _player.dispose();
    return super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  /// Custom method untuk play dari URL
  Future<void> playFromUrl(String url, String title) async {
    try {
      // Set media item untuk notifikasi
      mediaItem.add(MediaItem(
        id: url,
        album: "Sejenak Meditation",
        title: title,
        artist: "Sejenak",
        artUri: Uri.parse("https://example.com/meditation.jpg"),
      ));

      // Set audio source
      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));

      // Start playing
      await _player.play();
    } catch (e) {
      print('❌ Error playing audio: $e');
      throw e;
    }
  }

  /// Custom method untuk mengatur playlist
  Future<void> setPlaylist(List<MediaItem> items) async {
    final audioSources = items
        .map((item) => AudioSource.uri(
              Uri.parse(item.id),
              tag: item,
            ))
        .toList();

    await _player.setAudioSource(
      ConcatenatingAudioSource(children: audioSources),
    );
  }

  // Cleanup resources
  @override
  Future<void> onTaskRemoved() async {
    await _player.dispose();
    return super.onTaskRemoved();
  }

  @override
  Future<void> onClose() async {
    await _player.dispose();
  }
}

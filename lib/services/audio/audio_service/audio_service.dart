import 'package:audio_service/audio_service.dart';
import 'package:selena/models/meditation_models/meditation_models.dart';
import 'package:selena/services/api.dart';
import 'package:selena/services/audio/audio_handler/audio_handler.dart';
class MeditationService {
  final DioHttpClient _httpClient = DioHttpClient.getInstance();
  late final SejenakAudioHandler _audioHandler; // <-- jangan di-initialize di sini
  bool _isAudioHandlerInitialized = false;

  MeditationService._(); // private constructor

  static Future<MeditationService> create() async {
    final service = MeditationService._();
    await service._initAudioHandler();
    return service;
  }

  Future<void> _initAudioHandler() async {
    try {
      _audioHandler = await AudioService.init(
        builder: () => SejenakAudioHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.sejenak.selena.audio',
          androidNotificationChannelName: 'Sejenak Meditation',
          androidNotificationOngoing: true,
        ),
      );
      _isAudioHandlerInitialized = true;
      print('✅ AudioHandler initialized successfully');
    } catch (e) {
      print('❌ Error initializing AudioHandler: $e');
      _isAudioHandlerInitialized = false;
    }
  }

  /// Ambil list audio meditation dari API
  Future<List<MeditationModels>> getAudios() async {
    try {
      final response = await _httpClient.get(API.meditationAudios);
      if (response.statusCode == 200) {
        final List<dynamic> audiosData = response.data['audios']['data'];
        return audiosData
            .map((json) => MeditationModels.fromJson(json))
            .toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load audios');
      }
    } catch (e) {
      print('❌ Error in getAudios(): $e');
      rethrow;
    }
  }

  /// Ambil daily meditation dari API
  Future<MeditationModels?> getDailyMeditation() async {
    try {
      final response = await _httpClient.get(API.meditationDaily);

      if (response.statusCode == 200 &&
          (response.data['status'] == 'success' ||
              response.data['success'] == true)) {
        final data = response.data['data'];
        return MeditationModels.fromJson(data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load daily data');
      }
    } catch (e) {
      print('❌ Error in getDailyMeditation(): $e');
      rethrow;
    }
  }

  /// Mainkan audio meditation dengan error handling
  Future<void> playAudio(MeditationModels model) async {
    if (!_isAudioHandlerInitialized) {
      throw Exception('Audio handler not initialized');
    }

    final String audioUrl = "${API.endpointImage}storage/${model.filePath}";
    print('🎧 Playing meditation audio from: $audioUrl');
    
    try {
      await _audioHandler.playFromUrl(audioUrl, model.title);
    } catch (e) {
      print('❌ Error playing audio: $e');
      rethrow;
    }
  }

  /// Pause audio
  Future<void> pauseAudio() async {
    if (!_isAudioHandlerInitialized) return;
    await _audioHandler.pause();
  }

  /// Resume audio
  Future<void> resumeAudio() async {
    if (!_isAudioHandlerInitialized) return;
    await _audioHandler.play();
  }

  /// Stop audio
  Future<void> stopAudio() async {
    if (!_isAudioHandlerInitialized) return;
    await _audioHandler.stop();
  }

  /// Seek to position
  Future<void> seekAudio(Duration position) async {
    if (!_isAudioHandlerInitialized) return;
    await _audioHandler.seek(position);
  }

  /// Stream untuk UI update (posisi, state, dll)
  Stream<PlaybackState> get playbackState {
    if (!_isAudioHandlerInitialized) {
      return Stream.empty();
    }
    return _audioHandler.playbackState;
  }

  /// Stream untuk media item
  Stream<MediaItem?> get currentMediaItem {
    if (!_isAudioHandlerInitialized) {
      return Stream.empty();
    }
    return _audioHandler.mediaItem;
  }

  /// Check if audio is playing
  Future<bool> get isPlaying async {
    if (!_isAudioHandlerInitialized) return false;
    final state = _audioHandler.playbackState.value;
    return state.playing;
  }

  /// Get current position
  Stream<Duration> get positionStream {
    if (!_isAudioHandlerInitialized) {
      return Stream.empty();
    }
    return _audioHandler.playbackState.map((state) => state.position);
  }
}
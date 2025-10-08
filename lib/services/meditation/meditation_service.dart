import 'package:audio_service/audio_service.dart';
import 'package:selena/models/meditation_models/meditation_models.dart';
import 'package:selena/services/api.dart';
import 'package:selena/services/audio_handler/audio_handler.dart';

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
  if (_isAudioHandlerInitialized) return; // <-- penting supaya gak double init
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

  SejenakAudioHandler get handler {
    if (!_isAudioHandlerInitialized) {
      throw Exception('AudioHandler not initialized');
    }
    return _audioHandler;
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

  /// Mainkan audio meditation
  Future<void> playAudio(MeditationModels model) async {
    final String audioUrl = "${API.endpointImage}storage/${model.filePath}";
    print('🎧 Playing meditation audio from: $audioUrl');
    await _audioHandler.playFromUrl(audioUrl, model.title);
  }

  /// Pause audio
  Future<void> pauseAudio() async => _audioHandler.pause();

  /// Resume audio
  Future<void> resumeAudio() async => _audioHandler.play();

  /// Stop audio
  Future<void> stopAudio() async => _audioHandler.stop();

  /// Stream untuk UI update (posisi, state, dll)
  Stream<PlaybackState> get playbackState => _audioHandler.playbackState;

  /// Stream untuk media item
  Stream<MediaItem?> get currentMediaItem => _audioHandler.mediaItem;
}

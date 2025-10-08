import 'package:selena/models/meditation_models/meditation_models.dart';
import 'package:selena/services/api.dart';
import 'package:just_audio/just_audio.dart';

class MeditationService {
  final DioHttpClient _httpClient = DioHttpClient.getInstance();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = true; // Langsung true karena tidak butuh init complex

  MeditationService._(); // private constructor

  static Future<MeditationService> create() async {
    final service = MeditationService._();
    // Tidak perlu init yang complex
    print('✅ MeditationService created successfully');
    return service;
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

  /// Mainkan audio meditation dengan Just Audio
  Future<void> playAudio(MeditationModels model) async {
    final String audioUrl = "${API.endpointImage}storage/${model.filePath}";
    print('🎧 Playing meditation audio from: $audioUrl');
    
    try {
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      print('❌ Error playing audio: $e');
      rethrow;
    }
  }

  /// Pause audio
  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
  }

  /// Resume audio
  Future<void> resumeAudio() async {
    await _audioPlayer.play();
  }

  /// Stop audio
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  /// Seek to position
  Future<void> seekAudio(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// Stream untuk UI update
  Stream<PlayerState> get playbackState => _audioPlayer.playerStateStream;

  /// Stream untuk position
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  /// Stream untuk duration
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  /// Check if audio is playing
  Stream<bool> get isPlayingStream => _audioPlayer.playingStream;

  /// Get current playing state
  bool get isPlaying => _audioPlayer.playing;

  /// Dispose resources
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
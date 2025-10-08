import 'package:audio_service/audio_service.dart';
import 'package:selena/services/audio/audio_handler/audio_handler.dart';

class AudioInitializer {
  static SejenakAudioHandler? _instance;
  static bool _isInitializing = false;

  static Future<SejenakAudioHandler> getHandler() async {
    if (_instance != null) return _instance!;
    if (_isInitializing) {
      // Wait if already initializing
      await Future.delayed(const Duration(milliseconds: 100));
      return getHandler();
    }

    _isInitializing = true;
    try {
      _instance = await AudioService.init(
        builder: () => SejenakAudioHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.sejenak.meditation.channel.audio',
          androidNotificationChannelName: 'Meditation Audio',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
          androidNotificationIcon: 'mipmap/ic_launcher',
        ),
      );
      return _instance!;
    } finally {
      _isInitializing = false;
    }
  }

  // Cleanup method
  static Future<void> dispose() async {
    await _instance?.dispose();
    _instance = null;
  }
}
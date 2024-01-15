import 'package:just_audio/just_audio.dart';

class AudioPlayerUtil {
  AudioPlayerUtil._internal() {
    _Player = AudioPlayer();
  }
  factory AudioPlayerUtil() => _instance;

  static late final AudioPlayerUtil _instance = AudioPlayerUtil._internal();

  late AudioPlayer _Player;

  static AudioPlayerUtil getInstance() {
    return _instance;
  }

  Future<Duration?> play(String url) async {
    final durations = await _Player.setUrl(url);
    return durations;
  }

  bool isPlaying() => _Player.playing;

  Future<void> stop() async {
    return await _Player.stop();
  }
}

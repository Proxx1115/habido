import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static void playAsset(String audioAsset) async {
    try {
      AudioCache audioCache = AudioCache();
      if (Platform.isIOS) {
        audioCache.fixedPlayer?.notificationService.startHeadlessService();
      }

      AudioPlayer audioPlayer = await audioCache.play(audioAsset);
    } catch (e) {
      print(e);
    }
  }
}

import 'package:audioplayers/audioplayers.dart';

mixin AudioController {
  final player = AudioPlayer();

  void play(String file) async {
    await player.play(AssetSource(file));
  }

  void stop() {
    player.stop();
  }

  void pause() {
    player.pause();
  }
}

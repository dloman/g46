
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

final AudioPlayer gPlayer = new AudioPlayer();

void load_horn() async {
}

void horn() async {
  gPlayer.play(AssetSource("sounds/horn.mp3"));
}

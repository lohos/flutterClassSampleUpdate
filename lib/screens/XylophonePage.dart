import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class XylophoneApp extends StatelessWidget {
  void playSound(int soundNumber) {
    final player = AudioPlayer();
    player.play(AssetSource('note$soundNumber.wav'));
  }

  Expanded buildKey(int soundNumber, MaterialColor btnColor) {
    return Expanded(
      child: InkWell(
        onTap: () {
          playSound(soundNumber);
        },
        child: Container(
          color: btnColor,
          // child: Center(
          //   child: Text(
          //     'button$soundNumber',
          //     style: const TextStyle(color: Colors.white),
          //   ),
          // ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildKey(1, Colors.red),
              buildKey(2, Colors.orange),
              buildKey(3, Colors.yellow),
              buildKey(4, Colors.green),
              buildKey(5, Colors.teal),
              buildKey(6, Colors.blue),
              buildKey(7, Colors.purple),
            ],
          ),
        ),
      ),
    );
  }
}

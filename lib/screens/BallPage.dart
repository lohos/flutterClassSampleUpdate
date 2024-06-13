import 'package:flutter/material.dart';
import 'dart:math';

class Ball extends StatefulWidget {
  @override
  State<Ball> createState() => _BallState();
}

class _BallState extends State<Ball> {
  int ballNumber = 1;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          setState(() {
            ballNumber = Random().nextInt(5) + 1;
          });
          print(ballNumber);
        },
        child: Image.asset('images/ball$ballNumber.png'),
      ),
    );
  }
}

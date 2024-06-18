import 'package:flutter/material.dart';
import 'my_colors.dart';

class GameFinishPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.thirdColor,
      appBar: AppBar(
        title: Text('Game Finish Page'),
      ),
      // Add more widgets to the body as needed
      body: Center(child: Text('Game Over')),
    );
  }
}

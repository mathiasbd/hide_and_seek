import 'package:flutter/material.dart';
import '../my_colors.dart';

class GameFinishPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 95, 188, 255),
      appBar: AppBar(
        title: Text('Game Finish Page'),
            centerTitle: true,
            titleTextStyle: const TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
            fontFamily: 'Oswald',
          ),
          backgroundColor: Colors.blue[400],
      ),
      // Add more widgets to the body as needed
      body: Center(child: Text('Game Over')),
    );
  }
}

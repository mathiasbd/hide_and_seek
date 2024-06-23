import 'package:flutter/material.dart';
import '../custom_widgets.dart';

class GameoverPage extends StatelessWidget {
  final List<dynamic> caughtHiders; // Step 1: Add caughtHiders variable

  // Step 2: Modify constructor to accept caughtHiders
  const GameoverPage({super.key, required this.caughtHiders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 188, 255),
      appBar: AppBar(
        title: const Text('Game Finish Page'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
          fontFamily: 'Oswald',
        ),
        backgroundColor: Colors.blue[400],
      ),
      body: Center(
        child: customActionButton(
          context: context,
          text: 'Restart Game',
          onPressed: () {
            // Logic to restart the game or navigate to the main menu
          },
          backgroundColor: Colors.green,
          textStyle: const TextStyle(fontSize: 20.0, color: Colors.white),
          width: 250.0,
          height: 60.0,
          borderRadius: 12.0,
        ),
      ),
    );
  }
}
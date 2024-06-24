import 'package:flutter/material.dart';
import '../pages/home_screen.dart';
import '../custom_widgets.dart';

class GameoverPage extends StatelessWidget {

  const GameoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 188, 255),
      appBar: AppBar(
        title: const Text('Game Over'),
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
          text: 'Go to Home Screen',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          width: 250.0,
          height: 60.0,
          borderRadius: 12.0,
        ),
      ),
    );
  }
}
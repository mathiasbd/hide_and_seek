import 'package:flutter/material.dart';
import '../pages/home_screen.dart'; // Ensure you have a HomeScreen page in your project

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
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to HomeScreen
            );
          },
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20.0, color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          ),
          child: const Text('Go to Home Screen'),
        ),
      ),
    );
  }
}
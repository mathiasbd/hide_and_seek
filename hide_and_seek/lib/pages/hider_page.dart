import 'package:flutter/material.dart';
import 'maps_page.dart';
import '../classes/User.dart';

class HiderPage extends StatelessWidget {

  final User user;

  const HiderPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 95, 188, 255),
        appBar: AppBar(
          title: const Text('Hider'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
            fontFamily: 'Oswald',
          ),
          backgroundColor: Colors.blue[400],
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MapsPage()),
                          );
                        },
                        child: const Text(
                          'Location',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          // Add your code here
                        },
                        child: const Text(
                          'meow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          // Add your code here
                        },
                        child: const Text(
                          'meowmeow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

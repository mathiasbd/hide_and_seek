import 'package:flutter/material.dart';
import 'maps_page.dart';
import '../my_colors.dart';

class SeekersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 95, 188, 255),
        appBar: AppBar(
          title: const Text('Seeker'),
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
                        child: Text(
                          'Location',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MapsPage()),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text(
                          'meow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          // Add your code here
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text(
                          'meowmeow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          // Add your code here
                        },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          child: Text('meowmeowmeow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () {
                            // Add your code here
                          }
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
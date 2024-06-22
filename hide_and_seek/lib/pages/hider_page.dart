import 'package:flutter/material.dart';
import 'maps_page.dart';
import '../classes/User.dart';

class HiderPage extends StatelessWidget {

  final User user;
  final String matchName;

  const HiderPage({
    super.key,
    required this.user,
    required this.matchName,
    });

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
      body: Flex(
        direction: Axis.vertical,
        children: <Flexible>[
          Flexible(
            flex: 1
            ,
            child: Container(color: Colors.blue[400]),
          ),
          Flexible(
            flex: 10,
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(color: Colors.blue[400]),
                ),
                Flexible(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,  
                        width: 2,            
                      ),
                    ),
                    child: MapsPage(matchName: matchName, user: user),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(color: Colors.blue[400]),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              color: Colors.blue[400],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'You are the hider! Find a good spot to hide! the seeker can use abilities to find you!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hide_and_seek/pages/maps_page.dart';
import '../classes/abillity_manager.dart';
import '../classes/User.dart';

class SeekerPage extends StatelessWidget {

  final AbillityManager abillityManager = AbillityManager();
  
  User user;

  SeekerPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 188, 255),
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
                    child: MapsPage(),
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
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () {
                        abillityManager.getHiderLocations();
                      },
                      child: Icon(Icons.visibility, color: Colors.white),
                      backgroundColor: Colors.black,
                      shape: CircleBorder(),
                    ),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      onPressed: () {
                        abillityManager.getNoiseQue();
                      },
                      child: Icon(Icons.volume_up, color: Colors.white),
                      backgroundColor: Colors.black,
                      shape: CircleBorder(),
                    ),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      onPressed: () {
                        abillityManager.catchHider();
                      },
                      child: Icon(Icons.pan_tool, color: Colors.white),
                      backgroundColor: Colors.black,
                      shape: CircleBorder(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
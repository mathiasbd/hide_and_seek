import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:hide_and_seek/pages/create_match.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:hide_and_seek/pages/join_match.dart';
import 'package:hide_and_seek/pages/seekers_page.dart';
import 'package:hide_and_seek/pages/game_finnish_page.dart';
import '../classes/User.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController _firestoreController =
        FirestoreController(instance: firestore);
    final TextEditingController myController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/GeoChaser.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40.0), // Adjust the top padding as needed
              child: Text(
                'GeoChaser',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Oswald',
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 200.0,
                  height: 60.0,
                  child: TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      hintText: 'Player name',
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w900, // Makes the text thicker
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  height: 100.0,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Button 1 pressed');
                      String name = myController.text;
                      //myController.clear();
                      User user = new User(name, context, 'Admin');
                      if (name.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateMatch(user: user)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    ),
                    child: Text(
                      'Create Match',
                      style: TextStyle(
                          fontSize: 24.0,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  height: 100.0,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Button 2 pressed');
                      String name = myController.text;
                      //myController.clear();
                      User user = new User(name, context, 'Standard');
                      if (name.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JoinMatch(user: user)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    ),
                    child: Text(
                      'Join Match',
                      style: TextStyle(
                          fontSize: 24.0,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

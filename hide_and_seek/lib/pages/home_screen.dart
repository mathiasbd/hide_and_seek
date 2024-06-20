import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:hide_and_seek/pages/create_match.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:hide_and_seek/pages/join_match.dart';
import '../classes/User.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController firestoreController =
        FirestoreController(instance: firestore);
    final TextEditingController myController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/GeoChaser.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
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
                SizedBox(
                  width: 200.0,
                  height: 60.0,
                  child: TextField(
                    controller: myController,
                    decoration: const InputDecoration(
                      hintText: 'Player name',
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900, // Makes the text thicker
                    ),
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  height: 100.0,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Button 1 pressed');
                      String name = myController.text;
                      //myController.clear();
                      User user = User(name, context, 'Admin');
                      if (name.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateMatch(user: user)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    child: const Text(
                      'Create Match',
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  height: 100.0,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Button 2 pressed');
                      String name = myController.text;
                      //myController.clear();
                      User user = User(name, context, 'Standard');
                      if (name.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JoinMatch(user: user)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    child: const Text(
                      'Join Match',
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Color.fromARGB(255, 255, 255, 255)),
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

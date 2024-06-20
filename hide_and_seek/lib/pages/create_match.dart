import 'package:flutter/material.dart';
import 'package:hide_and_seek/pages/create_match.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase/firebase_options.dart';
import '../classes/User.dart';
import 'lobby.dart';

class CreateMatch extends StatelessWidget {
  final User user;

  CreateMatch({required this.user});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController _firestoreController =
        FirestoreController(instance: firestore);
    final TextEditingController myController = TextEditingController();

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 95, 188, 255), // Change this line
        appBar: AppBar(
            title: const Text('Create Match'),
            centerTitle: true,
            titleTextStyle: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
              fontFamily: 'Oswald',
            ),
            backgroundColor: Colors.blue[400]),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: 0.0), // Added SizedBox for spacing
            Container(
              width: 200.0,
              height: 100.0,
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                  hintText: 'Enter match name',
                ),
              ),
            ),
            Container(
              width: 150.0, // adjust the width as needed
              height: 75.0, // adjust the height as needed
              child: FloatingActionButton(
                onPressed: () {
                  String matchName = myController.text;
                  createAndAdd(_firestoreController, matchName);
                  myController.clear();
                  if (matchName.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Lobby(matchName: matchName, user: user)),
                    );
                  }
                },
                tooltip: 'Create Match',
                child: const Text(
                  'Create',
                  style: TextStyle(color: Colors.white), // Add this line
                ),
                backgroundColor: Colors.black, // Change this line
              ),
            ),
          ],
        )));
  }

  void createAndAdd(_firestoreController, matchName) async {
    await _firestoreController?.createMatch(matchName);
    await _firestoreController.joinMatch(matchName, user.toMap());
  }
}

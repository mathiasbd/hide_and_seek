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

  final String name;

  CreateMatch({this.name = 'unnamed'});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController _firestoreController = FirestoreController(instance: firestore);
    final TextEditingController myController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Match'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Oswald',
        ),
        backgroundColor: Colors.blue[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
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
          ],
        )
        
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text('+'),
        onPressed: () {
          String matchName = myController.text;
          createAndAdd(_firestoreController, matchName);
          myController.clear();
          if(!matchName.isEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Lobby(rights: 'Admin', matchName: matchName,)),
            );
          }
        },
      ),
    );
  }

  void createAndAdd(_firestoreController, matchName) async {
    await _firestoreController?.createMatch(matchName);
    await _firestoreController.joinMatch(matchName, name);
  }
}
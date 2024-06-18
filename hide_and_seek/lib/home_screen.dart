import 'package:flutter/material.dart';
import 'package:hide_and_seek/create_match.dart';
import 'package:hide_and_seek/firestore_controller.dart';
import 'package:hide_and_seek/join_match.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'user.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController _firestoreController = FirestoreController(instance: firestore);
    final TextEditingController myController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hide And Seek'),
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
              height: 60.0,
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                  hintText: 'Enter player name',
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
                  myController.clear();
                  if(!name.isEmpty && name != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateMatch(name: name)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                ),
                child: Text(
                  'Create Match',
                  style: TextStyle(fontSize: 24.0, color: Colors.black),
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
                  myController.clear();
                  if(!name.isEmpty && name != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JoinMatch(name: name)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                ),
                child: Text(
                  'Join Match',
                  style: TextStyle(fontSize: 24.0, color: Colors.black),
                ),
              ),
            ),
            
          ],
        )
        ),
    );
  }
}
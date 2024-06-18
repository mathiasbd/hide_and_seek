import 'package:flutter/material.dart';
import 'package:hide_and_seek/pages/create_match.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase/firebase_options.dart';
import '../classes/User.dart';
import 'lobby.dart';

class JoinMatch extends StatelessWidget {
  final String name;

  JoinMatch({this.name = 'Unnamed'});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController _firestoreController =
        FirestoreController(instance: firestore);
    final TextEditingController myController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Match'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Oswald',
        ),
        backgroundColor: Colors.blue[400],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('matches').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var matches = snapshot.data!.docs;

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              var match = matches[index];
              var matchData = match.data() as Map<String, dynamic>;
              String matchName = matchData['Match Name'] ?? 'Unknown Match';

              return Container(
                margin: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    _firestoreController.joinMatch(matchName, name);
                    if (!matchName.isEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Lobby(
                                  matchName: matchName,
                                )),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                  ),
                  child: Text(
                    matchName,
                    style: const TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

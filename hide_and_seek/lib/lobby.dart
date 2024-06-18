import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hide_and_seek/firestore_controller.dart';
import 'package:hide_and_seek/hider_page.dart';
import 'package:provider/provider.dart';

class Lobby extends StatelessWidget {

  final String rights;
  final String matchName;

  Lobby({this.rights = 'Standard', this.matchName = 'No Match'});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController _firestoreController = FirestoreController(instance: firestore);

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('matches').doc(matchName).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var matchData = snapshot.data!.data() as Map<String, dynamic>;
                var participants = matchData['participants'] ?? [];

                if (participants.isEmpty) {
                  return Center(child: Text('No participants found'));
                }

                return ListView.builder(
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Player: ${participants[index]}'),
                    );
                  },
                );
              },
            ),
          ),
          Center(
            child: Container(
              width: 200.0,
              height: 100.0,
              child: ElevatedButton(
                onPressed: () {
                  if(rights=='Admin') {
                    print('succes');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HiderPage()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                ),
                child: Text(
                  getButtonText(),
                  style: TextStyle(fontSize: 24.0, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getButtonText() {
    String buttonText = 'Ready';
    if (rights=='Admin') {
      buttonText = 'Start game';
    };
    return buttonText;
  }
}
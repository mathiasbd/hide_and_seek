import 'package:flutter/material.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/User.dart';
import 'lobby.dart';

class JoinMatch extends StatelessWidget {
  final User user;

  const JoinMatch({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController firestoreController =
        FirestoreController(instance: firestore);
    final TextEditingController myController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 188, 255),
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
                    firestoreController.joinMatch(matchName, user.toMap());
                    if (matchName.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Lobby(
                                  matchName: matchName, user: user,
                                )),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    matchName,
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),
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

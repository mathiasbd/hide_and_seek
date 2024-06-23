import 'package:flutter/material.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/User.dart';
import 'lobby_page.dart';

class JoinMatch extends StatelessWidget {
  final User user;

  const JoinMatch({super.key, required this.user});

@override
Widget build(BuildContext context) {
  FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
  FirestoreController firestoreController =
      FirestoreController(instance: firestore);

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
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var matches = snapshot.data!.docs;

        return ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) => _buildMatchItem(context, matches[index], firestoreController),
        );
      },
    ),
  );
}

// the button that will be displayed for each match (Fix so playercount is shown right now it is hardcoded to 0)

Widget _buildMatchItem(BuildContext context, QueryDocumentSnapshot<Object?> match, FirestoreController firestoreController) {
  var matchData = match.data() as Map<String, dynamic>;
  String matchName = matchData['Match Name'] ?? 'Unknown Match';
  String matchId = match.id;

  // Assuming FirestoreController has a method getNumberOfPlayers(matchId) that returns Future<int>
  Future<int> numberOfPlayers = firestoreController.getNumberOfPlayers(matchName);

  return Card(
    margin: const EdgeInsets.all(20.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: InkWell(
      onTap: () => _joinMatch(context, matchName, firestoreController),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              matchName,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<int>(
              future: numberOfPlayers,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading players...');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    'Players: ${snapshot.data}',
                    style: const TextStyle(fontSize: 16.0),
                  );
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}

// join the match and navigate to the lobby page

void _joinMatch(BuildContext context, String matchName, FirestoreController firestoreController) {
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
}
}
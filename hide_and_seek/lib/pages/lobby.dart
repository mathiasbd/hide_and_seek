import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:hide_and_seek/pages/hider_page.dart';
import 'package:provider/provider.dart';
import '../classes/User.dart';

class Lobby extends StatelessWidget {
  final String rights;
  final String matchName;
  final User user;

  Lobby({this.rights = 'Standard', this.matchName = 'No Match', required this.user});


  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController _firestoreController = FirestoreController(instance: firestore);

    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          await _firestoreController.removeUserFromMatch(matchName, user);
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 95, 188, 255), // Change this line
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
                stream: FirebaseFirestore.instance
                    .collection('matches')
                    .doc(matchName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: const CircularProgressIndicator());
                  }

                  var matchData = snapshot.data!.data() as Map<String, dynamic>;
                  var participants = (matchData['participants'] as List<dynamic> ?? []);
                  var participantsName = participants.map((participant) => participant['name']).toList();
                  var participantsReady = participants.map((participant) => participant['ready']).toList();

                  if (participants.isEmpty) {
                    return const Center(child: Text('No participants found'));
                  }

                  return ListView.builder(
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Text('Player: ${participantsName[index]}'),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              width: 20,
                              height: 20,
                              color: getColor(participantsReady[index]),
                            )
                          ],
                        ),
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
                    if (rights == 'Admin') {
                      print('Started game');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HiderPage()),
                      );
                    } else {
                      user.changeReady(matchName, user);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  child: Text(
                    getButtonText(),
                    style: const TextStyle(
                        fontSize: 24.0,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getButtonText() {
    String buttonText = 'Ready';
    if (rights == 'Admin') {
      buttonText = 'Start game';
    }
    ;
    return buttonText;
  }

  Color getColor(participantsReady) {
    if(participantsReady) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}

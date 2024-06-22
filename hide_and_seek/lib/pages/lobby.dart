import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:hide_and_seek/pages/hider_page.dart';
import 'package:hide_and_seek/pages/join_match.dart';
import 'package:hide_and_seek/pages/seekers_page.dart';
import 'package:provider/provider.dart';
import '../classes/User.dart';

class Lobby extends StatelessWidget {
  final String matchName;
  final User user;

  const Lobby({super.key, this.matchName = 'No Match', required this.user});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController firestoreController =
        FirestoreController(instance: firestore);

    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (didPop && user.userType == 'Admin') {
          await firestoreController.removeUserFromMatch(matchName, user);
          await firestoreController.removeMatch(matchName);
          await user.forceUnready(matchName, user);
          return;
        } else if (didPop) {
          await firestoreController.removeUserFromMatch(matchName, user);
          await user.forceUnready(matchName, user);
          return;
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 95, 188, 255),
        appBar: AppBar(
          title: const Text('Lobby'),
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
                stream:
                    firestore.collection('matches').doc(matchName).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context);
                    });
                    return const Center(child: Text('Match does not exist'));
                  }

                  var matchData = snapshot.data!.data() as Map<String, dynamic>;
                  var matchStarted = matchData['Match started'] ?? false;
                  var participants = List<Map<String, dynamic>>.from(
                      matchData['participants'] ?? []);
                  var participantsName = participants
                      .map((participant) => participant['name'])
                      .toList();
                  var participantsReady = participants
                      .map((participant) => participant['ready'])
                      .toList();
                  var participantsUserType = participants
                      .map((participant) => participant['userType'])
                      .toList();

                  int userIndex = participants.indexWhere((participant) => participant['id'] == user.id);

                  if (matchStarted) {
                    user.changeReady(matchName, user);
                    if (participants[userIndex]['role'] == 'Hider') {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HiderPage(user: user, matchName: matchName)),
                        );
                      });
                    } else if (participants[userIndex]['role'] == 'Seeker') {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SeekerPage(user: user, matchName: matchName)),
                        );
                      });
                    }
                  }

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
                              margin: const EdgeInsets.only(left: 20),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: getColor(participantsReady[index],
                                    participantsUserType[index]),
                                borderRadius: BorderRadius.circular(10),
                              ),
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
              child: SizedBox(
                width: 200.0,
                height: 100.0,
                child: ElevatedButton(
                  onPressed: () {
                    if (user.userType == 'Admin') {
                      startMatch(matchName, user, firestoreController);
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
            Center(
              child: SizedBox(
                width: 200.0,
                height: 100.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HiderPage(user: user, matchName: matchName)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  child: const Text(
                    'Go to Hider Page',
                    style: TextStyle(
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
    return user.userType == 'Admin' ? 'Start game' : 'Ready';
  }

  Color getColor(bool participantsReady, String participantUserType) {
    if (participantUserType != 'Admin') {
      return participantsReady ? Colors.green : Colors.red;
    } else {
      return Colors.black;
    }
  }

  void startMatch(matchName, user, firestoreController) async {
    bool isReady = await firestoreController.checkUsersReady(matchName, user);
    if(isReady) {
      await firestoreController.findRandomSeeker(matchName);
      await firestoreController.changeGameStarted(matchName);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:hide_and_seek/pages/hider_page.dart';
import 'package:hide_and_seek/pages/seekers_page.dart';
import 'package:provider/provider.dart';
import '../classes/User.dart';
import '../custom_widgets.dart';

class Lobby extends StatelessWidget {
  final String matchName;
  final User user;

  const Lobby({Key? key, this.matchName = 'No Match', required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirebaseFirestore>(context);
    final firestoreController = FirestoreController(instance: firestore);

    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          await firestoreController.removeUserFromMatch(matchName, user);
          await checkAdminInMatch(firestoreController, matchName);
          return;
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 95, 188, 255),
        appBar: _buildAppBar(),
        body: _buildBody(context, firestore, firestoreController),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Lobby'),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Oswald',
      ),
      backgroundColor: Colors.blue[400],
    );
  }

  Widget _buildBody(BuildContext context, FirebaseFirestore firestore,
      FirestoreController firestoreController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: _buildParticipantsList(
                context, firestore, firestoreController)),
        _buildActionButton(context, firestoreController),
      ],
    );
  }

  Widget _buildParticipantsList(BuildContext context,
      FirebaseFirestore firestore, FirestoreController firestoreController) {
    bool navigated = false;
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore.collection('matches').doc(matchName).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          Future.microtask(() => Navigator.pop(context));
          return const Center(child: Text('Match does not exist'));
        }
        var matchData = snapshot.data!.data() as Map<String, dynamic>;
        var participants =
            List<Map<String, dynamic>>.from(matchData['participants'] ?? []);
        var gameStarted = matchData['Match started'];
        checkGameStarted(gameStarted, navigated, context, firestoreController);
        
        if (participants.isEmpty) {
          return const Center(child: Text('No participants found'));
        } else {
          return _buildParticipantsListView(participants);
        }
      },
    );
  }

  Widget _buildParticipantsListView(List<Map<String, dynamic>> participants) {
    return ListView.builder(
      itemCount: participants.length,
      itemBuilder: (context, index) {
        var participant = participants[index];
        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(30.0),
          child: ListTile(
            title: Text(participant['name']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(participant['ready'] ? 'Ready' : 'Not Ready'),
                SizedBox(width: 10),
                _buildParticipantStatusIndicator(participant),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticipantStatusIndicator(Map<String, dynamic> participant) {
    if (participant['userType'] == 'Admin') {
      return Icon(Icons.star, color: Colors.yellow);
    } else {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: getColor(participant['ready'], participant['userType']),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }
  }

  Future<void> checkAdminInMatch(firestoreController, matchName) async {
    bool isInMatch = await firestoreController.checkAdminInMatch(matchName);
    if (!isInMatch) {
      firestoreController.removeMatch(matchName);
    }
  }

  Widget _buildActionButton(
      BuildContext context, FirestoreController firestoreController) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom:
              50.0), // Adjust the value to increase or decrease the distance
      child: customActionButton(
        context: context,
        text: getButtonText(),
        onPressed: () =>
            _handleActionButtonPressed(context, firestoreController),
        backgroundColor: Colors.black, // Optional if you want to customize
        textStyle: const TextStyle(
            fontSize: 24.0,
            color: Colors.white), // Optional if you want to customize
        width: 200.0, // Optional if you want to customize
        height: 75.0, // Optional if you want to customize
        borderRadius: 8.0, // Optional if you want to customize
      ),
    );
  }

  String getButtonText() => user.userType == 'Admin' ? 'Start game' : 'Ready';

  Color getColor(bool participantsReady, String participantUserType) {
    if (participantUserType != 'Admin') {
      return participantsReady ? Colors.green : Colors.red;
    } else {
      return Colors.yellow;
    }
  }

  void _handleActionButtonPressed(
      BuildContext context, FirestoreController firestoreController) {
    if (user.userType == 'Admin') {
      startMatch(
          context, matchName, user, firestoreController); // Pass context here
    } else {
      user.changeReady(matchName, user);
    }
  }

  void startMatch(BuildContext context, String matchName, User user,
      FirestoreController firestoreController) async {
    bool isReady = await firestoreController.checkUsersReady(matchName, user);
    if (isReady) {
      await firestoreController.findRandomSeeker(matchName);
      await firestoreController.changeGameStarted(matchName);
    }
  }
  Future<void> checkGameStarted(gameStarted, navigated, context, firestoreController) async {
    if (gameStarted && navigated == false) {
          String updatedRole = await firestoreController.fetchUserRole(matchName, user);
          user.role = updatedRole;
          navigated = true;
          if (user.role == 'Seeker') {
            debugPrint('Changed page to seeker_page');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SeekerPage(matchName: matchName, user: user)),
              );
            });
          } else if(user.role == 'Hider') {
            debugPrint('Changed page to hider_page');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HiderPage(matchName: matchName, user: user)),
              );
            });
          }
        }
  }
}

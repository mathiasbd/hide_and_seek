import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';
import 'maps_page.dart';
import '../classes/User.dart';
import 'gameover_page.dart';
import 'dart:async';

class HiderPage extends StatefulWidget {
  final User user;
  final String matchName;

  const HiderPage({
    super.key,
    required this.user,
    required this.matchName,
  });

  @override
  HiderPageState createState() => HiderPageState();
}

class HiderPageState extends State<HiderPage> {
  int? distanceToSeeker;
  final GlobalKey<MapsPageState> _mapsPageKey = GlobalKey<MapsPageState>();
  StreamSubscription<DocumentSnapshot>? _caughtSubscription;

  @override
  void initState() {
    super.initState();
    listenForCaught();
  }

  @override
  void dispose() {
    _caughtSubscription?.cancel();
    super.dispose();
  }

  void listenForCaught() {
  String matchName = widget.matchName;
  User user = widget.user;
  String currentUserID = widget.user.id;
  FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context, listen: false);
  FirestoreController firestoreController = FirestoreController(instance: firestore);
  debugPrint('matchName: $matchName currentUserID: $currentUserID');
  _caughtSubscription = FirebaseFirestore.instance.collection('matches').doc(matchName).snapshots().listen((event) async {
    if (event.exists) {
      List<dynamic>? participants = await firestoreController.getParticipants(matchName);
      if (participants != null) {
        int index = participants.indexWhere((participant) => participant['id'] == currentUserID);
        if (index != -1 && participants[index]['caught']) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GameoverPage(),
            ),
          ).then((_) {
            firestoreController.removeUserFromMatch(matchName, user);
          });
        }
      }
    }
  });
}

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context, listen: false); // Fixed context usage
    FirestoreController firestoreController =
        FirestoreController(instance: firestore);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 188, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Hider'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
          fontFamily: 'Oswald',
        ),
        backgroundColor: Colors.blue[400],
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: 1,
            child: Container(color: Colors.blue[400]),
          ),
          Flexible(
            flex: 10,
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(color: Colors.blue[400]),
                ),
                Flexible(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: MapsPage(
                        matchName: widget.matchName,
                        user: widget.user,
                        key: _mapsPageKey),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(color: Colors.blue[400]),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              color: Colors.blue[400],
              child: Center(
                child: Visibility(
                  visible: distanceToSeeker != null,
                  child: Text(
                    'Distance to seeker: ${distanceToSeeker ?? ''} meters',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
                color: Colors.blue[400],
                child: Center(
                  child: FloatingActionButton(
                    onPressed: () async {
                      final int distance = await firestoreController
                          .distanceToSeeker(widget.matchName, widget.user);
                      setState(() {
                        distanceToSeeker = distance;
                      });
                    },
                    child: Icon(Icons.visibility, color: Colors.white),
                    backgroundColor: Colors.black,
                    shape: CircleBorder(),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
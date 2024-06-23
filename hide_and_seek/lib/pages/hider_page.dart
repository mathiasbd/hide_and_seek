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

  void listenForCaught() async {
    String matchName = widget.matchName;
    String currentUserID = widget.user.id;
    debugPrint('matchName: $matchName currentUserID: $currentUserID');
    _caughtSubscription = FirebaseFirestore.instance.collection('matches').doc(matchName).snapshots().listen((event) {
      if (event.exists) {
        debugPrint('Caught: ${event.data()?['caught']}');
        final List caught = event.data()?['caught'];
        if (caught.contains(currentUserID)) {
          debugPrint('Caught!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GameoverPage()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
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
                    // Step 2: Use the GlobalKey when creating the MapsPage widget
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
                // Use Visibility widget to show/hide the text
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

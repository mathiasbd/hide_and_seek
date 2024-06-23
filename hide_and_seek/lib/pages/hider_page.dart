import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';
import 'maps_page.dart';
import '../classes/User.dart';

class HiderPage extends StatefulWidget {
  final User user;
  final String matchName;

  const HiderPage({
    super.key,
    required this.user,
    required this.matchName,
  });

  @override
  _HiderPageState createState() => _HiderPageState();
}

class _HiderPageState extends State<HiderPage> {
  int? distanceToSeeker;
  // Step 1: Define a GlobalKey for the MapsPage widget
  final GlobalKey<MapsPageState> _mapsPageKey = GlobalKey<MapsPageState>();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController firestoreController =
        FirestoreController(instance: firestore);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 188, 255),
      appBar: AppBar(
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
                        matchName: widget.matchName, user: widget.user, key: _mapsPageKey),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(color: Colors.blue[400]),
                ),
              ],
            ),
          ),
          if (distanceToSeeker != null) // Display distance if not null
            Flexible(
              flex: 2,
              child: Container(
                color: Colors.blue[400],
                child: Center(
                  child: Text(
                    'Distance to seeker: $distanceToSeeker meters',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          Flexible(
            flex: 3,
            child: Container(
                color: Colors.blue[400],
                child: Center(
                  child: FloatingActionButton(
                    onPressed: () async {
                      final int distance = await firestoreController.distanceToSeeker(
                          widget.matchName, widget.user);
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
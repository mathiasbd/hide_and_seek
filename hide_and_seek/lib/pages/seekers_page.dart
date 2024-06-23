import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hide_and_seek/pages/gameover_page.dart';
import 'package:hide_and_seek/pages/maps_page.dart';
import '../classes/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';

class SeekerPage extends StatefulWidget {
  final String matchName;
  final User user;

  const SeekerPage({
    Key? key,
    required this.matchName,
    required this.user,
  }) : super(key: key);

  @override
  SeekerPageState createState() => SeekerPageState();
}

class SeekerPageState extends State<SeekerPage> {
  final GlobalKey<MapsPageState> mapsPageKey = GlobalKey<MapsPageState>();


  void navigateCaughtHiders() async {
    List<dynamic> caughtHiders = await FirestoreController(instance: FirebaseFirestore.instance).catchHiders(widget.matchName);
    if (caughtHiders.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameoverPage(caughtHiders: caughtHiders),
        ),
      );
    }
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
        title: const Text('Seeker'),
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
        children: <Flexible>[
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
                    child: MapsPage(matchName: widget.matchName, user: widget.user, key: mapsPageKey),
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
            flex: 3,
            child: Container(
              color: Colors.blue[400],
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () async {
                        List<LatLng> hidersLocations = await firestoreController.getHidersLocations(widget.matchName);
                        final mapsPageState = mapsPageKey.currentState;
                        mapsPageState?.addMarkers(hidersLocations);
                      },
                      child: Icon(Icons.visibility, color: Colors.white),
                      backgroundColor: Colors.black,
                      shape: CircleBorder(),
                    ),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      onPressed: () {
                        navigateCaughtHiders();
                      },
                      child: Icon(Icons.pan_tool, color: Colors.white),
                      backgroundColor: Colors.black,
                      shape: CircleBorder(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
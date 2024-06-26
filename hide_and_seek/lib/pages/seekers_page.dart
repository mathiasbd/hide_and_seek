import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hide_and_seek/pages/maps_page.dart';
import '../classes/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'gameover_page.dart';

class SeekerPage extends StatefulWidget {
  final String matchName;
  final User user;
  

  const SeekerPage({
    super.key,
    required this.matchName,
    required this.user,
  });

  @override
  SeekerPageState createState() => SeekerPageState();
}

class SeekerPageState extends State<SeekerPage> {
  final GlobalKey<MapsPageState> mapsPageKey = GlobalKey<MapsPageState>();
  Timer? _timer;
  int _counter = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                    Column(
                      children: [
                        FloatingActionButton(
                          onPressed: () async {
                            if(_counter <= 0) {
                              List<LatLng> hidersLocations = await firestoreController.getHidersLocations(widget.matchName);
                              final mapsPageState = mapsPageKey.currentState;
                              mapsPageState?.addMarkers(hidersLocations);
                              startTimer();
                            }
                          },
                          backgroundColor: Colors.black,
                          shape: const CircleBorder(),
                          child: const Icon(Icons.visibility, color: Colors.white),
                        ),
                        Text(getCounterText()),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        FloatingActionButton(
                          onPressed: () async {
                            await firestoreController.catchHiders(widget.matchName);
                            int playersLeft = await firestoreController.getNumberOfPlayers(widget.matchName);
                            if(playersLeft <= 1) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GameoverPage(),
                                ),
                              );
                            }
                          },
                          backgroundColor: Colors.black,
                          shape: const CircleBorder(),
                          child: const Icon(Icons.pan_tool, color: Colors.white),
                        ),
                        const Text('Catch'),
                      ],
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

  void startTimer() {
    _counter = 300;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  String getCounterText() {
    if (_counter > 0) {
      return '$_counter';
    } else {
      return 'Look';
    }
  }
}
import 'package:flutter/material.dart';
import 'package:hide_and_seek/pages/maps_page.dart';
import '../classes/abillity_manager.dart';
import '../classes/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';
import '../classes/abillity_manager.dart';


class SeekerPage extends StatelessWidget {

  final String matchName;
  User user;
  late final AbilityManager abilityManager;


  SeekerPage({
    super.key,
    required this.matchName,
    required this.user,
    });

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context);
    FirestoreController firestoreController =
        FirestoreController(instance: firestore);

    abilityManager = AbilityManager(firestoreController: firestoreController);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 188, 255),
      appBar: AppBar(
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
            flex: 1
            ,
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
                    child: MapsPage(matchName: matchName, user: user),
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
                      onPressed: () {
                        abilityManager.getHiderLocations();
                      },
                      child: Icon(Icons.visibility, color: Colors.white),
                      backgroundColor: Colors.black,
                      shape: CircleBorder(),
                    ),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      onPressed: () {
                        abilityManager.catchHiders(matchName);
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
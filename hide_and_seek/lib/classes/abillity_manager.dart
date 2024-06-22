import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';


class AbilityManager {

  final FirestoreController firestoreController;

  AbilityManager({required this.firestoreController});
  
  void getHiderLocations() {
    // Make a LatLng field in the User class
    // constantly update the user's location in the database
    // Get the hider locations from the database
    // make points on the map for each hider
  }

  void catchHiders(String matchName) {
    double radius = 1;
    firestoreController.catchHidersWithinRadius(matchName, radius);
  }
}

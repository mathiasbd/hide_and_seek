import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class User {
  LatLng? location;
  String name;
  String id = '';
  String userType;
  String role = 'Hider';
  bool ready = false;
  late FirestoreController _firestoreController;

  User(this.name, BuildContext context, this.userType) {
    id = _generateUniqueId();

    FirebaseFirestore firestore =
        Provider.of<FirebaseFirestore>(context, listen: false);
    _firestoreController = FirestoreController(instance: firestore);
  }

  String _generateUniqueId() {
    var random = Random();
    var randomNumber = 1000 + random.nextInt(9000);
    return '$name$randomNumber';
  }

  void printDetails() {
    print('Name: $name, ID: $id, Type: ${userType.toString() ?? "None"}');
  }

  Future<void> changeReady(matchName, user) async {
    ready = !ready;
    await _firestoreController.changeUserReady(matchName, user);
    print('changed ready to $ready');
  }

  Future<void> forceUnready(matchName, user) async {
    if (ready == true) {
      ready = !ready;
      print('Forced user to be unready');
    } else {
      print('User was already undready');
    }
  }

  void updateLocation(location) {
    location = location;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ready': ready,
      'userType': userType,
      'role': role,
    };
  }
}

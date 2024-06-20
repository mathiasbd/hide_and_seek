import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

enum UserType { Hider, Seeker }

class User {
  String name;
  String id = '';
  UserType? userType;
  bool ready = false;
  late FirestoreController _firestoreController;


  User(this.name, BuildContext context) {
    id = _generateUniqueId();

    FirebaseFirestore firestore = Provider.of<FirebaseFirestore>(context, listen: false);
    _firestoreController = FirestoreController(instance: firestore);
  }

  String _generateUniqueId() {
    var random = Random();
    var randomNumber = 1000 + random.nextInt(9000);
    return '$name$randomNumber';
  }

  void useAbility() {
    if (userType == UserType.Hider) {
      print('$name uses hiding ability!');
    } else if (userType == UserType.Seeker) {
      print('$name uses seeking ability!');
    } else {
      print('$name has no assigned role yet.');
    }
  }

  void printDetails() {
    print('Name: $name, ID: $id, Type: ${userType?.toString() ?? "None"}');
  }

  void changeReady(matchName, user) async {
    ready = !ready;
    _firestoreController.changeUserReady(matchName, user);
    print('changed ready to $ready');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ready': ready,
    };
  }
}
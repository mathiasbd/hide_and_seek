import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreController extends ChangeNotifier {
  final FirebaseFirestore instance;

  FirestoreController({required this.instance}) {}


  void createMatch(matchName) {
    instance.collection('matches').doc(matchName).set({'Match Name': matchName}).then((_) {
      print('Match created succesfully');
    })
    .catchError((error) {
      print('Error creating match: $error');
    });
  }

  void joinMatch(matchName, name) {
    instance.collection('matches').doc(matchName).update({
      'participants': FieldValue.arrayUnion([name]),
    }).then((_) {
      print('$name added to $matchName');
    }).catchError((error) {
      print('Failed to add user to match: $error');
    });
  }
}

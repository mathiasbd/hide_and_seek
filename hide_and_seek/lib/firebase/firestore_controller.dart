import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hide_and_seek/pages/join_match.dart';

class FirestoreController extends ChangeNotifier {
  final FirebaseFirestore instance;

  FirestoreController({required this.instance});


  void createMatch(matchName) {
    instance.collection('matches').doc(matchName).set({'Match Name': matchName}).then((_) {
      print('Match created succesfully');
    })
    .catchError((error) {
      print('Error creating match: $error');
    });
  }

  void joinMatch(matchName, user) {
    instance.collection('matches').doc(matchName).update({
      'participants': FieldValue.arrayUnion([user]),
    }).then((_) {
      print('$user added to $matchName');
    }).catchError((error) {
      print('Failed to add user to match: $error');
    });
  }

  Future<bool?> removeUserFromMatch(matchName, user) async {
    try {
      await FirebaseFirestore.instance
          .collection('matches')
          .doc(matchName)
          .update({
            'participants': FieldValue.arrayRemove([user.toMap()])
          });
      print('User removed from the Firestore');
    } catch (e) {
      print('Error removing user: $e');
    }
    return true;
  }

  Future<bool?> removeMatch(matchName) async {
    try {
      DocumentReference matchRef = instance.collection('matches').doc(matchName);

      await matchRef.delete();

      print('$matchName deleted succesfully');
    } catch (e) {
      print('Error deleting match: $e');
    }
    return true;
  }

  Future<void> changeUserReady(matchName, user) async {
    print('test 1');
    try {
      DocumentReference matchRef = instance.collection('matches').doc(matchName);

      DocumentSnapshot matchSnapshot = await matchRef.get();

      if(matchSnapshot.exists && matchSnapshot != null) {

        Map<String, dynamic>? matchData = matchSnapshot.data() as Map<String, dynamic>?;

        if(matchData != null) {
          List<dynamic> participants = matchData['participants'];

          int index = participants.indexWhere((participant) => participant['id'] == user.id);

          if (index != -1) {
            participants[index]['ready'] = user.ready;

            await matchRef.update({
              'participants': participants,
            });
            print('Participant ready status updated succesfully');
          } else {
            print('No participant found');
          }
        }
      } else {
        print('Match document reference does not exist');
      }
    } catch (e) {
      print('Error making participant ready: $e');
    }
  }
}

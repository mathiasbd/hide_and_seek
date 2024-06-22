import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

class FirestoreController extends ChangeNotifier {
  final FirebaseFirestore instance;

  FirestoreController({required this.instance});

  Future<void> createMatch(matchName) async {
    await instance
        .collection('matches')
        .doc(matchName)
        .set({'Match Name': matchName, 'Match started': false}).then((_) {
      print('Match created succesfully');
    }).catchError((error) {
      print('Error creating match: $error');
    });
  }

  Future<void> joinMatch(matchName, user) async {
    await instance.collection('matches').doc(matchName).update({
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
      DocumentReference matchRef =
          instance.collection('matches').doc(matchName);

      await matchRef.delete();

      print('$matchName deleted succesfully');
    } catch (e) {
      print('Error deleting match: $e');
    }
    return true;
  }

  Future<void> changeUserReady(matchName, user) async {
    try {
      DocumentReference matchRef =
          instance.collection('matches').doc(matchName);

      DocumentSnapshot matchSnapshot = await matchRef.get();

      if (matchSnapshot.exists) {
        Map<String, dynamic>? matchData =
            matchSnapshot.data() as Map<String, dynamic>?;

        if (matchData != null) {
          List<dynamic> participants = matchData['participants'];

          int index = participants
              .indexWhere((participant) => participant['id'] == user.id);

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

  Future<void> changeGameStarted(matchName) async {
    try {
      DocumentReference matchRef =
          instance.collection('matches').doc(matchName);

      await matchRef.update({'Match started': true});
      print('Game started succesfully');
    } catch (e) {
      print('Error starting the game: $e');
    }
  }

  Future<bool> checkUsersReady(matchName, user) async {
    try {
      DocumentReference matchRef =
          instance.collection('matches').doc(matchName);

      DocumentSnapshot matchSnapshot = await matchRef.get();

      if (matchSnapshot.exists) {
        Map<String, dynamic>? matchData =
            matchSnapshot.data() as Map<String, dynamic>?;
        if (matchData != null) {
          List<dynamic> participants = matchData['participants'];

          int index = participants
              .indexWhere((participant) => participant['id'] == user.id);

          for (int i = 0; i < participants.length; i++) {
            if (!participants[i]['ready'] && i != index) {
              return false;
            }
          }
          print('Participant ready status checked succesfully');
          return true;
        } else {
          print('No participant found');
        }
      } else {
        print('Match document reference does not exist');
      }
    } catch (e) {
      print('Error checking participant ready: $e');
    }
    return false;
  }

  Future<void> findRandomSeeker(matchName) async {
    try {
      DocumentReference matchRef = instance.collection('matches').doc(matchName);

      DocumentSnapshot matchSnapshot = await matchRef.get();

      if (matchSnapshot.exists) {
        Map<String, dynamic>? matchData =
            matchSnapshot.data() as Map<String, dynamic>?;
        if (matchData != null) {
          List<dynamic> participants = matchData['participants'];
          var random = Random();
          var randomSeeker = random.nextInt(participants.length);
          participants[randomSeeker]['role'] = 'Seeker';
          await matchRef.update({
              'participants': participants,
          });
          print('Seeker role assigned');
        }
      }
    } catch (e) {
      print('Error checking if user is seeker');
    }
  }

  Future<void> changeUserLocation(matchName, user) async {
    try {
      DocumentReference matchRef =
          instance.collection('matches').doc(matchName);

      DocumentSnapshot matchSnapshot = await matchRef.get();

      if (matchSnapshot.exists) {
        Map<String, dynamic>? matchData =
            matchSnapshot.data() as Map<String, dynamic>?;

        if (matchData != null) {
          List<dynamic> participants = matchData['participants'];

          int index = participants.indexWhere((participant) => participant['id'] == user['id']);

          if (index != -1) {
            participants[index]['location'] = user.location;

            await matchRef.update({
              'participants': participants,
            });
            print('Participant location updated succesfully');
          } else {
            print('No participant found');
          }
        }
      } else {
        print('Match document reference does not exist');
      }
    } catch (e) {
      print('Error updating participant location: $e');
    }
  }
}

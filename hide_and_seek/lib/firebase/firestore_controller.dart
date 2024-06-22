import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../classes/abillity_manager.dart';

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
      DocumentReference matchRef =
          instance.collection('matches').doc(matchName);

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

  Future<void> changeUserLocation(
      String matchName, Map<String, dynamic> user) async {
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
              .indexWhere((participant) => participant['id'] == user['id']);
          if (index != -1) {
            participants[index]['location'] = user['location'];
            await matchRef.update({
              'participants': participants,
            });
            print('User location updated successfully');
          } else {
            print('User not found in match');
          }
        }
      } else {
        print('Match document does not exist');
      }
    } catch (e) {
      print('Error updating user location: $e');
    }
  }

  Future<LatLng> getSeekerLocation(matchName) async {
    try {
      DocumentReference matchRef =
          instance.collection('matches').doc(matchName);
      DocumentSnapshot matchSnapshot = await matchRef.get();
      if (matchSnapshot.exists) {
        Map<String, dynamic>? matchData =
            matchSnapshot.data() as Map<String, dynamic>?;
        if (matchData != null) {
          List<dynamic> participants = matchData['participants'];
          int index = participants.indexWhere(
              (participant) => participant['role'] == 'Seeker');
          if (index != -1) {
            Map<String, dynamic> seekerLocation =
                participants[index]['location'];
            return LatLng(seekerLocation['latitude'], seekerLocation['longitude']);
          } else {
            print('Seeker not found in match');
          }
        }
      } else {
        print('Match document does not exist');
      }
    } catch (e) {
      print('Error getting seeker location: $e');
    }
    return LatLng(0, 0);
  }


  Future<void> catchHidersWithinRadius(String matchName, double radius) async {
    LatLng seekerLocation = await getSeekerLocation(matchName);
    DocumentReference matchRef = instance.collection('matches').doc(matchName);
    DocumentSnapshot matchSnapshot = await matchRef.get();
    if (matchSnapshot.exists) {
      Map<String, dynamic>? matchData = matchSnapshot.data() as Map<String, dynamic>?;
      if (matchData != null) {
        List<dynamic> participants = matchData['participants'];
        List<dynamic> updatedParticipants = [];
        for (var participant in participants) {
          if (participant['role'] == 'Hider') {
            LatLng hiderLocation = LatLng(participant['location']['latitude'], participant['location']['longitude']);
            double distance = getUserDistance(hiderLocation, seekerLocation);
            if (distance > radius) {
              // Keep the hider in the match if they are outside the radius
              updatedParticipants.add(participant);
            }
            // If the hider is within the radius, they are not added to updatedParticipants, effectively removing them
          } else {
            // Keep all non-hiders in the match
            updatedParticipants.add(participant);
          }
        }
        // Update the match document with the modified participants list
        await matchRef.update({'participants': updatedParticipants});
      }
    }
  }

    double getUserDistance(LatLng hiderLocation, LatLng seekerLocation) {
    const int earthRadius = 6371000;
    double lat1 = hiderLocation.latitude;
    double lon1 = hiderLocation.longitude;
    double lat2 = seekerLocation.latitude;
    double lon2 = seekerLocation.longitude;
    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);

    double distance = 2 * earthRadius * asin(sqrt((1-cos(dLat)) + cos(lat1) * cos(lat2) * (1-cos(dLon))/2));
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

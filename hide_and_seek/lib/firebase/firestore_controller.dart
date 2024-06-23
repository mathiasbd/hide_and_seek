import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../classes/ability_manager.dart';
import '../classes/User.dart';

class FirestoreController extends ChangeNotifier {
  final FirebaseFirestore instance;

  FirestoreController({required this.instance});


  // this method creates a match in the Firestore database

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


  // this method ensures that the user is added to the match with the correct ready status, if the user is an admin they will be added as ready by default

  Future<void> joinMatch(matchName, user) async {
    bool isAdmin = user['userType'] == 'Admin';
    Map<String, dynamic> userToAdd = isAdmin ? {...user, 'ready': true} : user;

    await instance.collection('matches').doc(matchName).update({
      'participants': FieldValue.arrayUnion([userToAdd]),
    }).then((_) {
      print('$user added to $matchName with ready status: ${isAdmin ? "true" : "false"}');
    }).catchError((error) {
      print('Failed to add user to match: $error');
    });
  }

  // this method removes the user from the match

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

  // this method removes the match from the Firestore database

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

  // this method changes the ready status of the user

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

  // this method changes the game started status to true

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

  // this method checks if all the users in the match are ready

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

  // this method assigns the seeker role to a random user in the match

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
        }
      }
    } catch (e) {
      debugPrint('Error checking if user is seeker');
    }
  }

  // this method fetches the user role from the Firestore database

  Future<String> fetchUserRole(String matchName, User user) async {
    try {
      DocumentReference matchRef = instance.collection('matches').doc(matchName);
      DocumentSnapshot matchSnapshot = await matchRef.get();
      if (matchSnapshot.exists) {
        Map<String, dynamic>? matchData = matchSnapshot.data() as Map<String, dynamic>?;
        if (matchData != null) {
          List<dynamic> participants = matchData['participants'];
          var updatedUser = participants.firstWhere((participant) => participant['id'] == user.id, orElse: () => null);
          return updatedUser != null ? updatedUser['role'] : user.role;
        }
      }
    } catch (e) {
      debugPrint('Error fetching user role: $e');
    }
    return user.role;
  }

  // this method updates the user location in the match

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
            debugPrint('User location updated successfully');
          } else {
            debugPrint('User not found in match');
          }
        }
      } else {
        debugPrint('Match document does not exist');
      }
    } catch (e) {
      debugPrint('Error updating user location: $e');
    }
  }

  // this method gets the location of the seeker in the match

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
            debugPrint('Seeker not found in match');
          }
        }
      } else {
        debugPrint('Match document does not exist');
      }
    } catch (e) {
      debugPrint('Error getting seeker location: $e');
    }
    return LatLng(0, 0);
  }

  // this method gets the locations of all the hiders in the match

  Future<List<LatLng>> getHidersLocations(String matchName) async {
    List<LatLng> hidersLocations = [];
    try {
      DocumentReference matchRef = instance.collection('matches').doc(matchName);
      DocumentSnapshot matchSnapshot = await matchRef.get();
      if (matchSnapshot.exists) {
        Map<String, dynamic>? matchData = matchSnapshot.data() as Map<String, dynamic>?;
        if (matchData != null) {
          List<dynamic> participants = matchData['participants'];
          for (var participant in participants) {
            if (participant['role'] == 'Hider') {
              LatLng hiderLocation = LatLng(participant['location']['latitude'], participant['location']['longitude']);
              hidersLocations.add(hiderLocation);
            }
          }
        }
      }
    } catch (e) {
      print('Error getting hiders locations: $e');
    }
    return hidersLocations;
  }

  // this methods keeps the hiders that are outside the radius and removes the hiders that are inside the radius

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

  // this method gets the distance between the hider and the seeker (should be put in ability_manager)

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

  // this method converts degrees to radians (should be put in ability_manager)

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }


}

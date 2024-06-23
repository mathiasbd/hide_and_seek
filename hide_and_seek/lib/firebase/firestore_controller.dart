import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../classes/User.dart';

class FirestoreController extends ChangeNotifier {
  final FirebaseFirestore instance;

  FirestoreController({required this.instance});

  // this method creates a match in the Firestore database

  Future<void> createMatch(String matchName) async {
    try {
      await instance
          .collection('matches')
          .doc(matchName)
          .set({'Match Name': matchName, 'Match started': false});
      debugPrint('Match created successfully');
    } catch (error) {
      debugPrint('Error creating match: $error');
    }
  }

  // this method ensures that the user is added to the match with the correct ready status, if the user is an admin they will be added as ready by default

  Future<void> joinMatch(String matchName, Map<String, dynamic> user) async {
    try {
      await instance.collection('matches').doc(matchName).update({
        'participants': FieldValue.arrayUnion([user]),
      });
      debugPrint('$user added to $matchName');
    } catch (error) {
      debugPrint('Failed to add user to match: $error');
    }
  }

  // this method removes the user from the match

  Future<void> removeUserFromMatch(String matchName, User user) async {
    try {
      await instance.collection('matches').doc(matchName).update({
        'participants': FieldValue.arrayRemove([user.toMap()])
      });
      debugPrint('User removed from the Firestore');
    } catch (e) {
      debugPrint('Error removing user: $e');
    }
  }

  // this method removes the match from the Firestore database

  Future<void> removeMatch(String matchName) async {
    try {
      await instance.collection('matches').doc(matchName).delete();
      debugPrint('$matchName deleted successfully');
    } catch (e) {
      debugPrint('Error deleting match: $e');
    }
  }

// This method gets a list of participants in the match
  Future<List<dynamic>?> getParticipants(matchName) async {
    try {
      DocumentReference matchRef =
          instance.collection('matches').doc(matchName);

      DocumentSnapshot matchSnapshot = await matchRef.get();

      if (matchSnapshot.exists) {
        Map<String, dynamic>? matchData =
            matchSnapshot.data() as Map<String, dynamic>?;

        if (matchData != null) {
          List<dynamic> participants = matchData['participants'];
          return participants;
        } else {
          print('No participant found');
        }
      } else {
        print('Match document reference does not exist');
      }
    } catch (e) {
      print('Error getting participants $e');
    }
    return null;
  }

  // this method changes the ready status of the user

  Future<void> changeUserReady(matchName, user) async {
    try {
      DocumentReference matchRef =
          instance.collection('matches').doc(matchName);

      List<dynamic>? participants = await getParticipants(matchName);

      if (participants != null) {
        int index = participants
            .indexWhere((participant) => participant['id'] == user.id);
        if (index != -1) {
          participants[index]['ready'] = user.ready;
          await matchRef.update({
            'participants': participants,
          });
          print('Participant ready status updated succesfully');
        }
      }
    } catch (e) {
      print('Error making participant ready: $e');
    }
  }

  // this method changes the game started status to true

  Future<void> changeGameStarted(String matchName) async {
    try {
      await instance
          .collection('matches')
          .doc(matchName)
          .update({'Match started': true});
      debugPrint('Game started successfully');
    } catch (e) {
      debugPrint('Error starting the game: $e');
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

  Future<bool?> checkAdminInMatch(matchName) async {
    try {
      List<dynamic>? participants = await getParticipants(matchName);

      if (participants != null) {
        for (int i = 0; i < participants.length; i++) {
          print(i);
          if (participants[i]['userType'] == 'Admin') {
            return true;
          }
        }
        print('No admin in this lobby');
      } else {
        print('No participants found');
      }
    } catch (e) {
      print('Error checking if the admin is in the match: $e');
    }
    return false;
  }

  //this method assigns the seeker role to a random user in the match

  Future<void> findRandomSeeker(String matchName) async {
    try {
      DocumentSnapshot matchSnapshot =
          await instance.collection('matches').doc(matchName).get();
      if (matchSnapshot.exists) {
        List<dynamic> participants = matchSnapshot['participants'];
        var random = Random();
        var randomSeeker = random.nextInt(participants.length);
        participants[randomSeeker]['role'] = 'Seeker';
        await instance.collection('matches').doc(matchName).update({
          'participants': participants,
        });
      }
    } catch (e) {
      debugPrint('Error assigning seeker role: $e');
    }
  }

  // this method fetches the user role from the Firestore database

  Future<String> fetchUserRole(String matchName, User user) async {
    try {
      DocumentReference matchRef =
          instance.collection('matches').doc(matchName);
      DocumentSnapshot matchSnapshot = await matchRef.get();
      if (matchSnapshot.exists) {
        Map<String, dynamic>? matchData =
            matchSnapshot.data() as Map<String, dynamic>?;
        if (matchData != null) {
          List<dynamic> participants = matchData['participants'];
          var updatedUser = participants.firstWhere(
              (participant) => participant['id'] == user.id,
              orElse: () => null);
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
          int index = participants
              .indexWhere((participant) => participant['role'] == 'Seeker');
          if (index != -1) {
            Map<String, dynamic> seekerLocation =
                participants[index]['location'];
            return LatLng(
                seekerLocation['latitude'], seekerLocation['longitude']);
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
    return const LatLng(0, 0);
  }

  // this method gets the locations of all the hiders in the match

  Future<List<LatLng>> getHidersLocations(String matchName) async {
    List<LatLng> hidersLocations = [];
    try {
      DocumentReference matchRef =
          instance.collection('matches').doc(matchName);
      DocumentSnapshot matchSnapshot = await matchRef.get();
      if (matchSnapshot.exists) {
        Map<String, dynamic>? matchData =
            matchSnapshot.data() as Map<String, dynamic>?;
        if (matchData != null) {
          List<dynamic> participants = matchData['participants'];
          for (var participant in participants) {
            if (participant['role'] == 'Hider') {
              LatLng hiderLocation = LatLng(participant['location']['latitude'],
                  participant['location']['longitude']);
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

  Future<void> catchHiders(String matchName) async {
    double radius = 100;
    LatLng seekerLocation = await getSeekerLocation(matchName);
    DocumentReference matchRef = instance.collection('matches').doc(matchName);
    DocumentSnapshot matchSnapshot = await matchRef.get();
    if (matchSnapshot.exists) {
      Map<String, dynamic>? matchData =
          matchSnapshot.data() as Map<String, dynamic>?;
      if (matchData != null) {
        List<dynamic> participants = matchData['participants'];
        List<dynamic> updatedParticipants = [];
        for (var participant in participants) {
          if (participant['role'] == 'Hider') {
            LatLng hiderLocation = LatLng(participant['location']['latitude'],
                participant['location']['longitude']);
            int distance = getUserDistance(hiderLocation, seekerLocation);
            if (distance > radius) {
              // Keep the hider in the match if they are outside the radius
              updatedParticipants.add(participant);
            }
            // If the hider is within the radius, they are not added to updatedParticipants, effectively removing them
          } else {
            // Keep all non-hiders in the match
            //updatedParticipants.add(participant);
          }
        }
        // Update the match document with the modified participants list
        await matchRef.update({'participants': updatedParticipants});
      }
    }
  }


  // This method returns the number of players in a given match

  Future<int> getNumberOfPlayersInMatch(String matchName) async {
    try {
      DocumentSnapshot matchSnapshot = await instance.collection('matches').doc(matchName).get();
      if (matchSnapshot.exists) {
        Map<String, dynamic>? matchData = matchSnapshot.data() as Map<String, dynamic>?;
        if (matchData != null && matchData.containsKey('participants')) {
          List<dynamic> participants = matchData['participants'];
          return participants.length;
        }
      }
      return 0;
    } catch (e) {
      debugPrint('Error getting number of players in match: $e');
      return 0;
    }
  }

  // this method gets the distance between the hider and the seeker

  int getUserDistance(LatLng hiderLocation, LatLng seekerLocation) {
    const int earthRadius = 6363652;
    double lat1 = degreesToRadians(hiderLocation.latitude);
    double lon1 = degreesToRadians(hiderLocation.longitude);
    double lat2 = degreesToRadians(seekerLocation.latitude);
    double lon2 = degreesToRadians(seekerLocation.longitude);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
              cos(lat1) * cos(lat2) *
              sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    debugPrint(distance.toString());
    return distance.round();
  }

  Future<int> distanceToSeeker(String matchName, User user) async {
    LatLng seekerPos = await getSeekerLocation(matchName);

    return getUserDistance(user.location!, seekerPos);
  }

  // this method converts degrees to radians

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}

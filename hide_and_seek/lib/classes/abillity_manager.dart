import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';


class AbillityManager {

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  void getHiderLocations() {
    // Make a LatLng field in the User class
    // constantly update the user's location in the database
    // Get the hider locations from the database
    // make points on the map for each hider
  }

  void getNoiseQue() {
    await _firebaseMessaging.send(RemoteMessage(
      notification: Notification(
        title: 'Noise Que Notification',
        body: 'A noise que has been triggered',
      ),
      data: {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
      },
      topic: 'noiseQue',
    ));
  }

  bool catchHider(LatLng hiderLocation, LatLng seekerLocation, double radius) {
    const int earthRadius = 6371000;
    double lat1 = hiderLocation.latitude;
    double lon1 = hiderLocation.longitude;
    double lat2 = seekerLocation.latitude;
    double lon2 = seekerLocation.longitude;
    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);
    double distance = 2 * earthRadius * asin(sqrt((1-cos(dLat)) + cos(lat1) * cos(lat2) * (1-cos(dLon))/2));
    if (distance <= radius) {
      return true;
    }
    return false;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

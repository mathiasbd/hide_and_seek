import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';

class AbilityManager {

  final FirestoreController firestoreController;

  AbilityManager({required this.firestoreController});
  
  Future<List<LatLng>> getHidersLocations(String matchName) async {
    return firestoreController.getHidersLocations(matchName);
  }

  void catchHiders(String matchName) {
    double radius = 1;
    firestoreController.catchHidersWithinRadius(matchName, radius);
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../classes/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hide_and_seek/firebase/firestore_controller.dart';


class MapsPage extends StatefulWidget {
  final String matchName;
  final User user;

  const MapsPage({
    super.key,
    required this.matchName,
    required this.user,
  });

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final locationController = Location();
  LatLng? currentPos;
  BitmapDescriptor currentPosIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await getUserLocation());
    super.initState();
    setCustomMarkerIcon();
  }

  Future<void> getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permission;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permission = await locationController.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await locationController.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) async{
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          currentPos =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        widget.user.location = currentPos;
        await FirestoreController(instance: FirebaseFirestore.instance).changeUserLocation(widget.matchName, widget.user);
      }
    });
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/CurrentLocation.png")
        .then(
      (icon) {
        currentPosIcon = icon;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentPos == null
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: currentPos!, zoom: 14),
                markers: {
                    Marker(
                        markerId: const MarkerId('Current position'),
                        icon: currentPosIcon,
                        position: currentPos!)
                  }));
  }
}

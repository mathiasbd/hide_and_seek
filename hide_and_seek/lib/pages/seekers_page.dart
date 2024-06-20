import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../my_colors.dart';
import '../classes/abillity.dart';

class SeekersPage extends StatefulWidget {
  @override
  _SeekersPageState createState() => _SeekersPageState();
}

class _SeekersPageState extends State<SeekersPage> {
  final Ability getHiderLocationsAbility = Ability('Get Hider Locations');
  final Ability catchHiderAbility = Ability('Catch Hider');
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

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPos =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        print(currentPos);
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
      backgroundColor: Color.fromARGB(255, 95, 188, 255),
      appBar: AppBar(
        title: const Text('Seeker'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
          fontFamily: 'Oswald',
        ),
        backgroundColor: Colors.blue[400],
      ),
      body: currentPos == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(target: currentPos!, zoom: 14),
              markers: {
                  Marker(
                      markerId: const MarkerId('Current position'),
                      icon: currentPosIcon,
                      position: currentPos!)
                },
            ),
    );
  }
}
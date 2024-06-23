import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../classes/User.dart';

class MapsPage extends StatefulWidget {
  final String matchName;
  final User user;
  @override
  final GlobalKey<MapsPageState> key;

  const MapsPage({
    required this.matchName,
    required this.user,
    required this.key,
  }) : super(key: key);

  @override
  MapsPageState createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {
  final locationController = Location();
  LatLng? currentPos;
  BitmapDescriptor? currentPosIcon;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    initializeLocationAndMarker();
  }

  Future<void> initializeLocationAndMarker() async {
    await setCustomMarkerIcon();
    await checkAndRequestLocationPermissions();
    subscribeToLocationChanges();
  }

  Future<void> setCustomMarkerIcon() async {
    currentPosIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/CurrentLocation.png");
  }

  Future<void> checkAndRequestLocationPermissions() async {
    bool serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permission = await locationController.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await locationController.requestPermission();
      if (permission != PermissionStatus.granted) return;
    }
  }

  void subscribeToLocationChanges() {
    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        updateLocation(LatLng(currentLocation.latitude!, currentLocation.longitude!));
      }
    });
  }

  void updateLocation(LatLng newLocation) {
    setState(() {
      currentPos = newLocation;
    });
    widget.user.updateLocation(newLocation, widget.matchName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentPos == null
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
                initialCameraPosition: CameraPosition(target: currentPos!, zoom: 14),
                markers: markers..add(Marker(
                    markerId: const MarkerId('Current position'),
                    icon: currentPosIcon ?? BitmapDescriptor.defaultMarker,
                    position: currentPos!)),
              ));
  }

  void addMarkers(List<LatLng> hiderLocation) {
    markers = {};
    debugPrint('addMarkers called');
    setState(() {
      debugPrint('Setstate innit');
      for (var location in hiderLocation) {
        debugPrint('$location');
        markers.add(
          Marker(
            markerId: MarkerId(location.toString()),
            icon:  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: location,
          ),
        );
      }
    });
  }
}
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isLocationPermissionGranted = false;
  late GoogleMapController _controller;
  late CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(0.0, 0.0), // Default location
    zoom: 10, // Default zoom level
  );


  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: _isLocationPermissionGranted
          ? GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _controller = controller;
                });
                _getUserLocation();
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<void> _requestLocationPermission() async {
    var permissionResult = await Permission.location.request();
    if (permissionResult.isGranted) {
      setState(() {
        _isLocationPermissionGranted = true;
      });
    }
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _initialCameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        );
      });

      _controller.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    } catch (e) {
      print('Error getting user location: $e');
    }
  }
}

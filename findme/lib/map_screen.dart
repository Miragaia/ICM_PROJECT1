import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  late CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(0.0, 0.0), // Default location
    zoom: 10, // Default zoom level
  );

  late LatLng _friendLocation = LatLng(37.422, -122.084); // Friend's location
  late String _direction = ''; // Direction to friend's location
  String _latitude = '';
  String _longitude = '';

  bool _isLocationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _updateLocationAndDirection(); // Start updating location and direction
    _getFriendLocation(); // Start listening for friend's location updates
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: _isLocationPermissionGranted
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: _initialCameraPosition,
                          mapType: MapType.normal,
                          myLocationEnabled: true, // Enable showing the user's location with a blue dot
                          markers: _friendLocation != null
                              ? {
                                  Marker(
                                    markerId: MarkerId('Friend'),
                                    position: _friendLocation!,
                                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                                  )
                                }
                              : {},
                          onMapCreated: (GoogleMapController controller) {
                            setState(() {
                              _controller = controller;
                            });
                            _getUserLocation();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Your Current Position: $_latitude, $_longitude',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Direction to Friend: $_direction',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        size: 48, // Adjust the size as needed
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }


  Future<void> _checkLocationPermission() async {
    var permissionStatus = await Permission.location.status;
    if (permissionStatus.isGranted) {
      setState(() {
        _isLocationPermissionGranted = true;
      });
    } else if (permissionStatus.isDenied ||
        permissionStatus.isRestricted ||
        permissionStatus.isPermanentlyDenied) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Location Permission'),
          content: Text('This app requires access to your location to function properly.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                var permissionResult = await Permission.location.request();
                if (permissionResult.isGranted) {
                  setState(() {
                    _isLocationPermissionGranted = true;
                  });
                }
              },
              child: Text('Allow'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Deny'),
            ),
          ],
        ),
      );
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
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
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

  void _updateLocationAndDirection() {
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      _getUserLocation();
      _calculateDirection();
    });
  }

  void _getFriendLocation() {
    // Simulated function to receive friend's location updates
    // Replace this with your actual implementation using a communication channel
    // For demonstration purposes, friend's location is simulated every 5 seconds
    // This function will keep updating the friend's location on the map when available
    Future.delayed(Duration(seconds: 10), () {
      // Generate random latitude and longitude coordinates
      Random random = Random();
      double minLat = -90.0;
      double maxLat = 90.0;
      double minLong = -180.0;
      double maxLong = 180.0;

      double randomLat = minLat + random.nextDouble() * (maxLat - minLat);
      double randomLong = minLong + random.nextDouble() * (maxLong - minLong);

      // Simulated friend's location
      LatLng friendLocation = LatLng(randomLat, randomLong);

      setState(() {
        _friendLocation = friendLocation;
      });

      // Recursive call to keep getting friend's location updates
      _getFriendLocation();
    });
  }

  double bearingBetweenCoordinates(LatLng from, LatLng to) {
    double lat1 = from.latitude * pi / 180.0;
    double lon1 = from.longitude * pi / 180.0;
    double lat2 = to.latitude * pi / 180.0;
    double lon2 = to.longitude * pi / 180.0;

    double dLon = lon2 - lon1;

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    double bearing = atan2(y, x) * 180.0 / pi;
    return (bearing + 360) % 360;
  }

  void _calculateDirection() {
    double bearing = bearingBetweenCoordinates(
      LatLng(_initialCameraPosition.target.latitude, _initialCameraPosition.target.longitude),
      _friendLocation,
    );

    // Convert degrees to cardinal direction
    if (bearing >= 0 && bearing < 22.5) {
      _direction = 'North';
    } else if (bearing >= 22.5 && bearing < 67.5) {
      _direction = 'Northeast';
    } else if (bearing >= 67.5 && bearing < 112.5) {
      _direction = 'East';
    } else if (bearing >= 112.5 && bearing < 157.5) {
      _direction = 'Southeast';
    } else if (bearing >= 157.5 && bearing < 202.5) {
      _direction = 'South';
    } else if (bearing >= 202.5 && bearing < 247.5) {
      _direction = 'Southwest';
    } else if (bearing >= 247.5 && bearing < 292.5) {
      _direction = 'West';
    } else if (bearing >= 292.5 && bearing < 337.5) {
      _direction = 'Northwest';
    } else {
      _direction = 'North';
    }
    
    setState(() {});
  }
}

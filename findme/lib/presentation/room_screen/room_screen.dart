import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';

import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_compass/flutter_compass.dart';


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:math';
import '../home_page/home_page.dart';

class RoomScreen extends StatefulWidget {
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late GoogleMapController _controller;
  late CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(0.0, 0.0), // Default location
    zoom: 10, // Default zoom level
  );

  List<User> _users = []; // List to store users data

  LatLng _friendLocation = LatLng(0.0, 0.0); // Friend's location
  String _direction = ''; // Direction to friend's location
  String _directionMeters = ''; // Distance to friend's location
  String _latitude = '';
  String _longitude = '';
  double? _arrowRotation;

  bool _isLocationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _updateLocationAndDirection(); // Start updating location and direction
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUsers();
  }

  void _fetchUsers() {
    try {
      final Map<String, dynamic> args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      final String roomId = args['roomName']; // Get roomId from arguments

      FirebaseFirestore.instance
          .collection('users')
          .where('roomId', isEqualTo: roomId)
          .snapshots()
          .listen((QuerySnapshot usersSnapshot) {
        setState(() {
          _users = usersSnapshot.docs.map((doc) {
            User user = User.fromSnapshot(doc);
            // Preserve the isSelected property set by user interaction
            User? existingUser = _users.firstWhere(
                (existingUser) => existingUser.id == user.id,
                orElse: () => user);
            user.isSelected = existingUser.isSelected;
            return user;
          }).toList();
        });
        print('Users updated: $_users');
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  // Define a map to store the angles for each direction
  final Map<String, double> directionAngles = {
    'North': 0,
    'North Northeast': pi / 8,
    'Northeast': pi / 4,
    'East Northeast': 3 * pi / 8,
    'East': pi / 2,
    'East Southeast': 5 * pi / 8,
    'Southeast': 3 * pi / 4,
    'South Southeast': 7 * pi / 8,
    'South': pi,
    'South Southwest': 9 * pi / 8,
    'Southwest': 5 * pi / 4,
    'West Southwest': 11 * pi / 8,
    'West': 3 * pi / 2,
    'West Northwest': 13 * pi / 8,
    'Northwest': 7 * pi / 4,
    'North Northwest': 15 * pi / 8,
  };

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String roomName = args['roomName'];
    final String location = args['location'];
    final String usersCount = args['usersCount'];
    final String image = args['image'];
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 7.v),
          child: Column(
            children: [
              Container(
                height: 50.adaptSize,
                width: 50.adaptSize,
                padding: EdgeInsets.symmetric(horizontal: 1.h),
                decoration: AppDecoration.fillGreen.copyWith(
                  borderRadius: BorderRadiusStyle.circleBorder22,
                ),
                child: CustomImageView(
                  imagePath: image,
                  height: 67.adaptSize,
                  width: 67.adaptSize,
                  radius: BorderRadius.circular(15.h),
                  alignment: Alignment.topCenter,
                ),
              ),
              Text(roomName, style: theme.textTheme.titleLarge),
              SizedBox(height: 4.v),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgLocation,
                    height: 18.adaptSize,
                    width: 18.adaptSize,
                    margin: EdgeInsets.only(bottom: 3.v),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.h),
                    child: Text(location, style: theme.textTheme.titleSmall),
                  ),
                ],
              ),
              SizedBox(height: 5.v),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgImage4,
                    height: 28.v,
                    width: 29.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3.h),
                    child: Text(usersCount, style: CustomTextStyles.bodyLargePoppins),
                  ),
                ],
              ),
              SizedBox(height: 10.v),
              _buildMap(context),
              SizedBox(height: 5.v),
              Text("Users", style: CustomTextStyles.titleLargeInter),
              SizedBox(height: 1.v),
              Text("Select the User to follow", style: theme.textTheme.titleSmall),
              Text("(scroll to see more users)", style: theme.textTheme.titleSmall),

              Container(
                height: 70,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _users
                        .where((user) => user.email != FirebaseAuth.instance.currentUser?.email)
                        .map((user) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _users.forEach((currentUser) {
                              currentUser.isSelected = (currentUser == user);
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUser.id)
                                  .update({'isSelected': currentUser.isSelected})
                                  .then((_) => print('User isSelected updated in Firestore'))
                                  .catchError((error) => print('Error updating user isSelected: $error'));
                            });
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImageView(
                              imagePath: user.isSelected ? ImageConstant.imgImage10 : ImageConstant.imgImage7,
                              height: 20.adaptSize,
                              width: 20.adaptSize,
                              margin: EdgeInsets.only(top: 4.v),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 27.h),
                              child: Text(
                                user.name,
                                style: CustomTextStyles.titleMediumGray700.copyWith(
                                  color: user.isSelected ? Colors.red : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(height: 10.v),
              Container(
                height: 18,
                child: Text(
                  "Direction to Friend: $_direction",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                ),
              ),
              Container(
                height: 45,
                child: FutureBuilder<double>(
                  future: _getCompassHeading(), // Call the function to get the compass heading
                  builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for the future to complete, show a loading indicator or placeholder
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // If there's an error, handle it accordingly
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Once the future completes successfully, use the result to rotate the arrow
                      return Transform.rotate(
                        angle: snapshot.data ?? 0, // Use the heading to rotate the arrow
                        child: CustomImageView(
                          imagePath: ImageConstant.imgImage11,
                          height: 40.v,
                          width: 40.h,
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 119.h),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 40.v),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 30.v,
                  width: 154.h,
                  margin: EdgeInsets.only(right: 81.h),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                _directionMeters,
                                style: CustomTextStyles.titleLargeGray700.copyWith(
                                  fontSize: _directionMeters.length > 10 ? 14.0 : 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: 30.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeft,
            margin: EdgeInsets.only(left: 20.h, top: 17.v, bottom: 17.v),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HomePage();
              }));
            }),
        centerTitle: true,
        title: AppbarTitle(text: "Room"));
  }

  Widget _buildMap(BuildContext context) {
    return SizedBox(
      height: 250.v,
      width: 340.h,
      child: _isLocationPermissionGranted
          ? GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              mapType: MapType.normal,
              myLocationEnabled: true,
              markers: _users
                  .where((user) =>
                      user.email != FirebaseAuth.instance.currentUser?.email)
                  .map((user) {
                return Marker(
                  markerId: MarkerId(user.id),
                  position: LatLng(user.latitude, user.longitude),
                  icon: user.isSelected
                      ? BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen)
                      : BitmapDescriptor.defaultMarker,
                );
              }).toSet(),
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

  Future<double> _getCompassHeading() async {
    try {
      // Listen to the FlutterCompass events stream and get the first event
      CompassEvent? compassEvent = await FlutterCompass.events!.first;
      double heading = compassEvent?.heading ?? 0; // Extract the heading value
      return heading;
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error getting compass heading: $e');
      return 0; // Return a default value in case of error
    }
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
          content: Text(
              'This app requires access to your location to function properly.'),
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

      // Update user's location in Firestore
      String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
      if (userEmail.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({
              'latitude': position.latitude,
              'longitude': position.longitude,
            })
            .then((_) => print('User location updated in Firestore'))
            .catchError(
                (error) => print('Error updating user location: $error'));
      }
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  void _updateLocationAndDirection() {
    Timer.periodic(Duration(seconds: 4), (Timer timer) {
      _getUserLocation();
      _calculateDirection();
      _calculateDirectionMeters();
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

  void _calculateDirectionMeters() {
    // Get the current user's location
    double userLatitude = double.parse(_latitude);
    double userLongitude = double.parse(_longitude);

    // Find the selected friend's location
    User selectedFriend = _users.firstWhere((user) => user.isSelected,
        orElse: () => User(
            id: '',
            name: '',
            email: '',
            latitude: 0,
            longitude: 0,
            isSelected: false));
    double friendLatitude = selectedFriend.latitude;
    double friendLongitude = selectedFriend.longitude;

    // Calculate the distance between the current user and the selected friend
    double distance = _calculateDistance(
        userLatitude, userLongitude, friendLatitude, friendLongitude);

    // Convert distance to kilometers if it exceeds 1000 meters
    if (distance >= 1000) {
      distance /= 1000; // Convert meters to kilometers
      _directionMeters =
          '${distance.toStringAsFixed(2)} km away'; // Format to display only two decimal units
    } else {
      _directionMeters =
          '${distance.toStringAsFixed(2)} meters away'; // Format to display only two decimal units
    }

    setState(() {});
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double radius = 6371; // Earth's radius in km

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radius * c * 1000; // Convert to meters
    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  void _calculateDirection() {
    // Get the current user's location
    double userLatitude = double.parse(_latitude);
    double userLongitude = double.parse(_longitude);

    // Find the selected friend's location
    User selectedFriend = _users.firstWhere((user) => user.isSelected,
        orElse: () => User(
            id: '',
            name: '',
            email: '',
            latitude: 0,
            longitude: 0,
            isSelected: false));
    double friendLatitude = selectedFriend.latitude;
    double friendLongitude = selectedFriend.longitude;

    double bearing = bearingBetweenCoordinates(
      LatLng(_initialCameraPosition.target.latitude,
          _initialCameraPosition.target.longitude),
          LatLng(friendLatitude, friendLongitude),
    );

    // Convert degrees to cardinal direction
    if (bearing >= 0 && bearing < 11.25) {
      _direction = 'North';
    } else if (bearing >= 11.25 && bearing < 33.75) {
      _direction = 'North Northeast';
    } else if (bearing >= 33.75 && bearing < 56.25) {
      _direction = 'Northeast';
    } else if (bearing >= 56.25 && bearing < 78.75) {
      _direction = 'East Northeast';
    } else if (bearing >= 78.75 && bearing < 101.25) {
      _direction = 'East';
    } else if (bearing >= 101.25 && bearing < 123.75) {
      _direction = 'East Southeast';
    } else if (bearing >= 123.75 && bearing < 146.25) {
      _direction = 'Southeast';
    } else if (bearing >= 146.25 && bearing < 168.75) {
      _direction = 'South Southeast';
    } else if (bearing >= 168.75 && bearing < 191.25) {
      _direction = 'South';
    } else if (bearing >= 191.25 && bearing < 213.75) {
      _direction = 'South Southwest';
    } else if (bearing >= 213.75 && bearing < 236.25) {
      _direction = 'Southwest';
    } else if (bearing >= 236.25 && bearing < 258.75) {
      _direction = 'West Southwest';
    } else if (bearing >= 258.75 && bearing < 281.25) {
      _direction = 'West';
    } else if (bearing >= 281.25 && bearing < 303.75) {
      _direction = 'West Northwest';
    } else if (bearing >= 303.75 && bearing < 326.25) {
      _direction = 'Northwest';
    } else if (bearing >= 326.25 && bearing < 348.75) {
      _direction = 'North Northwest';
    } else {
      _direction = 'North';
    }

    setState(() {});
  }

  onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}

class User {
  String id;
  String name;
  String email;
  double latitude;
  double longitude;
  bool isSelected;
  // Other properties...

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.isSelected,
    // Initialize other properties here...
  });

  // Factory method to construct User object from DocumentSnapshot
  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return User(
      id: snapshot.id,
      name: data['username'] ?? '',
      email: data['email'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(), // Convert to double
      longitude: (data['longitude'] ?? 0).toDouble(), // Convert to double
      isSelected: data['isSelected'] ?? false,
      // Map other properties accordingly...
    );
  }
}

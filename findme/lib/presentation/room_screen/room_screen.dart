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
  String _latitude = '';
  String _longitude = '';

  bool _isLocationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _updateLocationAndDirection(); // Start updating location and direction
    _listenForFriendLocation(); // Start listening for friend's location updates
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUsers();
  }


  // Fetch users data with the current roomId
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
          _users = usersSnapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();
        });
        print('Users updated: $_users');
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }



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
                child: Column(children: [
                  Container(
                    height: 70.adaptSize,
                    width: 70.adaptSize,
                    padding: EdgeInsets.symmetric(horizontal: 1.h),
                    decoration: AppDecoration.fillGreen.copyWith(
                      borderRadius: BorderRadiusStyle.circleBorder22,
                    ),
                    child: CustomImageView(
                      imagePath: image, // Use the passed image path
                      height: 67.adaptSize,
                      width: 67.adaptSize,
                      radius: BorderRadius.circular(15.h),
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Text(roomName,
                      style: theme
                          .textTheme.titleLarge), // Use the passed roomName
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
                        child: Text(location,
                            style: theme.textTheme
                                .titleSmall), // Use the passed location
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
                        child: Text(usersCount,
                            style: CustomTextStyles
                                .bodyLargePoppins), // Use the passed usersCount
                      ),
                    ],
                  ),
                  SizedBox(height: 10.v),
                  _buildMap(context),
                  SizedBox(height: 5.v),
                  Text("Users", style: CustomTextStyles.titleLargeInter),
                  SizedBox(height: 1.v),
                  Text("Select the User to follow",
                      style: theme.textTheme.titleSmall),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _users.where((user) => user.email != FirebaseAuth.instance.currentUser?.email).map((user) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgImage7,
                            height: 26.adaptSize,
                            width: 26.adaptSize,
                            margin: EdgeInsets.only(top: 4.v),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 27.h),
                            child: Text(
                              user.name,
                              style: CustomTextStyles.titleLargeGray700.copyWith(color: Colors.red), // Set the color to red
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.v),
                  Text("Direction to Friend: $_direction",
                      style: CustomTextStyles.titleLargeInter),
                  SizedBox(height: 6.v),
                  Transform.rotate(
                    angle: (_direction == 'North')
                        ? 0
                        : (_direction == 'Northeast')
                            ? pi / 4
                            : (_direction == 'East')
                                ? pi / 2
                                : (_direction == 'Southeast')
                                    ? 3 * pi / 4
                                    : (_direction == 'South')
                                        ? pi
                                        : (_direction == 'Southwest')
                                            ? 5 * pi / 4
                                            : (_direction == 'West')
                                                ? 3 * pi / 2
                                                : (_direction == 'Northwest')
                                                    ? 7 * pi / 4
                                                    : 0,
                    child: CustomImageView(
                        imagePath: ImageConstant.imgImage11,
                        height: 50.v,
                        width: 50.h,
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 119.h)),
                  ),
                  SizedBox(height: 20.v),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          height: 40.v,
                          width: 154.h,
                          margin: EdgeInsets.only(right: 81.h),
                          child:
                              Stack(alignment: Alignment.topCenter, children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: Text("12 meters away",
                                    style: CustomTextStyles.titleLargeGray700))
                          ]))),
                ]))));
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: 30.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeft,
            margin: EdgeInsets.only(left: 20.h, top: 17.v, bottom: 17.v),
            onTap: () {
              onTapArrowLeft(context);
            }),
        centerTitle: true,
        title: AppbarTitle(text: "Room"));
  }

  /// Section Widget
  Widget _buildMap(BuildContext context) {
    return SizedBox(
      height: 250.v,
      width: 340.h,
      child: _isLocationPermissionGranted
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
                          myLocationEnabled:
                              true, // Enable showing the user's location with a blue dot
                          markers: _friendLocation != null
                              ? {
                                  Marker(
                                    markerId: MarkerId('Friend'),
                                    position: _friendLocation,
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueGreen),
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

  void _listenForFriendLocation() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc('friend1')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        double latitude = snapshot['latitude'];
        double longitude = snapshot['longitude'];
        setState(() {
          _friendLocation = LatLng(latitude, longitude);
          _calculateDirection();
        });
      }
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
      LatLng(_initialCameraPosition.target.latitude,
          _initialCameraPosition.target.longitude),
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

  onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}

class User {
  String id;
  String name;
  String email;
  // Other properties...

  User({
    required this.id,
    required this.name,
    required this.email,
    // Initialize other properties here...
  });

  // Factory method to construct User object from DocumentSnapshot
  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return User(
      id: snapshot.id,
      name: data['username'] ?? '',
      email: data['email'] ?? '',
      // Map other properties accordingly...
    );
  }
}

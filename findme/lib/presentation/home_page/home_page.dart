import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/app_bar/appbar_trailing_circleimage.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_search_view.dart';
import '../../presentation/create_room_bottomsheet/create_room_bottomsheet.dart';
import '../../presentation/enter_room_bottomsheet/enter_room_bottomsheet.dart';
import 'widgets/home_item_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      updateRoomId();
    });
  }

  void createRoom(String roomName, String location, String image) {
    //nothing done here
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _buildSearchBox(context),
            SizedBox(height: 20.v),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: _buildTwentySix(context,
                  availableRooms: "Available Rooms", showAll: "Show All"),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 24.v),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('rooms')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }

                          return FutureBuilder<List<Map<String, dynamic>>>(
                            future: _fetchRoomsData(snapshot.data!.docs),
                            builder: (context, roomsSnapshot) {
                              if (roomsSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }

                              if (roomsSnapshot.hasError) {
                                return Center(
                                    child:
                                        Text('Error: ${roomsSnapshot.error}'));
                              }

                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 15.v),
                                    SingleChildScrollView(
                                      // Wrap _buildHome with SingleChildScrollView
                                      child: _buildHome(
                                          context, roomsSnapshot.data!),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomContainer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBottomItem(
            context,
            label: 'Home',
            icon: Icons.home,
            onTap: () => Navigator.pushNamed(context, AppRoutes.homePage),
          ),
          _buildBottomItem(
            context,
            label: 'Create Room',
            icon: Icons.add,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.85, // Define a altura como 80% da altura da tela
                    child: CreateRoomBottomsheet(
                      onCreateRoom: createRoom,
                    ),
                  );
                },
              );
            },
          ),
          _buildBottomItem(
            context,
            label: 'Profile',
            icon: Icons.person,
            onTap: () => Navigator.pushNamed(context, AppRoutes.profileScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsList(BuildContext context, List<DocumentSnapshot> docs) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchRoomsData(docs),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return _buildHome(context, snapshot.data!);
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchRoomsData(
      List<DocumentSnapshot> docs) async {
    List<Map<String, dynamic>> roomsData = [];
    for (var doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String roomName = data['name'];
      int usersCount = 0;

      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('roomId', isEqualTo: roomName)
          .get();
      usersCount = usersSnapshot.size;

      roomsData.add({
        'roomName': roomName,
        'location': data['location'],
        'usersCount': '$usersCount Users',
        'image': ImageConstant.imgDefaulRoom,
      });
    }
    return roomsData;
  }

  Widget _buildBottomItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    void Function()? onTap, // Define onTap parameter
  }) {
    return GestureDetector(
      // Wrap the column with GestureDetector to handle taps
      onTap: onTap, // Assign onTap callback
      child: Column(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(height: 5.v),
          Text(
            label,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 64.h,
      actions: [
        AppbarTrailingCircleimage(
          imagePath: ImageConstant.imgRectangle382,
          margin: EdgeInsets.symmetric(
            horizontal: 20.h,
            vertical: 6.v,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildSearchBox(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CustomSearchView(
              controller: searchController,
              hintText: "Search rooms...",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHome(
      BuildContext context, List<Map<String, dynamic>> roomsData) {
    return ListView.builder(
      itemCount: roomsData.length,
      shrinkWrap: true,
      physics:
          ClampingScrollPhysics(), // Eita que o ListView tenha um efeito de rebote
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return EnterRoomBottomsheet(
                  roomName: roomsData[index]['roomName'],
                  location: roomsData[index]['location'],
                  usersCount: roomsData[index]['usersCount'],
                  image: roomsData[index]['image'],
                );
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: HomeItemWidget(
              roomName: roomsData[index]['roomName'],
              location: roomsData[index]['location'],
              usersCount: roomsData[index]['usersCount'],
              image: roomsData[index]['image'],
            ),
          ),
        );
      },
    );
  }

  /// Common widget
  Widget _buildTwentySix(
    BuildContext context, {
    required String availableRooms,
    required String showAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          availableRooms,
          style: theme.textTheme.titleLarge!.copyWith(
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.v),
          child: Text(
            showAll,
            style: theme.textTheme.bodySmall!.copyWith(
              color: appTheme.gray700,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> updateRoomId() async {
    try {
      String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
      if (userEmail.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({
          'roomId': "",
        });
        print('RoomId updated successfully');
      } else {
        print('User email is empty');
      }
    } catch (e) {
      print('Error updating roomId: $e');
    }
  }
}

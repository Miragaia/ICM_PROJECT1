import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/app_bar/appbar_trailing_circleimage.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_search_view.dart';
import '../../presentation/create_room_bottomsheet/create_room_bottomsheet.dart';
import '../../presentation/enter_room_bottomsheet/enter_room_bottomsheet.dart';
import 'widgets/home_item_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  TextEditingController searchController = TextEditingController();

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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 24.v),
                child: Column(
                  children: [
                    _buildSearchBox(context),
                    SizedBox(
                      height: 425.v,
                      width: double.maxFinite,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }

                          List<Map<String, dynamic>> roomsData = snapshot.data!.docs.map((doc) {
                            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                            return {
                              'roomName': data['name'],
                              'location': data['location'],
                              'usersCount': "1 Users", // For now, consider it as static
                              'image': ImageConstant.imgDefaulRoom, // For now, consider it as static
                            };
                          }).toList();

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTwentySix(context, availableRooms: "Available Rooms", showAll: "Show All"),
                                SizedBox(height: 15.v),
                                _buildHome(context, roomsData),
                              ],
                            ),
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
          _buildBottomItem(
            context,
            label: 'Settings',
            icon: Icons.settings,
            onTap: () => Navigator.pushNamed(context, AppRoutes.homePage),
          ),
        ],
      ),
    );
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

  Widget _buildHome(BuildContext context, List<Map<String, dynamic>> roomsData) {
    List<Widget> roomsWidgets = [];

    for (int i = 0; i < roomsData.length; i++) {
      roomsWidgets.add(
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return EnterRoomBottomsheet(
                  roomName: roomsData[i]['roomName'],
                  location: roomsData[i]['location'],
                  usersCount: roomsData[i]['usersCount'],
                  image: roomsData[i]['image'],
                );
              },
            );
          },
          child: HomeItemWidget(
            roomName: roomsData[i]['roomName'],
            location: roomsData[i]['location'],
            usersCount: roomsData[i]['usersCount'],
            image: roomsData[i]['image'],
          ),
        ),
      );

      // Add a SizedBox after each item, except the last one
      if (i < roomsData.length - 1) {
        roomsWidgets.add(SizedBox(height: 10));
      }
    }

    return Column(
      children: roomsWidgets,
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
}
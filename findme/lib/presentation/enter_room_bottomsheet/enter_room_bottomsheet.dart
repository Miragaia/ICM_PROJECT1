import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../presentation/room_screen/room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnterRoomBottomsheet extends StatefulWidget {
  final String roomName;
  final String location;
  final String usersCount;
  final String image;

  EnterRoomBottomsheet({
    Key? key,
    required this.roomName,
    required this.location,
    required this.usersCount,
    required this.image,
  }) : super(key: key);

  @override
  _EnterRoomBottomsheetState createState() => _EnterRoomBottomsheetState();
}

class _EnterRoomBottomsheetState extends State<EnterRoomBottomsheet> {
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 11.h,
          vertical: 10.v,
        ),
        child: Column(
          children: [
            SizedBox(
              width: 80.h,
              child: Divider(),
            ),
            SizedBox(height: 32.v),
            Container(
              height: 70.adaptSize,
              width: 70.adaptSize,
              padding: EdgeInsets.symmetric(horizontal: 1.h),
              decoration: AppDecoration.fillGreen.copyWith(
                borderRadius: BorderRadiusStyle.circleBorder22,
              ),
              child: CustomImageView(
                imagePath: widget.image,
                height: 67.adaptSize,
                width: 67.adaptSize,
                radius: BorderRadius.circular(
                  15.h,
                ),
                alignment: Alignment.topCenter,
              ),
            ),
            SizedBox(height: 13.v),
            Text(
              widget.roomName,
              style: theme.textTheme.titleLarge,
            ),
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
                  child: Text(
                    widget.location,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.v),
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
                  child: Text(
                    widget.usersCount,
                    style: CustomTextStyles.bodyLargePoppins,
                  ),
                ),
              ],
            ),
            SizedBox(height: 42.v),
            Padding(
              padding: EdgeInsets.only(left: 18.h),
              child: CustomTextFormField(
                controller: passwordController,
                hintText: "Insert Password",
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.visiblePassword,
                alignment: Alignment.centerRight,
                obscureText: true,
              ),
            ),
            SizedBox(height: 76.v),
            CustomElevatedButton(
              height: 88.v,
              width: 220.h,
              text: "Enter Room",
              buttonTextStyle: theme.textTheme.headlineSmall!,
              onPressed: () async {
                String password = passwordController.text;
                bool isPasswordCorrect = await verifyPassword(widget.roomName, password);
                if (isPasswordCorrect) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.roomScreen,
                    arguments: {
                      'roomName': widget.roomName,
                      'location': widget.location,
                      'usersCount': widget.usersCount,
                      'image': widget.image,
                    },
                  );
                } else {
                  // Show error message or handle incorrect password
                  print('Incorrect password');
                }
              },
            ),
            SizedBox(height: 76.v),
          ],
        ),
      ),
    );
  }

  Future<bool> verifyPassword(String roomName, String password) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('name', isEqualTo: roomName)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        // Update the roomId in the user's document in Firestore
        String roomId = querySnapshot.docs.first.id; // Assuming roomId is the document ID
        await updateRoomId(roomId);
        
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error verifying password: $e');
      return false;
    }
  }

  Future<void> updateRoomId(String roomId) async {
    try {
      String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
      if (userEmail.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(userEmail).update({
          'roomId': roomId,
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

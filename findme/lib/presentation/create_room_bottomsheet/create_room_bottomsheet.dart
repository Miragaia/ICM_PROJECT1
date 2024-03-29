import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

class CreateRoomBottomsheet extends StatefulWidget {
  final Function(String, String, String) onCreateRoom;

  CreateRoomBottomsheet({
    Key? key,
    required this.onCreateRoom,
  }) : super(key: key);

  @override
  _CreateRoomBottomsheetState createState() => _CreateRoomBottomsheetState();
}

class _CreateRoomBottomsheetState extends State<CreateRoomBottomsheet> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FocusNode _focusNode = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.v),
          decoration: AppDecoration.fillGray.copyWith(
            borderRadius: BorderRadiusStyle.customBorderTL50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 80.h,
                  child: Divider(),
                ),
              ),
              SizedBox(height: 20.v),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Create Room",
                  style: CustomTextStyles.titleLargeInter,
                ),
              ),
              SizedBox(height: 10.v),
              Text(
                "Room Name",
                style: CustomTextStyles.titleMediumOnSecondaryContainer,
              ),
              SizedBox(height: 10.v),
              CustomTextFormField(
                controller: nameController,
                hintText: "Insert Name...",
                obscureText: false,
              ),
              SizedBox(height: 10.v),
              Text(
                "Password",
                style: CustomTextStyles.titleMediumOnSecondaryContainer,
              ),
              SizedBox(height: 10.v),
              CustomTextFormField(
                controller: passwordController,
                hintText: "Insert Password...",
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.visiblePassword,
                obscureText: false,
              ),
              SizedBox(height: 10.v),
              Text(
                "Location",
                style: CustomTextStyles.titleMediumOnSecondaryContainer,
              ),
              SizedBox(height: 10.v),
              CustomTextFormField(
                controller: locationController,
                hintText: "Insert the location...",
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                obscureText: false,
              ),
              SizedBox(height: 20.v),
              CustomElevatedButton(
                text: "Create Room",
                onPressed: () {
                  _createRoom(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createRoom(BuildContext context) async {
    String name = nameController.text;
    String location = locationController.text;
    String password = passwordController.text;

    // Add room to Firestore collection
    try {
      DocumentReference roomRef = await firestore.collection('rooms').add({
        'name': name,
        'location': location,
        'password': password,
      });

      String roomId = roomRef.id;

      // Notify the callback function
      widget.onCreateRoom(name, location, roomId);

      // Close the bottom sheet
      Navigator.pop(context);
    } catch (e) {
      print('Error creating room: $e');
      // Handle error
    }
  }
}

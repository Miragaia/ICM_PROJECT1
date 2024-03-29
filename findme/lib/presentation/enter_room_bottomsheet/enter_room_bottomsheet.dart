import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../presentation/room_screen/room_screen.dart';

// ignore_for_file: must_be_immutable
class EnterRoomBottomsheet extends StatelessWidget {
  EnterRoomBottomsheet({Key? key})
      : super(
          key: key,
        );

  TextEditingController passwordController = TextEditingController();

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
                imagePath: ImageConstant.imgRectangle516,
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
              "Deti Room",
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
                    "Aveiro, Portugal",
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
                    "3 Users",
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 76.v),
          ],
        ),
      ),
    );
  }
}

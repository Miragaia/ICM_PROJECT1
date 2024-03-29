import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore_for_file: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 27.v),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 82.v,
                        width: 80.h,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgRectangle38280x80,
                              height: 80.adaptSize,
                              width: 80.adaptSize,
                              radius: BorderRadius.circular(40.h),
                              alignment: Alignment.center,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 19.adaptSize,
                                width: 19.adaptSize,
                                margin: EdgeInsets.only(right: 6.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.h,
                                  vertical: 6.v,
                                ),
                                decoration:
                                    AppDecoration.outlineGray5001.copyWith(
                                  borderRadius: BorderRadiusStyle.roundedBorder9,
                                ),
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgFill244,
                                  height: 5.v,
                                  width: 6.h,
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.v),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Adom Shafi",
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Edit Profile",
                        style: CustomTextStyles.bodyMedium14,
                      ),
                    ),
                    SizedBox(height: 32.v),
                    Text("Name", style: theme.textTheme.bodyLarge),
                    SizedBox(height: 8.v),
                    _buildName(context),
                    SizedBox(height: 25.v),
                    Text("Your Email", style: theme.textTheme.bodyLarge),
                    SizedBox(height: 8.v),
                    _buildEmail(context),
                    SizedBox(height: 25.v),
                    Text("Password", style: theme.textTheme.bodyLarge),
                    SizedBox(height: 8.v),
                    _buildPassword(context),
                    SizedBox(height: 50.v),
                    _buildSaveNow(context),
                    SizedBox(height: 20.v), // Added extra space
                    _buildSignOutButton(context), // Added sign-out button
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 50.0, // Adjust button height
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _signOut(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Set button background color to red
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0), // Adjust button padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // Adjust button border radius
            ),
          ),
          child: Text(
            "Sign Out",
            style: TextStyle(
              fontSize: 16.0, // Set button text size
              color: Colors.white, // Set button text color to white
            ),
          ),
        ),
      ),
    );
  }



  void _signOut(BuildContext context) async {
    try {
      // Add sign-out logic here
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen after sign-out
      Navigator.pushNamed(context, AppRoutes.logInScreen);
    } catch (e) {
      print("Error signing out: $e");
    }
  }


  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: 30.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeft,
            margin: EdgeInsets.only(left: 20.h, top: 18.v, bottom: 16.v),
            onTap: () {
              onTapArrowLeft(context);
            }),
        centerTitle: true,
        title: AppbarTitle(text: "Profile"));
  }

  /// Section Widget
  Widget _buildName(BuildContext context) {
    return CustomTextFormField(
        controller: nameController, hintText: "Adom Shafi");
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return CustomTextFormField(
        controller: emailController,
        hintText: "hellobesnik@gmail.com",
        textInputType: TextInputType.emailAddress);
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return CustomTextFormField(
        controller: passwordController,
        hintText: "*************",
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.visiblePassword,
        obscureText: true);
  }

  /// Section Widget
  Widget _buildSaveNow(BuildContext context) {
    return CustomElevatedButton(
        text: "Save Now",
        buttonTextStyle: CustomTextStyles.titleMediumPoppinsOnPrimaryContainer);
  }

  /// Navigates back to the previous screen.
  onTapArrowLeft(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.homePage);
  }
}

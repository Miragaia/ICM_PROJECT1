import 'package:flutter/material.dart';
import 'package:findme/widgets/custom_text_form_field.dart';
import 'package:findme/widgets/custom_elevated_button.dart';
import 'package:findme/widgets/custom_icon_button.dart';
import 'package:findme/core/app_export.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../home_page/home_page.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    Future<void> _handleGoogleSignIn() async {
      try {
        // Sign in
        final GoogleSignInAccount? googleSignInAccount =
            await _googleSignIn.signIn();

        if (googleSignInAccount != null) {
          // Successful sign in, you can now get user details
          print('User Email: ${googleSignInAccount.email}');
          print('User Display Name: ${googleSignInAccount.displayName}');
          print('User Photo URL: ${googleSignInAccount.photoUrl}');

          // Proceed with your app logic, such as navigating to the home page
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
        } else {
          // User cancelled the sign-in process
          print('Google Sign-In cancelled.');
        }
      } catch (error) {
        // Error occurred during sign in
        print('Error signing in with Google: $error');
      }
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                padding: EdgeInsets.only(
                  left: 20.h,
                  top: 92.v,
                  right: 20.h,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.h),
                        child: Text(
                          "Welcome Back!",
                          style: theme.textTheme.headlineLarge,
                        ),
                      ),
                    ),
                    SizedBox(height: 3.v),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 249.h,
                        margin: EdgeInsets.only(
                          left: 10.h,
                          right: 75.h,
                        ),
                        child: Text(
                          "Fill your details or continue with Gmail/Face Recognition",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge!.copyWith(
                            height: 1.50,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 26.v),
                    CustomTextFormField(
                      controller: emailController,
                      hintText: "Email Address",
                      textInputType: TextInputType.emailAddress,
                      prefix: Container(
                        margin: EdgeInsets.fromLTRB(20.h, 15.v, 10.h, 15.v),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgMessage,
                          height: 24.adaptSize,
                          width: 24.adaptSize,
                        ),
                      ),
                      prefixConstraints: BoxConstraints(
                        maxHeight: 54.v,
                      ),
                    ),
                    SizedBox(height: 24.v),
                    CustomTextFormField(
                      controller: passwordController,
                      hintText: "Password",
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.visiblePassword,
                      prefix: Container(
                        margin: EdgeInsets.fromLTRB(20.h, 14.v, 14.h, 14.v),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgLocation,
                          height: 26.v,
                          width: 20.h,
                        ),
                      ),
                      prefixConstraints: BoxConstraints(
                        maxHeight: 54.v,
                      ),
                      suffix: Container(
                        margin: EdgeInsets.fromLTRB(30.h, 21.v, 20.h, 20.v),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgEyeslash,
                          height: 13.v,
                          width: 16.h,
                        ),
                      ),
                      suffixConstraints: BoxConstraints(
                        maxHeight: 54.v,
                      ),
                      obscureText: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.v),
                    ),
                    SizedBox(height: 8.v),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forget Password?",
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    SizedBox(height: 35.v),
                    CustomElevatedButton(
                      text: "LOG IN",
                      onPressed: () {
                        // Navigate to home page when Log In button is clicked
                        Navigator.pushNamed(context, AppRoutes.homePage);
                      },
                    ),
                    SizedBox(height: 35.v),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 12.v,
                            bottom: 9.v,
                          ),
                          child: SizedBox(
                            width: 20.h,
                            child: Divider(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text(
                            "Or Continue with",
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 12.v,
                            bottom: 9.v,
                          ),
                          child: SizedBox(
                            width: 30.h,
                            child: Divider(
                              indent: 10.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 26.v),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconButton(
                          height: 60.adaptSize,
                          width: 60.adaptSize,
                          padding: EdgeInsets.all(13.h),
                          onTap: _handleGoogleSignIn,
                          child: CustomImageView(
                            imagePath: ImageConstant.img1421929991558096326,
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgImage1,
                          height: 60.adaptSize,
                          width: 60.adaptSize,
                          margin: EdgeInsets.only(left: 27.h),
                        ),
                      ],
                    ),
                    SizedBox(height: 42.v),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.signUpScreen);
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "New User? ",
                              style: CustomTextStyles.titleMediumff6a6a6a,
                            ),
                            TextSpan(
                              text: "Create Account",
                              style: CustomTextStyles.titleMediumff1a1d1e,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 5.v),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

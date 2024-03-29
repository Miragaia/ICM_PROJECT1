import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController userNameController = TextEditingController();

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
                padding: EdgeInsets.symmetric(
                  horizontal: 20.h,
                  vertical: 17.v,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.h),
                        child: Text(
                          "Register Account",
                          style: CustomTextStyles.headlineLargeSemiBold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 212.h,
                        margin: EdgeInsets.only(left: 10.h),
                        child: Text(
                          "Fill your details or continue with Gmail/Fa",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge!.copyWith(
                            height: 1.50,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 28.v),
                    _buildUserName(context),
                    SizedBox(height: 24.v),
                    _buildEmail(context),
                    SizedBox(height: 24.v),
                    _buildPassword(context),
                    SizedBox(height: 40.v),
                    _buildSIGNUP(context),
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
                    SizedBox(height: 44.v),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.logInScreen);
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already Have Account? ",
                              style: CustomTextStyles.bodyLargeff6a6a6a,
                            ),
                            TextSpan(
                              text: "Log In",
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

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: double.maxFinite,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeft,
        margin: EdgeInsets.fromLTRB(30.h, 17.v, 335.h, 17.v),
      ),
    );
  }

  /// Section Widget
  Widget _buildUserName(BuildContext context) {
    return CustomTextFormField(
      controller: userNameController,
      hintText: "User Name",
      prefix: Container(
        margin: EdgeInsets.fromLTRB(20.h, 13.v, 15.h, 13.v),
        child: CustomImageView(
          imagePath: ImageConstant.imgLock,
          height: 22.v,
          width: 20.h,
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 54.v,
      ),
    );
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return CustomTextFormField(
      controller: emailController,
      hintText: "Email Address",
      textInputType: TextInputType.emailAddress,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(20.h, 17.v, 15.h, 17.v),
        child: CustomImageView(
          imagePath: ImageConstant.imgMessage,
          height: 20.adaptSize,
          width: 20.adaptSize,
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 54.v,
      ),
    );
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return CustomTextFormField(
      controller: passwordController,
      hintText: "Password",
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.visiblePassword,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(20.h, 12.v, 15.h, 16.v),
        child: CustomImageView(
          imagePath: ImageConstant.imgLocationGray700,
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
    );
  }

  /// Section Widget
  Widget _buildSIGNUP(BuildContext context) {
    return CustomElevatedButton(
      text: "SIGN UP",
      onPressed: () {
        // Navigate to home page when Sign Up button is clicked
        Navigator.pushNamed(context, AppRoutes.homePage);
      },
    );
  }
}

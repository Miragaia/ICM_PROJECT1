import '../../widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../log_in_screen/log_in_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 75.v),
              CustomImageView(
                imagePath: ImageConstant.imgLogo1,
                height: 364.v,
                width: 375.h,
              ),
              Text(
                "FindMe",
                style: theme.textTheme.displaySmall,
              ),
              SizedBox(height: 48.v),
              Container(
                width: 304.h,
                margin: EdgeInsets.only(
                  left: 35.h,
                  right: 36.h,
                ),
                child: Text(
                  "Connect, Navigate, Find: \nWhere Friends Meet, FindMe Leads the Way!",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    height: 1.63,
                  ),
                ),
              ),
              SizedBox(height: 11.v),
              CustomElevatedButton(
                width: 261.h,
                text: "Let’s Get Started",
                rightIcon: Container(
                  margin: EdgeInsets.only(left: 7.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgArrowright,
                    height: 20.adaptSize,
                    width: 20.adaptSize,
                  ),
                ),
                buttonTextStyle: CustomTextStyles.bodyLargeOnPrimaryContainer,
                onPressed: () {
                  // Redirecione para a página de login quando o botão for clicado
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LogInScreen()), (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

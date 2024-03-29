import 'package:flutter/material.dart';
import '../../core/app_export.dart';

// ignore: must_be_immutable
class AppbarTrailingCircleimage extends StatelessWidget {
  AppbarTrailingCircleimage({
    Key? key,
    this.imagePath,
    this.margin,
    this.onTap,
  }) : super(
          key: key,
        );

  String? imagePath;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadiusStyle.circleBorder22,
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.profileScreen);
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath,
          height: 44.adaptSize,
          width: 44.adaptSize,
          fit: BoxFit.contain,
          radius: BorderRadius.circular(
            22.h,
          ),
        ),
      ),
    );
  }
}

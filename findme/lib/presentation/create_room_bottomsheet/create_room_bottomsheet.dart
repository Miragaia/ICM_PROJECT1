import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CreateRoomBottomsheet extends StatelessWidget {
  CreateRoomBottomsheet({Key? key})
      : super(
          key: key,
        );

  TextEditingController nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  List<String> dropdownItemList = [
    "Item One",
    "Item Two",
    "Item Three",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 10.v,
      ),
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
          SizedBox(height: 35.v),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Create Room",
              style: CustomTextStyles.titleMediumOnSecondaryContainer,
            ),
          ),
          SizedBox(height: 36.v),
          Text(
            "Room Name",
            style: CustomTextStyles.titleMediumOnSecondaryContainer,
          ),
          SizedBox(height: 12.v),
          CustomTextFormField(
            controller: nameController,
            hintText: "Insert Name...",
          ),
          SizedBox(height: 26.v),
          Text(
            "Password",
            style: CustomTextStyles.titleMediumOnSecondaryContainer,
          ),
          SizedBox(height: 14.v),
          CustomTextFormField(
            controller: passwordController,
            hintText: "Insert Password...",
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          SizedBox(height: 36.v),
          Padding(
            padding: EdgeInsets.only(left: 113.h),
            child: Text(
              "Location",
              style: CustomTextStyles.titleLargeInter,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 82.h),
            child: CustomDropDown(
              width: 160.h,
              icon: Container(
                margin: EdgeInsets.fromLTRB(27.h, 19.v, 15.h, 17.v),
                child: CustomImageView(
                  imagePath: ImageConstant.imgArrowdown,
                  height: 18.adaptSize,
                  width: 18.adaptSize,
                ),
              ),
              hintText: "Aveiro",
              items: dropdownItemList,
              prefix: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 15.h,
                  vertical: 17.v,
                ),
                child: CustomImageView(
                  imagePath: ImageConstant.imgLinkedin,
                  height: 20.adaptSize,
                  width: 20.adaptSize,
                ),
              ),
              prefixConstraints: BoxConstraints(
                maxHeight: 54.v,
              ),
            ),
          ),
          SizedBox(height: 65.v),
          CustomElevatedButton(
            text: "Create Room",
          ),
          SizedBox(height: 65.v),
        ],
      ),
    );
  }
}

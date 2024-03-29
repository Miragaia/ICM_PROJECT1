import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CreateRoomBottomsheet extends StatelessWidget {
  final Function(String, String, String) onCreateRoom;

  CreateRoomBottomsheet({
    Key? key,
    required this.onCreateRoom,
  }) : super(key: key);

  final FocusNode _focusNode = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<String> dropdownItemList = [
    "Item One",
    "Item Two",
    "Item Three",
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(
            _focusNode); // Redirecionar o foco quando tocar fora dos campos de texto
      },
      child: SingleChildScrollView(
        child: Container(
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
                  onCreateRoom(
                    nameController.text,
                    locationController.text, // Localização da sala
                    ImageConstant
                        .imgRectangle516, // Imagem (definido como exemplo)
                  );
                  Navigator.pop(
                      context); // Fecha o modal bottom sheet após criar a sala
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

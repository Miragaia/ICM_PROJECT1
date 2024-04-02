import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/log_in_screen/log_in_screen.dart';
import '../presentation/sign_up_screen/sign_up_screen.dart';
import '../presentation/room_screen/room_screen.dart';
import '../presentation/home_page/home_page.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/create_room_bottomsheet/create_room_bottomsheet.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String logInScreen = '/log_in_screen';
  static const String signUpScreen = '/sign_up_screen';
  static const String homePage = '/home_page';
  static const String roomScreen = '/room_screen';
  static const String profileScreen = '/profile_screen';
  static const String createRoom = '/create_room_bottom_sheet';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashScreen(),
    logInScreen: (context) => LogInScreen(),
    signUpScreen: (context) => SignUpScreen(),
    roomScreen: (context) => RoomScreen(),
    profileScreen: (context) => ProfileScreen(),
    homePage: (context) => HomePage(),
    createRoom: (context) => CreateRoomBottomsheet(
          onCreateRoom: (String roomName, String location, String image) {},
        ),
  };
}

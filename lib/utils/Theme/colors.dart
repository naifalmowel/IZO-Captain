import 'package:flutter/material.dart';

Color primaryColor = const Color(0xFFee6800).withOpacity(0.8);
//Color primaryColor = Colors.orange.withOpacity(1);
//Color secondaryColor = Colors.grey.withOpacity(0.8);
//Color primaryColor = const Color(0x00ee6800).withOpacity(0.65);
Color secondaryColor = Colors.black45.withOpacity(0.7);
Color errorColor = const Color(0x00c71b27).withOpacity(1);
Color textColor = const Color(0x00000000).withOpacity(1);
Color backgroundColorDropDown = const Color(0x00ffe8d9);
Color colorSnakeBarSuccess = const Color(0x0000b078).withOpacity(1);
Color colorSnakeBarError = const Color(0x00c71b27).withOpacity(0.9);
LinearGradient backgroundGradient = LinearGradient(
  colors: [
    Colors.white.withOpacity(0.8),
    Colors.white.withOpacity(0.1),
    primaryColor.withOpacity(0.1),
// secondaryColor.withOpacity(0.3),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: const [0.0, 0.0, 0.9],
);

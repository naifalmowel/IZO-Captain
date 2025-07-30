import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: false,
  appBarTheme: AppBarTheme(
    actionsIconTheme: const IconThemeData(color: Colors.white),
    backgroundColor: secondaryColor,
    foregroundColor: secondaryColor,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: const TextStyle(
        color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
    centerTitle: true,
  ),
  primaryColor: primaryColor,
  colorScheme: ColorScheme.light(primary: primaryColor, error: Colors.red),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor),
  /*floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: secondaryColor,
  ),*/
  fontFamily: 'bah',
  // inputDecorationTheme: InputDecorationTheme(
  //   focusedBorder: OutlineInputBorder(
  //     borderSide: BorderSide(
  //       color: primaryColor,
  //     ),
  //     borderRadius: BorderRadius.circular(25),
  //   ),
  //   errorBorder: OutlineInputBorder(
  //     borderSide: BorderSide(
  //         color: colorSnakeBarError), // Set your error border color here
  //   ),
  // ),
  iconButtonTheme: const IconButtonThemeData(),
  cardTheme: const CardThemeData(
    color: Colors.white,
  ),
  iconTheme: const IconThemeData(
      //  color: Colors.white, // Set your desired default color for IconButtons here
      ),
  checkboxTheme: const CheckboxThemeData(),
  dividerColor: secondaryColor,
  dialogBackgroundColor: Colors.white,
  dropdownMenuTheme: DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        // If the button is pressed, return green, otherwise blue
        if (states.contains(MaterialState.pressed)) {
          return Colors.grey;
        }
        return Colors.white;
      }),
    ),
  ),
  canvasColor: Colors.white,
);

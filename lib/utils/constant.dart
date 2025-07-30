import 'dart:io';
import 'dart:typed_data';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_type_model.dart';
import 'Theme/colors.dart';

class ConstantApp {
  static bool lite = true;
  static bool isUpgrade = false;
  static bool isShowKeyboard = false;
  static bool justLandscape = false;
  static String languageApp = "us";
  static bool isRestore = true;
  static bool isSearch = false;
  static String pathImage = "";
  static int storeId = 1;
  static int selectSettingIndex = 0;
  static String type ="";

  static bool enableColor = Get.find<SharedPreferences>().getBool('enableColor') ?? false;
  static bool isDelivery = Get.find<SharedPreferences>().getBool('delivery') ?? false;

  static AppTypeModel appType = AppTypeModel(
    id: 1,
    name: "",
    type: "Lite",
    titleBar: "IZO",
    imageBar: "assets/icon/POS.ico",
    backgroundImage: "assets/background/restaurant.jpg",
    primaryColor: "",
  );

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getTextSize(BuildContext context) {
    return ConstantApp.isTab(context)
        ? MediaQuery.of(context).size.height / MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height;
  }

  static TextStyle getTextStyle({
    required BuildContext context,
    Color? color,
    double size = 10,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      color: color ?? primaryColor,
      fontSize: getTextSize(context) * size,
      fontFamily: "bah",
      fontWeight: fontWeight,
      decorationColor: primaryColor,
    );
  }

  static Widget circleImage({
    required String image,
    required BuildContext context,
    double? width,
    double? height,
    BoxFit? fit = BoxFit.contain,
  }) {
    width = isTab(context) ? ConstantApp.getWidth(context) * 0.2 : null;
    height = isTab(context) ? ConstantApp.getWidth(context) * 0.2 : null;
    return ClipOval(
      child: image == ''
          ? Image.asset(
              'assets/images/noImage.jpg',
              fit: BoxFit.scaleDown,
              width: width ?? ConstantApp.getHeight(context) * 0.2,
              height: height ?? ConstantApp.getHeight(context) * 0.2,
            )
          : FadeInImage(
              width: width ?? ConstantApp.getHeight(context) * 0.2,
              height: height ?? ConstantApp.getHeight(context) * 0.2,
              image: FileImage(
                File(image),
              ),
              placeholder: const AssetImage('assets/images/noImage.jpg'),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/noImage.jpg',
                    width: width ?? ConstantApp.getHeight(context) * 0.2,
                    height: height ?? ConstantApp.getHeight(context) * 0.2,
                    fit: BoxFit.scaleDown);
              },
              fit: fit,
            ),
    );
  }

  static Widget circleImageMemory({
    required Uint8List? image,
    required BuildContext context,
    double? width,
    double? height,
    BoxFit? fit = BoxFit.contain,
  }) {
    width = isTab(context) ? ConstantApp.getWidth(context) * 0.2 : width;
    height = isTab(context) ? ConstantApp.getWidth(context) * 0.2 : height;
    return ClipOval(
      child: image == null
          ? Image.asset(
              'assets/images/noImage.jpg',
              fit: BoxFit.scaleDown,
              width: width ?? ConstantApp.getHeight(context) * 0.2,
              height: height ?? ConstantApp.getHeight(context) * 0.2,
            )
          : FadeInImage(
              width: width ?? ConstantApp.getHeight(context) * 0.2,
              height: height ?? ConstantApp.getHeight(context) * 0.2,
              image: MemoryImage(image),
              placeholder: const AssetImage('assets/images/noImage.jpg'),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/noImage.jpg',
                    width: width ?? ConstantApp.getHeight(context) * 0.2,
                    height: height ?? ConstantApp.getHeight(context) * 0.2,
                    fit: BoxFit.scaleDown);
              },
              fit: fit,
            ),
    );
  }

  static String capitalizeFirstLetter(String input){
    List<String> words = input.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      } else {
        return word;
      }
    }).toList();
    return capitalizedWords.join(' ');
  }

  static void showSnakeBarSuccess(BuildContext context, String contentText) {
    AnimatedSnackBar.material(
      contentText,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
      type: AnimatedSnackBarType.success,
      duration: const Duration(milliseconds: 4000),
    ).show(
      context,
    );
  }

  static void showSnakeBarError(BuildContext context, String contentText) {
    AnimatedSnackBar.material(
      contentText,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
      type: AnimatedSnackBarType.error,
      snackBarStrategy: RemoveSnackBarStrategy(),
      duration: const Duration(milliseconds: 4000),
    ).show(
      context,
    );
  }

  static void showSnakeBarWarning(BuildContext context, String contentText) {
    AnimatedSnackBar.material(
      contentText,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
      type: AnimatedSnackBarType.warning,
      duration: const Duration(milliseconds: 2000),
    ).show(
      context,
    );
  }

  static void showSnakeBarInfo(BuildContext context, String contentText) {
    AnimatedSnackBar.material(
      contentText,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
      type: AnimatedSnackBarType.info,
      snackBarStrategy: RemoveSnackBarStrategy(),
      duration: const Duration(milliseconds: 5000),
    ).show(
      context,
    );
  }

  static Future<dynamic> showNoteDialog(String note, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(note),
          );
        });
  }

  static String formatNumber(double number) {
    return NumberFormat("#,##0.00").format(number);
  }

  static bool isTab(BuildContext context) {
    if (!Platform.isWindows && MediaQuery.of(context).size.width <= 800) {
      return true;
    }
    return false;
  }

  static Future<void> loading(BuildContext context) async {
    var dialogContext = context;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return SimpleDialog(backgroundColor: Colors.white70, children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 20),
                child: SpinKitFadingCircle(
                  color: const Color(0xffee680e).withOpacity(0.9),
                  size: 50,
                ),
              ),
              const Text(
                'Loading .. ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ]);
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(dialogContext).pop();
    });
  }

  static Map<dynamic, dynamic> sortMapByKey(Map<dynamic, dynamic> map) {
    List<MapEntry<dynamic, dynamic>> sortedEntries = map.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Map.fromEntries(sortedEntries);
  }

  static String roundDoubleToInt({required double num}) {
    return num.toStringAsFixed(2).endsWith('.00')
        ? num.toStringAsFixed(2).replaceAll('.00', '')
        : num.toStringAsFixed(2);
  }
}

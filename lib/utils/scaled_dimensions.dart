import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

class ScaledDimensions {
  static const double screenWidth = 390;
  static const double screenHeight = 844;

  static double getScaledHeight(
      {required double? px, double? ratio, double? fromHeight}) {
    double h = fromHeight ?? screenHeight;
    return Get.height * (px! / h);
  }

  static double getScaledWidth(
      {required double? px, double? ratio, double? fromWidth}) {
    double h = fromWidth ?? screenWidth;
    return Get.width * (px! / h);
  }

  static double getScaledWidthPrecentage({required pr}) {
    return (Get.width * pr) / 100;
  }

  static double getScaledHeightPrecentage({required pr}) {
    return (Get.height * pr) / 100;
  }
}

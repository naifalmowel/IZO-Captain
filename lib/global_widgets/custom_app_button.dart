
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import '../utils/constant.dart';
import '../utils/scaled_dimensions.dart';

class CustomAppButton extends StatelessWidget {
    const CustomAppButton(
      {required this.onPressed,
      required this.title,
      required this.backgroundColor,
      required this.textColor,
      required this.withPading,
      required this.width,
      required this.height,
        this.colorBorder  = Colors.grey,
      Key? key})
      : super(key: key);

  final Callback onPressed;
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final bool withPading;
  final double width;
  final double height;
  final Color colorBorder;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              border: Border.all(color: colorBorder.withOpacity(0.4)),
              color: backgroundColor,
              borderRadius: BorderRadius.circular(7)),
          margin: withPading
              ? EdgeInsets.symmetric(
                  vertical: ScaledDimensions.getScaledHeight(px: 10))
              : null,
          width: width,
          height: height,
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: ConstantApp.getTextStyle(context: context,color:textColor,fontWeight: FontWeight.bold ,size: 8),
            ),
          ),
        ));
  }
}

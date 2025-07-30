import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/constant.dart';

class NumPad extends StatelessWidget {
  final double buttonSize;
  final Color buttonColor;
  final Color iconColor;
  final TextEditingController controller;
  final Function delete;
  final Function onSubmit;
  final Function? onPressed;
  final bool showPoint;

  const NumPad({
    Key? key,
    this.buttonSize = 70,
    this.buttonColor = Colors.indigo,
    this.onPressed,
    this.iconColor = Colors.amber,
    this.showPoint = false,
    required this.delete,
    required this.onSubmit,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:ConstantApp.getWidth(context)>900?  const EdgeInsets.only(left: 30, right: 30): const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: NumberButton(
                  number: 1,
                  size: buttonSize,
                  color: buttonColor,
                  controller: controller, onPressed: onPressed,
                ),
              ),
              Expanded(
                child: NumberButton(
                  number: 2,
                  size: buttonSize,
                  color: buttonColor,
                  controller: controller, onPressed: onPressed,
                ),
              ),
              Expanded(
                child: NumberButton(
                  number: 3,
                  size: buttonSize,
                  color: buttonColor,
                  controller: controller, onPressed: onPressed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: NumberButton(
                  number: 4,
                  size: buttonSize,
                  color: buttonColor,
                  controller: controller, onPressed: onPressed,
                ),
              ),
              Expanded(
                child: NumberButton(
                  number: 5,
                  size: buttonSize,
                  color: buttonColor,
                  controller: controller, onPressed: onPressed,
                ),
              ),
              Expanded(
                child: NumberButton(
                  number: 6,
                  size: buttonSize,
                  color: buttonColor,
                  controller: controller, onPressed: onPressed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: NumberButton(
                  number: 7,
                  size: buttonSize,
                  color: buttonColor,
                  controller: controller, onPressed: onPressed,
                ),
              ),
              Expanded(
                child: NumberButton(
                  number: 8,
                  size: buttonSize,
                  color: buttonColor,
                  controller: controller, onPressed: onPressed,
                ),
              ),
              Expanded(
                child: NumberButton(
                  number: 9,
                  size: buttonSize,
                  color: buttonColor,
                  controller: controller, onPressed: onPressed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // this button is used to delete the last number
              Expanded(
                child: Row(
                  children: [
                    showPoint?IconButton(
                      onPressed: (){
                        if(controller.text.contains(".")){}
                        else{
                          controller.text += ".";
                        }
                      },
                      icon: Icon(
                        FontAwesomeIcons.circle,
                        color: iconColor,
                      ),
                      iconSize: 13,
                    ):const SizedBox(),
                    IconButton(
                      onPressed: () => delete(),
                      icon: Icon(
                        Icons.backspace,
                        color: iconColor,
                      ),
                      iconSize: buttonSize,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NumberButton(
                  number: 0,
                  size: buttonSize,
                  color: buttonColor,
                  controller: controller, onPressed: onPressed,
                ),
              ),
              // this button is used to submit the entered value
              Expanded(
                child: IconButton(
                  onPressed: () => onSubmit(),
                  icon: Icon(
                    Icons.done_rounded,
                    color: iconColor,
                  ),
                  iconSize: buttonSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final int number;
  final double size;
  final Color color;
  final TextEditingController controller;
  final Function? onPressed ;

  const NumberButton({
    Key? key,
    required this.number,
    required this.size,
    required this.color,
    required this.controller, this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:ConstantApp.getWidth(context)>900? const EdgeInsets.symmetric(horizontal: 10):const EdgeInsets.symmetric(horizontal: 2),
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
        onPressed: () {
          controller.text += number.toString();
          onPressed!();
        },
        child: Center(
          child: Text(
            number.toString(),
            style: ConstantApp.getTextStyle(context: context,color: Colors.white),
          ),
        ),
      ),
    );
  }

}

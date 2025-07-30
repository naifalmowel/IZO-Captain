import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izo_captain/global_widgets/custom_text_field.dart';
import 'package:pin_keyboard/pin_keyboard.dart';

class KeyboardScreen extends StatefulWidget {
  const KeyboardScreen({super.key});

  @override
  State<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends State<KeyboardScreen> {
  TextEditingController pinController = TextEditingController();
  FocusNode pinFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTextFormField(
              hint: "Enter Pin".tr,
              focusNode: pinFocusNode,
              textEditingController: pinController,
              onSaved: (val) {},
              validator: (val) {
                return null;
              }),
          PinKeyboard(
            length: 7,
            enableBiometric: false,
            iconBiometricColor: Colors.blue[400],
            onChange: (pin) {
              pinController.text = pin;
            },
            onConfirm: (pin) {},
            onBiometric: () {},
           // iconBiometric: const Icon(FontAwesomeIcons.unlock),
          ),
        ],
      ),
    );
  }
}

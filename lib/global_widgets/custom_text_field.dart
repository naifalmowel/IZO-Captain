import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../utils/Theme/colors.dart';
import '../utils/scaled_dimensions.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatefulWidget {
  CustomTextFormField(
      {required this.hint,
      required this.focusNode,
      required this.textEditingController,
      required this.onSaved,
      required this.validator,
      this.textInputType,
      this.onTap,
      this.readOnly,
      this.title,
      this.enable,
      this.onChange,
      this.vis,
      this.isNum,
      Key? key,
      this.isDis,
      this.isInt,
      this.autoFocus,
      this.maxLin})
      : super(key: key);
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final String hint;
  final String? Function(String?) validator;
  final Function(String?) onSaved;
  Function(String?)? onChange;
  final TextInputType? textInputType;
  final Callback? onTap;
  final bool? readOnly;
  final bool? isDis;
  final String? title;
  bool? isUnVis;
  final bool? vis;
  final bool? autoFocus;

  final int? maxLin;

  final bool? isNum;
  final bool? isInt;
  bool? enable;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late InputBorder inputBorder;

  @override
  void initState() {
    inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Colors.white));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: ScaledDimensions.getScaledHeight(px: 10)),
      width: ScaledDimensions.getScaledWidth(
          px: widget.maxLin == null ? 100 : 250),
      // height: ScaledDiemsions.getScaledHeight(px: 50),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(7),
        child: TextFormField(
          inputFormatters: widget.isNum == true
              ? widget.isInt ==true
                  ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))]
                  : [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))]
              : [],
          readOnly: widget.readOnly ?? false,
          onSaved: widget.onSaved,
          validator: widget.validator,
          onTap: widget.onTap,
          //     (){
          //    //Change here
          //   if(widget.onTap != null){
          //     widget.onTap!();
          //     print("aaa");
          //   }
          //   if(!widget.readOnly!){
          //   ConstantApp.openKeyboard();
          //   }
          // },
          enabled: widget.enable ?? true,
          cursorColor: primaryColor.withOpacity(1),
          controller: widget.textEditingController,
          focusNode: widget.focusNode,
          keyboardType: widget.textInputType,
          autofocus: widget.autoFocus??false,
          obscureText: widget.vis ?? false,
          maxLines: widget.maxLin ?? 1,
          maxLength: widget.maxLin == null ? null : 255,
          onChanged: widget.onChange,
          decoration: InputDecoration(
            // contentPadding:  EdgeInsets.symmetric(vertical: 40),
            enabledBorder: inputBorder,
            filled: true,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(color: primaryColor.withOpacity(1))),
            disabledBorder: inputBorder,
            fillColor: Colors.white,
            border: inputBorder,
            labelText: widget.hint,
            labelStyle: TextStyle(color: primaryColor.withOpacity(0.8)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(color: colorSnakeBarError)),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                  color:
                      colorSnakeBarError), // Set your error border color here
            ),

            // contentPadding: EdgeInsets.symmetric(
            //     vertical: 2,
            //     horizontal: ScaledDiemsions.getScaledWidth(px: 5))
          ),
        ),
      ),
    );
  }
}

class CustomTextFiled extends StatefulWidget {
  const CustomTextFiled(
      {required this.hint,
      // required this.focusNode,
      // required this.textEditingController,this.textInputType,
      Key? key})
      : super(key: key);

  //   final FocusNode focusNode;
  // final TextEditingController textEditingController;
  final String hint;

  // final TextInputType? textInputType;

  @override
  State<CustomTextFiled> createState() => _CustomTextFiledState();
}

class _CustomTextFiledState extends State<CustomTextFiled> {
  late InputBorder inputBorder;

  @override
  void initState() {
    inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Colors.white));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScaledDimensions.getScaledHeight(px: 45),
      child: TextField(
        cursorColor: const Color(0xffee680e),
        // controller: widget.textEditingController,
        // focusNode: widget.focusNode
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          enabledBorder: inputBorder,
          filled: true,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xffee680e))),
          disabledBorder: inputBorder,
          // fillColor: Colors.white,
          border: inputBorder,
          // hintText: widget.hint,

          // contentPadding: EdgeInsets.symmetric(
          //     vertical: 2,
          //     horizontal: ScaledDiemsions.getScaledWidth(px: 5))
        ),
      ),
    );
  }
}

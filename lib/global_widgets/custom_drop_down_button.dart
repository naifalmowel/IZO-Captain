import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/scaled_dimensions.dart';
import '../utils/Theme/colors.dart';

//ignore: must_be_immutable
class CustomDropDownButton extends StatefulWidget {
  CustomDropDownButton(
      {required this.title,
      required this.hint,
      required this.items,
      this.value,
      this.withOutValue,
      required this.onChange,
      required this.width,
      required this.height,
      Key? key})
      : super(key: key);

  final String title;
  final String hint;
  final List<String> items;
  String? value;
  final Function(String?) onChange;
  final double width;
  final double height;
  final bool? withOutValue;

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  String? valuee;
  var init = true;

  @override
  void initState() {
    // TODO: implement initState
    if (init) {
      valuee = null;
      init = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: ScaledDimensions.getScaledHeight(px: 10)),
      width: widget.width,
      height: widget.height,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          style: TextStyle(color: primaryColor.withOpacity(1)),
          hint: Center(
              child: Text(
                widget.hint,
                style:  TextStyle(color: textColor),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          items: widget.items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Center(
                      child: Text(
                        item.toString().tr,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ))
              .toList(),
          value: widget.withOutValue != null ? widget.value : valuee,
          onChanged: (value) {
            setState(() {
              // print(value);
              widget.value = value;

              valuee = value;
            });
            widget.onChange(value);
          },
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
                color: backgroundColorDropDown.withOpacity(1),
                borderRadius: const BorderRadius.all(
                    Radius.circular(30))),
            padding: const EdgeInsets.only(left: 12),
            width: double.infinity,
          ),
          dropdownStyleData: const DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(30)),
            ),
            maxHeight: 200,
            width: 125
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,


          ),

        ),
      ),
    );
  }
}

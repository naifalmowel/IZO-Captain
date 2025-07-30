import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izo_captain/models/user_model.dart';

import '../../../utils/scaled_dimensions.dart';
import '../utils/Theme/colors.dart';
import '../utils/constant.dart';
//ignore: must_be_immutable
class CustomDropDownButtonUsers extends StatefulWidget {
  CustomDropDownButtonUsers(
      {required this.title,
        required this.hint,
        required this.items,
        this.value,
        this.withOutValue,
        required this.onChange,
        required this.width,
        required this.height,
        required this.textEditingController,
        Key? key})
      : super(key: key);

  final String title;
  final String hint;
  final List<UserModel> items;
  int? value;
  final Function(int?) onChange;
  final double width;
  final double height;
  final bool? withOutValue;
  TextEditingController textEditingController;

  @override
  State<CustomDropDownButtonUsers> createState() => _CustomDropDownButtonUsersState();
}

class _CustomDropDownButtonUsersState extends State<CustomDropDownButtonUsers> {
  int? val;
  var init = true;
  FocusNode searchFocusNode = FocusNode();
  @override
  void initState() {
    if (init) {
      val = null;
      init = false;
    }
    searchFocusNode.requestFocus();
    super.initState();
  }
  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: ScaledDimensions.getScaledHeight(px: 10)),
      width: widget.width,
      height: widget.height,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<int>(
          isExpanded: true,
          style: TextStyle(color: primaryColor.withOpacity(1)),
          hint: Center(
            child: Text(
              widget.hint,
              style: ConstantApp.getTextStyle(context: context,color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          items: widget.items
              .map((item) => DropdownMenuItem<int>(
            value: item.id,
            child: Center(
              child: Text(
                item.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ))
              .toList(),
          value:  widget.value ,
          onChanged: (value) {

            setState(() {
              // print(value);
              widget.value = value;

              val = value;
            });
            widget.onChange(value);
          },
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
                color: backgroundColorDropDown.withOpacity(1),
                borderRadius: const BorderRadius.all(
                    Radius.circular(30))),
            padding: const EdgeInsets.all(8),
            height: 40,
            width: double.infinity,
          ),
          dropdownStyleData: const DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(30)),
            ),
            maxHeight: 200,
            width: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          autofocus: true,
          dropdownSearchData: DropdownSearchData(
            searchController: widget.textEditingController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                autofocus: true,
                expands: true,
                maxLines: null,
                controller: widget.textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Search...'.tr,
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              final myItem = widget.items.firstWhere((element) => element.id == item.value);
              return ((myItem.name.toString()
                  .toLowerCase()
                  .toString()
                  .contains(
                  searchValue.toLowerCase().toString())) || (item.value.toString()
                  .toLowerCase()
                  .toString()
                  .contains(
                  searchValue.toLowerCase().toString())));
            },
          ),
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              widget.textEditingController.clear();
            }
          },
        ),
      ),
    );
  }
}

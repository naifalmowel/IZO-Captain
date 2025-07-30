import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izo_captain/models/driver_model.dart';

import '../../../utils/scaled_dimensions.dart';

// ignore: must_be_immutable
class CustomDropDownButtonDriver extends StatefulWidget {
  CustomDropDownButtonDriver(
      {required this.title,
      required this.hint,
      required this.items,
      this.value,
      this.withOutValue,
      required this.onChange,
      required this.width,
      required this.height,
      Key? key,
      required this.textEditingController})
      : super(key: key);

  final String title;
  final String hint;
  final List<DriverModel> items;
  int? value;
  final Function(int?) onChange;
  final double width;
  final double height;
  final bool? withOutValue;
  final TextEditingController textEditingController;

  @override
  State<CustomDropDownButtonDriver> createState() =>
      _CustomDropDownButtonDriverState();
}

class _CustomDropDownButtonDriverState
    extends State<CustomDropDownButtonDriver> {
  int? valuee;
  var init = true;

  @override
  void initState() {
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
        child: DropdownButton2<int>(
          isExpanded: true,
          hint: Row(
            children: [
              Expanded(
                child: Text(
                  widget.hint,
                  style: const TextStyle(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: widget.items.map((item) {
            return DropdownMenuItem<int>(
              value: item.id,
              child: Text(
                item.name,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          value: widget.value,
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
                color: const Color(0xffee680e).withOpacity(0.8),
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            padding: const EdgeInsets.all(8),
            height: 40,
            width: double.infinity,
          ),
          dropdownStyleData: const DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            maxHeight: 200,
            width: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
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
              final myItem = widget.items
                  .firstWhere((element) => element.id == item.value);
              return (myItem.name
                      .toString()
                      .toLowerCase()
                      .toString()
                      .contains(searchValue.toLowerCase().toString()) ||
                  item.value
                      .toString()
                      .toLowerCase()
                      .toString()
                      .contains(searchValue.toLowerCase().toString()));
            },
          ),
          //This to clear the search value when you close the menu
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

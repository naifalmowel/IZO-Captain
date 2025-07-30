// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/Theme/colors.dart';
import '../../../utils/constant.dart';
import '../../../controllers/order_controller.dart';

class TempOrderItem extends StatefulWidget {
  TempOrderItem({
    this.onChange,
    required this.name,
    required this.ident,
    required this.price,
    required this.qty,
    required this.guest,
    required this.onPressed,
    super.key,
    required this.iconVis,
    this.note,
    required this.changPrice,
    this.index,
    this.orderNum,
    required this.select,
    required this.unitWidget,
    required this.changQty,
    required this.addQty,
    required this.subQty,
  });
  final String ident;
  final String name;
  final double qty;
  final VoidCallback onPressed;
  final String guest;
  String? note;
  final double price;
  final bool iconVis;
  Function(String?)? onChange;
  final VoidCallback select;
  final VoidCallback changPrice;
  final VoidCallback changQty;
  final VoidCallback addQty;
  final VoidCallback subQty;
  int? index;
  int? orderNum;
  Widget unitWidget;

  @override
  State<TempOrderItem> createState() => _TempOrderItemState();
}

class _TempOrderItemState extends State<TempOrderItem> {
  final notController = TextEditingController();
  bool selected = false;
  Color color = Colors.white;

  @override
  void initState() {
    selected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.qty.isNegative) {
      color = Colors.red[700]!;
    } else {
      if ((Get.find<OrderController>().selected1.value == widget.index &&
              widget.orderNum ==
                  Get.find<OrderController>().checkOrderList.value)) {
        color = Colors.blue.withOpacity(0.2);
      } else {
        color = Colors.white;
      }
    }
    return GestureDetector(
      onTap:!widget.iconVis? widget.select : (){},
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Text(
                        widget.name,
                        style: ConstantApp.getTextStyle(
                            context: context, color: textColor, size: 8),
                      )),
                  Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: widget.changQty,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                             widget.iconVis? Expanded(child: IconButton(onPressed:widget.subQty , icon: const Icon(Icons.remove) , color: errorColor)):const SizedBox(),
                              Expanded(
                                child: Text(
                                  widget.qty.toString(),
                                  textAlign: TextAlign.center,
                                  style:ConstantApp.getTextStyle(
                                      context: context, color: textColor, size: 8),
                                ),
                              ),
                              widget.iconVis?  Expanded(child: IconButton(onPressed: widget.addQty, icon: const Icon(Icons.add) , color: primaryColor)):const SizedBox(),
                            ],
                          ),
                        ),
                      )),
           Obx(() =>        Get.find<OrderController>().showUnit.value
               ? Flexible(
               flex: 1,
               fit: FlexFit.tight,
               child: Center(
                 child: widget.unitWidget,
               ))
               : const SizedBox(),),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: InkWell(
                        onTap: widget.changPrice,
                        child: Center(
                          child: Text(
                            '${widget.price}',
                            style: ConstantApp.getTextStyle(
                                context: context, size: 8),
                            // TextStyle(
                            //     fontWeight: FontWeight.w400, fontSize:widget.price.toString().length>10?12: 15),
                          ),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Center(
                        child: Text(
                          '${widget.price * widget.qty}',
                          style: ConstantApp.getTextStyle(
                              context: context, color: textColor, size: 8),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Center(
                        child: Text(
                          widget.guest,
                          style:ConstantApp.getTextStyle(
                              context: context, color: textColor, size: 8),
                        ),
                      )),
                  Flexible(
                    flex: 1,
                    child: widget.iconVis
                        ? PopupMenuButton(onSelected: (_) {
                            Get.back();
                          },
                        itemBuilder: (BuildContext context) {
                            return <PopupMenuItem<Widget>>[
                              PopupMenuItem<Widget>(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Add Note '.tr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          actions: [
                                            TextFormField(
                                              controller: notController,
                                              onChanged: widget.onChange,
                                              autofocus: true,
                                              decoration: const InputDecoration(
                                                  enabledBorder:
                                                      InputBorder.none),
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Text('Add Note'.tr),
                              ),
                              PopupMenuItem<Widget>(
                                onTap: widget.onPressed,
                                child: Text('Remove'.tr),
                              ),
                            ];
                          })
                        : const SizedBox(),
                  ),
                ],
              ),
              widget.note!.isEmpty
                  ? const SizedBox()
                  : Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                        '${widget.note}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: primaryColor.withOpacity(0.8)),
                      ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

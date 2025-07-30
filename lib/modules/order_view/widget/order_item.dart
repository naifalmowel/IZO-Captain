import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:izo_captain/modules/order_view/widget/temp_order_items.dart';
import 'package:izo_captain/utils/constant.dart';

import '../../../global_widgets/custom_app_button.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../models/order/order_model.dart';
import '../../../controllers/order_controller.dart';
import '../../../models/product/product_model.dart';
import '../../../utils/Theme/colors.dart';

class OrderItemWidget extends StatefulWidget {
  const OrderItemWidget({
    required this.items,
    required this.orderDate,
    required this.orderId,
    super.key,
    required this.setStateMore,
  });
  final int orderId;
  final DateTime orderDate;
  final List<OrderModel> items;
  final Function() setStateMore;

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  TextEditingController priceEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${'Orders'.tr} : ${widget.orderId}',
                  style: ConstantApp.getTextStyle(
                      context: context, fontWeight: FontWeight.w500),
                  maxLines: 1,
                ),
                Text(DateFormat.jm().format(widget.orderDate),
                    style: ConstantApp.getTextStyle(
                        context: context, fontWeight: FontWeight.w500),
                    maxLines: 1)
              ],
            ),
          ),
        ),
        GetBuilder<OrderController>(builder: (controller) {
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.items.length,
              itemBuilder: (context, index) => TempOrderItem(
                    name: widget.items[index].name,
                    ident: widget.items[index].ident,
                    price: widget.items[index].price,
                    qty: widget.items[index].quantity,
                    guest: widget.items[index].guest,
                    onPressed: () {},
                    iconVis: false,
                    note: widget.items[index].note!,
                    select: () {
                      if (widget.items[index].quantity.isNegative) return;
                      controller.selected1.value = 100;
                      controller.selected1.value = index;
                      controller.checkOrderList.value = widget.orderId;
                      controller.orderTemp = widget.items[index];
                      print(controller.orderTemp.billNum);
                      setState(() {});
                      widget.setStateMore();
                    },
                    orderNum: widget.orderId,
                    index: index,
                    changPrice: () async {
                      if(widget.items[index].quantity.isNegative){
                        return;
                      }
                      priceEditingController.text =
                          widget.items[index].price.toStringAsFixed(2);
                      double whole = 0;
                      double min = 0;
                      double max = 0;
                      double cost = 0;
                      double price = double.tryParse(
                              widget.items[index].price.toStringAsFixed(2)) ??
                          0.0;
                      ProductModel product = controller.products.firstWhere(
                          (element) =>
                              element.id == widget.items[index].itemId);
                      if (widget.items[index].unitId == product.unit) {
                        whole = product.wholePrice ?? 0;
                        min = product.minPrice ?? 0;
                        max = product.maxPrice ?? 0;
                        cost = product.costPrice ?? 0;
                      } else if (widget.items[index].unitId == product.unit2) {
                        whole = product.wholePrice2 ?? 0;
                        min = product.minPrice2 ?? 0;
                        max = product.maxPrice2 ?? 0;
                        cost = product.costPrice2 ?? 0;
                      } else if (widget.items[index].unitId == product.unit3) {
                        whole = product.wholePrice3 ?? 0;
                        min = product.minPrice3 ?? 0;
                        max = product.maxPrice3 ?? 0;
                        cost = product.costPrice3 ?? 0;
                      }
                      if (!mounted) return;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PopScope(
                              canPop: false,
                              child: AlertDialog(
                                  title: Row(children: [
                                    Expanded(
                                      child: CustomAppButton(
                                          onPressed: () {
                                            setState(() {
                                              priceEditingController.text =
                                                  price.toString();
                                              widget.items[index].price = price;
                                              controller.totalPrice.value = 0.0;
                                              for (var i in widget.items) {
                                                controller.totalPrice.value +=
                                                    (i.price * i.quantity);
                                              }
                                            });
                                          },
                                          title: '${"Price/".tr}$price ${"AED".tr}',
                                          backgroundColor:
                                              primaryColor.withOpacity(0.5),
                                          textColor: textColor,
                                          withPading: false,
                                          width: ConstantApp.getWidth(context) /
                                              10,
                                          height:
                                              ConstantApp.getHeight(context) /
                                                  15),
                                    ),
                                    Expanded(
                                      child: CustomAppButton(
                                          onPressed: () {
                                            setState(() {
                                              priceEditingController.text =
                                                  whole.toString();
                                              widget.items[index].price = whole;
                                              controller.totalPrice.value = 0.0;
                                              for (var i in widget.items) {
                                                controller.totalPrice.value +=
                                                    (i.price * i.quantity);
                                              }
                                            });
                                          },
                                          title: '${"Whole/".tr}$whole ${"AED".tr}',
                                          backgroundColor:
                                              primaryColor.withOpacity(0.5),
                                          textColor: textColor,
                                          withPading: false,
                                          width: ConstantApp.getWidth(context) /
                                              10,
                                          height:
                                              ConstantApp.getHeight(context) /
                                                  15),
                                    ),
                                    Expanded(
                                      child: CustomAppButton(
                                          onPressed: () {
                                            setState(() {
                                              priceEditingController.text =
                                                  min.toString();
                                              widget.items[index].price = min;
                                              controller.totalPrice.value = 0.0;
                                              for (var i in widget.items) {
                                                controller.totalPrice.value +=
                                                    (i.price * i.quantity);
                                              }
                                            });
                                          },
                                          title: '${"Min/".tr}$min ${"AED".tr}',
                                          backgroundColor:
                                              primaryColor.withOpacity(0.5),
                                          textColor: textColor,
                                          withPading: true,
                                          width: ConstantApp.getWidth(context) /
                                              10,
                                          height:
                                              ConstantApp.getHeight(context) /
                                                  15),
                                    ),
                                    Expanded(
                                      child: CustomAppButton(
                                          onPressed: () {
                                            setState(() {
                                              priceEditingController.text =
                                                  max.toString();
                                              widget.items[index].price = max;
                                              controller.totalPrice.value = 0.0;
                                              for (var i in widget.items) {
                                                controller.totalPrice.value +=
                                                    (i.price * i.quantity);
                                              }
                                            });
                                          },
                                          title: '${"Max/".tr}$max ${"AED".tr}',
                                          backgroundColor:
                                              primaryColor.withOpacity(0.5),
                                          textColor: textColor,
                                          withPading: true,
                                          width: ConstantApp.getWidth(context) /
                                              10,
                                          height:
                                              ConstantApp.getHeight(context) /
                                                  15),
                                    ),
                                    Expanded(
                                      child: CustomAppButton(
                                          onPressed: () {
                                            setState(() {
                                              priceEditingController.text =
                                                  cost.toString();
                                              widget.items[index].price = cost;
                                              controller.totalPrice.value = 0.0;
                                              for (var i in widget.items) {
                                                controller.totalPrice.value +=
                                                    (i.price * i.quantity);
                                              }
                                            });
                                          },
                                          title: '${"Cost/".tr}$cost ${"AED".tr}',
                                          backgroundColor:
                                              primaryColor.withOpacity(0.5),
                                          textColor: textColor,
                                          withPading: true,
                                          width: ConstantApp.getWidth(context) /
                                              10,
                                          height:
                                              ConstantApp.getHeight(context) /
                                                  15),
                                    ),
                                  ]),
                                  actions: [
                                    Center(
                                      child: CustomTextFormField(
                                        isNum: true,
                                        readOnly: true,
                                        textInputType: TextInputType.number,
                                        onChange: (val) {},
                                        hint: 'Price'.tr,
                                        focusNode: FocusNode(),
                                        textEditingController:
                                            priceEditingController,
                                        onSaved: (val) {},
                                        validator: (val) {
                                          return null;
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CustomAppButton(
                                            onPressed: () async {
                                                priceEditingController.text =
                                                    price.toString();
                                                widget.items[index].price =
                                                    price;
                                                await controller.getOrderForTable(widget
                                                    .items[index].hall, widget
                                                    .items[index].table);
                                              setState(() {
                                              });
                                              Get.back();
                                            },
                                            title: 'Cansel'.tr,
                                            backgroundColor: errorColor,
                                            textColor: textColor,
                                            withPading: true,
                                            width: Get.width / 10,
                                            height: Get.height / 15),
                                        CustomAppButton(
                                            onPressed: () async {
                                              String message =
                                                  await controller.updatePrice(
                                                      id: widget
                                                          .items[index].id!,
                                                      price: double.tryParse(
                                                              priceEditingController
                                                                  .text) ??
                                                          0.0,
                                                      total: controller
                                                          .totalPrice.value,
                                                      hall: widget
                                                          .items[index].hall,
                                                      table: widget
                                                          .items[index].table);
                                             await controller.getAllOrders(hall: widget
                                                 .items[index].hall, table: widget
                                                 .items[index].table);
                                             await controller.getOrderForTable(widget
                                                 .items[index].hall, widget
                                                 .items[index].table);
                                              if (!context.mounted)return;
                                              if(message == 'Success'){
                                                Get.back();
                                                ConstantApp.showSnakeBarSuccess(context, 'update Success !!'.tr);
                                              }else{
                                                ConstantApp.showSnakeBarError(context, 'Some Thing Wrong !!'.tr);
                                              }
                                            },
                                            title: 'Save'.tr,
                                            backgroundColor: primaryColor,
                                            textColor: textColor,
                                            withPading: true,
                                            width: Get.width / 10,
                                            height: Get.height / 15),
                                      ],
                                    ),
                                  ]),
                            );
                          },
                          barrierDismissible: false,
                        );
                    },
                    unitWidget: Text(
                      Get.find<OrderController>()
                          .units
                          .firstWhere((element) =>
                              element.id == widget.items[index].unitId)
                          .name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                    changQty: () {},
                    addQty: () {},
                    subQty: () {},
                  ));
        })
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../../utils/constant.dart';

class DeliveryTableWidget extends StatefulWidget {
  const DeliveryTableWidget({
    required this.number,
    required this.amount,
    required this.isOn,
    required this.onTap,
    required this.isBill,
    required this.orders,
    required this.onUpdatedPress,
    required this.onBillRequest,
    this.time,
    required this.formatNumber,
    super.key,
  });

  final String number;
  final String amount;
  final String formatNumber;
  final bool isOn;
  final Callback onTap;
  final bool isBill;
  final DateTime? time;
  final List<int> orders;
  final Function(int) onUpdatedPress;
  final Callback onBillRequest;

  @override
  State<DeliveryTableWidget> createState() => _DeliveryTableWidgetState();
}

class _DeliveryTableWidgetState extends State<DeliveryTableWidget> {
  var isEditing = false;
  var isChangingOrder = false;
  Color color = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initColor();
    return GestureDetector(
        onTap: widget.onTap,
        child: Card(
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Row(
            children: [
              if (widget.isOn && !widget.isBill && widget.orders.isNotEmpty)
                Expanded(
                  flex: 5,
                  child: Column(children: [
                    Expanded(
                      child: Lottie.asset('lottie/delivery.json'),
                    ),
                  ]),
                ),
              if (widget.isOn && !widget.isBill && widget.orders.isEmpty)
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Lottie.asset('lottie/delivery.json'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(10))),
                            alignment: Alignment.bottomLeft,
                            child: Center(
                              child: Text('To the kitchen'.tr,
                                  style: ConstantApp.getTextStyle(
                                      context: context,
                                      fontWeight: FontWeight.w700,
                                      size: Get.width > 750 ? 7: 5,
                                  )),
                            )),
                      )
                    ],
                  ),
                ),
              if (widget.isOn && widget.isBill)
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Lottie.asset('lottie/delivery.json'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(10),
                                )),
                            alignment: Alignment.bottomLeft,
                            child: Center(
                              child: Text('Bill Requested'.tr,
                                  style: ConstantApp.getTextStyle(
                                      context: context,
                                      fontWeight: FontWeight.w700,
                                      size: Get.width > 750 ? 7 : 5,
                                      color: Colors.green)),
                            )),
                      )
                    ],
                  ),
                ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.number,
                          style: ConstantApp.getTextStyle(
                              context: context,
                              color: Colors.black,
                              size: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (widget.isOn && widget.time != null)
                      Expanded(
                          child: Text(DateFormat.jm().format(widget.time!))),
                    if (widget.isOn)
                      Expanded(
                        child: Text(
                          '${widget.amount} ${'AED'.tr}',
                          style: TextStyle(
                              color: widget.isOn ? Colors.black : Colors.white),
                        ),
                      ),
                    Expanded(
                        child: Text(widget.formatNumber,
                            style: ConstantApp.getTextStyle(
                                context: context,
                                color: Colors.black,
                                size: Get.width > 750 ? 9: 5,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
  void initColor() {
    if(ConstantApp.enableColor){
      if (widget.isOn && !widget.isBill && widget.orders.isNotEmpty){
        color = Colors.red.withOpacity(0.7);
      }
      else if (widget.isOn && !widget.isBill && widget.orders.isEmpty){
        color = Colors.orange.withOpacity(0.7);
      }
      else if (widget.isOn && widget.isBill){
        color = Colors.green.withOpacity(0.7);
      }
      else{
        color = Colors.white;
      }
    }else{
      color = Colors.white;
    }
  }
}

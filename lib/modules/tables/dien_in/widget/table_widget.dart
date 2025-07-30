import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../../utils/constant.dart';

class TableWidget extends StatefulWidget {
  const TableWidget(
      {required this.number,
      required this.amount,
      required this.isOn,
      required this.onTap,
      required this.onLongPress,
      required this.isBill,
      required this.orders,
      required this.onUpdatedPress,
      required this.onBillRequest,
      required this.bookingTable,
      required this.bookingDate,
      required this.deleteBooking,
      required this.editBooking,
      required this.guestsNumber,
      required this.guestName,
      required this.guestMobil,
      required this.formatNumber,
      required this.lockIconPressed,
      this.time,
      super.key});

  final String number;
  final String amount;
  final String guestName;
  final String guestMobil;
  final String guestsNumber;
  final String formatNumber;
  final bool isOn;
  final Callback onTap;
  final Callback onLongPress;
  final Callback deleteBooking;
  final Callback editBooking;
  final Callback lockIconPressed;
  final bool isBill;
  final bool bookingTable;
  final DateTime? time;
  final DateTime? bookingDate;
  final List<int> orders;
  final Function(int) onUpdatedPress;
  final Callback onBillRequest;

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
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
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: Card(
              color: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              // color: const Color(0xFFf1f1f1),
              elevation: 4,
              child: Row(
                children: [
                  if (widget.isOn && !widget.isBill && widget.orders.isNotEmpty)
                    Expanded(
                      flex: 5,
                      child: Container(),
                    ),
                  if (widget.isOn && !widget.isBill && widget.orders.isEmpty)
                    Expanded(
                      flex: 5,
                      child: Column(children: [
                        Expanded(
                          flex: 3,
                          child: Lottie.asset('lottie/bill_req.json'),
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20))),
                                alignment: Alignment.bottomLeft,
                                child: Center(
                                  child: Text('To the kitchen'.tr,
                                      style: ConstantApp.getTextStyle(
                                        context: context,
                                        fontWeight: FontWeight.w700,
                                        size: Get.width > 750 ? 7 : 5,
                                      )),
                                )))
                      ]),
                    ),
                  if (widget.isOn && widget.isBill)
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Lottie.asset('lottie/bill_req.json'),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20))),
                                  alignment: Alignment.bottomLeft,
                                  child: Center(
                                    child: Text('Bill requested'.tr,
                                        style: ConstantApp.getTextStyle(
                                            context: context,
                                            fontWeight: FontWeight.w700,
                                            size: Get.width > 750 ? 7 : 5,
                                            color: Colors.green)),
                                  )))
                        ],
                      ),
                    ),
                  if (widget.bookingTable &&
                      !widget.isOn &&
                      !widget.isBill &&
                      widget.orders.isEmpty)
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            DateFormat('yyyy-MM-dd hh:mm aa')
                                .format(widget.bookingDate!),
                            style: ConstantApp.getTextStyle(
                                context: context,
                                color: Colors.black,
                                size: Get.width > 750 ? 9 : 7),
                          ),
                        ),
                      ),
                    ),
                  if (!widget.isOn && !widget.bookingTable)
                    Expanded(
                      flex: 5,
                      child: Container(),
                    ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.number,
                              style: ConstantApp.getTextStyle(
                                  context: context,
                                  color: Colors.black,
                                  size: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        widget.isOn && widget.time != null
                            ? Expanded(
                                child:
                                    Text(DateFormat.jm().format(widget.time!)))
                            : const SizedBox(),
                        widget.isOn
                            ? Expanded(
                                child: Text(
                                  '${widget.amount} ${'AED'.tr}',
                                  style: TextStyle(
                                      color: widget.isOn
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              )
                            : const SizedBox(),
                        widget.formatNumber == ''
                            ? const SizedBox()
                            : Expanded(
                                child: Text(widget.formatNumber,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: Colors.black,
                                        size: Get.width > 750 ? 9 : 7,
                                        fontWeight: FontWeight.bold)),
                              ),
                        if (widget.bookingTable &&
                            !widget.isOn &&
                            !widget.isBill &&
                            widget.orders.isEmpty)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(widget.guestName,
                                      style: ConstantApp.getTextStyle(
                                          context: context,
                                          color: Colors.black,
                                          size: 8,
                                          fontWeight: FontWeight.w600)),
                                  Text(widget.guestMobil,
                                      style: ConstantApp.getTextStyle(
                                          context: context,
                                          color: Colors.black,
                                          size: 8,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          )
                        else
                          const SizedBox(),
                      ],
                    ),
                  )
                ],
              ),
            )),
        widget.bookingTable
            ? Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: widget.editBooking,
                  icon: Icon(
                    Icons.lock,
                    color: Colors.redAccent,
                    size: ConstantApp.getTextSize(context) * 13,
                  ),
                ))
            : const SizedBox(),
      ],
    );
  }

  void initColor() {
    if (ConstantApp.enableColor) {
      if (widget.isOn && !widget.isBill && widget.orders.isNotEmpty) {
        color = Colors.red.withOpacity(0.7);
      } else if (widget.isOn && !widget.isBill && widget.orders.isEmpty) {
        color = Colors.orange.withOpacity(0.7);
      } else if (widget.isOn && widget.isBill) {
        color = Colors.green.withOpacity(0.7);
      } else if (widget.bookingTable &&
          !widget.isOn &&
          !widget.isBill &&
          widget.orders.isEmpty) {
        color = Colors.red.withOpacity(0.7);
      } else if (!widget.isOn && !widget.bookingTable) {
        color = Colors.white;
      } else {
        color = Colors.white;
      }
    } else {
      color = Colors.white;
    }
  }
}

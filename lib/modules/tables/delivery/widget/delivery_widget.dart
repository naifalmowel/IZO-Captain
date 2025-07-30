import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:izo_captain/controllers/order_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../controllers/tables_controller.dart';
import '../../../../models/table_model.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/scaled_dimensions.dart';
import '../../../order_view/order_view_a.dart';
import '../../../order_view/order_view_w.dart';
import 'delivery_table_widget.dart';

class DeliveryWidget extends StatefulWidget {
  const DeliveryWidget({required this.number, required this.tables, super.key});
  final List<TableModel> tables;
  final int number;

  @override
  State<DeliveryWidget> createState() => _DeliveryWidgetState();
}

class _DeliveryWidgetState extends State<DeliveryWidget> {
  bool payT = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: ScaledDimensions.getScaledHeight(px: 10),
        ),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GetPlatform.isDesktop || Get.width > 750
                  ? Get.width < 1000
                      ? 3
                      : 5
                  : 2,
              childAspectRatio: 1.8),
          itemCount: widget.tables.length,
          itemBuilder: (BuildContext context, int index) {
            return DeliveryTableWidget(
              number: widget.tables[index].number,
              amount: widget.tables[index].voidAmount != null
                  ? (widget.tables[index].cost -
                          widget.tables[index].voidAmount!)
                      .toString()
                  : widget.tables[index].cost.toString(),
              isOn: widget.tables[index].cost != 0 ? true : false,
              onTap: () async {
                BuildContext dialogContext = context;
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context1) {
                    dialogContext = context1;
                    return SimpleDialog(backgroundColor: Colors.white70, children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 20),
                            child: SpinKitFadingCircle(
                              color: const Color(0xffee680e).withOpacity(0.9),
                              size: 50,
                            ),
                          ),
                           Text(
                            'Loading .. '.tr,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ]);
                  },
                );
                if(ConstantApp.type == "guest"){
                  Get.find<OrderController>().getAllProducts();
                  Get.find<OrderController>().getAllOrders(hall: widget.tables[index].hall.toString(), table: widget.tables[index].number.toString());
                  Navigator.of(dialogContext).pop();
                  Get.to(() =>GetPlatform.isWindows ?  OrderViewW(
                    hall: widget.tables[index].hall.toString(),
                    table: widget.tables[index].number.toString(),
                    customerId: widget.tables[index].customerId ?? 0,
                    billRequest: widget.tables[index].waitCustomer ?? false,
                  ):OrderViewA(
                    hall: widget.tables[index].hall.toString(),
                    table: widget.tables[index].number.toString(),
                    customerId: widget.tables[index].customerId ?? 0,
                    billRequest: widget.tables[index].waitCustomer ?? false,
                  ));
                }
                else{
                  Get.find<OrderController>().getCustomerOrderNumber();
                  Get.find<OrderController>().getAllProducts();
                  Get.find<OrderController>().order.clear();
                  await Get.find<OrderController>().getAllOrders(hall: widget.tables[index].hall.toString(), table: widget.tables[index].number.toString());
                  await Get.find<OrderController>().getOrderForTable(
                    widget.tables[index].hall.toString(),
                    widget.tables[index].number.toString(),
                  );
                  final cashier =
                      Get.find<SharedPreferences>().getString('name') ?? '';

                  final message =
                  await Get.find<TableController>().entryToTable(data: {
                    "number": widget.tables[index].number.toString(),
                    "hall": widget.tables[index].hall.toString(),
                    "cashier": cashier,
                  });
                  if (message == 'ERROR') {
                    if (!context.mounted) return;
                    ConstantApp.showSnakeBarError(context, 'The Table is Busy'.tr);
                    Navigator.of(dialogContext).pop();
                    return;
                  }
                  if (!dialogContext.mounted) return;
                  Navigator.of(dialogContext).pop();
                  Get.to(() =>GetPlatform.isWindows ?  OrderViewW(
                    hall: widget.tables[index].hall.toString(),
                    table: widget.tables[index].number.toString(),
                    customerId: widget.tables[index].customerId ?? 0,
                    billRequest: widget.tables[index].waitCustomer ?? false,
                  ):OrderViewA(
                    hall: widget.tables[index].hall.toString(),
                    table: widget.tables[index].number.toString(),
                    customerId: widget.tables[index].customerId ?? 0,
                    billRequest: widget.tables[index].waitCustomer ?? false,
                  ));
                }
              },
              isBill: widget.tables[index].waitCustomer != null &&
                      widget.tables[index].waitCustomer == true
                  ? true
                  : false,
              orders: const [],
              onUpdatedPress: (val) {},
              onBillRequest: () {},
              time: widget.tables[index].time,
              formatNumber: widget.tables[index].formatNumber ?? '',
            );
          },
        ),
      ],
    );
  }
}

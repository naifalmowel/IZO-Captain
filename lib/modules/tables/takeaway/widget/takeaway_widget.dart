import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:izo_captain/controllers/tables_controller.dart';
import '../../../../controllers/order_controller.dart';
import '../../../order_view/order_view_a.dart';
import '../../../order_view/order_view_w.dart';
import 'package:izo_captain/modules/tables/takeaway/widget/takeaway_table_widget.dart';
import 'package:izo_captain/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/table_model.dart';
import '../../../../utils/scaled_dimensions.dart';

class TakeawayWidget extends StatelessWidget {
  const TakeawayWidget({required this.number, required this.tables, super.key});
  final List<TableModel> tables;
  final int number;

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
         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: GetPlatform.isDesktop || Get.width > 750
                 ? Get.width < 1000
                 ? 3
                 : 5
                 : 2,
             childAspectRatio: 1.8),
         physics: const NeverScrollableScrollPhysics(),
         itemCount: tables.length,
         itemBuilder: (BuildContext context, int index) {
           return TakeawayTableWidget(
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

               Get.find<OrderController>().getAllProducts();
               if(ConstantApp.type == "guest"){
                 Get.find<OrderController>().getAllOrders(hall: '', table: '');
               }
               else{
                 Get.find<OrderController>().getCustomerOrderNumber();
                 Get.find<OrderController>().order.clear();
                 Get.find<OrderController>().orders.clear();
                 await Get.find<OrderController>().getAllOrders(hall: tables[index].hall.toString(), table: tables[index].number.toString());
                 await Get.find<OrderController>().getOrderForTable(
                   tables[index].hall.toString(),
                   tables[index].number.toString(),
                 );
                 // await Future.wait([Get.find<OrderController>().getAllOrders(),
                 //     Get.find<OrderController>().getOrderForTable(
                 //       tables[index].hall.toString(),
                 //       tables[index].number.toString(),
                 //     ),
                 //  ]);
                 //Get.find<OrderController>().orders.clear();
                 final cashier =
                     Get.find<SharedPreferences>().getString('name') ?? '';

                 final message =
                 await Get.find<TableController>().entryToTable(data: {
                   "number": tables[index].number.toString(),
                   "hall": tables[index].hall.toString(),
                   "cashier": cashier,
                 });
                 if (!context.mounted) return;
                 if (message == 'ERROR') {
                   ConstantApp.showSnakeBarError(context, 'The Table is Busy'.tr);
                   Navigator.of(dialogContext).pop();
                   return;
                 }
               }
               Navigator.of(dialogContext).pop();
               Get.to(() =>GetPlatform.isWindows ?  OrderViewW(
                 hall: tables[index].hall.toString(),
                 table: tables[index].number.toString(),
                 customerId: tables[index].customerId ?? 0,
                 billRequest: tables[index].waitCustomer ?? false,
               ):OrderViewA(
                 hall: tables[index].hall.toString(),
                 table: tables[index].number.toString(),
                 customerId: tables[index].customerId ?? 0,
                 billRequest: tables[index].waitCustomer ?? false,
               ));

             },
             number: tables[index].number,
             amount: tables[index].voidAmount != null
                 ? (tables[index].cost - tables[index].voidAmount!).toString()
                 : tables[index].cost.toString(),
             isOn: tables[index].cost != 0 ? true : false,
             isBill: tables[index].waitCustomer != null &&
                 tables[index].waitCustomer == true
                 ? true
                 : false,
             time: tables[index].time,
             orders: const [],
             onUpdatedPress: (value) async {},
             onBillRequest: () async {},
             formatNumber: tables[index].formatNumber ?? '',
           );
         },
       )
      ],
    );
  }
}

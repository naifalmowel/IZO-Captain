import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izo_captain/controllers/info_controllers.dart';
import 'package:izo_captain/controllers/tables_controller.dart';
import 'package:izo_captain/modules/tables/takeaway/widget/takeaway_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/user_controller.dart';
import '../../../utils/Theme/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/scaled_dimensions.dart';
import '../../home_view/header_widget.dart';
import '../../login/login.dart';

class TakeawayView extends StatefulWidget {
  const TakeawayView({super.key});

  @override
  State<TakeawayView> createState() => _TakeawayViewState();
}

class _TakeawayViewState extends State<TakeawayView> {
  final infoController = Get.find<InfoController>();
@override
  void initState() {
  Get.find<TableController>().loading(false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_)async{
        showDialog(
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SingleChildScrollView(
                child: AlertDialog(
                  alignment: Alignment.topCenter,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  actionsPadding: const EdgeInsets.all(20),
                  shape: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  title: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Lottie.asset('lottie/question.json',
                              height: 200, width: 200),
                          Text('Are You Sure To Logout ?'.tr,
                              textAlign: TextAlign.center),
                        ],
                      )),
                  content:  Text(
                      'You Will Not Be Able To Return To This Page'.tr,
                      textAlign: TextAlign.center),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.redAccent)),
                        child:  Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text('No'.tr,style: const TextStyle(color: Colors.white , fontWeight: FontWeight.w600),),
                        )),
                    ElevatedButton(
                        onPressed: () async{
                          try{
                            bool result = await Get.find<UserController>().logoutUser();
                            if(result){
                              if (!context.mounted) return;
                              ConstantApp.showSnakeBarInfo(context, 'Logout Done !!'.tr);
                            }
                          }catch(e){
                            print(e);
                          }
                          Get.find<SharedPreferences>().remove('name');
                          Get.back();
                          Get.offAll(()=> const LoginPage());
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => primaryColor.withOpacity(0.8))),
                        child:  Padding(
                          padding: const EdgeInsets.only(left: 20 , right: 20),
                          child: Text('Yes'.tr ,style: const TextStyle(color: Colors.white , fontWeight: FontWeight.w600),),
                        )),
                  ],
                ),
              ),
            );
          },
          barrierDismissible: true,
        );
      },
      child: SafeArea(
          child: Scaffold(
        body: Container(
          width: ConstantApp.getWidth(context),
          height: ConstantApp.getHeight(context),
          decoration: BoxDecoration(
            gradient: backgroundGradient,
          ),
          child: Obx(
            () => SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: ScaledDimensions.getScaledWidth(px: 10),
                    vertical: ScaledDimensions.getScaledHeight(px: 15)),
                child: Column(children: [
                  const HeaderWidget(),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: primaryColor),
                    child: Center(
                      child: Text(
                        'TAKEAWAY'.tr,
                        style: ConstantApp.getTextStyle(
                            context: context,
                            size: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold).copyWith(letterSpacing: 3,),
                      ),
                    ),
                  ),
                  Column(
                    children: infoController.halls
                        .where((p0) => p0.id == -1)
                        .toList()
                        .map((element) => TakeawayWidget(
                            number: element.id, tables: element.tables))
                        .toList(),
                  ),
                ])),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () async {
                String message = await Get.find<TableController>().incTakeaway();
                if (message == 'ERROR') {
                  if(!context.mounted)return;
                  ConstantApp.showSnakeBarError(
                      context, 'SORRY , NO SERVER CONNECTION !!'.tr);
                }
              },
              backgroundColor: primaryColor.withOpacity(0.7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.add),
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              heroTag: "btn2",
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: () async {
                String message = await Get.find<TableController>().decTakeaway();
                if (message == 'ERROR') {
                  if(!context.mounted)return;
                  ConstantApp.showSnakeBarError(
                      context, 'SORRY , CAN NOT DELETE !!'.tr);
                }
              },
              backgroundColor: errorColor.withOpacity(0.7),
              child: const Icon(Icons.remove),
            )
          ],
        ),
      )),
    );
  }
}

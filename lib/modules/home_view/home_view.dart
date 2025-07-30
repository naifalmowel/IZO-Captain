import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:izo_captain/controllers/info_controllers.dart';
import 'package:izo_captain/controllers/internet_check_controller.dart';
import 'package:izo_captain/utils/constant.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/user_controller.dart';
import '../../utils/Theme/colors.dart';
import '../tables/delivery/delivery.dart';
import '../tables/dien_in/tables_view.dart';
import '../tables/takeaway/takeaway.dart';
import '../widget/no_internet_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached || state == AppLifecycleState.inactive) {
      try {
        Get.find<UserController>().logoutUser();
      } catch (e) {
        print("Error during logout: $e");
      }
    }else if(state == AppLifecycleState.resumed){
      try {
        final userId = Get.find<SharedPreferences>().getInt('userId')??0;
        Get.find<UserController>().loginUser(userId: userId);
      } catch (e) {
        print("Error during loginUser: $e");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<InfoController>(
        builder: (controller) {
      controller.isDelivery.value = ConstantApp.isDelivery;
      return Obx(() => PopScope(
        canPop: false,
        onPopInvoked: (_){
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
                               Text('Are You Sure To Exit ?'.tr,
                                  textAlign: TextAlign.center),
                            ],
                          )),
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
                            onPressed: () {
                              exit(0);
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
              barrierDismissible: true,);
        },
        child: Scaffold(
              body: <Widget>[
                Get.find<INetworkInfo>().connectionStatus.value == 0
                    ? EmptyFailureNoInternetView(
                        image: 'lottie/no_internet.json',
                        title: 'Network Error'.tr,
                        description: 'Internet Not Found !!'.tr,
                        buttonText: "Retry".tr,
                        onPressed: () async {},
                      )
                    : const TakeawayView(),
                Get.find<INetworkInfo>().connectionStatus.value == 0
                    ? EmptyFailureNoInternetView(
                        image: 'lottie/no_internet.json',
                        title: 'Network Error'.tr,
                        description: 'Internet Not Found !!'.tr,
                        buttonText: "Retry".tr,
                        onPressed: () async {},
                      )
                    : controller.isDelivery.value
                        ? const DeliveryView()
                        : const SizedBox(),
                Get.find<INetworkInfo>().connectionStatus.value == 0
                    ? EmptyFailureNoInternetView(
                        image: 'lottie/no_internet.json',
                        title: 'Network Error'.tr,
                        description: 'Internet Not Found !!'.tr,
                        buttonText: "Retry".tr,
                        onPressed: () async {},
                      )
                    : const TablesView(),
              ][currentPageIndex],
              bottomNavigationBar: NavigationBar(
                onDestinationSelected: (int index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
                indicatorColor: primaryColor.withOpacity(0.6),
                selectedIndex: currentPageIndex,
                elevation: 20,
                shadowColor: secondaryColor,
                destinations: <Widget>[
                  NavigationDestination(
                    icon: Badge(
                        label: Text(controller.badgeTakeaway.length.toString()),
                        isLabelVisible:
                            controller.badgeTakeaway.isEmpty ? false : true,
                        child: const Icon(FontAwesomeIcons.bagShopping)),
                    label: 'TakeAway'.tr,
                  ),
                  controller.isDelivery.value
                      ? NavigationDestination(
                          icon: Badge(
                              label: Text(
                                  controller.badgeDelivery.length.toString()),
                              isLabelVisible:
                                  controller.badgeDelivery.isEmpty ? false : true,
                              child: const Icon(
                                FontAwesomeIcons.truckFast,
                              )),
                          label: 'Delivery'.tr,
                        )
                      : Container(),
                  NavigationDestination(
                    icon: Badge(
                      label: Text(controller.badgeTables.length.toString()),
                      isLabelVisible:
                          controller.badgeTables.isEmpty ? false : true,
                      child: const Icon(FontAwesomeIcons.utensils),
                    ),
                    label: 'Dine In'.tr,
                  ),
                ],
              ),
            ),
      ));
    });
  }
}

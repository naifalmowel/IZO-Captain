import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/user_controller.dart';
import '../../utils/IZO_information_page.dart';
import '../../utils/Theme/colors.dart';
import '../../utils/constant.dart';
import '../login/login.dart';
import '../setting/setting_page.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();

}
String cashierName = '';

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  void initState() {
    cashierName = Get.find<SharedPreferences>().getString('name')??'';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return   Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              Get.to(()=>const AppSetting());
            },
            tooltip: 'Setting'.tr,
            iconSize: 30,
            icon: Icon(
              Icons.settings,
              color: secondaryColor,
            )),
        InkWell(
            onTap: () {
              Get.to(() => const IZOPage());
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/IZO.png',
                  width: 50,
                  height: 50,
                ),
                if(cashierName.isNotEmpty) Text('/ $cashierName')
              ],
            )),
        IconButton(
            onPressed: () {
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
            tooltip: 'Logout'.tr,
            iconSize: 30,
            icon: Icon(Icons.logout, color: secondaryColor)),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izo_captain/controllers/admin_controller.dart';
import 'package:izo_captain/controllers/tax_controller.dart';
import 'package:izo_captain/utils/Theme/colors.dart';
import 'package:izo_captain/utils/Theme/light_theme.dart';
import 'package:izo_captain/utils/constant.dart';
import 'package:izo_captain/utils/languages.dart';
import 'package:window_manager/window_manager.dart';
import '/controllers/info_controllers.dart';
import 'package:get/get.dart';
import '/controllers/internet_check_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/tables_controller.dart';
import 'controllers/user_controller.dart';
import 'database/app_db_controller.dart';
import 'modules/login/controller/login_controller.dart';
import 'controllers/order_controller.dart';
import 'modules/login/login.dart';
import 'modules/permission/permission_controller.dart';
import 'modules/qr_code/qr_scanner.dart';
import 'modules/setting/controller/setting_controller.dart';
import 'modules/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  Get.put(prefs);
  Get.put(AppSettingController());
  initController();
  initSharedPreferenceValue(prefs);
  if (Platform.isWindows) {
    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(800, 600),
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setMinimumSize(const Size(800, 600));
      await windowManager.show();
      await windowManager.focus();

    });
  }
  ConstantApp.languageApp = prefs.getString("lang")??"us";
  Get.find<AppSettingController>().language.value = prefs.getString("lang")??"en";
  runApp(const MyApp());
}

void initSharedPreferenceValue(SharedPreferences prefs) {
  Get.find<OrderController>().enableGuests.value =
      prefs.getBool("enableGuests") ?? false;
  ConstantApp.enableColor =
      Get.find<SharedPreferences>().getBool('enableColor') ?? false;
  ConstantApp.isDelivery =
      Get.find<SharedPreferences>().getBool('delivery') ?? false;
}

void initController() {
  Get.put(AppDataBaseController());
  Get.put(InfoController());
  Get.put(UserController());
  Get.put(OrderController());
  Get.put(LoginController());
  Get.put(INetworkInfo());
  Get.put(TableController());
  Get.put(PermissionController());
  Get.put(AdminController());
  Get.put(TaxController());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onInit: () async {
        if( GetPlatform.isWindows){
          bool isE = false;
          String urlServer = Get.find<SharedPreferences>().getString('url') ?? '';
          if (urlServer.isNotEmpty) {
            try {
              isE = await Get.find<InfoController>().checkMobile();
              await Get.find<InfoController>().getAllInformation();
              await Get.find<UserController>().getUsers();
            } catch (e) {
              isE = false;
              Get.find<InfoController>().isLoading(false);
              Get.find<InfoController>().isLoadingCheck(false);
            }
          }
          Future.delayed( Duration(seconds:GetPlatform.isWindows ?  2 : 5), () {
            Get.offAll(() => urlServer == ''
                ? const QRScanner() :const LoginPage()
            );
          });
        }

      },
      translations: Languages(),
      locale:
      Get.find<AppSettingController>().language.value ==
          "en"
          ? const Locale('en', 'US')
          : const Locale('ar', 'AR'),
      fallbackLocale:
      Get.find<AppSettingController>().language.value ==
          "en"
          ? const Locale('en', 'US')
          : const Locale('ar', 'AR'),
      theme: lightTheme,
      defaultTransition: Transition.cupertino,
      debugShowCheckedModeBanner: false,
      title: 'IZO_CAPTAIN',
      home: GetPlatform.isWindows
          ? Scaffold(
              body: Center(
                  child: SpinKitFoldingCube(
                color: primaryColor,
                size: 75,
              )),
            )
          : const Scaffold(
              body: VideoPlayerScreen(),
            ),
    );
  }
}


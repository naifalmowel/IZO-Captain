import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:izo_captain/controllers/admin_controller.dart';
import 'package:izo_captain/controllers/info_controllers.dart';
import 'package:izo_captain/controllers/user_controller.dart';
import 'package:izo_captain/modules/qr_code/qr_scanner.dart';
import 'package:izo_captain/utils/constant.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/internet_check_controller.dart';
import '../../controllers/tax_controller.dart';
import '../../utils/Theme/colors.dart';
import '../home_view/home_view.dart';
import '../../controllers/order_controller.dart';
import '../setting/controller/setting_controller.dart';
import '../widget/no_internet_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  MobileScannerController cameraController = MobileScannerController();
  FocusNode passwordFN = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool vis = false;
  int userId = 0;
  late TextEditingController passwordController;
  List lang = ['us', 'ae'];
  String l = '';


  @override
  void initState() {
    passwordController = TextEditingController();
    userId = 0;
    vis = false;
    String lang1 = Get.find<AppSettingController>().language.value;
    // String lang1 = Get.find<AppSettingController>().appSetting.value.language;
    if (lang1 == 'en') {
      l = 'us';
    }
    else {
      l = 'ae';
    }
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
          ),
          Get.find<INetworkInfo>().connectionStatus.value == 0
              ? EmptyFailureNoInternetView(
                  image: 'lottie/no_internet.json',
                  title: 'Network Error',
                  description: 'Internet Not Found !!',
                  buttonText: "Retry",
                  onPressed: () async {
                    await Get.find<InfoController>().getAllInformation();
                  },
                )
              : Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SingleChildScrollView(
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (MediaQuery.of(context).size.width > 850)
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Lottie.asset('lottie/login.json',
                                            width: 650, height: 650),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: info(),
                                        )),
                                  ],
                                ),
                              if (MediaQuery.of(context).size.width < 850)
                                Center(
                                  child: Lottie.asset(
                                    'lottie/login.json',
                                  ),
                                ),
                              if (MediaQuery.of(context).size.width < 850)
                                info(),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: SingleChildScrollView(
                                            child: AlertDialog(
                                              alignment: Alignment.topCenter,
                                              backgroundColor:
                                                  Colors.white.withOpacity(0.9),
                                              actionsPadding:
                                                  const EdgeInsets.all(20),
                                              shape: const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30))),
                                              title: Center(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Lottie.asset(
                                                      'lottie/question.json',
                                                      height: 200,
                                                      width: 200),
                                                   Text(
                                                      'Are You Sure To Rescan QR Code ?'.tr,
                                                      textAlign:
                                                          TextAlign.center),
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
                                                    // style: ButtonStyle(
                                                    //     backgroundColor: WidgetStateProperty.all<Color>(Colors.redAccent),
                                                    //
                                                    // ),
                                                    child:  Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 20, right: 20),
                                                      child: Text(
                                                        'No'.tr,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    )),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Get.find<
                                                              SharedPreferences>()
                                                          .remove('url');
                                                      Get.find<InfoController>()
                                                          .isLoading
                                                          .value = false;
                                                      Get.back();
                                                      Get.offAll(() =>
                                                          const QRScanner());
                                                    },
                                                    // style: ButtonStyle(
                                                    //     backgroundColor: WidgetStateColor
                                                    //         .resolveWith((states) =>
                                                    //             primaryColor
                                                    //                 .withOpacity(
                                                    //                     0.8))),
                                                    child:  Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 20, right: 20),
                                                      child: Text(
                                                        'Yes'.tr,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      barrierDismissible: true,);
                                },
                                icon: const Icon(Icons.qr_code),
                                color: primaryColor,
                                tooltip: "Rescan QR Code".tr,
                                iconSize: 35),
                          )
                        ],
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget info() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Container(
          width: Get.width > 750
              ? ConstantApp.getWidth(context) / 1.6
              : ConstantApp.getWidth(context) / 1.2,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: -3,
                  blurRadius: 7,
                  offset: const Offset(0, 15), // changes position of shadow
                )
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.8), width: 3),
              color: Colors.grey.withOpacity(0.3)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 150,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: DropdownButton(
                            icon: Icon(
                              Icons.language,
                              color: secondaryColor,
                            ),
                            hint: Text(
                              'Languages'.tr,
                              style:  TextStyle(color: secondaryColor),
                            ),
                            items: lang
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    item.toString().tr,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style:
                                    ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ],
                              ),
                            ))
                                .toList(),
                            onChanged: (value) async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              l = value!;
                              ConstantApp.languageApp = value;
                              Get.find<AppSettingController>().language.value = value;
                              if (value == 'us') {
                                prefs.remove('lang');
                                prefs.setString('lang', 'en');
                                // Get.find<AppSettingController>()
                                //     .updateLanguage('en');
                                Get.updateLocale(
                                    const Locale('en', 'US'));
                              } else {
                                prefs.remove('lang');
                                prefs.setString('lang', 'ar');
                                // Get.find<AppSettingController>()
                                //     .updateLanguage('ar');
                                Get.updateLocale(
                                    const Locale('ar', 'AR'));
                              }
                            },
                            value: l == '' ? null : l,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gutter(),
                  Text('LOGIN'.tr.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: ConstantApp.getTextStyle(
                          context: context,
                          size: 15,
                          color: Colors.grey[800]!.withOpacity(0.8),
                          fontWeight: FontWeight.bold)),
                  Divider(color: primaryColor, thickness: 3),
                  const Gutter(),
                  GetBuilder<UserController>(builder: (controller) {
                    return
                      controller.isLogin.value
                        ? Center(
                            child: SpinKitFoldingCube(
                            color: primaryColor,
                            size: 75,
                          ))
                        : Container(
                            margin: const EdgeInsets.only(
                                right: 50, left: 50, bottom: 20),
                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.black45),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                  ),
                                  child: DropdownButton(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    value: userId == 0 ? null : userId,
                                    items: controller.users
                                        .map((element) => DropdownMenuItem(
                                              value: element.id,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16, right: 16),
                                                child: Text(element.name),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      userId = value!;
                                      setState(() {});
                                    },
                                    icon: Padding(
                                        //Icon at tail, arrow bottom is default icon
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                             bool result =    await controller.getUsers();
                                             if(!result){
                                               if(!mounted){return;}
                                               ConstantApp.showSnakeBarError(context, 'There may be no internet connection or server error !!'.tr);
                                             }
                                              },
                                              icon: const Icon(Icons.refresh),
                                              color: secondaryColor,
                                            ),
                                            const Icon(
                                                Icons.arrow_circle_down_sharp),
                                          ],
                                        )),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87),
                                    dropdownColor: Colors.white70,
                                    hint: Text(
                                      'Select User'.tr,
                                      style: TextStyle(color: primaryColor),
                                    ),
                                    underline: Container(),
                                    isExpanded: true,
                                  ),
                                )));
                  }),
                  Container(
                    margin:
                        const EdgeInsets.only(right: 50, left: 50, bottom: 50),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: passwordController,
                      obscureText: !vis,
                      obscuringCharacter: '*',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Can Not Be Empty !!'.tr;
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      decoration: InputDecoration(
                          label:  Text('Password'.tr),
                          labelStyle: TextStyle(color: primaryColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          focusColor: primaryColor.withOpacity(0.5),
                          suffixIcon: IconButton(
                            onPressed: () {
                              vis = !vis;
                              setState(() {});
                            },
                            icon: Icon(
                                vis ? Icons.visibility_off : Icons.visibility),
                          )),
                      onFieldSubmitted: (value) {
                        login();
                      },
                    ),
                  ),
                  Align(
                    alignment: MediaQuery.of(context).size.width > 650
                        ? Alignment.bottomRight
                        : Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: ElevatedButton(
                          onPressed: () async {
                            login();
                          },
                          // style: ButtonStyle(
                          //     shape: WidgetStateProperty.all<
                          //             RoundedRectangleBorder>(
                          //         RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(18),
                          //             side: const BorderSide(
                          //                 color: Colors.black38))),
                          //     backgroundColor: WidgetStateColor.resolveWith(
                          //         (states) => primaryColor)),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text('LOGIN'.tr,
                                    style: const TextStyle(
                                        fontFamily: 'bung',
                                        fontSize: 20,
                                        color: Colors.white)),
                              ),
                            ],
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    Get.find<UserController>().isLogin(true);
    Get.find<AdminController>().viewTax();
    Get.find<TaxController>().getAllTaxesSetting();
    if (userId == 0) {
      ConstantApp.showSnakeBarError(context, 'Please , Select User !!'.tr);
      Get.find<UserController>().isLogin(false);
      return;
    }
    if (passwordController.text.isEmpty) {
      ConstantApp.showSnakeBarError(context, 'Please , Enter Password !!'.tr);
      Get.find<UserController>().isLogin(false);
      return;
    }
    if (_formKey.currentState!.validate()) {
      var user = Get.find<UserController>()
          .users
          .where((p0) => p0.id == userId)
          .toList();
      if (user.isNotEmpty) {
        if (user.last.password == passwordController.text) {
          try{
            bool result = await Get.find<UserController>().loginUser(userId: user.last.id);
            if(!result){
              if (!mounted) return;
              ConstantApp.showSnakeBarError(context, 'This account is being used on another device. Please log out from other devices !!'.tr);
              setState(() {
                Get.find<UserController>().isLogin(false);
              });
              return;
            }
          }catch(e){
            print(e);
            setState(() {
              Get.find<UserController>().isLogin(false);
            });
            return;
          }
          Get.find<SharedPreferences>().remove('name');
          Get.find<SharedPreferences>().remove('userId');
          Get.find<SharedPreferences>().remove('stop');
          Get.find<SharedPreferences>().setString('name', user.last.name);
          Get.find<SharedPreferences>().setInt('userId', user.last.id);

          if (!mounted) return;
          ConstantApp.showSnakeBarSuccess(context, 'Success Login !!'.tr);
          Get.offAll(() => const HomeView());
           Future.wait([
            Get.find<OrderController>().getAllProducts(),
            Get.find<InfoController>().balanceSetting()
          ]);
          bool isFetching = false;
            Timer.periodic(const Duration(seconds: 1), (timer) async {
              String url = Get.find<SharedPreferences>().getString('url') ?? '';
              if (url == '') {
                timer.cancel();
              }
              if (!isFetching) {
                isFetching = true;
                await Get.find<InfoController>().getAllInformation();
                isFetching = false;
              }
            });

          Get.find<UserController>().isLogin(false);

          passwordController.clear();
          userId = 0;
        } else {
          Get.find<UserController>().isLogin(false);
          ConstantApp.showSnakeBarError(context, 'invalid Password !!'.tr);
        }
      }
    }
  }
}

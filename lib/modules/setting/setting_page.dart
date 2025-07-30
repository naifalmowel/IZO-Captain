import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izo_captain/controllers/info_controllers.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constant.dart';

import '../../utils/Theme/colors.dart';

class AppSetting extends StatefulWidget {
  const AppSetting({super.key});

  @override
  AppSettingState createState() => AppSettingState();
}

class AppSettingState extends State<AppSetting> {
bool isCumulatively = false;
  @override
  void initState() {
    ConstantApp.enableColor = Get.find<SharedPreferences>().getBool('enableColor') ?? false;
    ConstantApp.isDelivery = Get.find<SharedPreferences>().getBool('delivery') ?? false;
    isCumulatively = Get.find<SharedPreferences>().getBool('Cumulatively') ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Setting'.tr,
        style: ConstantApp.getTextStyle(context: context, color: Colors.white),
      )),
      body: Container(
        width: ConstantApp.  getWidth(context),
        height: ConstantApp.getHeight(context),
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: SettingsList(
          lightTheme: const SettingsThemeData(
              settingsListBackground: Colors.transparent),
          sections: [
            SettingsSection(
              title: Text('App Setting'.tr,
                  style: ConstantApp.getTextStyle(context: context)),
              tiles: [
                SettingsTile.switchTile(
                  title: Text('Allow To Add Delivery Orders'.tr),
                  leading: const Icon(Icons.delivery_dining),
                  activeSwitchColor: primaryColor,
                  onToggle: (value) {
                    setState(() {
                      ConstantApp.isDelivery = value;
                      Get.find<SharedPreferences>().remove('delivery');
                      Get.find<SharedPreferences>().setBool('delivery', value);
                      Get.find<InfoController>().updateHomePage();
                    });
                  },
                  initialValue: ConstantApp.isDelivery,
                ),
                SettingsTile.switchTile(
                  title: Text('Add Items Cumulatively To Invoice'.tr),
                  leading: const Icon(Icons.point_of_sale),
                  activeSwitchColor: primaryColor,
                  onToggle: (value) {
                    setState(() {
                      isCumulatively = value;
                      Get.find<SharedPreferences>().remove('Cumulatively');
                      Get.find<SharedPreferences>()
                          .setBool('Cumulatively', value);
                    });
                  },
                  initialValue: isCumulatively,
                ),
              ],
            ),
            SettingsSection(
              title: Text('Theme'.tr,
                  style: ConstantApp.getTextStyle(context: context)),
              tiles: [
                SettingsTile.switchTile(
                  title: Text('Enable color item'.tr),
                  leading: const Icon(Icons.color_lens_outlined),
                  activeSwitchColor: primaryColor,
                  onToggle: (value) {
                    setState(() {
                      ConstantApp.enableColor = value;
                      Get.find<SharedPreferences>().remove('enableColor');
                      Get.find<SharedPreferences>().setBool('enableColor', value);
                      Get.find<InfoController>().updateHomePage();
                    });
                  },
                  initialValue: ConstantApp.enableColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:izo_captain/database/app_db.dart';

class AppDataBaseController extends GetxController {
  AppDataBaseController();
  late AppDataBase appDataBase;

  @override
  void onInit() {
    appDataBase = AppDataBase();
    super.onInit();
  }

  @override
  void onClose() {
    appDataBase.close();
    super.onClose();
  }
}


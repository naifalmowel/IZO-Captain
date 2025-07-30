

import 'package:get/get.dart';
import 'package:izo_captain/controllers/tax_controller.dart';

import '../models/tax_model.dart';

class AdminController extends GetxController{

  late List<TaxModel> taxes = [];
  RxList<TaxModel> taxesPlayer = RxList([]);

  Future<void> viewTax() async {
    taxes = await Get.find<TaxController>().getAllTaxes();
    taxesPlayer.value = taxes;
    update();
  }


}
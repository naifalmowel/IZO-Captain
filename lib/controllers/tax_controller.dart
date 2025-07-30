


import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/tax_model.dart';
import '../models/tax_setting.dart';
import '../server/dio_services.dart';

class TaxController extends GetxController{

  RxList<TaxSettingDrift> taxSetting = RxList([]);

  Future<void> getAllTaxesSetting() async {
    taxSetting.value = await getAllTaxesSettings();
    update();
  }

  Future<List<TaxSettingDrift>> getAllTaxesSettings() async {
    List<TaxSettingDrift> taxSetting = [];
    DioClient dio = DioClient();
    final response = await dio.getDio(path: '/taxSettingPos');
    if (response.statusCode == 200) {
      //  var list = response.data['purchase'];
      var data = jsonDecode(response.data);
      var list2 = data['taxSetting'];
      for (var i in list2) {
        taxSetting.add(TaxSettingDrift(
          id: i["id"],
          taxId: i["taxId"],
          every: i["every"],
          taxNumber: i["taxNumber"],
          taxType: i["taxType"],
          createBy: i["createBy"],
          createAt: DateFormat("yyyy-MM-dd HH:mm:ss").parse(i["createAt"]),
          fromPeriod1:
          i["fromPeriod1"] == "null" ? null : DateFormat("yyyy-MM-dd HH:mm:ss").parse(i["fromPeriod1"]),
          tillPeriod1:
          i["tillPeriod1"] == "null" ? null : DateFormat("yyyy-MM-dd HH:mm:ss").parse(i["tillPeriod1"]),
        ));
      }
    }
    return taxSetting;
  }

  Future<List<TaxModel>> getAllTaxes() async {
    List<TaxModel> tax = [];
    DioClient dio = DioClient();
    final response = await dio.getDio(path: '/taxPos');
    if (response.statusCode == 200) {
      //  var list = response.data['purchase'];
      var data = jsonDecode(response.data);
      var list2 = data['listTax'];
      for (var i in list2) {
        tax.add(TaxModel(
            id: i["id"],
            name: i["name"],
            taxValue: i["taxValue"],
            createdAt:
            DateFormat("yyyy-MM-dd HH:mm:ss").parse(i["createdAt"])));
      }
    }
    return tax;
  }

}
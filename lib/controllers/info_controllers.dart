import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/login/login.dart';
import '../utils/constant.dart';
import '/models/hall_model.dart';
import '/models/table_model.dart';
import '/server/dio_services.dart';

class InfoController extends GetxController {

  RxList<HallModel> halls = RxList([]);
  RxBool isLoading = false.obs;
  RxBool isLoadingCheck = false.obs;
  RxBool isE = false.obs;
  RxList badgeTakeaway = RxList([]);
  RxList badgeDelivery = RxList([]);
  RxList badgeTables = RxList([]);
  RxBool isDelivery = RxBool(false);
  RxBool weight = RxBool(false);
  RxBool price = RxBool(false);
  RxBool both = RxBool(false);
  RxBool isActive = RxBool(false);
  RxInt  balanceStart = RxInt(21);
  RxInt  startProduct = RxInt(21);
  RxInt  endProduct = RxInt(21);
  RxInt  startWeight = RxInt(21);
  RxInt  endWeight = RxInt(21);
  RxInt  startPrice = RxInt(21);
  RxInt  endPrice = RxInt(21);

  Future updateHomePage() async {
    isDelivery.value =
        Get.find<SharedPreferences>().getBool('delivery') ?? false;
    update();
  }

  Future<bool> getAllInformation() async {
    isLoading(true);
    if(ConstantApp.type == "guest"){
      halls.value = [
        HallModel(tables: [
          TableModel(
              number: "1",
              hall: "1",
              voidAmount: 100,
              cost: 100,
              waitCustomer: false,
              time: DateTime.now(),
              bookingTable: false,
              bookingDate: null,
              customerId: 1),
          TableModel(
              number: "2",
              hall: "1",
              voidAmount: 0,
              cost: 0,
              waitCustomer: false,
              time: DateTime.now(),
              bookingTable: false,
              bookingDate: null,
              customerId: 1),
        ],
            name: "Hall 1",
            id: 1,
            tableCount: 2, users: []),
        HallModel(tables: [
          TableModel(
              number: "1",
              hall: "0",
              voidAmount: 0,
              cost: 0,
              waitCustomer: false,
              time: DateTime.now(),
              bookingTable: false,
              bookingDate: null,
              customerId: 1),
        ],
            name: "Delivery",
            id: 0,
            tableCount: 2, users: []),
        HallModel(tables: [
          TableModel(
              number: "1",
              hall: "-1",
              voidAmount: 0,
              cost: 0,
              waitCustomer: false,
              time: DateTime.now(),
              bookingTable: false,
              bookingDate: null,
              customerId: 1),
        ],
            name: "Take Away",
            id: -1,
            tableCount: 2, users: []),
      ];
      isLoading(false);
      return true;
    }
    else{
      DioClient dio = DioClient();
      try {
        final response = await dio.getDio(path: '/info');
        if (response.statusCode == 200) {
          try {
            halls.clear();
            var data = jsonDecode(response.data);
            List list1 = jsonDecode(data['hall']);
            for (var i in list1) {
              List listTable = jsonDecode(i['tables']);
              List<TableModel> listT = [];
              for (var j in listTable) {
                listT.add(TableModel(
                    number: j['number'],
                    hall: j['hall'],
                    voidAmount: double.tryParse(j['amount']) ?? 0.0,
                    cost: double.tryParse(j['cost']) ?? 0.0,
                    waitCustomer: bool.tryParse(j['wait']) ?? false,
                    time: DateTime.tryParse(j['time']) ?? DateTime.now(),
                    bookingTable: bool.tryParse(j['booking']) ?? false,
                    bookingDate: DateTime.tryParse(j['booking-date']),
                    guestName: j['guest-name'],
                    guestMobile: j['guest-mobil'] ?? '',
                    guestNo: j['guestNo'] ?? '',
                    deliveryName: j['driver-name'],
                    formatNumber: j['format'],
                    customerId: int.tryParse(j['customerId']) ?? 0));
              }
                halls.add(HallModel(
                  tables: listT,
                  name: i["name"],
                  id: int.tryParse(i['id'].toString()) ?? 0,
                  tableCount: int.tryParse(i["table-count"]) ?? 0, users: List<String?>.from(i['users']??[]),
                ));

            }
            badgeTakeaway.clear();
            badgeDelivery.clear();
            badgeTables.clear();

            for (var j in halls) {
              for (var i in j.tables) {
                if (i.hall == '-1' && (i.cost != 0 || i.bookingTable!)) {
                  badgeTakeaway.add(i);
                } else if (i.hall == '0' && (i.cost != 0 || i.bookingTable!)) {
                  badgeDelivery.add(i);
                } else if ((int.tryParse(i.hall) ?? 0) > 0&&
                    (i.cost != 0 || i.bookingTable!)) {
                  badgeTables.add(i);
                }
              }
            }

            isLoading(false);

            update();
            return true;
          } catch (e) {
            debugPrint('Error ====>$e');
            isLoading(false);
            update();
            return false;
          }
        }
        else {
          debugPrint('Error getAllInformation');
          isLoading(false);
          update();
          return false;
        }
      } catch (e) {
        debugPrint('Error getAllInformation');
        isLoading(false);
        return false;
      }
    }
  }

  Future<bool> checkQR() async {
    try {
      DioClient dio = DioClient();
      final response = await dio.getDio(path: '/check');

      if (response.statusCode == 200) {
        isLoadingCheck(true);
        if (response.data.toString() == 'success') {
          isLoadingCheck(false);
          return true;
        } else {
          isLoadingCheck(false);
          return false;
        }
      } else {
        isLoadingCheck(false);
        return false;
      }
    } catch (e) {
      isLoadingCheck(false);
      return false;
    }
  }

  Future<bool> checkMobile() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (GetPlatform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      DioClient dio = DioClient();
      final response = await dio.postDio(
          path: '/check-mobile',
          data1: {"product": "${androidInfo.product + androidInfo.serialNumber}:Captain"});
      if (response.statusCode == 200) {
        if (response.data['message'] == 'success') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      var windowsInfo = await deviceInfo.windowsInfo;
      DioClient dio = DioClient();
      try {
        final response = await dio.postDio(
            path: '/check-mobile',
            data1: {"product": '${windowsInfo.deviceId}:Captain'});
        if (response.statusCode == 200) {
          if (response.data['message'] == 'success') {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }
  }

  Future<void> signUp() async {
    DioClient dio = DioClient();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(GetPlatform.isAndroid){
      var androidInfo = await deviceInfo.androidInfo;
      final data = {
        "name": '${androidInfo.brand} / ${androidInfo.product}',
        "device_id": '${androidInfo.product + androidInfo.serialNumber}:Captain',
        "date": DateTime.now().toString()
      };
      final response = await dio.postDio(path: '/signup', data1: data);
      if (response.statusCode == 200) {
        Get.offAll(() => const LoginPage());
        Get.snackbar(
          'Success',
          'The Server Is Connected !!',
          isDismissible: false,
          backgroundColor: Colors.green,
          margin:
          EdgeInsets.only(left: Get.width / 3, right: Get.width / 3, top: 20),
          icon: const Icon(Icons.check),

        );
      } else {
        Get.back();
      }
    }else{
      var androidInfo = await deviceInfo.windowsInfo;
      final data = {
        "name": '${androidInfo.computerName} / ${androidInfo.deviceId}',
        "device_id": "${androidInfo.deviceId}:Captain",
        "date": DateTime.now().toString()
      };
      final response = await dio.postDio(path: '/signup', data1: data);
      if (response.statusCode == 200) {
        Get.offAll(() => const LoginPage());
        Get.snackbar(
          'Success',
          'The Server Is Connected !!',
          isDismissible: false,
          backgroundColor: Colors.green,
          margin:
          EdgeInsets.only(left: Get.width / 3, right: Get.width / 3, top: 20),
          icon: const Icon(Icons.check),
        );
      } else {
        Get.back();
      }
    }

  }

  Future balanceSetting() async {
    DioClient dio = DioClient();
    try {
      final response = await dio.getDio(path: '/balance');

      if(response.statusCode == 200){

        var data = response.data;
        if((bool.tryParse(data['isActive'])??false)){
          isActive.value = true;
          weight.value = bool.tryParse(data['weight'])??false;
          price.value = bool.tryParse(data['price'])??false;
          both.value = bool.tryParse(data['both'])??false;
          balanceStart.value = int.tryParse(data['balanceStart'])??21;
          startProduct.value = int.tryParse(data['startProduct'])??3;
          endProduct.value = int.tryParse(data['endProduct'])??10;
          startWeight.value = int.tryParse(data['startWeight'])??11;
          endWeight.value = int.tryParse(data['endWeight'])??16;
          startPrice.value = int.tryParse(data['startPrice'])??17;
          endPrice.value = int.tryParse(data['endPrice'])??22;
          update();
        }else{
          isActive.value = false;
          update();
        }
      }
    } catch (e) {
      isActive.value = false;
      update();
      debugPrint("error balanceSetting $e");
    }
  }

}

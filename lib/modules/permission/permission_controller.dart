import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izo_captain/models/permission.dart';
import 'package:izo_captain/utils/constant.dart';

class PermissionController extends GetxController {
  RxBool viewSales = false.obs;
  RxBool addSales = false.obs;
  RxBool returnSales = false.obs;
  RxBool viewProduct = false.obs;
  RxBool addContact = false.obs;
  RxBool discount = false.obs;
  RxBool voidPer = false.obs;
  RxBool viewDriver = false.obs;
  RxBool takeAway = false.obs;
  RxBool delivery = false.obs;
  RxBool dineIn = false.obs;
  RxBool kitchen = false.obs;
  RxBool tableChange = false.obs;
  RxBool viewGuest = false.obs;

  late PermissionModel permissionModel;

  Future<void> getPermission() async {
    permissionModel = PermissionModel(
        id: 1,
        userId: 1,
        addContact: false,
        voidPer: false,
        viewDriver: false,
        takeAway: false,
        delivery: false,
        dineIn: false,
        kitchen: false,
        tableChange: false,
        viewGuest: false);
    addContact.value = permissionModel.addContact;
    voidPer.value = permissionModel.voidPer;
    viewDriver.value = permissionModel.viewDriver;
    takeAway.value = permissionModel.takeAway;
    delivery.value = permissionModel.delivery;
    dineIn.value = permissionModel.dineIn;
    kitchen.value = permissionModel.kitchen;
    tableChange.value = permissionModel.tableChange;
    viewGuest.value = permissionModel.viewGuest;
  }

  bool isPermission(
    bool per,
    BuildContext context,
  ) {
    if (per == false) {
      ConstantApp.showSnakeBarError(context, 'No Permission !!'.tr);
      return false;
    } else {
      return true;
    }
  }
}

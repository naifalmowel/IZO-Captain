import 'dart:convert';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:izo_captain/controllers/info_controllers.dart';
import 'package:izo_captain/models/customer_model.dart';
import 'package:izo_captain/models/driver_model.dart';
import 'package:izo_captain/models/order/order_model.dart';
import 'package:izo_captain/models/product/product_qty.dart';
import 'package:izo_captain/models/unit_model.dart';
import 'package:izo_captain/server/dio_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_db.dart';
import '../database/app_db_controller.dart';
import '../models/category/category_model.dart';
import '../models/product/product_model.dart';
import '../models/product/variable_product_model.dart';
import 'admin_controller.dart';
import 'tax_controller.dart';
import '../utils/constant.dart';

class OrderController extends GetxController {
  RxInt customerId = RxInt(0);
  RxInt orderWidth = RxInt(5);
  RxInt productWidth = RxInt(3);
  RxInt subWidth = RxInt(1);
  RxInt mainWidth = RxInt(1);
  RxInt productItem = RxInt(4);
  RxInt mainItem = RxInt(1);
  RxInt subItem = RxInt(1);
  RxBool showMain = RxBool(true);
  RxBool showSub = RxBool(true);
  RxBool obscure = false.obs;
  RxBool negative = false.obs;
  RxBool loadingOrders = RxBool(false);
  RxList<ProductQty> proQty = RxList();
  RxList<OrderItem> orders = <OrderItem>[].obs;
  RxList<OrderModel> tempOrder = RxList();
  RxString salesType = RxString('sales');
  RxList<OrderModel> order = RxList();
  RxList<UnitModel> units = RxList();
  late RxInt selected1 = 100.obs;
  late RxInt checkOrderList = RxInt(0);
  late RxDouble totalPrice = 0.0.obs;
  late OrderModel orderTemp;
  late RxDouble qty = 0.0.obs;
  TextEditingController? discountValue = TextEditingController();
  String type = "TakeAway";
  late RxBool keyboardVis = false.obs;
  late RxBool showUnit = false.obs;
  RxList<CustomerModel> customer = RxList();
  RxString customerName = RxString('');
  RxString voidReason = RxString('');
  RxString priceType = RxString('');
  RxList<ProductModel> products = RxList();
  RxList<ProductVariableModel> allVariable = RxList([]);
  RxList<ProductVariableModel> productsVariable = RxList([]);
  RxList<SubCategoryModel> subCategories = RxList([]);
  RxList<MainCategoryModel> mainCategory = RxList([]);
  RxList<SubCategoryModel> subCategoriesPlayer = RxList([]);
  RxList<MainCategoryModel> mainCategoryPlayer = RxList([]);
  RxList<ProductModel> productDataPlayer = RxList([]);
  var productsLoading = false.obs;
  RxInt orderNumber = 0.obs;
  var requstingBill = false.obs;
  RxInt selectDriver = RxInt(0);
  List<DriverModel> drivers = RxList([]);
  late String guest = 'Global';
  RxList<String> listGuest = RxList([]);
  RxBool enableGuests = false.obs;
  RxBool allChange = false.obs;
  RxBool guestChange = false.obs;
  RxBool singleChange = false.obs;
  late RxBool byMistake = RxBool(false);
  late RxBool changeHisMind = RxBool(false);
  late RxBool cold = RxBool(false);
  late RxBool delay = RxBool(false);
  late RxBool notLike = RxBool(false);

  late RxDouble priceWithOutVat = 0.0.obs;
  late RxDouble vat = 0.0.obs;
  RxDouble fTotal = RxDouble(0.0);
  RxDouble disAmount = RxDouble(0.0);
  RxDouble vatAfterDis = RxDouble(0.0);

  Map<String, IconData> icons = {
    "ban": FontAwesomeIcons.ban,
    "bowlFood": FontAwesomeIcons.bowlFood,
    "bowlRice": FontAwesomeIcons.bowlRice,
    "fastfood_outlined": Icons.fastfood_outlined,
    "burger": FontAwesomeIcons.burger,
    "hotdog": FontAwesomeIcons.hotdog,
    "pizzaSlice": FontAwesomeIcons.pizzaSlice,
    "breadSlice": FontAwesomeIcons.breadSlice,
    "cakeCandles": FontAwesomeIcons.cakeCandles,
    "cheese": FontAwesomeIcons.cheese,
    "candyCane": FontAwesomeIcons.candyCane,
    "cookie": FontAwesomeIcons.cookie,
    "iceCream": FontAwesomeIcons.iceCream,
    "fish": FontAwesomeIcons.fish,
    "shrimp": FontAwesomeIcons.shrimp,
    "appleWhole": FontAwesomeIcons.appleWhole,
    "wineBottle": FontAwesomeIcons.wineBottle,
    "wineGlass": FontAwesomeIcons.wineGlass,
    "mugHot": FontAwesomeIcons.mugHot,
    "emoji_food_beverage_rounded": Icons.emoji_food_beverage_rounded,
  };

  Map<String, IconData> iconsRetail = {
    "ban": FontAwesomeIcons.ban,
    "shopify": FontAwesomeIcons.shopify,
    "personDress": FontAwesomeIcons.personDress,
    "person": FontAwesomeIcons.person,
    "shirt": FontAwesomeIcons.shirt,
    "bagShopping": FontAwesomeIcons.bagShopping,
    "child": FontAwesomeIcons.child,
    "baby": FontAwesomeIcons.baby,
    "ring": FontAwesomeIcons.ring,
    "gifts": FontAwesomeIcons.gifts,
    "childDress": FontAwesomeIcons.childDress,
    "babyCarriage": FontAwesomeIcons.babyCarriage,
    "mitten": FontAwesomeIcons.mitten,
    "socks": FontAwesomeIcons.socks,
    "umbrella": FontAwesomeIcons.umbrella,
  };

  Map<String, IconData> iconsSalon = {
    "ban": FontAwesomeIcons.ban,
    "stethoscope": FontAwesomeIcons.stethoscope,
    "hospital": FontAwesomeIcons.hospital,
    "user-injured": FontAwesomeIcons.userInjured,
    "user-doctor": FontAwesomeIcons.userDoctor,
    "truck-medical": FontAwesomeIcons.truckMedical,
    "syringe": FontAwesomeIcons.syringe,
    "bandage": FontAwesomeIcons.bandage,
    "microscope": FontAwesomeIcons.microscope,
    "mask-face": FontAwesomeIcons.maskFace,
    "lungs-virus": FontAwesomeIcons.lungsVirus,
    "kit-medical": FontAwesomeIcons.kitMedical,
    "heart-pulse": FontAwesomeIcons.heartPulse,
    "suitcase-medical": FontAwesomeIcons.suitcaseMedical,
    "spray-can-sparkles": FontAwesomeIcons.sprayCanSparkles,
    "scissors": FontAwesomeIcons.scissors,
    "ruler-horizontal": FontAwesomeIcons.rulerHorizontal,
    "pump-soap": FontAwesomeIcons.pumpSoap,
    "cut": Icons.cut,
    "bedroom_child": Icons.bedroom_child,
    "bathroom": Icons.bathroom,
    "hot_tub": Icons.hot_tub,
    "description": Icons.description,
  };

  Future getProductQty() async {
    if (ConstantApp.type == "guest") {
      proQty.value = [
        ProductQty(proId: 1, variableId: 1, qty: 10, name: "name"),
        ProductQty(proId: 2, variableId: 2, qty: 10, name: "name"),
        ProductQty(proId: 3, variableId: 3, qty: 10, name: "name"),
      ];
    } else {
      DioClient dio = DioClient();
      proQty.clear();
      final response = await dio.getDio(path: '/product-qty');
      if (response.statusCode == 200) {
        var data = response.data;
        for (var i in data['product']) {
          proQty.add(ProductQty(
            proId: int.tryParse(i['proId']) ?? 0,
            variableId: int.tryParse(i['varId']) ?? 0,
            qty: double.tryParse(i['qty']) ?? 0.0,
            name: i['proName'],
          ));
        }
      }
    }
    update();
  }

  Future<void> getAllProducts() async {
    if (ConstantApp.type == "guest") {
      products.value = [
        ProductModel(
          id: 1,
          englishName: "product 1",
          arabicName: "منتج 1",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 2,
          englishName: "product 2",
          arabicName: "منتج 2",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 3,
          englishName: "product 3",
          arabicName: "منتج 3",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 4,
          englishName: "product 4",
          arabicName: "منتج 4",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 5,
          englishName: "product 5",
          arabicName: "منتج 5",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 6,
          englishName: "product 6",
          arabicName: "منتج 6",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 7,
          englishName: "product 7",
          arabicName: "منتج 7",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 8,
          englishName: "product 8",
          arabicName: "منتج 8",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 1,
          englishName: "product 9",
          arabicName: "منتج 9",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 2,
          englishName: "product 10",
          arabicName: "منتج 10",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 3,
          englishName: "product 11",
          arabicName: "منتج 11",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 4,
          englishName: "product 12",
          arabicName: "منتج 12",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 5,
          englishName: "product 13",
          arabicName: "منتج 13",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 6,
          englishName: "product 14",
          arabicName: "منتج 14",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 7,
          englishName: "product 15",
          arabicName: "منتج 15",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 8,
          englishName: "product 16",
          arabicName: "منتج 16",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
      ];
      mainCategory.value = [
        MainCategoryModel(
            id: 1,
            englishName: "main 1",
            arabicName: "منيو 1",
            image: Uint8List(0),
            color: "0xb3ec1c1c",
            icon: null),
        MainCategoryModel(
            id: 2,
            englishName: "main 2",
            arabicName: "منيو 2",
            image: Uint8List(0),
            color: "0xb3ec1c1c",
            icon: null),
      ];
      subCategories.value = [
        SubCategoryModel(
            id: 1,
            englishName: "sub 1",
            arabicName: "مجموعه فرعيه 1",
            image: Uint8List(0),
            color: "0xb3ec1c1c",
            mainId: 1,
            icon: null),
        SubCategoryModel(
            id: 2,
            englishName: "sub 2",
            arabicName: "مجموعه فرعيه 2",
            image: Uint8List(0),
            color: "0xb3ec1c1c",
            mainId: 2,
            icon: null),
      ];
      mainCategoryPlayer.value = mainCategory;
      subCategoriesPlayer.value = subCategories;
      productDataPlayer.value = products;
    } else {
      DioClient dio = DioClient();
      try {
        final response = await dio.getDio(path: '/product');
        if (response.statusCode == 200) {
          var data = response.data;
          List allProduct = data["product"];
          List allVar = data["variable"];
          List allMain = data['main_cat'];
          List allSub = data['sub_cat'];
          products.clear();
          allVariable.clear();
          subCategories.clear();
          mainCategory.clear();
          for (var i in allProduct) {
            products.add(ProductModel(
              id: int.tryParse(i['id']) ?? 0,
              englishName: i['englishName'],
              arabicName: (i['arabicName'] == null || i['arabicName'] =="") ? i['englishName']: i['arabicName'],
              image: Uint8List.fromList(List<int>.from(i['image'] as List)),
              price: i['price'],
              price2: i['price2'],
              price3: i['price3'],
              description: i['description'],
              code: i['code'],
              subId: i['subId'],
              mainId: i['mainId'],
              type: i['type'],
              unit: int.tryParse(i['unit']) ?? 0,
              unit2: int.tryParse(i['unit2']) ?? 0,
              unit3: int.tryParse(i['unit3']) ?? 0,
              barcode: i['barcode'],
              barcode2: i['barcode2'],
              barcode3: i['barcode3'],
              variableId: int.tryParse(i['variableId']) ?? 0,
              vat: double.tryParse(i['vat']) ?? 0.0,
              qty: double.tryParse(i['qty']) ?? 0.0,
              vatId: int.tryParse(i['vatId']) ?? 0,
              recipeId: int.tryParse(i['recipeId']) ?? 0,
              forSale: bool.tryParse(i['forSale']) ?? false,
              colorProduct: i['colorProduct'],
              wholePrice: double.tryParse(i['wholePrice']) ?? 0.0,
              wholePrice2: double.tryParse(i['wholePrice2']) ?? 0.0,
              wholePrice3: double.tryParse(i['wholePrice3']) ?? 0.0,
              minPrice: double.tryParse(i['minPrice']) ?? 0.0,
              minPrice2: double.tryParse(i['minPrice2']) ?? 0.0,
              minPrice3: double.tryParse(i['minPrice3']) ?? 0.0,
              maxPrice: double.tryParse(i['maxPrice']) ?? 0.0,
              maxPrice2: double.tryParse(i['maxPrice2']) ?? 0.0,
              maxPrice3: double.tryParse(i['maxPrice3']) ?? 0.0,
              costPrice: double.tryParse(i['costPrice']) ?? 0.0,
              costPrice2: double.tryParse(i['costPrice2']) ?? 0.0,
              costPrice3: double.tryParse(i['costPrice3']) ?? 0.0,
            ));
          }
          for (var i in allVar) {
            allVariable.add(ProductVariableModel(
              id: int.tryParse(i['id']) ?? 0,
              proId: int.tryParse(i['proId']) ?? 0,
              image: Uint8List.fromList(List<int>.from(i['image'] as List)),
              price: double.tryParse(i['price']) ?? 0.0,
              code: i['code'],
              recipeId: int.tryParse(i['recipeId']) ?? 0,
              size: i['size'],
              color: i['color'],
              barcode: i['barcode'],
              name: i['name'],
              date: DateTime.tryParse(i['date']) ?? DateTime.now(),
            ));
          }
          for (var i in allMain) {
            mainCategory.add(MainCategoryModel(
              id: int.tryParse(i['id']) ?? 0,
              englishName: i['englishName'],
              arabicName: (i['arabicName'] == null || i['arabicName'] == "")? i['englishName']:i['arabicName'],
              color: i['color'],
              image: Uint8List.fromList(List<int>.from(i['image'] as List)),
              icon: i['icon'],
              showInPos: i['showInPos'],
            ));
          }
          for (var i in allSub) {
            subCategories.add(SubCategoryModel(
              id: int.tryParse(i['id']) ?? 0,
              englishName: i['englishName'],
              arabicName: (i['arabicName'] == null || i['arabicName'] == "")?i['englishName']:i['arabicName'],
              color: i['color'],
              image: Uint8List.fromList(List<int>.from(i['image'] as List)),
              mainId: int.tryParse(i['mainId']) ?? 0,
              icon: i['icon'],
            ));
          }

          ///ToDO : change here 12/01/2025
          mainCategoryPlayer.value =
              mainCategory.where((p0) => p0.showInPos!).toList();
          subCategoriesPlayer.value = subCategories;
          productDataPlayer.value = products;
        }
      } catch (e) {
        print("error");
      }
    }
    update();
  }

  Future getVariable(int id) async {
    productsVariable.value = allVariable.where((p0) => p0.proId == id).toList();

    update();
  }

  Future<void> getAllOrders(
      {required String hall, required String table}) async {
    if (ConstantApp.type == "guest") {
      order.value = [
        OrderModel(
            name: "1",
            quantity: 2,
            price: 30,
            itemId: 1,
            createdAt: DateTime.now(),
            totalPrice: 30,
            guest: "guest",
            table: "1",
            hall: "1",
            ident: "alaa",
            note: "note",
            unitId: 1,
            vatId: 0,
            catId: "1",
            arabicName: '2'),
        OrderModel(
            name: "2",
            quantity: 2,
            price: 30,
            itemId: 2,
            createdAt: DateTime.now(),
            totalPrice: 30,
            guest: "guest",
            table: "1",
            hall: "1",
            ident: "alaa",
            note: "note",
            unitId: 1,
            vatId: 0,
            catId: "1",
            arabicName: '2'),
        OrderModel(
            name: "3",
            quantity: 3,
            price: 45,
            itemId: 3,
            createdAt: DateTime.now(),
            totalPrice: 30,
            guest: "guest",
            table: "1",
            hall: "1",
            ident: "alaa",
            note: "note",
            unitId: 1,
            vatId: 0,
            catId: "1",
            arabicName: '2'),
      ];
      units.value = [
        UnitModel(
            id: 1,
            name: "pieces",
            arabicName: "pieces",
            qty: 1,
            source: 0,
            acceptsDecimal: false,
            createdAt: DateTime.now())
      ];
      orders.value = [
        OrderItem(id: 1, orderDate: DateTime.now(), orders: order),
      ];
      customer.value = [
        CustomerModel(
            id: 1,
            firstName: "علاء",
            lastName: "Alaa",
            businessName: "Alaa",
            code: "code",
            address: ["Dubai"],
            mobileList: ["25556556"],
            city: "Dubai",
            email: "alaa@gmail.com",
            type: "Customer",
            createAt: DateTime.now()),
        CustomerModel(
            id: 2,
            firstName: "naif",
            lastName: "naif",
            businessName: "naif",
            code: "code",
            address: ["Dubai"],
            mobileList: ["25556556"],
            city: "Dubai",
            email: "naif@gmail.com",
            type: "Customer",
            createAt: DateTime.now()),
      ];
      totalPrice.value = 155;
      qty.value = 7;
    } else {
      DioClient dio = DioClient();
      order.clear();
      try {
        final response = await dio
            .postDio(path: '/orderTH', data1: {"hall": hall, "table": table});
        if (response.statusCode == 200) {
          var data = response.data;
          List list = data['order'];
          for (var i in list) {
            order.add(OrderModel(
              id: int.tryParse(i['id']) ?? 0,
              name: i['name'],
              quantity: double.tryParse(i['quantity']) ?? 0.0,
              price: double.tryParse(i['price']) ?? 0.0,
              itemId: int.tryParse(i['itemId']) ?? 0,
              createdAt: DateTime.tryParse(i['createdAt']) ?? DateTime.now(),
              totalPrice: double.tryParse(i['totalPrice']) ?? 0.0,
              serial: int.tryParse(i['serial']) ?? 0,
              variableId: int.tryParse(i['variableId']) ?? 0,
              recipeId: int.tryParse(i['recipeId']) ?? 0,
              vatId: int.tryParse(i['vatId']) ?? 0,
              unitId: int.tryParse(i['unitId']) ?? 0,
              guest: i['guest'],
              table: i['table'],
              hall: i['hall'],
              ident: i['ident'],
              note: i['note'],
              billNum: i['billNum'],
              productType: i['productType'],
              catId: i['catId'],
              salesType: i['salesType'],
              employeeId: int.tryParse(i['employeeId'] ?? '0') ?? 0,
              arabicName: i['arabicName'],
            ));
          }
          update();
        }
      } catch (e) {
        print('error getAllOrders');
      }
    }
  }

  Future getOrderForTable(String hall, String table) async {
    loadingOrders(true);
    if (order.isEmpty) {
      loadingOrders(false);
      orders.clear();
      totalPrice.value = 0.0;
      qty.value = 0.0;
      salesType.value = 'sales';
      return;
    }
    List<int?> temp = [];
    for (var i in order) {
      if (!temp.contains(i.serial)) {
        temp.add(i.serial);
      }
    }
    orders.clear();
    for (var i in temp) {
      var d = order.firstWhere((element) => element.serial == i);
      orders.add(OrderItem(
        id: i!,
        orderDate: d.createdAt,
        orders: order.where((element) => element.serial == i).map((e) {
          return OrderModel(
              id: e.id,
              name: e.name,
              quantity: e.quantity,
              price: e.price,
              itemId: e.itemId,
              createdAt: e.createdAt,
              totalPrice: e.totalPrice,
              guest: e.guest,
              table: e.table,
              hall: e.hall,
              ident: e.ident,
              note: e.note,
              unitId: e.unitId,
              vatId: e.vatId,
              billNum: e.billNum,
              serial: e.serial,
              variableId: e.variableId,
              recipeId: e.recipeId,
              productType: e.productType,
              salesType: e.salesType,
              employeeId: e.employeeId,
              catId: e.catId,
              arabicName: e.arabicName);
        }).toList(),
      ));
    }
    update();
    totalPrice.value = 0.0;
    qty.value = 0.0;
    for (var i in order) {
      qty.value += i.quantity;
      totalPrice.value += (i.quantity * i.price);
    }
    salesType.value =
        (order.isEmpty ? 'sales' : order.last.salesType) ?? 'sales';
    loadingOrders(false);
    update();
  }

  void filterMainPlayer(String playerName) {
    List<MainCategoryModel> results = [];
    if (playerName.isEmpty) {
      results = mainCategory;
    } else {
      results = mainCategory
          .where((element) => element.englishName
              .toString()
              .toLowerCase()
              .contains(playerName.toLowerCase()))
          .toList();
    }
    mainCategoryPlayer.value = results;
    update();
  }

  Future<void> fillMain(int mainId) async {
    subCategoriesPlayer.value =
        subCategories.where((p0) => p0.mainId == mainId).toList();
    productDataPlayer.value = products
        .where((p0) => p0.type != 'raw' && p0.mainId == mainId.toString())
        .toList();
    update();
  }

  Future<void> fillProduct(int subId) async {
    productDataPlayer.value = products
        .where((p0) => p0.type != 'raw' && p0.subId == subId.toString())
        .toList();
    update();
  }

  void filterSubPlayer(String playerName) {
    List<SubCategoryModel> results = [];
    if (playerName.isEmpty) {
      results = subCategories;
    } else {
      results = subCategories
          .where((element) => element.englishName
              .toString()
              .toLowerCase()
              .contains(playerName.toLowerCase()))
          .toList();
    }
    subCategoriesPlayer.value = results;
    update();
  }

  void filterProductPlayer(String playerName) {
    List<ProductModel> results = [];
    if (playerName.isEmpty) {
      results = products.where((p0) => p0.type != 'raw').toList();
    } else {
      results = products
          .where((p0) => p0.type != 'raw')
          .toList()
          .where((element) =>
              element.englishName
                  .toString()
                  .toLowerCase()
                  .contains(playerName.toLowerCase()) ||
              element.arabicName
                  .toString()
                  .toLowerCase()
                  .contains(playerName.toLowerCase()))
          .toList();
    }
    productDataPlayer.value = results;
    update();
  }

  Future<void> getCustomerOrderNumber() async {
    DioClient dio = DioClient();
    try {
      final response = await dio.getDio(path: '/customer');
      if (response.statusCode == 200) {
        customer.clear();
        units.clear();
        var data = response.data;
        List customers = data['customer'];
        List unit = data['units'];
        orderNumber.value = int.tryParse(data['order_no']) ?? 0;
        for (var i in customers) {
          customer.add(
            CustomerModel(
              id: int.tryParse(i['id']) ?? 0,
              firstName: i['firstName'],
              lastName: i['lastName'],
              businessName: i['businessName'],
              code: i['code'],
              address: List<String>.from(i['address']),
              mobileList: List<String>.from(i['mobileList']),
              city: i['city'],
              email: i['email'],
              type: i['type'],
              createAt: DateTime.tryParse(i['type']) ?? DateTime.now(),
            ),
          );
        }
        for (var i in unit) {
          units.add(
            UnitModel(
              id: int.tryParse(i['id']) ?? 0,
              name: i['name'],
              arabicName: i['arabicName'],
              qty: i['qty'],
              source: int.tryParse(i['source']) ?? 0,
              acceptsDecimal: bool.tryParse(i['acceptsDecimal']) ?? false,
              createdAt: DateTime.tryParse(i['createdAt']) ?? DateTime.now(),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("error getCustomerOrderNumber$e");
    }
    update();
  }

  Future<void> addProductFromBarcode(
    String barcode,
    BuildContext context,
    String hall,
    String table,
  ) async {
    await getProductQty();
    var controller = Get.find<InfoController>();
    await controller.balanceSetting();
    List<double> list = [];
    for (var i in tempOrder) {
      list.add(i.quantity);
    }
    var allProduct = products;
    var allVar = allVariable;
    String weightBarcode = '';
    String priceBarcode = '';
    if (controller.isActive.value) {
      if ((controller.isActive.value &&
          barcode.startsWith(controller.balanceStart.value.toString()))) {
        String productBarcode = barcode.substring(
            controller.startProduct.value - 1, controller.endProduct.value - 1);
        if (controller.both.value) {
          weightBarcode = barcode.substring(
              controller.startWeight.value - 2, controller.endWeight.value - 2);
          priceBarcode = barcode.substring(
              controller.startPrice.value - 3, controller.endPrice.value - 3);
        } else if (controller.weight.value) {
          weightBarcode = barcode.substring(
              controller.startWeight.value - 2, controller.endWeight.value - 2);
        } else if (controller.price.value) {
          priceBarcode = barcode.substring(
              controller.startPrice.value - 2, controller.endPrice.value - 2);
        } else {
          weightBarcode = '';
          priceBarcode = '';
        }
        for (var i in allProduct) {
          if (i.barcode == productBarcode) {
            if (i.type != 'variable') {
              double qty = proQty
                  .where((element) =>
                      element.proId == i.id && element.variableId == 0)
                  .toList()
                  .last
                  .qty;
              for (var j in tempOrder) {
                if (j.itemId == i.id! && j.variableId == 0) {
                  qty -= j.quantity;
                }
              }
              if (negative.value ? true : qty > 0) {
                await addOrder(i, 0, double.tryParse(weightBarcode),
                    double.tryParse(priceBarcode), hall, table);
                break;
              }
            }
          }
        }
        for (var j in allVar) {
          if (j.barcode == productBarcode) {
            double qty = proQty
                .where((element) =>
                    element.proId == j.proId && element.variableId == j.id)
                .toList()
                .last
                .qty;
            for (var i in tempOrder) {
              if (i.itemId == j.proId! && i.variableId == j.id) {
                qty -= i.quantity;
              }
            }
            if ((negative.value ? true : qty > 0)) {
              var i = allProduct.firstWhere((element) => element.id == j.proId);
              await addOrder(i, j.id!, double.tryParse(weightBarcode),
                  double.tryParse(priceBarcode), hall, table);
              break;
            }
          }
        }
      } else {
        for (var i in allProduct) {
          if (i.barcode == barcode) {
            if (i.type != 'variable') {
              double qty = proQty
                  .where((element) =>
                      element.proId == i.id && element.variableId == 0)
                  .toList()
                  .last
                  .qty;
              for (var j in tempOrder) {
                if (j.itemId == i.id! && j.variableId == 0) {
                  qty -= j.quantity;
                }
              }
              if (negative.value ? true : qty > 0) {
                await addOrder(i, 0, double.tryParse(weightBarcode),
                    double.tryParse(priceBarcode), hall, table);
                break;
              }
            }
          }
        }
        for (var j in allVar) {
          if (j.barcode == barcode) {
            double qty = proQty
                .where((element) =>
                    element.proId == j.proId && element.variableId == j.id)
                .toList()
                .last
                .qty;
            for (var i in tempOrder) {
              if (i.itemId == j.proId! && i.variableId == j.id) {
                qty -= i.quantity;
              }
            }
            if ((negative.value ? true : qty > 0)) {
              var i = allProduct.firstWhere((element) => element.id == j.proId);
              await addOrder(i, j.id!, double.tryParse(weightBarcode),
                  double.tryParse(priceBarcode), hall, table);
              break;
            }
          }
        }
      }
    } else {
      for (var i in allProduct) {
        if (i.barcode == barcode) {
          if (i.type != 'variable') {
            double qty = proQty
                .where((element) =>
                    element.proId == i.id && element.variableId == 0)
                .toList()
                .last
                .qty;
            for (var j in tempOrder) {
              if (j.itemId == i.id! && j.variableId == 0) {
                qty -= j.quantity;
              }
            }
            if (negative.value ? true : qty > 0) {
              await addOrder(i, 0, double.tryParse(weightBarcode),
                  double.tryParse(priceBarcode), hall, table);
              break;
            }
          }
        }
      }
      for (var j in allVar) {
        if (j.barcode == barcode) {
          double qty = proQty
              .where((element) =>
                  element.proId == j.proId && element.variableId == j.id)
              .toList()
              .last
              .qty;
          for (var i in tempOrder) {
            if (i.itemId == j.proId! && i.variableId == j.id) {
              qty -= i.quantity;
            }
          }
          if ((negative.value ? true : qty > 0)) {
            var i = allProduct.firstWhere((element) => element.id == j.proId);
            await addOrder(i, j.id!, double.tryParse(weightBarcode),
                double.tryParse(priceBarcode), hall, table);
            break;
          }
        }
      }
    }
    if (list.equals(tempOrder.map((element) => element.quantity).toList())) {
      if (!context.mounted) return;
      ConstantApp.showSnakeBarError(context, 'Not Found !!');
      return;
    }
  }

  Future<void> addOrder(
    ProductModel product,
    int variableId,
    double? qtyBarcode,
    double? priceBarcode,
    String hall,
    String table,
  ) async {
    for (var i in customer) {
      if (customerId.value == i.id) {
        customerName.value = i.businessName;
      }
    }
    String varName = '';
    double price = 0.0;
    int recipeVarId = 0;
    for (var i in allVariable) {
      if (i.id == variableId) {
        varName = i.name!;
        price = i.price!;
        recipeVarId = i.recipeId!;
      }
    }
    final prefs = await SharedPreferences.getInstance();
    var temp;
    if (tempOrder.isEmpty) {
      totalPrice.value = 0;
      qty.value = 0;
    }
    for (var x in tempOrder) {
      if (x.itemId == product.id &&
          x.guest == guest &&
          x.note == '' &&
          x.variableId == variableId) {
        temp = x;
        break;
      }
    }
    bool isCumulatively =
        Get.find<SharedPreferences>().getBool('Cumulatively') ?? false;
    var index = tempOrder.indexOf(temp);
    if (isCumulatively && index != -1) {
      add(index, 'i', qtyBarcode);
    } else {
      qty.value += qtyBarcode ?? 1;
      totalPrice.value += priceBarcode ??
          (variableId == 0 ? double.parse(product.price!) : price);
      tempOrder.add(OrderModel(
        name: variableId == 0
            ? product.englishName!
            : '${product.englishName!}/$varName',
        quantity: qtyBarcode ?? 1,
        price: priceBarcode != null && qtyBarcode != null
            ? priceBarcode / qtyBarcode
            : (variableId == 0 ? double.parse(product.price!) : price),
        itemId: product.id!,
        createdAt: DateTime.now(),
        totalPrice: priceBarcode ??
            (variableId == 0 ? double.parse(product.price!) : price),
        serial: orderNumber.value,
        guest: guest,
        table: table,
        hall: hall,
        ident: prefs.getString('name')!,
        note: '',
        variableId: variableId,
        productType: product.type,
        recipeId: variableId == 0 ? product.recipeId : recipeVarId,
        vatId: product.vatId,
        unitId: product.unit,
        catId: product.subId,
        wholePrice: product.wholePrice,
        wholePrice2: product.wholePrice2,
        wholePrice3: product.wholePrice3,
        minPrice: product.minPrice,
        minPrice2: product.minPrice2,
        minPrice3: product.minPrice3,
        maxPrice: product.maxPrice,
        maxPrice2: product.maxPrice2,
        maxPrice3: product.maxPrice3,
        costPrice: product.costPrice,
        costPrice2: product.costPrice2,
        costPrice3: product.costPrice3,
        firstPrice: priceBarcode != null && qtyBarcode != null
            ? priceBarcode / qtyBarcode
            : (variableId == 0 ? double.parse(product.price!) : price),
        arabicName: variableId == 0
            ? product.arabicName ?? ''
            : '${product.englishName ?? ''}/$varName',
      ));
    }
    update();
  }

  void add(
    int index,
    String quantity,
    double? qtyBar,
  ) {
    if (quantity == 'i') {
      tempOrder[index].quantity += (qtyBar ?? 1);
      tempOrder[index].totalPrice =
          tempOrder[index].price * tempOrder[index].quantity;
      totalPrice.value +=
          tempOrder[index].totalPrice / tempOrder[index].quantity;
      qty.value += tempOrder[index].quantity;
    } else {
      tempOrder[index].quantity = double.parse(quantity);
      tempOrder[index].totalPrice =
          tempOrder[index].price * tempOrder[index].quantity;
      totalPrice.value = 0;
      qty.value = 0;
      for (var i in tempOrder) {
        totalPrice.value += (i.price * i.quantity);
        qty.value += i.quantity;
      }
    }
    update();
  }

  Future sendOrder() async {
    loadingOrders(true);
    DioClient dio = DioClient();
    List<Map<String, dynamic>> list = [];
    for (var i in tempOrder) {
      list.add({
        "name": i.name,
        "arabicName": i.arabicName,
        "quantity": i.quantity.toString(),
        "price": i.price.toString(),
        "itemId": i.itemId.toString(),
        "createdAt": i.createdAt.toString(),
        "totalPrice": i.totalPrice.toString(),
        "serial": i.serial.toString(),
        "variableId": i.variableId.toString(),
        "recipeId": i.recipeId.toString(),
        "vatId": i.vatId.toString(),
        "unitId": i.unitId.toString(),
        "guest": i.guest,
        "table": i.table,
        "hall": i.hall,
        "ident": i.ident,
        "note": i.note,
        "billNum": i.billNum.toString(),
        "productType": i.productType,
        "catId": i.catId,
        "employeeId": i.employeeId.toString(),
        "commission": i.commission.toString()
      });
    }

    Map<String, dynamic> data1 = {
      "temp": jsonEncode(list),
      "customer_id": customerId.value.toString(),
      "total": totalPrice.value.toString(),
      "salesType": salesType.value.toString(),
    };
    final response = await dio.postDio(path: '/send-order', data1: data1);
    if (response.statusCode == 200) {
      tempOrder.clear();
    }
    loadingOrders(false);
    update();
  }

  Future voidOrder(
      {required OrderModel order,
      required String reason,
      required double qty1}) async {
    loadingOrders(true);
    DioClient dio = DioClient();
    Map<String, dynamic> data1 = {
      "id": order.id.toString(),
      "name": order.name,
      "arabicName": order.arabicName,
      "quantity": order.quantity.toString(),
      "price": order.price.toString(),
      "itemId": order.itemId.toString(),
      "createdAt": order.createdAt.toString(),
      "totalPrice": order.totalPrice.toString(),
      "serial": order.serial.toString(),
      "variableId": order.variableId.toString(),
      "recipeId": order.recipeId.toString(),
      "vatId": order.vatId.toString(),
      "unitId": order.unitId.toString(),
      "guest": order.guest,
      "table": order.table,
      "hall": order.hall,
      "ident": order.ident,
      "note": order.note,
      "billNum": order.billNum.toString(),
      "productType": order.productType,
      "catId": order.catId,
      "reason": reason,
      "qty": qty1.toString(),
      "salesType": order.salesType.toString(),
      "cashier": Get.find<SharedPreferences>().getString('name') ?? ''
    };
    final response = await dio.postDio(path: '/void', data1: data1);
    if (response.statusCode == 200) {}
    loadingOrders(false);
    update();
  }

  Future<void> getDetails() async {
    await Get.find<AdminController>().viewTax();
    totalPrice.value = 0;
    priceWithOutVat.value = 0;
    vat.value = 0;
    fTotal.value = 0;
    qty.value = 0.0;
    if (orders.isEmpty) {
      totalPrice.value = 0;
      priceWithOutVat.value = 0;
      vat.value = 0;
      fTotal.value = 0.0;
    } else {
      for (var i in orders) {
        for (var j in i.orders) {
          totalPrice.value += (j.quantity * j.price);
          qty.value += j.quantity;
          var tax = j.vatId == 0
              ? 0
              : Get.find<AdminController>()
                      .taxes
                      .firstWhere((element) => element.id == j.vatId)
                      .taxValue ??
                  0;
          var taxType = Get.find<TaxController>().taxSetting.isEmpty
              ? ''
              : Get.find<TaxController>().taxSetting.last.taxType;
          if (taxType == 'inc') {
            priceWithOutVat.value += (j.quantity * j.price * 100 / (100 + tax));
          } else {
            priceWithOutVat.value += (j.quantity * j.price);
          }
        }
      }
      if (disAmount.value == 0) {
        vat.value = (totalPrice.value - priceWithOutVat.value);
        fTotal.value = totalPrice.value;
      } else {
        vat.value = vatAfterDis.value;
        fTotal.value =
            vatAfterDis.value + (priceWithOutVat.value - disAmount.value);
      }
    }
    print(vat);
    update();
  }

  Future<String> billRequest({
    required String address,
    required String customerNo,
    required String hall,
    required String table,
    required double total,
  }) async {
    loadingOrders(true);

    await getDetails();

    DioClient dio = DioClient();

    Map<String, dynamic> data1 = {
      "addressCustomer": address,
      "customerNumber": customerNo,
      "hall": hall,
      "table": table,
      "salesType": salesType.value,
      "customer": customerId.value.toString(),
      "total": total.toString(),
      "driver": '0',
      "totalPrice": totalPrice.value.toString(),
      "vat": vat.value,
    };

    try {
      final response = await dio.postDio(path: '/bill-request', data1: data1);
      if (response.statusCode == 200) {
        loadingOrders(false);
        requstingBill(true);
        update();
        return 'Success';
      } else {
        loadingOrders(false);
        update();
        return 'Error';
      }
    } catch (e) {
      loadingOrders(false);
      update();
      return 'Error';
    }
  }

  Future<String> addCustomer({
    required String firstName,
    required String busName,
    required String address,
    required String mobile,
  }) async {
    DioClient dio = DioClient();
    final data1 = {
      "firstName": firstName,
      "busName": busName,
      "address": address,
      "mobile": mobile,
    };
    try {
      final response = await dio.postDio(path: '/add-customer', data1: data1);
      if (response.statusCode == 200) {
        return 'Success';
      } else {
        return 'Error';
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<void> updateOrderSetting(PosSettingData acc) async {
    Get.find<AppDataBaseController>().appDataBase.updatePosSetting(acc);
    getOrderSetting();
  }

  Future<void> getOrderSetting() async {
    PosSettingData pos =
        await Get.find<AppDataBaseController>().appDataBase.getPosSetting();
    orderWidth.value = pos.orderW!;
    productWidth.value = pos.productW!;
    subWidth.value = pos.subW!;
    mainWidth.value = pos.mainW!;
    productItem.value = pos.productItem!;
    mainItem.value = pos.mainItem!;
    subItem.value = pos.subItem!;
    showMain.value = pos.showMain!;
    showSub.value = pos.showSub!;
    update();
  }

  Future<double> checkQty({required int id, required int variableId}) async {
    DioClient dio = DioClient();
    try {
      var data1 = {
        "id": id.toString(),
        "variable_id": variableId.toString(),
      };
      final response = await dio.postDio(path: '/check-qty', data1: data1);
      if (response.statusCode == 200) {
        var data = response.data;

        negative.value = bool.tryParse(data['negative_sale']) ?? false;
        update();
        return double.tryParse(data['qty']) ?? 0;
      }
    } catch (e) {
      debugPrint("$e");
      return 0.0;
    }
    return 0.0;
  }

  Future<String> addNewAddressMobile(
      {required int id,
      required String address,
      required String mobile}) async {
    DioClient dio = DioClient();
    try {
      var data1 = {
        "id": id.toString(),
        "address": address,
        "mobile": mobile,
      };
      final response = await dio.postDio(path: '/address-mobile', data1: data1);
      if (response.statusCode == 200) {
        return 'Success';
      } else {
        return 'Error';
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> updatePrice({
    required int id,
    required double price,
    required double total,
    required String hall,
    required String table,
  }) async {
    var data = {
      "id": id.toString(),
      "price": price.toString(),
      "total": total.toString(),
      "hall": hall,
      "table": table,
    };
    DioClient dio = DioClient();
    try {
      final response = await dio.postDio(path: '/update-price', data1: data);
      if (response.statusCode == 200) {
        if (response.data['message'] == 'Success') {
          return 'Success';
        } else {
          return 'Error';
        }
      } else {
        return 'Error';
      }
    } catch (e) {
      return 'Error';
    }
  }
}

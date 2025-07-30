import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:izo_captain/models/customer_model.dart';
import 'package:izo_captain/models/product/product_model.dart';
import 'package:izo_captain/modules/order_view/widget/custom_dialog_pos_setting.dart';
import 'package:izo_captain/modules/order_view/widget/grid_item.dart';
import 'package:izo_captain/modules/order_view/widget/order_item.dart';
import 'package:izo_captain/modules/order_view/widget/temp_order_items.dart';
import 'package:izo_captain/server/dio_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import '../../controllers/info_controllers.dart';
import '../../controllers/internet_check_controller.dart';
import '../../controllers/tables_controller.dart';
import '../../global_widgets/custom_app_button.dart';
import '../../global_widgets/custom_clock.dart';
import '../../global_widgets/custom_drop_down_button.dart';
import '../../global_widgets/custom_text_field.dart';
import '../../global_widgets/drop_down_button_customers.dart';
import '../../global_widgets/drop_down_unit.dart';
import '../../global_widgets/keyboard.dart';
import '../../global_widgets/loader.dart';
import '../../models/table_model.dart';
import '../../models/unit_model.dart';
import '../../utils/Theme/colors.dart';
import '../../utils/constant.dart';
import '../../utils/scaled_dimensions.dart';
import '../permission/permission_controller.dart';
import '../setting/controller/setting_controller.dart';
import '../widget/no_internet_widget.dart';
import '../../controllers/order_controller.dart';

class OrderViewW extends StatefulWidget {
  const OrderViewW({
    super.key,
    required this.hall,
    required this.table,
    required this.customerId,
    required this.billRequest,
  });

  final String hall;
  final String table;
  final int customerId;
  final bool billRequest;

  @override
  State<OrderViewW> createState() => _OrderViewWState();
}

class _OrderViewWState extends State<OrderViewW> with WindowListener {
  var controller = Get.find<OrderController>();
  var controller1 = Get.find<PermissionController>();
  var infoController = Get.find<InfoController>();
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  int val = 1;
  var focusNode = FocusNode();
  var barcodeFN = FocusNode();
  TextEditingController numController = TextEditingController();
  TextEditingController deliveryManController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController busNameController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController mobileTextEditing = TextEditingController();
  TextEditingController temp = TextEditingController();
  TextEditingController temp1 = TextEditingController();
  TextEditingController quantityVoidController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  TextEditingController textEditingController3 = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController guestNameController = TextEditingController();
  TextEditingController newAddressController = TextEditingController();
  TextEditingController newMobileController = TextEditingController();
  TextEditingController noteOrderController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController password = TextEditingController();
  late TextEditingController storeTextEditingController =
      TextEditingController();
  int section = 1;
  bool show = false;
  List<bool> isDecimal = [];
  String addressCustomer = "";
  String? customerNumber;
  double width = 3;
  String noteOrder = "";
  int storeId = ConstantApp.storeId;
  int userId = 1;
  bool negative =
      Get.find<SharedPreferences>().getBool('negativeSelling') ?? false;

  String hallName = "";
  bool isClose = true;
  String cashierName = '';
  @override
  void initState() {
    controller.tempOrder.clear();
    controller.enableGuests(
        Get.find<SharedPreferences>().getBool('enableGuests') ?? false);
    controller
        .showUnit(Get.find<SharedPreferences>().getBool('showUnit') ?? false);
    initTableName();
    controller.customerId.value =
        widget.customerId == 0 ? 1 : widget.customerId;
    storeId = ConstantApp.storeId;
    controller.getOrderSetting();
    controller.selected1.value = 100;
    controller.requstingBill.value = widget.billRequest;
    controller.priceType.value = '';
    controller.listGuest.value =
        Get.find<SharedPreferences>().getStringList('listGuest') ?? ['Global'];
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
    cashierName = Get.find<SharedPreferences>().getString('name')??'';
    super.initState();
  }

  @override
  void dispose() {
    newAddressController.dispose();
    noteOrderController.dispose();
    barcodeController.dispose();
    barcodeFN.dispose();
    password.dispose();
    windowManager.removeListener(this);
    windowManager.setPreventClose(false);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      if (!context.mounted) return;
      Get.dialog(AlertDialog(
        title: Text('Are you sure you want to close this App?'.tr),
        actions: [
          TextButton(
            child: Text('No'.tr),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            onPressed: ()async{
              isClose ? Get.back() : null;
              isClose
              ? await Get.find<TableController>().exitFromTable(data: {
                "number": widget.table,
                "hall": widget.hall,
                "cashier": Get.find<SharedPreferences>()
                    .getString('name') ??
                    '',
              })
              : null;
            },
            child: Text('Yes'.tr),
          ),
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      onPopInvoked: (_) async {
        if (ConstantApp.type == "guest") {
        } else {
          await Get.find<TableController>().exitFromTable(data: {
            "number": widget.table,
            "hall": widget.hall,
            "cashier": Get.find<SharedPreferences>()
                .getString('name') ??
                '',
          });
        }
        Get.back();
      },
      child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: AppBar(
                  title: Center(
                    child: Text(
                      'POS'.tr + (cashierName.isNotEmpty ? " / $cashierName" :""),
                      style: ConstantApp.getTextStyle(
                          context: context,
                          size: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () async {
                      if (ConstantApp.type == "guest") {
                      } else {
                        await Get.find<TableController>().exitFromTable(data: {
                          "number": widget.table,
                          "hall": widget.hall,
                          "cashier": Get.find<SharedPreferences>()
                              .getString('name') ??
                              '',
                        });
                      }
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  actions: [
                    Get.width > 800
                        ? IconButton(
                            onPressed: () async {
                              if (!mounted) return;
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const CustomPOSSettingDialog();
                                  },
                                  barrierDismissible: true);
                            },
                            icon: const Icon(Icons.settings),
                            tooltip: 'Page Setting'.tr,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              backgroundColor: const Color(0xFFf1f1f1),
              body: BarcodeKeyboardListener(
                  bufferDuration: const Duration(milliseconds: 200),
                  onBarcodeScanned: (barcode) async {
                    if (barcode.isEmpty) {
                      return;
                    }
                    setState(() {});
                  },
                  child: Obx(
                    () => Get.find<INetworkInfo>().connectionStatus.value == 0
                        ? EmptyFailureNoInternetView(
                            image: 'lottie/no_internet.json',
                            title: 'Network Error'.tr,
                            description: 'Internet Not Found !!'.tr,
                            buttonText: "Retry".tr,
                            onPressed: () async {},
                          )
                        : SizedBox(
                            width: ConstantApp.getWidth(context),
                            height: ConstantApp.getHeight(context),
                            child: ConstantApp.isTab(context)
                                ? verticalOrderView()
                                : horizontalOrderView(),
                          ),
                  )))),
    );
  }

  Widget horizontalOrderView() {
    return Column(children: [
      Expanded(
        child: Row(
          children: [
            orderWidget(),
            productItemsWidget(),
            Obx(
              () => !controller.showSub.value
                  ? const SizedBox()
                  : supCategoryWidget(),
            ),
            Obx(() => !controller.showMain.value
                ? const SizedBox()
                : mainCategoryWidget()),
          ],
        ),
      ),
    ]);
  }

  Widget verticalOrderView() {
    return Column(children: [
      Expanded(
        child: Column(
          children: [
            orderWidget(),
          ],
        ),
      ),
    ]);
  }

  Widget orderWidget() {
    return Obx(
      () => Expanded(
          flex: controller.orderWidth.value,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: ConstantApp.isTab(context)
                    ? ConstantApp.getHeight(context) * 0.09
                    : ConstantApp.getHeight(context) * 0.17,
                color: secondaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          settingWidgetOrderView(),
                          const Expanded(child: CustomClock()),
                          Expanded(
                            child: Text(hallName,
                                style: const TextStyle(color: Colors.white)),
                          ),
                          Expanded(
                            child: Obx(
                              () => Text(
                                '${'Orders'.tr} - ${controller.orderNumber}',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Obx(
                              () {
                                return controller.orders.isNotEmpty &&
                                        !controller.requstingBill.value
                                    ? const Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.soup_kitchen_outlined,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const SizedBox();
                              },
                            ),
                          ),
                          Expanded(
                            child: Obx(() => controller.requstingBill.value
                                ? const Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.attach_money,
                                      color: Colors.white,
                                    ),
                                  )
                                : const SizedBox()),
                          ),
                          Expanded(
                            child: Text(
                              DateFormat('yyyy-MM-dd').format(DateTime.now()),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              widgetAddCustomer(),
                              GetBuilder<OrderController>(
                                  builder: (controller) {
                                return CustomDropDownButtonCustomer(
                                  title: '',
                                  hint: 'Customers'.tr,
                                  value: controller.customerId.value == 0
                                      ? null
                                      : controller.customerId.value,
                                  items: controller.customer,
                                  onChange: (val) {
                                    controller.customerId.value = val!;
                                    for (var element in controller.customer) {
                                      if (element.id == val) {
                                        customerNumber = element.mobileList[0];
                                        addressCustomer =
                                            element.address[0].toString();
                                        customerNumber = customerNumber == ""
                                            ? element.mobileList[0]
                                            : customerNumber;
                                        addressCustomer = addressCustomer == ""
                                            ? element.address[0].toString()
                                            : addressCustomer;
                                        if (controller.customerId.value != 1) {
                                          dialogAddress(
                                              address: element.address,
                                              id: val,
                                              mobilNumber: element.mobileList,
                                              name: element.businessName);
                                        }
                                      }
                                    }
                                  },
                                  width:GetPlatform.isWindows ? Get.width / 10: Get.width > 800
                                      ? Get.width / 15
                                      : Get.width / 2,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 50),
                                  textEditingController: textEditingController,
                                );
                              }),
                            ],
                          ),
                          controller.tempOrder.isEmpty?
                          const SizedBox():  Row(
                            children: [
                              CustomDropDownButton(
                                  title: '',
                                  hint: 'Price'.tr,
                                  value: controller.priceType.isEmpty
                                      ? null
                                      : controller.priceType.value,
                                  withOutValue: false,
                                  items:  const[
                                    'Whole Price',
                                    'Min price',
                                    'Max Price',
                                    'Cost Price'
                                  ],
                                  onChange: (value) {
                                    controller.priceType.value = value!;
                                    controller.totalPrice.value = 0;
                                    if (controller.priceType
                                        .contains('Whole')) {
                                      for (var i in controller.tempOrder) {
                                        i.price = i.wholePrice!;
                                        controller.totalPrice.value +=
                                            (i.price * i.quantity);
                                      }
                                    } else if (controller.priceType
                                        .contains('Min')) {
                                      for (var i in controller.tempOrder) {
                                        i.price = i.minPrice!;
                                        controller.totalPrice.value +=
                                            (i.price * i.quantity);
                                      }
                                    } else if (controller.priceType
                                        .contains('Max')) {
                                      for (var i in controller.tempOrder) {
                                        i.price = i.maxPrice!;
                                        controller.totalPrice.value +=
                                            (i.price * i.quantity);
                                      }
                                    } else if (controller.priceType
                                        .contains('Cost')) {
                                      for (var i in controller.tempOrder) {
                                        i.price = i.costPrice!;
                                        controller.totalPrice.value +=
                                            (i.price * i.quantity);
                                      }
                                    }
                                    setState(() {});
                                  },
                                  width:GetPlatform.isWindows ? Get.width / 10: Get.width > 800
                                      ? Get.width / 15
                                      : Get.width / 6,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 50)),
                              IconButton(
                                  onPressed: () {
                                    controller.priceType.value = '';
                                    controller.totalPrice.value = 0;
                                    for (var i in controller.tempOrder) {
                                      i.price = i.firstPrice!;
                                      controller.totalPrice.value +=
                                          (i.quantity * i.price);
                                    }
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                          !controller.enableGuests.value || (int.tryParse(widget.hall)??-1)<=0
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      tooltip: 'Add Guest'.tr,
                                      color: Colors.white,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              guestNameController.text =
                                                  '${"Guest".tr} ${controller.listGuest.length}';
                                              return AlertDialog(
                                                scrollable: true,
                                                title: Text('Add Guest'.tr),
                                                content: Form(
                                                  key: formKey,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      controller:
                                                          guestNameController,
                                                      onSaved: (val) {
                                                        guestNameController
                                                            .text = val!;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Name'.tr,
                                                        icon: const Icon(
                                                            Icons.account_box),
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Enter name'
                                                              .tr;
                                                        }
                                                        for (var i in controller
                                                            .listGuest) {
                                                          if (value == i) {
                                                            return 'The name is already in use !!'
                                                                .tr;
                                                          }
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: Text(
                                                        'Cancel'.tr,
                                                        style: const TextStyle(
                                                            color: Colors.red),
                                                      )),
                                                  TextButton(
                                                      child: Text(
                                                        "Add".tr,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xffee680e)),
                                                      ),
                                                      onPressed: () {
                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          formKey.currentState!
                                                              .save();
                                                          controller.listGuest.add(
                                                              guestNameController
                                                                  .text);
                                                          Get.find<
                                                                  SharedPreferences>()
                                                              .remove(
                                                                  'listGuest');
                                                          Get.find<
                                                                  SharedPreferences>()
                                                              .setStringList(
                                                                  'listGuest',
                                                                  controller
                                                                      .listGuest);
                                                          Get.back();
                                                          guestNameController
                                                              .clear();
                                                          setState(() {});
                                                        }
                                                      }),
                                                ],
                                                icon: Container(
                                                  color: secondaryColor
                                                      .withOpacity(0.5),
                                                  width: 100,
                                                  height: 100,
                                                  child:
                                                      Obx(
                                                          () =>
                                                              ListView.builder(
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Card(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            controller.listGuest[index],
                                                                            style:
                                                                                const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                                                          ),
                                                                          IconButton(
                                                                              onPressed: () {
                                                                                if (index > 0) {
                                                                                  controller.listGuest.removeAt(index);
                                                                                  guestNameController.text = '${"Guest".tr} ${controller.listGuest.length}';
                                                                                  setState(() {});
                                                                                }
                                                                              },
                                                                              iconSize: 20,
                                                                              icon: const Icon(Icons.clear))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                itemCount:
                                                                    controller
                                                                        .listGuest
                                                                        .length,
                                                              )),
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                    CustomDropDownButton(
                                        title: '',
                                        hint: 'Guest'.tr,
                                        value: controller.guest.isEmpty
                                            ? null
                                            : controller.guest,
                                        withOutValue: false,
                                        items: controller.listGuest,
                                        onChange: (value) {
                                          controller.guest = value!;
                                        },
                                        width: Get.width > 800
                                            ? Get.width / 15
                                            : Get.width / 6,
                                        height:
                                            ScaledDimensions.getScaledHeight(
                                                px: 50)),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              addressCustomer == ""
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${"Address :".tr} $addressCustomer",
                            style: ConstantApp.getTextStyle(
                                context: context, color: secondaryColor),
                          ),
                        ),
                      ],
                    ),
              noteOrder == ""
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              showDialogNote(noteOrder);
                            },
                            child: Text(
                              "${"Note :".tr} $noteOrder",
                              style: ConstantApp.getTextStyle(
                                  context: context, color: secondaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Text(
                          'Name'.tr,
                          style: ConstantApp.getTextStyle(
                              context: context,
                              color: secondaryColor,
                              fontWeight: FontWeight.bold),
                        )),
                    Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Center(
                          child: Text(
                            'Qty'.tr,
                            style: ConstantApp.getTextStyle(
                                context: context,
                                color: secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    controller.showUnit.value
                        ? Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Units'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                        : const SizedBox(),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Center(
                          child: Text(
                            'Price'.tr,
                            style: ConstantApp.getTextStyle(
                                context: context,
                                color: secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Center(
                          child: Text(
                            'Total'.tr,
                            style: ConstantApp.getTextStyle(
                                context: context,
                                color: secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Center(
                          child: Text(
                            'Guest'.tr,
                            style: ConstantApp.getTextStyle(
                                context: context,
                                color: secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text(
                          ''.tr,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
              ),
              Expanded(
                child: GetBuilder<OrderController>(builder: (controller) {
                  isDecimal.clear();
                  return controller.loadingOrders.value
                      ? Center(
                          child: SpinKitFoldingCube(
                          color: primaryColor,
                          size: 75,
                        ))
                      : controller.orders.isEmpty &&
                              controller.tempOrder.isEmpty
                          ? Center(
                              child: Text(
                              'No Order'.tr,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ))
                          : controller.tempOrder.isNotEmpty
                              ? ListView.builder(
                                  itemBuilder: (context, index) {
                                    Map<int, double> map = {};
                                    List<UnitModel> listUnit =
                                        <UnitModel>[];
                                    for (var i
                                        in controller.productDataPlayer) {
                                      if (i.id ==
                                          controller
                                              .tempOrder[index].itemId) {
                                        map.addIf(
                                            (i.unit != 0 && i.unit != null),
                                            i.unit ?? 0,
                                            double.tryParse(
                                                    i.price ?? '0') ??
                                                0.0);
                                        map.addIf(
                                            (i.unit2 != 0 &&
                                                i.unit2 != null),
                                            i.unit2 ?? 0,
                                            double.tryParse(
                                                    i.price2 ?? '0') ??
                                                0.0);
                                        map.addIf(
                                            (i.unit3 != 0 &&
                                                i.unit3 != null),
                                            i.unit3 ?? 0,
                                            double.tryParse(
                                                    i.price3 ?? '0') ??
                                                0.0);
                                      }
                                    }
                                    for (var i in controller.units) {
                                      if (map.keys.contains(i.id)) {
                                        listUnit.add(i);
                                      }
                                    }
                                    isDecimal.add(controller.units
                                        .firstWhere((element) =>
                                            element.id ==
                                            controller
                                                .tempOrder[index].unitId)
                                        .acceptsDecimal);
                                    return TempOrderItem(
                                      name:
                                      Get.find<AppSettingController>().language.value ==
                                          "en"?
                                          controller.tempOrder[index].name:
                                          controller.tempOrder[index].arabicName,
                                      ident:
                                          controller.tempOrder[index].ident,
                                      price:
                                          controller.tempOrder[index].price,
                                      qty: controller
                                          .tempOrder[index].quantity,
                                      guest:
                                          controller.tempOrder[index].guest,
                                      note:
                                          controller.tempOrder[index].note,
                                      onPressed: () {
                                        controller.tempOrder
                                            .removeAt(index);
                                        if (controller.tempOrder.isEmpty) {
                                          controller.getOrderForTable(
                                              widget.hall, widget.table);
                                        } else {
                                          controller.totalPrice.value = 0.0;
                                          controller.qty.value = 0.0;
                                          for (var i
                                              in controller.tempOrder) {
                                            controller.totalPrice.value +=
                                                (i.price * i.quantity);
                                            controller.qty.value +=
                                                i.quantity;
                                          }
                                        }
                                        setState(() {});
                                      },
                                      iconVis: true,
                                      onChange: (val) {
                                        controller.tempOrder[index].note =
                                            val;
                                        setState(() {});
                                      },
                                      select: () {},
                                      index: index,
                                      changPrice: () async {
                                        priceEditingController.text =
                                            controller
                                                .tempOrder[index].price
                                                .toStringAsFixed(2);
                                        double whole = 0;
                                        double min = 0;
                                        double max = 0;
                                        double cost = 0;
                                        double price = double.tryParse(
                                                controller
                                                    .tempOrder[index].price
                                                    .toStringAsFixed(2)) ??
                                            0.0;
                                        ProductModel product = controller
                                            .products
                                            .firstWhere((element) =>
                                                element.id ==
                                                controller.tempOrder[index]
                                                    .itemId);
                                        if (controller
                                                .tempOrder[index].unitId ==
                                            product.unit) {
                                          whole = product.wholePrice ?? 0;
                                          min = product.minPrice ?? 0;
                                          max = product.maxPrice ?? 0;
                                          cost = product.costPrice ?? 0;
                                        } else if (controller
                                                .tempOrder[index].unitId ==
                                            product.unit2) {
                                          whole = product.wholePrice2 ?? 0;
                                          min = product.minPrice2 ?? 0;
                                          max = product.maxPrice2 ?? 0;
                                          cost = product.costPrice2 ?? 0;
                                        } else if (controller
                                                .tempOrder[index].unitId ==
                                            product.unit3) {
                                          whole = product.wholePrice3 ?? 0;
                                          min = product.minPrice3 ?? 0;
                                          max = product.maxPrice3 ?? 0;
                                          cost = product.costPrice3 ?? 0;
                                        }
                                        if (!mounted) return;
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  title: Row(children: [
                                                    Expanded(
                                                      child:
                                                          CustomAppButton(
                                                              onPressed:
                                                                  () {
                                                                controller
                                                                    .tempOrder[
                                                                        index]
                                                                    .price = price;
                                                                controller
                                                                    .totalPrice
                                                                    .value = 0;
                                                                for (var i
                                                                    in controller
                                                                        .tempOrder) {
                                                                  controller
                                                                      .totalPrice
                                                                      .value += (i
                                                                          .price *
                                                                      i.quantity);
                                                                }
                                                                setState(
                                                                    () {});
                                                                priceEditingController
                                                                        .text =
                                                                    price
                                                                        .toString();
                                                              },
                                                              title:
                                                                  '${"Price/".tr}$price ${"AED".tr}',
                                                              backgroundColor:
                                                                  primaryColor
                                                                      .withOpacity(
                                                                          0.5),
                                                              textColor:
                                                                  textColor,
                                                              withPading:
                                                                  false,
                                                              width: ConstantApp
                                                                      .getWidth(
                                                                          context) /
                                                                  10,
                                                              height: ConstantApp
                                                                      .getHeight(
                                                                          context) /
                                                                  15),
                                                    ),
                                                    Expanded(
                                                      child:
                                                          CustomAppButton(
                                                              onPressed:
                                                                  () {
                                                                controller
                                                                    .tempOrder[
                                                                        index]
                                                                    .price = whole;
                                                                controller
                                                                    .totalPrice
                                                                    .value = 0;
                                                                for (var i
                                                                    in controller
                                                                        .tempOrder) {
                                                                  controller
                                                                      .totalPrice
                                                                      .value += (i
                                                                          .price *
                                                                      i.quantity);
                                                                }
                                                                setState(
                                                                    () {});
                                                                priceEditingController
                                                                        .text =
                                                                    whole
                                                                        .toString();
                                                              },
                                                              title:
                                                                  '${"Whole/".tr}$whole ${"AED".tr}',
                                                              backgroundColor:
                                                                  primaryColor
                                                                      .withOpacity(
                                                                          0.5),
                                                              textColor:
                                                                  textColor,
                                                              withPading:
                                                                  false,
                                                              width: ConstantApp
                                                                      .getWidth(
                                                                          context) /
                                                                  10,
                                                              height: ConstantApp
                                                                      .getHeight(
                                                                          context) /
                                                                  15),
                                                    ),
                                                    Expanded(
                                                      child:
                                                          CustomAppButton(
                                                              onPressed:
                                                                  () {
                                                                controller
                                                                    .tempOrder[
                                                                        index]
                                                                    .price = min;
                                                                controller
                                                                    .totalPrice
                                                                    .value = 0;
                                                                for (var i
                                                                    in controller
                                                                        .tempOrder) {
                                                                  controller
                                                                      .totalPrice
                                                                      .value += (i
                                                                          .price *
                                                                      i.quantity);
                                                                }
                                                                setState(
                                                                    () {});
                                                                priceEditingController
                                                                        .text =
                                                                    min.toString();
                                                              },
                                                              title:
                                                                  '${"Min/".tr}$min ${"AED".tr}',
                                                              backgroundColor:
                                                                  primaryColor.withOpacity(
                                                                      0.5),
                                                              textColor:
                                                                  textColor,
                                                              withPading:
                                                                  true,
                                                              width: ConstantApp
                                                                      .getWidth(
                                                                          context) /
                                                                  10,
                                                              height: ConstantApp
                                                                      .getHeight(
                                                                          context) /
                                                                  15),
                                                    ),
                                                    Expanded(
                                                      child:
                                                          CustomAppButton(
                                                              onPressed:
                                                                  () {
                                                                controller
                                                                    .tempOrder[
                                                                        index]
                                                                    .price = max;
                                                                controller
                                                                    .totalPrice
                                                                    .value = 0;
                                                                for (var i
                                                                    in controller
                                                                        .tempOrder) {
                                                                  controller
                                                                      .totalPrice
                                                                      .value += (i
                                                                          .price *
                                                                      i.quantity);
                                                                }
                                                                setState(
                                                                    () {});
                                                                priceEditingController
                                                                        .text =
                                                                    max.toString();
                                                              },
                                                              title:
                                                                  '${"Max/".tr}$max ${"AED".tr}',
                                                              backgroundColor:
                                                                  primaryColor.withOpacity(
                                                                      0.5),
                                                              textColor:
                                                                  textColor,
                                                              withPading:
                                                                  true,
                                                              width: ConstantApp
                                                                      .getWidth(
                                                                          context) /
                                                                  10,
                                                              height: ConstantApp
                                                                      .getHeight(
                                                                          context) /
                                                                  15),
                                                    ),
                                                    Expanded(
                                                      child:
                                                          CustomAppButton(
                                                              onPressed:
                                                                  () {
                                                                controller
                                                                    .tempOrder[
                                                                        index]
                                                                    .price = cost;
                                                                controller
                                                                    .totalPrice
                                                                    .value = 0;
                                                                for (var i
                                                                    in controller
                                                                        .tempOrder) {
                                                                  controller
                                                                      .totalPrice
                                                                      .value += (i
                                                                          .price *
                                                                      i.quantity);
                                                                }
                                                                setState(
                                                                    () {});
                                                                priceEditingController
                                                                        .text =
                                                                    cost.toString();
                                                              },
                                                              title:
                                                                  '${"Cost/".tr}$cost ${"AED".tr}',
                                                              backgroundColor:
                                                                  primaryColor.withOpacity(
                                                                      0.5),
                                                              textColor:
                                                                  textColor,
                                                              withPading:
                                                                  true,
                                                              width: ConstantApp
                                                                      .getWidth(
                                                                          context) /
                                                                  10,
                                                              height: ConstantApp
                                                                      .getHeight(
                                                                          context) /
                                                                  15),
                                                    ),
                                                  ]),
                                                  actions: [
                                                    Center(
                                                      child:
                                                          CustomTextFormField(
                                                        isNum: true,
                                                        readOnly: true,
                                                        onChange: (val) {},
                                                        hint: 'Price'.tr,
                                                        focusNode:
                                                            FocusNode(),
                                                        textEditingController:
                                                            priceEditingController,
                                                        onSaved: (val) {},
                                                        validator: (val) {
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ]);
                                            });
                                      },
                                      unitWidget: CustomDropDownButtonUnits(
                                          title: '',
                                          hint: 'Units'.tr,
                                          value: controller.tempOrder[index]
                                                      .unitId ==
                                                  0
                                              ? null
                                              : controller
                                                  .tempOrder[index].unitId,
                                          withOutValue: true,
                                          items: listUnit,
                                          onChange: (value) {
                                            controller.tempOrder[index]
                                                .unitId = value!;
                                            controller.tempOrder[index]
                                                .price = map[value]!;
                                            controller.totalPrice.value =
                                                0.0;
                                            controller.qty.value = 0;
                                            for (var i
                                                in controller.tempOrder) {
                                              controller.totalPrice.value +=
                                                  (i.price * i.quantity);
                                              controller.qty.value +=
                                                  i.quantity;
                                            }
                                            setState(() {});
                                          },
                                          width: Get.width > 800
                                              ? ConstantApp.getWidth(
                                                      context) /
                                                  20
                                              : ConstantApp.getWidth(
                                                      context) /
                                                  10,
                                          height: Get.width > 800
                                              ? ConstantApp.getHeight(
                                                      context) /
                                                  20
                                              : ConstantApp.getHeight(
                                                      context) /
                                                  35,
                                          showIconReset: false,
                                          textEditingController:
                                              textEditingController),
                                      changQty: () {
                                        priceEditingController.text =
                                            controller
                                                .tempOrder[index].quantity
                                                .toStringAsFixed(1);
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(actions: [
                                                TextFormField(
                                                  autofocus: true,
                                                  inputFormatters:
                                                      isDecimal[index] ==
                                                              true
                                                          ? [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'(^\d*\.?\d*)'))
                                                            ]
                                                          : [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'[0-9]')),
                                                            ],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      labelText: 'QTY'.tr,
                                                      enabledBorder:
                                                          const UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                      focusedBorder:
                                                          const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none)),
                                                  controller:
                                                      priceEditingController,
                                                  onChanged: (val) {
                                                    if (val.isNotEmpty) {
                                                      if (double.parse(
                                                              val) <=
                                                          0) {
                                                        controller
                                                                .tempOrder[
                                                                    index]
                                                                .quantity =
                                                            1.00;
                                                      } else {
                                                        controller
                                                                .tempOrder[
                                                                    index]
                                                                .quantity =
                                                            double.parse(
                                                                val);
                                                      }
                                                    }
                                                    controller.totalPrice
                                                        .value = 0.0;
                                                    controller.qty.value =
                                                        0;
                                                    for (var i in controller
                                                        .tempOrder) {
                                                      controller.totalPrice
                                                              .value +=
                                                          (i.price *
                                                              i.quantity);
                                                      controller
                                                              .qty.value +=
                                                          i.quantity;
                                                    }
                                                    setState(() {});
                                                  },
                                                ),
                                              ]);
                                            });
                                      },
                                      addQty: () async {
                                        double qty =
                                            await controller.checkQty(
                                                variableId: controller
                                                    .tempOrder[index]
                                                    .variableId!,
                                                id: controller
                                                    .tempOrder[index]
                                                    .itemId);
                                        for (var i
                                            in controller.tempOrder) {
                                          if (i.itemId ==
                                                  controller
                                                      .tempOrder[index]
                                                      .itemId &&
                                              i.variableId ==
                                                  controller
                                                      .tempOrder[index]
                                                      .variableId) {
                                            qty -= i.quantity;
                                          }
                                        }
                                        if (!controller.negative.value) {
                                          if (qty <= 0) {
                                            if (!mounted) {
                                              return;
                                            }
                                            if(!context.mounted)return;
                                            ConstantApp.showSnakeBarError(
                                                context,
                                                'There Is No Quantity !!'.tr);
                                            return;
                                          }
                                        }
                                        controller
                                            .tempOrder[index].quantity++;
                                        controller.tempOrder[index]
                                            .totalPrice = controller
                                                .tempOrder[index].quantity *
                                            controller
                                                .tempOrder[index].price;
                                        controller.totalPrice.value = 0.0;
                                        controller.qty.value = 0;
                                        for (var i
                                            in controller.tempOrder) {
                                          controller.totalPrice.value +=
                                              (i.price * i.quantity);
                                          controller.qty.value +=
                                              i.quantity;
                                        }
                                        setState(() {});
                                      },
                                      subQty: () {
                                        if (controller
                                                .tempOrder[index].quantity >
                                            1) {
                                          controller
                                              .tempOrder[index].quantity--;
                                          controller.tempOrder[index]
                                              .totalPrice = controller
                                                  .tempOrder[index]
                                                  .quantity *
                                              controller
                                                  .tempOrder[index].price;
                                          controller.totalPrice.value = 0.0;
                                          controller.qty.value = 0;
                                          for (var i
                                              in controller.tempOrder) {
                                            controller.totalPrice.value +=
                                                (i.price * i.quantity);
                                            controller.qty.value +=
                                                i.quantity;
                                          }
                                        }
                                        setState(() {});
                                      },
                                    );
                                  },
                                  itemCount: controller.tempOrder.length,
                                )
                              : Obx(
                                  () => ListView.builder(
                                    itemBuilder: (context, index) =>
                                        OrderItemWidget(
                                      items:
                                          controller.orders[index].orders,
                                      orderDate: controller
                                          .orders[index].orderDate,
                                      orderId: controller.orders[index].id,
                                      setStateMore: () {
                                        setState(() {});
                                      },
                                    ),
                                    itemCount: controller.orders.length,
                                  ),
                                );
                }),
              ),
              SizedBox(
                height: Get.width > 800 ? 100 : 175,
                width: Get.width,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Get.width > 800 || GetPlatform.isWindows
                              ? const SizedBox()
                              : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton(
                                onPressed: () {
                                  Get.dialog(Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    elevation: 0.0,
                                    backgroundColor: Colors.transparent,
                                    child: addButton(context),
                                  ));
                                },
                                backgroundColor:
                                secondaryColor.withOpacity(0.8),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                )),
                          ),
                          Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                color: Colors.white),
                            child: Obx(
                                  () => Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 25,
                                        color: secondaryColor.withOpacity(0.8),
                                        child: Center(
                                          child: Text(
                                              '${controller.qty} \t ${'QTY'.tr}',
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          '${controller.totalPrice.toStringAsFixed(2)} ${'AED'.tr}',
                                          style: ConstantApp.getTextStyle(
                                            context: context,
                                            color: textColor,
                                            size: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: CustomAppButton(
                        height: ScaledDimensions.getScaledHeight(px: 60),
                        width: ScaledDimensions.getScaledWidth(px: 100),
                        onPressed: sendFunction,
                        title: 'Send'.tr,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        withPading: false,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: CustomAppButton(
                        height: ScaledDimensions.getScaledHeight(px: 60),
                        width: ScaledDimensions.getScaledWidth(px: 100),
                        onPressed: printBillFunction,
                        title: 'Bill Request'.tr,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        withPading: false,
                      ),
                    ),
                    Flexible(
                        flex: 2,
                        child: Center(
                          child: TextButton(
                            onPressed: voidFun,
                            child: Text(
                              'Void'.tr,
                              style: ConstantApp.getTextStyle(
                                  context: context,
                                  color: secondaryColor,
                                  size: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget productItemsWidget() {
    return Obx(
      () => Expanded(
          flex: Get.width > 800
              ? ConstantApp.isTab(context)
                  ? controller.productWidth.value - 1
                  : controller.productWidth.value
              : 5,
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: ScaledDimensions.getScaledHeight(px: 100),
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        border: const Border.symmetric(
                            vertical:
                                BorderSide(color: Colors.white, width: 1))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 6,
                            child: TextField(
                              controller: textEditingController3,
                              onChanged: (value) =>
                                  controller.filterProductPlayer(value),
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  icon:GetPlatform.isWindows?const SizedBox(): IconButton(
                                      icon: const Icon(FontAwesomeIcons.barcode,
                                          color: Colors.white),
                                      onPressed: () async {
                                        isClose = false;
                                        var result =
                                            await BarcodeScanner.scan();
                                        if (!mounted) {
                                          return;
                                        }
                                        await controller.addProductFromBarcode(
                                            result.rawContent,
                                            context,
                                            widget.hall,
                                            widget.table);
                                        isClose = true;
                                        setState(() {});
                                      }),
                                  suffixIconColor: Colors.white,
                                  hintText: 'Search...'.tr,
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  suffixIcon: const Icon(Icons.search),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                  onPressed: () async {
                                    textEditingController3.clear();
                                    await controller.getAllProducts();
                                  },
                                  icon: Icon(
                                    Icons.refresh_outlined,
                                    color: primaryColor,
                                    size: ConstantApp.getTextSize(context)*15,
                                  )))
                        ],
                      ),
                    ),
                  )),
              Expanded(
                flex: Get.width > 800 ? 11 : 15,
                child: Column(
                  children: [
                    Expanded(
                      child: GetBuilder<OrderController>(
                        builder: (controller) => Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                border: const Border.symmetric(
                                    vertical: BorderSide(
                                        color: Colors.black, width: 2))),
                            child: controller.productsLoading.value
                                ? const DefaultLoader()
                                : GridView.builder(
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: Get.width > 800
                                                ? ConstantApp.isTab(context)
                                                    ? controller
                                                            .productItem.value +
                                                        3
                                                    : controller
                                                        .productItem.value
                                                : 3,
                                            crossAxisSpacing:
                                                ScaledDimensions.getScaledWidth(
                                                    px: 2),
                                            mainAxisSpacing: ScaledDimensions
                                                .getScaledHeight(px: 5)),
                                    itemCount:
                                        controller.productDataPlayer.length,
                                    itemBuilder: ((context, index) {
                                      return GridItem(
                                        maxLine: 2,
                                        onTap: () async {
                                          if (controller
                                                  .productDataPlayer[index]
                                                  .type ==
                                              'variable') {
                                            await controller.getVariable(
                                                controller
                                                    .productDataPlayer[index]
                                                    .id!);
                                            if(!context.mounted)return;
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return SimpleDialog(
                                                  backgroundColor: Colors.white,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              1.6,
                                                      child: GetBuilder<
                                                          OrderController>(
                                                        builder: (controller) {
                                                          return GridView
                                                              .builder(
                                                            padding: EdgeInsets.all(
                                                                ScaledDimensions
                                                                    .getScaledWidth(
                                                                        px: 5)),
                                                            gridDelegate:
                                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                              childAspectRatio:
                                                                  1,
                                                              crossAxisCount: 2,
                                                              crossAxisSpacing:
                                                                  ScaledDimensions
                                                                      .getScaledWidth(
                                                                          px: 10),
                                                              mainAxisSpacing:
                                                                  10,
                                                            ),
                                                            itemCount: controller
                                                                .productsVariable
                                                                .length,
                                                            itemBuilder:
                                                                ((context,
                                                                    index1) {
                                                              return GridItem(
                                                                onTap:
                                                                    () async {
                                                                  double qty = await controller.checkQty(
                                                                      variableId: controller
                                                                          .productsVariable[
                                                                              index1]
                                                                          .id!,
                                                                      id: controller
                                                                          .productDataPlayer[
                                                                              index]
                                                                          .id!);
                                                                  for (var i
                                                                      in controller
                                                                          .tempOrder) {
                                                                    if (i.itemId ==
                                                                            controller
                                                                                .productDataPlayer[
                                                                                    index]
                                                                                .id &&
                                                                        i.variableId ==
                                                                            controller.productsVariable[index1].id) {
                                                                      qty -= i
                                                                          .quantity;
                                                                    }
                                                                  }
                                                                  if (!controller
                                                                      .negative
                                                                      .value) {
                                                                    if (qty <=
                                                                        0) {
                                                                      if(!context.mounted)return;
                                                                      ConstantApp.showSnakeBarError(
                                                                          context,
                                                                          'There Is No Quantity !!'.tr);
                                                                      return;
                                                                    }
                                                                  }

                                                                  await controller.addOrder(
                                                                      controller.productDataPlayer[
                                                                          index],
                                                                      controller
                                                                          .productsVariable[
                                                                              index1]
                                                                          .id!,
                                                                      null,
                                                                      null,
                                                                      widget
                                                                          .hall,
                                                                      widget
                                                                          .table);

                                                                  if(!context.mounted)return;
                                                                  ConstantApp
                                                                      .showSnakeBarInfo(
                                                                          context,
                                                                          'Add Items Success !!'.tr);
                                                                  Get.back();
                                                                },
                                                                name: controller
                                                                    .productsVariable[
                                                                        index1]
                                                                    .name!,
                                                                image: "",
                                                                imageBytes: controller
                                                                    .productsVariable[
                                                                        index1]
                                                                    .image,
                                                              );
                                                            }),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              barrierDismissible: true,
                                            );
                                          }
                                          else {
                                            double qty = 0.0;
                                            qty = await controller.checkQty(
                                                variableId: 0,
                                                id: controller
                                                    .productDataPlayer[index]
                                                    .id!);
                                            for (var i
                                                in controller.tempOrder) {
                                              if (i.itemId ==
                                                  controller
                                                      .productDataPlayer[index]
                                                      .id) {
                                                qty -= i.quantity;
                                              }
                                            }
                                            if (!controller.negative.value) {
                                              if (qty <= 0) {
                                                if(!context.mounted)return;
                                                ConstantApp.showSnakeBarError(
                                                    context,
                                                    'There Is No Quantity !!'.tr);
                                                return;
                                              }
                                            }

                                            controller.addOrder(
                                                controller
                                                    .productDataPlayer[index],
                                                0,
                                                null,
                                                null,
                                                widget.hall,
                                                widget.table);
                                            if(!context.mounted)return;
                                            ConstantApp.showSnakeBarInfo(
                                                context,
                                                'Add Items Success !!'.tr);
                                          }
                                          setState(() {});
                                        },
                                        name: Get.find<AppSettingController>().language.value ==
                                            "en"?
                                        controller
                                            .productDataPlayer[index]
                                            .englishName!:controller
                                            .productDataPlayer[index]
                                            .arabicName!,
                                        image: "",
                                        imageBytes: controller
                                            .productDataPlayer[index].image,
                                        price: controller
                                            .productDataPlayer[index].price,
                                        onLongPress: () {},
                                        color: Color(int.parse(controller
                                                .productDataPlayer[index]
                                                .colorProduct!))
                                            .withOpacity(0.7),
                                      );
                                    }))),
                      ),
                    ),
                    !controller.keyboardVis.value
                        ? const SizedBox()
                        : Expanded(
                            child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                border: const Border.symmetric(
                                    vertical: BorderSide(
                                        color: Colors.black, width: 2))),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: TextFormField(
                                        readOnly: true,
                                        textAlign: TextAlign.center,
                                        controller: numController,
                                        keyboardType: TextInputType.none,
                                        showCursor: false,
                                      ),
                                    ),
                                    NumPad(
                                        delete: () {
                                          if (numController.text.isEmpty) {
                                            return;
                                          }
                                          numController.text =
                                              numController.text.substring(
                                                  0,
                                                  numController.text.length -
                                                      1);
                                        },
                                        onSubmit: () {},
                                        controller: numController,
                                        buttonSize: 35,
                                        buttonColor: Colors.black,
                                        iconColor: Colors.black,
                                        onPressed: () {}),
                                  ],
                                ),
                              ),
                            ),
                          ))
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget supCategoryWidget() {
    return GetBuilder<OrderController>(builder: (controller) {
      return Expanded(
          flex: Get.width > 800 ? controller.subWidth.value : 2,
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        border: const Border.symmetric(
                            vertical:
                                BorderSide(color: Colors.black, width: 2))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) => controller.filterSubPlayer(value),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          suffixIconColor: Colors.white,
                          border: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: 'Search...'.tr,
                          hintStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          suffixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  )),
              Expanded(
                flex: Get.width > 800 ? 11 : 15,
                child: GetBuilder<OrderController>(
                  builder: (controller) => controller.productsLoading.value
                      ? const DefaultLoader()
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              border: const Border.symmetric(
                                  vertical: BorderSide(
                                      color: Colors.black, width: 2))),
                          child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1.5,
                                      crossAxisCount: Get.width > 800
                                          ? ConstantApp.isTab(context)
                                              ? controller.subItem.value + 5
                                              : controller.subItem.value
                                          : 1,
                                      // GetPlatform.isDesktop ? 6 : 2,
                                      crossAxisSpacing:
                                          ScaledDimensions.getScaledWidth(
                                              px: 4),
                                      mainAxisSpacing: 0),
                              itemCount: controller.subCategoriesPlayer.length,
                              itemBuilder: ((context, index) => GridItem(
                                icon: ConstantApp.appType.name == "RETAIL"
                                    ? Get.find<OrderController>().iconsRetail[
                                controller
                                    .subCategoriesPlayer[index].icon]
                                    : ConstantApp.appType.name == "Salon"
                                    ? Get.find<OrderController>()
                                    .iconsSalon[
                                controller
                                    .subCategoriesPlayer[index].icon]
                                    : Get.find<OrderController>().icons[
                                controller.subCategoriesPlayer[index]
                                    .icon],
                                    onTap: () {
                                      controller.fillProduct(controller
                                          .subCategoriesPlayer[index].id);
                                    },

                                    name: Get.find<AppSettingController>().language.value ==
                                        "en"?
                                    controller.subCategoriesPlayer[index]
                                        .englishName!:controller.subCategoriesPlayer[index]
                                        .arabicName,
                                    image: "",
                                    imageBytes: controller
                                        .subCategoriesPlayer[index].image,
                                    onLongPress: () {},
                                    color: Color(int.parse(controller
                                            .subCategoriesPlayer[index].color!))
                                        .withOpacity(0.7),
                                  ))),
                        ),
                ),
              ),
            ],
          ));
    });
  }

  Widget mainCategoryWidget() {
    return GetBuilder<OrderController>(builder: (controller) {
      return Expanded(
        flex: Get.width > 800 ? controller.mainWidth.value : 2,
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      border: const Border.symmetric(
                          vertical: BorderSide(color: Colors.black, width: 2))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) => controller.filterMainPlayer(value),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        suffixIconColor: Colors.white,
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: 'Search...'.tr,
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        suffixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                )),
            Expanded(
              flex: Get.width > 800 ? 11 : 15,
              child: GetBuilder<OrderController>(
                builder: (controller) => Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      border: const Border.symmetric(
                          vertical: BorderSide(color: Colors.black, width: 2))),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.5,
                          crossAxisCount: Get.width > 800
                              ? ConstantApp.isTab(context)
                                  ? controller.mainItem.value + 5
                                  : controller.mainItem.value
                              : 1,
                          crossAxisSpacing:
                              ScaledDimensions.getScaledWidth(px: 4),
                          mainAxisSpacing: 0),
                      itemCount: controller.mainCategoryPlayer.length,
                      itemBuilder: ((context, index)=>GridItem(
                        icon: ConstantApp.appType.name == "RETAIL"
                            ? Get.find<OrderController>().iconsRetail[
                        controller
                            .mainCategoryPlayer[index].icon]
                            : ConstantApp.appType.name == "Salon"
                            ? Get.find<OrderController>()
                            .iconsSalon[
                        controller
                            .mainCategoryPlayer[index].icon]
                            : Get.find<OrderController>().icons[
                        controller.mainCategoryPlayer[index]
                            .icon],
                        onTap: () {
                          controller.fillMain(
                              controller.mainCategoryPlayer[index].id);
                          setState(() {});
                        },
                        name: Get.find<AppSettingController>().language.value ==
                            "en"
                            ? controller
                            .mainCategoryPlayer[index].englishName!:
                        controller
                            .mainCategoryPlayer[index].arabicName,
                        image: "",
                        imageBytes:
                        controller.mainCategoryPlayer[index].image,
                        onLongPress: () {},
                        color: Color(int.parse(controller
                            .mainCategoryPlayer[index].color!))
                            .withOpacity(0.7),
                      ))),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget widgetAddCustomer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        controller.customerId.value != 1
            ? IconButton(
                icon: const Icon(Icons.remove_red_eye_rounded),
                tooltip: 'View Details'.tr,
                color: Colors.white,
                onPressed: () {
                  customerNumber = customerNumber;
                  addressCustomer = addressCustomer;
                  CustomerModel? element = Get.find<OrderController>()
                      .customer
                      .firstWhereOrNull((element) =>
                          element.id == controller.customerId.value);

                  dialogAddress(
                      address: element?.address ?? [],
                      id: element?.id ?? 0,
                      mobilNumber: element?.mobileList ?? [],
                      name: element?.businessName ?? "");

                  // dialogAddress(
                  //     address: element?.address ?? [],
                  //     id: element?.id ?? 0,
                  //     mobilNumber: element?.mobileList ?? [],
                  //     name: element?.businessName ?? "");
                },
              )
            : const SizedBox(),
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Add Customer'.tr,
          color: Colors.white,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Add Customer'.tr),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: busNameController,
                              onSaved: (val) {
                                busNameController.text = val!;
                              },
                              decoration: InputDecoration(
                                labelText: 'Business name'.tr,
                                icon: const Icon(Icons.business),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter name'.tr;
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: firstNameController,
                              onSaved: (val) {
                                firstNameController.text = val!;
                              },
                              decoration: InputDecoration(
                                labelText: 'Name'.tr,
                                icon: const Icon(Icons.account_box),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter name'.tr;
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: mobileTextEditing,
                              onSaved: (val) {
                                mobileTextEditing.text = val!;
                              },
                              decoration: InputDecoration(
                                labelText: "${'Mobile Number'.tr}*",
                                icon: const Icon(Icons.phone),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Mobile number'.tr;
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                            TextFormField(
                              controller: address1Controller,
                              onSaved: (val) {
                                address1Controller.text = val!;
                              },
                              decoration: InputDecoration(
                                labelText: 'Address'.tr,
                                icon: const Icon(Icons.location_on),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Address'.tr;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            'Cancel'.tr,
                            style: const TextStyle(color: Colors.red),
                          )),
                      TextButton(
                          child: Text(
                            "Add".tr,
                            style: const TextStyle(color: Color(0xffee680e)),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              String message = await controller.addCustomer(
                                  firstName: firstNameController.text,
                                  busName: busNameController.text,
                                  address: address1Controller.text,
                                  mobile: mobileTextEditing.text);
                              if (message == 'Error') {
                                if(!context.mounted)return;
                                ConstantApp.showSnakeBarError(
                                  context,
                                  'Some Thing Wrong !!'.tr,
                                );
                              }
                              if(!context.mounted)return;
                              ConstantApp.showSnakeBarSuccess(
                                context,
                                'Add Success !!'.tr,
                              );
                              customerNumber = mobileTextEditing.text;
                              addressCustomer = address1Controller.text;
                              firstNameController.clear();
                              busNameController.clear();
                              mobileTextEditing.clear();
                              address1Controller.clear();
                              Get.back();
                              setState(() {});
                            }
                          }),
                    ],
                  );
                });
          },
        ),
      ],
    );
  }

  Widget settingWidgetOrderView() {
    return PopupMenuButton(
        tooltip: 'Settings'.tr,
        iconSize: 20,
        icon: Icon(
          Icons.menu,
          color: primaryColor.withOpacity(0.8),
        ),
        color: Colors.white.withOpacity(0.8),
        onSelected: (value) async {
          setState(() {});
        },
        itemBuilder: (BuildContext bc) {
          List<PopupMenuItem> items = [
            PopupMenuItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Unit".tr),
                  const SizedBox(
                    width: 20,
                  ),
                  Obx(
                    () => Switch(
                      activeColor: primaryColor,
                      value: controller.showUnit.value,
                      onChanged: (value) {
                        controller.showUnit.value = value;
                        Get.find<SharedPreferences>().remove('showUnit');
                        Get.find<SharedPreferences>()
                            .setBool('showUnit', value);
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ),
          ];

          if (controller.type != "TakeAway" && controller.type != "Delivery") {
            items.add(
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Guests".tr),
                    const SizedBox(
                      width: 20,
                    ),
                    Obx(
                      () => Switch(
                        activeColor: primaryColor,
                        value: controller.enableGuests.value,
                        onChanged: (value) {
                          controller.enableGuests.value = value;
                          Get.find<SharedPreferences>().remove('enableGuests');
                          Get.find<SharedPreferences>()
                              .setBool('enableGuests', value);
                          setState(() {});
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          if (controller.type != "TakeAway" && controller.type != "Delivery") {
            items.add(PopupMenuItem(
              child: Text("Change Table".tr),
              onTap: () {
                controller.allChange.value =
                    controller.selected1.value == 100 ? true : false;
                controller.guestChange.value = false;
                controller.singleChange.value =
                    controller.selected1.value != 100 ? true : false;
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        alignment: Alignment.center,
                        actionsPadding: const EdgeInsets.all(20),
                        title: Column(
                          children: [
                             Text(
                              'Change Table'.tr,
                              style: const TextStyle(fontSize: 25),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(
                              () => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        controller.allChange.value = true;
                                        controller.guestChange.value = false;
                                        controller.singleChange.value = false;
                                      },
                                      color: controller.allChange.value
                                          ? primaryColor
                                          : Colors.grey,
                                      child: Text(
                                        'All'.tr,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        controller.allChange.value = false;
                                        controller.guestChange.value = true;
                                        controller.singleChange.value = false;
                                      },
                                      color: controller.guestChange.value
                                          ? primaryColor
                                          : Colors.grey,
                                      child: Text(
                                        'Guest'.tr,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        controller.allChange.value = false;
                                        controller.guestChange.value = false;
                                        controller.singleChange.value = true;
                                      },
                                      color: controller.singleChange.value
                                          ? primaryColor
                                          : Colors.grey,
                                      child: Text(
                                        'Single'.tr,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        content: SizedBox(
                          width:
                              Get.width > 800 ? Get.width / 3 : Get.width / 2,
                          height:
                              Get.width > 800 ? Get.height / 2 : Get.height / 3,
                          child: Column(
                            children: [
                              Obx(
                                () => controller.guestChange.value
                                    ? CustomDropDownButton(
                                        title: '',
                                        hint: 'Guest'.tr,
                                        value: controller.guest.isEmpty
                                            ? null
                                            : controller.guest,
                                        withOutValue: false,
                                        items: controller.listGuest,
                                        onChange: (value) {
                                          controller.guest = value!;
                                        },
                                        width: ScaledDimensions.getScaledWidth(
                                            px: 30),
                                        height:
                                            ScaledDimensions.getScaledHeight(
                                                px: 50))
                                    : const SizedBox(),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: infoController.halls
                                        .where((p0) => p0.id > 0)
                                        .toList()
                                        .length,
                                    itemBuilder: (context, index) {
                                      return ExpansionTile(
                                          collapsedBackgroundColor:
                                              backgroundColorDropDown
                                                  .withOpacity(0.8),
                                          title: Text(
                                              '${infoController.halls.where((p0) => p0.id > 0).toList()[index].name} / ${infoController.halls.where((p0) => p0.id > 0).toList()[index].id}'),
                                          childrenPadding:
                                              const EdgeInsets.only(
                                                  left: 40, right: 20),
                                          children: infoController.halls
                                              .where((p0) => p0.id > 0)
                                              .toList()[index]
                                              .tables
                                              .map((element) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  element.number,
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                                widget.table ==
                                                            element.number &&
                                                        widget.hall ==
                                                            element.hall
                                                    ? const Icon(
                                                        Icons.block,
                                                        color: Colors.red,
                                                      )
                                                    : IconButton(
                                                        onPressed: () async {
                                                          if (controller
                                                                  .singleChange
                                                                  .value &&
                                                              controller
                                                                      .selected1
                                                                      .value ==
                                                                  100) {
                                                            ConstantApp
                                                                .showSnakeBarError(
                                                                    context,
                                                                    'Select Order please !!'.tr);
                                                            Get.back();
                                                            return;
                                                          }
                                                          await changeTable(
                                                              element);
                                                          await controller
                                                              .getAllOrders(hall:  widget.hall, table:  widget.table);
                                                          Get.back();
                                                          await controller
                                                              .getOrderForTable(
                                                                  widget.hall,
                                                                  widget.table);
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(
                                                            Icons.move_down),
                                                        color: element.cost != 0
                                                            ? primaryColor
                                                            : Colors.green,
                                                      )
                                              ],
                                            );
                                          }).toList());
                                    }),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          CustomAppButton(
                              height: ScaledDimensions.getScaledHeight(px: 40),
                              width: ScaledDimensions.getScaledWidth(px: 40),
                              onPressed: () async {
                                Get.back();
                              },
                              title: 'Cancel'.tr,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              withPading: false),
                        ],
                      );
                    },
                    barrierDismissible: true,
                );
              },
            ));
          }

          return items;
        });
  }

  Future sendFunction() async {
    if (controller.tempOrder.isEmpty) {
      ConstantApp.showSnakeBarError(context, 'Please , Add Some Products !!'.tr);
      return;
    }

    await controller.sendOrder();
    await controller.getDetails();
    await controller.getAllOrders(hall:  widget.hall, table:  widget.table);
    await controller.getOrderForTable(widget.hall, widget.table);
    await Get.find<InfoController>().getAllInformation();
    controller.tempOrder.clear();
  }

  void printBillFunction() async {
    if (controller.orders.isEmpty) {
      ConstantApp.showSnakeBarError(context,
          'Select Sum Items And Press Send After That You Can Request The Bill !!'.tr);
      return;
    } else if (controller.orders.isNotEmpty &&
        controller.tempOrder.isNotEmpty) {
      ConstantApp.showSnakeBarError(context, 'Press Send Please !!'.tr);
      return;
    }
    final message = await controller.billRequest(
      address: addressCustomer,
      customerNo: customerNumber ?? '',
      hall: widget.hall,
      table: widget.table,
      total: controller.totalPrice.value,
    );
    if (message == 'Success') {
      if (!mounted) return;
      ConstantApp.showSnakeBarSuccess(context, 'Bill Requested !!'.tr);
    } else {
      if (!mounted) return;
      ConstantApp.showSnakeBarError(context, 'Some Thing Wrong !! '.tr);
    }
  }

  voidFun() async {
    if (controller.selected1.value == 100) {
      return;
    }
    double qtyVoid = controller.orderTemp.quantity;
    controller.voidReason.value = '';
    controller.voidReason.value = 'By Mistake';
    controller.byMistake.value = false;
    controller.cold.value = false;
    controller.changeHisMind.value = false;
    controller.delay.value = false;
    controller.notLike.value = false;
    var x = controller.order
        .where((p0) =>
            p0.hall == controller.orderTemp.hall &&
            p0.table == controller.orderTemp.table)
        .toList();
    for (var i in x) {
      if (i.itemId == controller.orderTemp.itemId &&
          i.serial == controller.orderTemp.serial && i.variableId == controller.orderTemp.variableId) {
        qtyVoid += i.quantity;
      } else {}
    }
    qtyVoid -= controller.orderTemp.quantity;
    quantityVoidController.text = qtyVoid.toString();
    if (qtyVoid <= 0) {
      ConstantApp.showSnakeBarError(context, 'The Quantity is Zero !!'.tr);
      return;
    }
    Get.dialog(
        Center(
          child: SizedBox(
            width: Get.width > 800
                ? ConstantApp.getWidth(context) / 2
                : ConstantApp.getWidth(context) / 1.3,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              child: Obx(
                () {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomAppButton(
                                  onPressed: () {
                                    controller.voidReason.value = '';
                                    controller.voidReason.value = 'By Mistake';
                                    controller.byMistake.value = true;
                                    controller.cold.value = false;
                                    controller.changeHisMind.value = false;
                                    controller.delay.value = false;
                                    controller.notLike.value = false;
                                  },
                                  title: 'BY MISTAKE'.tr,
                                  backgroundColor: controller.byMistake.value
                                      ? Colors.black38
                                      : Colors.white,
                                  textColor: Colors.black,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 80),
                                  width:
                                      ScaledDimensions.getScaledWidth(px: 60),
                                  withPading: false,
                                ),
                              ),
                              Expanded(
                                child: CustomAppButton(
                                  onPressed: () {
                                    controller.voidReason.value = '';
                                    controller.voidReason.value =
                                        'Change His Mind';
                                    controller.byMistake.value = false;
                                    controller.cold.value = false;
                                    controller.changeHisMind.value = true;
                                    controller.delay.value = false;
                                    controller.notLike.value = false;
                                  },
                                  title: 'CHANGE'.tr,
                                  backgroundColor:
                                      controller.changeHisMind.value
                                          ? Colors.black38
                                          : Colors.white,
                                  textColor: Colors.black,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 80),
                                  width:
                                      ScaledDimensions.getScaledWidth(px: 60),
                                  withPading: false,
                                ),
                              ),
                              Expanded(
                                child: CustomAppButton(
                                  onPressed: () {
                                    controller.voidReason.value = '';
                                    controller.voidReason.value = 'COLD';
                                    controller.byMistake.value = false;
                                    controller.cold.value = true;
                                    controller.changeHisMind.value = false;
                                    controller.delay.value = false;
                                    controller.notLike.value = false;
                                  },
                                  title: 'COLD'.tr,
                                  backgroundColor: controller.cold.value
                                      ? Colors.black38
                                      : Colors.white,
                                  textColor: Colors.black,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 80),
                                  width:
                                      ScaledDimensions.getScaledWidth(px: 60),
                                  withPading: false,
                                ),
                              ),
                              Expanded(
                                child: CustomAppButton(
                                  onPressed: () {
                                    controller.voidReason.value = '';
                                    controller.voidReason.value = 'DELAY';
                                    controller.byMistake.value = false;
                                    controller.cold.value = false;
                                    controller.changeHisMind.value = false;
                                    controller.delay.value = true;
                                    controller.notLike.value = false;
                                  },
                                  title: 'DELAY'.tr,
                                  backgroundColor: controller.delay.value
                                      ? Colors.black38
                                      : Colors.white,
                                  textColor: Colors.black,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 80),
                                  width:
                                      ScaledDimensions.getScaledWidth(px: 60),
                                  withPading: false,
                                ),
                              ),
                              Expanded(
                                child: CustomAppButton(
                                  onPressed: () {
                                    controller.voidReason.value = '';
                                    controller.voidReason.value =
                                        'DID NOT LIKE THE FOOD';
                                    controller.byMistake.value = false;
                                    controller.cold.value = false;
                                    controller.changeHisMind.value = false;
                                    controller.delay.value = false;
                                    controller.notLike.value = true;
                                  },
                                  title: 'NOT LIKE'.tr,
                                  backgroundColor: controller.notLike.value
                                      ? Colors.black38
                                      : Colors.white,
                                  textColor: Colors.black,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 80),
                                  width:
                                      ScaledDimensions.getScaledWidth(px: 60),
                                  withPading: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: quantityVoidController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'(^\d*\.?\d*)'))
                                ],
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  if (val.isNotEmpty) {
                                    if (double.parse(val) >
                                        controller.orderTemp.quantity) {
                                      quantityVoidController.text = controller
                                          .orderTemp.quantity
                                          .toStringAsFixed(1);
                                    }
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Can't Be Empty !!".tr;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'QTY'.tr,
                                  icon: const Icon(Icons.numbers),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if ((double.tryParse(
                                                      quantityVoidController
                                                          .text) ??
                                                  1) >=
                                              controller.orderTemp.quantity) {
                                            ConstantApp.showSnakeBarError(
                                                context,
                                                'It cannot be increased more !!'.tr);
                                            return;
                                          } else {
                                            quantityVoidController
                                                .text = ((double.tryParse(
                                                            quantityVoidController
                                                                .text) ??
                                                        1) +
                                                    1)
                                                .toString();
                                          }
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.add)),
                                    IconButton(
                                        onPressed: () {
                                          if ((double.tryParse(
                                                      quantityVoidController
                                                          .text) ??
                                                  1) <=
                                              1) {
                                            ConstantApp.showSnakeBarError(
                                                context,
                                                'It cannot be Decreased more !!'.tr);
                                            return;
                                          } else {
                                            quantityVoidController
                                                .text = ((double.tryParse(
                                                            quantityVoidController
                                                                .text) ??
                                                        1) -
                                                    1)
                                                .toString();
                                          }
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.remove))
                                  ],
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: ElevatedButton(
                                    // style: ButtonStyle(
                                    //     backgroundColor:
                                    //         WidgetStateProperty.resolveWith(
                                    //             (states) => errorColor)),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'Cancel'.tr,
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (qtyVoid == 0) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Can\'t be Void !! QTY most be bigger than zero !'
                                                  .tr),
                                          backgroundColor: Colors.red,
                                        ));
                                        return;
                                      }

                                      await controller.voidOrder(
                                          order: controller.orderTemp,
                                          reason: controller.voidReason.value,
                                          qty1: (double.tryParse(
                                                  quantityVoidController
                                                      .text) ??
                                              0.0));
                                      await controller.getAllOrders(hall:  widget.hall, table:  widget.table);
                                      await controller.getOrderForTable(
                                          widget.hall, widget.table);
                                      Get.back();
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Void'.tr,
                                      style: const TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        barrierColor: Colors.transparent.withOpacity(0.5));
  }

  void showDialogNote(String? note) {
    showDialog(
      context: context,
      builder: (context) {
        if (note != null) {
          noteOrderController.text = note;
        }
        return SimpleDialog(
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          titleTextStyle: ConstantApp.getTextStyle(context: context, size: 15),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: noteOrderController,
                      decoration: InputDecoration(
                        labelText: "Note Order".tr,
                        icon: const Icon(FontAwesomeIcons.noteSticky),
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      noteOrder = noteOrderController.text;
                      Get.back();
                      noteOrderController.clear();
                      setState(() {});
                    },
                    child: note == null
                        ? Text("Add Note".tr)
                        : Text("Update Note".tr)),
              ],
            ),
          ],
        );
      },
      barrierDismissible: true,

    );
  }

  void dialogAddress(
      {required List<String?> address,
      required int id,
      required List<String?> mobilNumber,
      required String name}) {
    String addressDialog = addressCustomer;
    String mobileNumberDialog = customerNumber.toString();

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: Center(
              child: Text(
            "Chose Address and Mobil Number".tr,
            style: ConstantApp.getTextStyle(
                context: context, fontWeight: FontWeight.bold, size: 12),
          )),
          alignment: Alignment.center,
          titleTextStyle: ConstantApp.getTextStyle(context: context, size: 15),
          children: [
            const SizedBox(
              height: 10,
            ),
            StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState1) {
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Address".tr,
                                style: ConstantApp.getTextStyle(
                                  context: context,
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold,
                                ).copyWith(
                                    decoration: TextDecoration.underline),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                    dialogAddNewAddress(address, id);
                                  },
                                  icon: const Icon(Icons.add)),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(
                              thickness: 4,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: ConstantApp.getHeight(context) * 0.3,
                            width: ConstantApp.getWidth(context) * 0.2,
                            child: ListView.separated(
                              // shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Center(
                                  child: address[index] == ""
                                      ? SizedBox(
                                          child: Center(
                                              child: Text(
                                            "There is no address to add".tr,
                                            style: ConstantApp.getTextStyle(
                                                context: context,
                                                color: secondaryColor),
                                          )),
                                        )
                                      : CheckboxListTile(
                                          title: Text(
                                            address[index] ?? "",
                                            style: ConstantApp.getTextStyle(
                                                context: context,
                                                color: textColor),
                                            textAlign: TextAlign.center,
                                          ),
                                          activeColor: primaryColor,
                                          value:
                                              addressDialog == address[index],
                                          onChanged: (bool? value) {
                                            setState1(() {
                                              if (value != null && value) {
                                                addressDialog =
                                                    address[index].toString();
                                              } else {
                                                addressDialog = "";
                                              }
                                            });
                                          },
                                        ),
                                  //     InkWell(
                                  //   onTap: () {
                                  //     Get.back();
                                  //     addressCustomer = address[index] ?? "";
                                  //     setState(() {});
                                  //   },
                                  //   child: Text(
                                  //     address[index] ?? "",
                                  //     style: ConstantApp.getTextStyle(
                                  //         context: context, color: secondaryColor),
                                  //   ),
                                  // )
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: address.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Mobile Number".tr,
                                  style: ConstantApp.getTextStyle(
                                    context: context,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ).copyWith(
                                      decoration: TextDecoration.underline)),
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                    dialogAddNewMobile(mobilNumber, id);
                                  },
                                  icon: const Icon(Icons.add)),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(
                              thickness: 4,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: ConstantApp.getHeight(context) * 0.3,
                            width: ConstantApp.getWidth(context) * 0.2,
                            child: ListView.separated(
                              // shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Center(
                                  child: mobilNumber[index] == ""
                                      ? const SizedBox()
                                      : CheckboxListTile(
                                          title: Text(
                                            mobilNumber[index] ?? "",
                                            style: ConstantApp.getTextStyle(
                                                context: context,
                                                color: textColor),
                                            textAlign: TextAlign.center,
                                          ),
                                          activeColor: primaryColor,
                                          value: mobileNumberDialog ==
                                              mobilNumber[index],
                                          onChanged: (bool? value) {
                                            setState1(() {
                                              if (value != null && value) {
                                                mobileNumberDialog =
                                                    mobilNumber[index]
                                                        .toString();
                                              } else {
                                                mobileNumberDialog = "";
                                              }
                                            });
                                          },
                                        ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: mobilNumber.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            CustomAppButton(
                height: ScaledDimensions.getScaledHeight(px: 30),
                width: ScaledDimensions.getScaledWidth(px: 50),
                onPressed: () async {
                  if (addressDialog == "" || mobileNumberDialog == "") {
                    ConstantApp.showSnakeBarError(
                        context, "Chose Address and Mobil Number".tr);
                  } else {
                    setState(() {
                      addressCustomer = addressDialog;
                      customerNumber = mobileNumberDialog;
                    });
                    Get.back();
                  }
                },
                title: 'Add'.tr,
                backgroundColor: secondaryColor,
                textColor: Colors.white,
                withPading: false),
          ],
        );
      },
      barrierDismissible: true,
    );
  }

  void dialogAddNewAddress(List<String?> address, int id) {
    newAddressController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: Center(child: Text("New Address".tr)),
          alignment: Alignment.center,
          titleTextStyle: ConstantApp.getTextStyle(context: context, size: 15),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: newAddressController,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Can Not Be Empty !!'.tr;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'New Address'.tr,
                        icon: const Icon(Icons.location_on_outlined),
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      if (newAddressController.text.trim().isEmpty) {
                        return;
                      }
                      final message = await controller.addNewAddressMobile(
                          id: id,
                          address: newAddressController.text,
                          mobile: '');
                      if(!context.mounted)return;
                      if (message == 'Success') {
                        ConstantApp.showSnakeBarSuccess(
                            context, 'Add New Address !!'.tr);
                      } else {
                        ConstantApp.showSnakeBarError(
                            context, 'Some Thing Wrong !!'.tr);
                      }
                      Get.back();
                    },
                    child: Text("Add Address".tr)),
              ],
            ),
          ],
        );
      },
      barrierDismissible: true,
    );
  }

  void dialogAddNewMobile(List<String?> mobile, int id) {
    newMobileController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: Center(child: Text("New Mobile Number".tr)),
          alignment: Alignment.center,
          titleTextStyle: ConstantApp.getTextStyle(context: context, size: 15),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: newMobileController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Can Not Be Empty !!'.tr;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'New Mobile Number'.tr,
                        icon: const Icon(FontAwesomeIcons.mobile),
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      final message = await controller.addNewAddressMobile(
                          id: id,
                          address: '',
                          mobile: newMobileController.text);
                      if(!context.mounted)return;
                      if (message == 'Success') {
                        ConstantApp.showSnakeBarSuccess(
                            context, 'Add New Mobile Number !!'.tr);
                      } else {
                        ConstantApp.showSnakeBarError(
                            context, 'Some Thing Wrong !!'.tr);
                      }
                      Get.back();
                    },
                    child: Text("Add".tr)),
              ],
            ),
          ],
        );
      },
      barrierDismissible: true,
    );
  }

  void initTableName() {
    if (widget.hall == "-1") {
      hallName = "TakeAway - ${widget.table}";
      controller.type = "TakeAway";
    } else if (widget.hall == "0") {
      hallName = "Delivery - ${widget.table}";
      controller.type = "Delivery";
    } else if (widget.hall == "-2") {
      hallName = "Sales";
      controller.type = "Sales";
    } else {
      hallName = "Hall ${widget.hall} - ${widget.table}";
      controller.type = "Table";
    }
  }

  changeTable(TableModel element) async {
    DioClient dio = DioClient();
    var data = {
      "hall": element.hall,
      "table": element.number,
      "oldTable": widget.table,
      "oldHall": widget.hall,
      "guest": controller.guest,
      "all": controller.allChange.value.toString(),
      "guestCh": controller.guestChange.value.toString(),
      "single": controller.singleChange.value.toString(),
      "orderId": (controller.orderTemp.id ?? 0).toString(),
      "orderPrice": controller.orderTemp.price.toString(),
      "orderQuantity": controller.orderTemp.quantity.toString(),
    };
    final response = await dio.postDio(path: '/change-table', data1: data);
    if (response.statusCode == 200) {
      debugPrint(response.data);
    }
  }

  addButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Row(
          children: [
            productItemsWidget(),
            supCategoryWidget(),
            mainCategoryWidget()
          ],
        ),
      ),
    );
  }
}

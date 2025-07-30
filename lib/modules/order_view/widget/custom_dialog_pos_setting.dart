import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/Theme/colors.dart';
import '../../../database/app_db.dart';
import '../../../global_widgets/custom_app_button.dart';
import '../../../utils/constant.dart';
import '../../../controllers/order_controller.dart';

class CustomPOSSettingDialog extends StatefulWidget {
  const CustomPOSSettingDialog({
    super.key,
  });

  @override
  State<CustomPOSSettingDialog> createState() => _CustomPOSSettingDialogState();
}

class _CustomPOSSettingDialogState extends State<CustomPOSSettingDialog> {
  var controller = Get.find<OrderController>();
  int orderW = 5;
  int productW = 3;
  int subW = 1;
  int mainW = 1;
  int mainItem = 1;
  int subItem = 1;
  int productItem = 4;
  int total = 10;
  bool showMain = true;
  bool showSub = true;
  List<String> productList = ['', '', '', ''];
  List<String> mainList = [''];
  List<String> subList = [''];

  dialogContent(BuildContext context) {
    return Container(
        height: ConstantApp.getHeight(context) / 1.2,
        width: ConstantApp.getWidth(context),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: ConstantApp.getWidth(context),
                  height: ConstantApp.getHeight(context) / 3,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: orderW,
                                child: Container(
                                  color: Colors.red,
                                  child: Center(
                                      child: Text('Order'.tr,
                                          style: ConstantApp.getTextStyle(
                                              context: context,
                                              color: Colors.white,
                                              size: 12))),
                                )),
                            Expanded(
                                flex: productW,
                                child: Column(
                                  children: [
                                    Container(
                                        color: Colors.blue,
                                        child: Center(
                                            child: Text('Product'.tr,
                                                style: ConstantApp.getTextStyle(
                                                    context: context,
                                                    color: Colors.white,
                                                    size: 12)))),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 60,
                                      child: GridView.builder(
                                          padding: EdgeInsets.zero,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: productItem,
                                          ),
                                          itemCount: productList.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: ((context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 10,
                                                color: Colors.blue,
                                              ),
                                            );
                                          })),
                                    )
                                  ],
                                )),
                            !showSub
                                ? const SizedBox()
                                : Expanded(
                                    flex: subW,
                                    child: Column(
                                      children: [
                                        Container(
                                            color: Colors.green,
                                            child: Center(
                                                child: Text('Sub'.tr,
                                                    style: ConstantApp
                                                        .getTextStyle(
                                                            context: context,
                                                            color: Colors.white,
                                                            size: 12)))),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: GridView.builder(
                                              padding: EdgeInsets.zero,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: subItem,
                                              ),
                                              itemCount: subList.length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: ((context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 10,
                                                    color: Colors.green,
                                                  ),
                                                );
                                              })),
                                        )
                                      ],
                                    )),
                            !showMain
                                ? const SizedBox()
                                : Expanded(
                                    flex: mainW,
                                    child: Column(
                                      children: [
                                        Container(
                                            color: Colors.black,
                                            child: Center(
                                                child: Text('Main'.tr,
                                                    style: ConstantApp
                                                        .getTextStyle(
                                                            context: context,
                                                            color: Colors.white,
                                                            size: 12)))),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: GridView.builder(
                                              padding: EdgeInsets.zero,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: mainItem,
                                              ),
                                              itemCount: mainList.length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: ((context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 10,
                                                    color: Colors.black,
                                                  ),
                                                );
                                              })),
                                        )
                                      ],
                                    )),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: orderW,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Divider(
                                          thickness: 3, color: Colors.black38),
                                      Center(child: Text(orderW.toString()))
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: productW,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Divider(
                                          thickness: 3, color: Colors.black38),
                                      Center(child: Text('$productW'))
                                    ],
                                  ),
                                )),
                            !showSub
                                ? const SizedBox()
                                : Expanded(
                                    flex: subW,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const Divider(
                                              thickness: 3,
                                              color: Colors.black38),
                                          Center(child: Text('$subW'))
                                        ],
                                      ),
                                    )),
                            !showMain
                                ? const SizedBox()
                                : Expanded(
                                    flex: mainW,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const Divider(
                                              thickness: 3,
                                              color: Colors.black38),
                                          Center(child: Text('$mainW'))
                                        ],
                                      ),
                                    )),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(thickness: 3, color: Colors.black38),
                        ),
                        Center(
                          child: Text(total.toString()),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Card(
                      color: Colors.black38,
                      child: Row(
                        children: [
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text(
                                ''.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                          Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Center(
                                child: Text(
                                  'Name'.tr,
                                  style: ConstantApp.getTextStyle(
                                      context: context,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Center(
                                child: Text(
                                  'Width'.tr,
                                  style: ConstantApp.getTextStyle(
                                      context: context,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Center(
                                child: Text(
                                  'Items In line'.tr,
                                  style: ConstantApp.getTextStyle(
                                      context: context,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Flexible(
                            flex: 1, fit: FlexFit.tight, child: Text('')),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Order'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (orderW <= 4) {
                                          return;
                                        }
                                        orderW -= 1;
                                        getTotal();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: errorColor,
                                      )),
                                  Text(
                                    orderW.toString(),
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: Colors.black,
                                        size: 10),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (orderW >= 8) {
                                          return;
                                        }
                                        orderW += 1;
                                        getTotal();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: primaryColor,
                                      ))
                                ],
                              ),
                            )),
                        const Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text('-'),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        const Flexible(
                            flex: 1, fit: FlexFit.tight, child: Text('')),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Product'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (productW <= 1) {
                                          return;
                                        }
                                        productW -= 1;
                                        getTotal();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: errorColor,
                                      )),
                                  Text(
                                    productW.toString(),
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: Colors.black,
                                        size: 10),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (productW >= 5) {
                                          return;
                                        }
                                        productW += 1;
                                        getTotal();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: primaryColor,
                                      ))
                                ],
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (productItem <= 1) {
                                          return;
                                        }
                                        productList.remove('');
                                        productItem -= 1;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: errorColor,
                                      )),
                                  Text(
                                    productItem.toString(),
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: Colors.black,
                                        size: 10),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (productItem >= 6) {
                                          return;
                                        }
                                        productList.add('');
                                        productItem += 1;
                                        getTotal();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: primaryColor,
                                      ))
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Switch(
                              value: showSub,
                              onChanged: (value) {
                                showSub = value;
                                setState(() {});
                              },
                              activeColor: primaryColor,
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Sub Category'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (subW <= 1) {
                                          return;
                                        }
                                        subW -= 1;
                                        getTotal();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: errorColor,
                                      )),
                                  Text(
                                    subW.toString(),
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: Colors.black,
                                        size: 10),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (subW >= 5) {
                                          return;
                                        }
                                        subW += 1;
                                        getTotal();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: primaryColor,
                                      ))
                                ],
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (subItem <= 1) {
                                          return;
                                        }
                                        subList.remove('');
                                        subItem -= 1;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: errorColor,
                                      )),
                                  Text(
                                    subItem.toString(),
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: Colors.black,
                                        size: 10),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (subItem >= 3) {
                                          return;
                                        }
                                        subList.add('');
                                        subItem += 1;
                                        getTotal();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: primaryColor,
                                      ))
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Switch(
                              value: showMain,
                              onChanged: (value) {
                                showMain = value;
                                setState(() {});
                              },
                              activeColor: primaryColor,
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Main Category'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (mainW <= 1) {
                                          return;
                                        }
                                        mainW -= 1;
                                        getTotal();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: errorColor,
                                      )),
                                  Text(
                                    mainW.toString(),
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: Colors.black,
                                        size: 10),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (mainW >= 5) {
                                          return;
                                        }
                                        mainW += 1;
                                        getTotal();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: primaryColor,
                                      ))
                                ],
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (mainItem <= 1) {
                                          return;
                                        }
                                        mainList.remove('');
                                        mainItem -= 1;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: errorColor,
                                      )),
                                  Text(
                                    mainItem.toString(),
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: Colors.black,
                                        size: 10),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (mainItem >= 3) {
                                          return;
                                        }
                                        mainList.add('');
                                        mainItem += 1;
                                        getTotal();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: primaryColor,
                                      ))
                                ],
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomAppButton(
                          onPressed: () async {
                            orderW = 5;
                            productW = 3;
                            subW = 1;
                            mainW = 1;
                            mainItem = 1;
                            subItem = 1;
                            productItem = 4;
                            total = 10;
                            showMain = true;
                            showSub = true;

                            mainList.clear();
                            productList.clear();
                            subList.clear();

                            for (int i = 1; i <= productItem; i++) {
                              productList.add('');
                            }
                            for (int i = 1; i <= mainItem; i++) {
                              mainList.add('');
                            }
                            for (int i = 1; i <= subItem; i++) {
                              subList.add('');
                            }
                            setState(() {});
                          },
                          title: 'Back To Default'.tr,
                          backgroundColor: errorColor,
                          textColor: Colors.white,
                          withPading: true,
                          width: ConstantApp.getWidth(context) / 5,
                          height: ConstantApp.getHeight(context) / 15),
                      CustomAppButton(
                          onPressed: () async {
                            await Get.find<OrderController>()
                                .updateOrderSetting(PosSettingData(
                                    id: 1,
                                    orderW: orderW,
                                    productW: productW,
                                    subW: subW,
                                    mainW: mainW,
                                    productItem: productItem,
                                    mainItem: mainItem,
                                    subItem: subItem,
                                    showMain: showMain,
                                    showSub: showSub,));
                            Get.back();
                            setState(() {});
                          },
                          title: 'Save'.tr,
                          backgroundColor: primaryColor,
                          textColor: textColor,
                          withPading: true,
                          width: ConstantApp.getWidth(context) / 5,
                          height: ConstantApp.getHeight(context) / 15),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    orderW = controller.orderWidth.value;
    productW = controller.productWidth.value;
    mainW = controller.mainWidth.value;
    subW = controller.subWidth.value;
    productItem = controller.productItem.value;
    mainItem = controller.mainItem.value;
    subItem = controller.subItem.value;
    showMain = controller.showMain.value;
    showSub = controller.showSub.value;
    mainList.clear();
    productList.clear();
    subList.clear();

    for (int i = 1; i <= controller.productItem.value; i++) {
      productList.add('');
    }
    for (int i = 1; i <= controller.mainItem.value; i++) {
      mainList.add('');
    }
    for (int i = 1; i <= controller.subItem.value; i++) {
      subList.add('');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  getTotal() {
    total = orderW + productW + mainW + subW;
    setState(() {});
  }
}

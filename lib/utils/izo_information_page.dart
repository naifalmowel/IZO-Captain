import '/utils/Theme/colors.dart';
import '/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class IZOPage extends StatefulWidget {
  const IZOPage({super.key});

  @override
  IZOPageState createState() => IZOPageState();
}

class IZOPageState extends State<IZOPage> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                primaryColor,
                backgroundColorDropDown,
              ], begin: Alignment.topCenter, end: Alignment.center)),
            ),
            Image.asset('assets/images/IZO.png',
                width: width / 2.2,
                height: height / 2.2,
                fit: BoxFit.contain,
                opacity: const AlwaysStoppedAnimation(.5)),
          ],
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: height / 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Opacity(
                          opacity: 0.8,
                          child: CircleAvatar(
                            backgroundImage:
                                const AssetImage('assets/images/IZOLogo.jpg'),
                            radius: height / 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height / 2.5),
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: height / 3.5, left: width / 10, right: width / 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 2.0,
                                    offset: Offset(0.0, 2.0))
                              ]),
                          child: Padding(
                            padding: EdgeInsets.all(width / 20),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  headerChild(
                                      'https://wa.me/971501770199?text=Hello%2C%20i%20have%20a%20question%20about%20a%20product!',
                                      FontAwesomeIcons.whatsapp),
                                  headerChild(
                                      'https://goo.gl/maps/PdWotoMx9dYenaQy7',
                                      FontAwesomeIcons.locationDot),
                                ]),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: height / 30),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    infoChild(
                                        width: 20,
                                        icon: FontAwesomeIcons.globe,
                                        data: 'www.izo.ae',
                                        onTap: () {}),
                                    infoChild(
                                      icon: Icons.email,
                                      data: 'info@izo.ae',
                                      width: 20,
                                      onTap: () {},
                                    ),
                                    infoChild(
                                        width: 20,
                                        icon: Icons.call,
                                        data: '+971-50 177 0199',
                                        onTap: () {}),
                                    infoChild(
                                        width: 20,
                                        icon: Icons.location_on,
                                        data:
                                            ' United Arab Emirates, Dubai, Salah Alddin Road,Speedex Building, Floor M, Office M01'
                                                .tr,
                                        onTap: () {}),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.clear))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget headerChild(String data, IconData icon) => Column(
        children: [
          QrImageView(
            data: data,
            version: QrVersions.auto,
            size: 115,
          ),
          Icon(icon)
        ],
      );

  Widget infoChild(
          {required double width,
          required IconData icon,
          required String data,
          required VoidCallback onTap}) =>
      InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: primaryColor,
              size: ConstantApp.getTextSize(context) * 20,
            ),
            SizedBox(
              width: ConstantApp.getWidth(context) * 0.15,
              child: Text(
                data,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: ConstantApp.getTextSize(context) * 5,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );
}

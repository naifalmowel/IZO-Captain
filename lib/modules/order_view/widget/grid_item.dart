
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../../utils/constant.dart';

class GridItem extends StatelessWidget {
  const GridItem(
      {required this.name,
       this.price,
       this.onLongPress,
       this.color,
       this.maxLine,
       this.imageBytes,
       this.icon,
      required this.image,
      required this.onTap,
      super.key,});

  final String name;
  final String? price;
  final String image;
  final Callback onTap;
  final Callback? onLongPress;
  final Color? color;
  final int? maxLine;
  final  Uint8List? imageBytes;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      onLongPress: onLongPress,
      child: Card(
        elevation: 25,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white, width: 3.0),
              borderRadius: BorderRadius.circular(6.4)),
          child: GridTile(
            footer: GridTileBar(
              subtitle: price !=null &&  price!="0.0"?
              Text(
               "$price ${"AED".tr}",
                style: const TextStyle(fontSize: 15,),
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
              ):const SizedBox(),
                backgroundColor: Colors.black45,
                title: Tooltip(
                  message:name ,
                  child: Column(
                    children: [
                      icon != null &&
                          icon != FontAwesomeIcons.ban
                          ? Icon(
                        icon,
                        color: Colors.white,
                        size: ConstantApp.getTextSize(context) * 15,
                      )
                          : const SizedBox(),
                      Text(
                        name,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 15,),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )),
            child: color != null && image ==""&& imageBytes!.isEmpty?
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: color,
              ),
            ):
            imageBytes!.isNotEmpty?
            FadeInImage(
              image: MemoryImage(imageBytes!),
              placeholder: const AssetImage('assets/images/noImage.jpg'),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/noImage.jpg', fit: BoxFit.cover);
              },
              fit: BoxFit.cover,
            ):
            FadeInImage(
              image: FileImage(File('assets/images/noImage.jpg')),
              placeholder: const AssetImage('assets/images/noImage.jpg'),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/noImage.jpg', fit: BoxFit.cover);
              },
              fit: BoxFit.cover,
            )
            ),
          )
    );
  }
}

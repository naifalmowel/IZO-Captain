import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DefaultLoader extends StatelessWidget {
  const DefaultLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SpinKitCircle(
      color: Color(0xff0BABA5),
    );
  }
}
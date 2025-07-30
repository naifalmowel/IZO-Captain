import 'package:flutter/material.dart';

class Information {
  String? title;
  int? percentage;
  Color? color;
  double? total;
  double? payment;
  double? receipt;

  Information({
    this.total,
    this.title,
    this.percentage,
    this.color,
    this.payment,
    this.receipt,
  });
}

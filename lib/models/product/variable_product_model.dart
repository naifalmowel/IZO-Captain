
import 'dart:typed_data';

class ProductVariableModel {
  ProductVariableModel(
      { this.id,
        this.image,
        this.price,
        this.name,
        this.size,
        this.proId,
        this.barcode,
        this.color,
        this.code,
        this.date,
        this.recipeId,
       });
  int? id;
  int? proId;
  int? recipeId;
  String? name;
  Uint8List? image;
  double? price;
  String? color;
  String? barcode;
  String? size;
  String? code;
  DateTime? date;
}

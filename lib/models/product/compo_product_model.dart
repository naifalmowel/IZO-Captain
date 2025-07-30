
import 'dart:typed_data';

class ProductCompoModel {
  ProductCompoModel(
      { this.id,
        this.image,
        this.price,
        this.arName,
        this.unit,
        this.proId,
        this.barcode,
        this.childId,
        this.enName,
        this.date,
        this.qty,
        this.variableId,
        this.recipeId,
      });
  int? id;
  int? proId;
  int? childId;
  double? qty;
  String? enName;
  String? arName;
  Uint8List? image;
  int? unit;
  int? variableId;
  int? recipeId;
  double? price;
  String? barcode;
  DateTime? date;
}

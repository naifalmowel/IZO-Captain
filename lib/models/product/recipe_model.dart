import 'dart:typed_data';

class RecipeModel {
  RecipeModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.idParent,
    required this.idChild,
    required this.qty,
    required this.image,
    required this.price,
    required this.variableId,
    required this.barcode,
    required this.recipeId,
  });

  int id;
  String name;
  Uint8List? image;
  int unit;
  int idParent;
  int idChild;
  double qty;
  int? variableId;
  int? recipeId;
  double? price;
  String? barcode;
}

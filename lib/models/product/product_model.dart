import 'dart:typed_data';

class ProductModel {
  ProductModel(
      { this.id,
      this.englishName,
       this.image,
       this.price,
      this.description,
       this.subId,
       this.code,
       this.arabicName,
      this.type,
      this.unit,
      this.barcode,
      this.barcode2,
      this.barcode3,
      this.mainId,
        this.vat,
        this.variableId,
        this.vatId,
        this.forSale,
        this.price3,
        this.unitId,
        this.price2,
        this.unit2,
        this.unit3,
        this.qty,
        this.recipeId,
        this.colorProduct,

        this.costPrice,
        this.maxPrice3,
        this.maxPrice2,
        this.maxPrice,
        this.minPrice3,
        this.wholePrice3,
        this.wholePrice2,
        this.wholePrice,
        this.costPrice2,
        this.costPrice3,
        this.minPrice,
        this.minPrice2,


      });
  int? id;
  String? englishName;
  String? arabicName;
  Uint8List? image;
  String? price;
  String? price2;
  String? price3;
  String? description;
  String? code;
  String? subId;
  String? mainId;
  String? type;
  int? unitId;
  int? unit;
  int? unit2;
  int? unit3;
  String? barcode;
  String? barcode2;
  String? barcode3;
  int? variableId;
  double? vat;
  double? qty;
  int? vatId;
  bool? forSale;
  int? recipeId;
  String? colorProduct;

  double? wholePrice;
  double? wholePrice2;
  double? wholePrice3;
  double? minPrice;
  double? minPrice2;
  double? minPrice3;
  double? maxPrice;
  double? maxPrice2;
  double? maxPrice3;
  double? costPrice;
  double? costPrice2;
  double? costPrice3;
}

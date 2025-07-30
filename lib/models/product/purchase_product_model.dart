
import 'dart:typed_data';

class ProductPurchaseModel {
  ProductPurchaseModel(
      {
        this.productId,
        this.id,
        this.name,
        this.priceExcVat,
        this.priceIncVat,
        this.priceExcVatAfterDis,
        required this.priceIncVatAfterDis,
        this.discountFix,
        this.discountPercentage,
        required this.qty,
        required this.totalPrice,
        required this.image,
        required this.variableId,
        required this.vatId,
        this.purchaseId,
        this.unit,
      });
  int? id;
  int? productId;
  String? name;
  Uint8List? image;
  double? priceIncVat;
  double? priceExcVat;
  double? priceExcVatAfterDis;
  double priceIncVatAfterDis;
  double? discountFix;
  double? discountPercentage;
  double totalPrice;
  double qty;
  int vatId;
  int? unit;
  int? variableId;
  int? purchaseId;
}
class ProductSalesModel {
  ProductSalesModel(
      {
        this.productId,
        this.id,
        this.name,
        this.priceExcVat,
        this.priceIncVat,
        this.priceExcVatAfterDis,
        required this.priceIncVatAfterDis,
        this.discountFix,
        this.discountPercentage,
        required this.qty,
        required this.totalPrice,
        required this.image,
        required this.variableId,
        required this.vatId,
        required this.cateId,
        this.unit,
        this.printerName,
        this.payType,
        this.recipeId,
        this.productType,
        this.sectionId,
      });
  int? id;
  int? productId;
  String? name;
  Uint8List? image;
  double? priceIncVat;
  double? priceExcVat;
  double? priceExcVatAfterDis;
  double priceIncVatAfterDis;
  double? discountFix;
  double? discountPercentage;
  double totalPrice;
  double qty;
  int vatId;
  int? unit;
  int? variableId;
  int? sectionId;
  int? recipeId;
  String? printerName;
  String? payType;
  String? productType;
  int cateId;
}
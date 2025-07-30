class OrderModel {
  OrderModel({
    this.id,
    required this.name,
    required this.arabicName,
    required this.quantity,
    required this.price,
    required this.itemId,
    required this.createdAt,
    required this.totalPrice,
    this.serial,
    required this.guest,
    required this.table,
    required this.hall,
    required this.ident,
    required this.note,
    required this.unitId,
    this.variableId,
    this.recipeId,
    required this.vatId,
    required this.catId,
    this.billNum,
    this.sectionId,
    this.productType,
    this.costPrice,
    this.maxPrice,
    this.minPrice,
    this.wholePrice2,
    this.minPrice2,
    this.wholePrice,
    this.costPrice3,
    this.costPrice2,
    this.wholePrice3,
    this.minPrice3,
    this.maxPrice2,
    this.maxPrice3,
    this.firstPrice,
    this.commission,
    this.employeeId,
    this.salesType,
  });

  int? id;
  String name;
  String arabicName;
  double quantity;
  double price;
  int itemId;
  DateTime createdAt;
  double totalPrice;
  int? serial;
  int? variableId;
  int? recipeId;
  int? vatId;
  int? unitId;
  int? sectionId;
  int? employeeId;
  String guest;
  String table;
  String hall;
  String ident;
  String? note;
  String? billNum;
  String? productType;
  String? catId;
  String? salesType;
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
  double? firstPrice;
  double? commission;
}

class OrderItem {
  OrderItem({
    required this.id,
    required this.orderDate,
    required this.orders,
    this.finishDate,
    this.type,
    this.readyDate,
  });

  final int id;
  final DateTime orderDate;
  DateTime? readyDate;
  DateTime? finishDate;
  String? type;
  final List<OrderModel> orders;
}

class OrderKitchen {
  OrderKitchen({
    required this.id,
    required this.orderDate,
    required this.orders,
    required this.hall,
    required this.table,
  });

  final int id;
  final DateTime orderDate;
  final String hall;
  final String table;
  final List<OrderModel> orders;
}

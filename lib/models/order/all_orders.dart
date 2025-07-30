class AllOrdersModel {
  AllOrdersModel({
    required this.id,
    required this.cashier,
    required this.name,
    required this.price,
    required this.qyt,
    required this.gusts,
    required this.numberOfBill,
    required this.numberOfOrder,
    required this.createdAt,
  });

  int? id;
  String cashier;
  String name;
  double price;
  int qyt;
  String gusts;
  int numberOfBill;
  int numberOfOrder;
  DateTime createdAt;
}

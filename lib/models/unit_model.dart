class UnitModel {
  int id;
  String name;
  String arabicName;
  double qty;
  int source;
  bool acceptsDecimal;
  DateTime createdAt;

  UnitModel({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.qty,
    required this.source,
    required this.acceptsDecimal,
    required this.createdAt,
  });
}

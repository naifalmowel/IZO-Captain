class TableModel {
  TableModel({
    required this.number,
    required this.hall,
    required this.voidAmount,
    required this.cost,
    required this.waitCustomer,
    required this.time,
    required this.bookingTable,

    required this.bookingDate,
    required this.customerId,
    this.deliveryName,
    this.deliveryId,
    this.guestName,
    this.guestMobile,
    this.guestNo,
    this.cashierName,
    this.formatNumber,
  });
  String number;
  String hall;
  String? deliveryName;
  int? deliveryId;
  int? customerId;
  String? guestName;
  String? guestMobile;
  String? guestNo;
  String? cashierName;
  String? formatNumber;
  double? voidAmount;
  double cost;
  bool? waitCustomer;
  bool? bookingTable;
  DateTime? time;
  DateTime? bookingDate;
}

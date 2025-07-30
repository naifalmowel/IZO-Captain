class BillModel {
  BillModel({
    required this.id,
    required this.finalTotal,
    required this.visaAmount,
    required this.cashAmount,
    required this.hall,
    required this.table,
    required this.billNum,
    required this.cashierName,
    required this.customerName,
    required this.date,
    required this.subtotal,
    required this.type,
  });

  int id;
  String billNum;
  double subtotal;
  double finalTotal;
  double cashAmount;
  double visaAmount;
  String customerName;
  String cashierName;
  String hall;
  String table;
  String type;
  DateTime date;
}

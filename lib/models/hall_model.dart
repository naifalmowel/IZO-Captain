import '/models/table_model.dart';

class HallModel {
  HallModel({
    required this.tables,
    required this.name,
    required this.id,
    required this.tableCount,
    required this.users,
  });

  int id;
  int tableCount;
  String name;
  List<TableModel> tables;
  List<String?>? users;
}
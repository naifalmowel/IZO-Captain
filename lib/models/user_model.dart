class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.password,
    required this.type,
    required this.isActive,
    required this.discount,
  });

  int id;

  String name;

  String type;
  String password;
  bool isActive;
  double discount;
}

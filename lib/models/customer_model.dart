class CustomerModel {
  int id;
  String firstName;
  String lastName;
  String businessName;
  String code;
  List<String> address;
  List<String> mobileList;
  String city;
  String email;
  String type;
  DateTime createAt;

  CustomerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.businessName,
    required this.code,
    required this.address,
    required this.mobileList,
    required this.city,
    required this.email,
    required this.type,
    required this.createAt,
  });
}

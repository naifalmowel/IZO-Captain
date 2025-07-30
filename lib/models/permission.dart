class PermissionModel{

  int id;
  int userId;
  bool addContact;
  bool  voidPer;
  bool  viewDriver;
  bool  takeAway;
  bool delivery;
  bool dineIn;
  bool kitchen;
  bool tableChange;
  bool viewGuest;

  PermissionModel({
    required this.id,
    required this.userId,
    required this.addContact,
    required this.voidPer,
    required this.viewDriver,
    required this.takeAway,
    required this.delivery,
    required this.dineIn,
    required this.kitchen,
    required this.tableChange,
    required this.viewGuest,
});
}
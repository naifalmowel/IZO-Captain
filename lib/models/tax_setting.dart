class TaxSettingModel {
  TaxSettingModel({
    required this.id,
    required this.every,
    required this.createAt,
    required this.createBy,
    required this.taxId,
    required this.taxNumber,
    required this.taxType,
  });
  int? id;
  int? taxId;
  int? every;
  String? taxNumber;
  String? taxType;
  String? createBy;
  DateTime? createAt;
}

class TaxSettingDrift {
  int id;
  int taxId;
  int every;
  String taxNumber;
  String taxType;
  String createBy;
  DateTime createAt;
  DateTime? fromPeriod1;
  DateTime? tillPeriod1;

  TaxSettingDrift({
    required this.id,
    required this.taxId,
    required this.every,
    required this.taxNumber,
    required this.taxType,
    required this.createBy,
    required this.createAt,
    required this.fromPeriod1,
    required this.tillPeriod1,
  });
}


import 'package:drift/drift.dart';

class PosSetting extends Table{
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderW => integer().nullable()();
  IntColumn get productW => integer().nullable()();
  IntColumn get subW => integer().nullable()();
  IntColumn get mainW => integer().nullable()();
  IntColumn get productItem => integer().nullable()();
  IntColumn get mainItem => integer().nullable()();
  IntColumn get subItem => integer().nullable()();
  BoolColumn get showMain => boolean().nullable()();
  BoolColumn get showSub => boolean().nullable()();
}

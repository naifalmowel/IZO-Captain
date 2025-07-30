import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:izo_captain/database/entity/pos_setting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';

part 'app_db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.mobile'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [
  PosSetting,
])
class AppDataBase extends _$AppDataBase {
  AppDataBase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await insertDb();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 3) {}
      },
      beforeOpen: (details) async {},
    );
  }

  void tryCatch(Future<void> fun) async {
    try {
      await fun;
    } catch (e) {
      debugPrint('ERROR MIGRATION');
    }
  }

  Future<void> insertDb() async {
    await into(posSetting).insertReturning(const PosSettingCompanion(
      id: Value(1),
      productItem: Value(4),
      mainItem: Value(1),
      subItem: Value(1),
      orderW: Value(5),
      productW: Value(3),
      mainW: Value(1),
      subW: Value(1),
      showMain: Value(true),
      showSub: Value(true),
    ));
  }

  Future insertPosSetting(PosSettingCompanion mov) =>
      into(posSetting).insert(mov);

  Future updatePosSetting(PosSettingData acc) =>
      update(posSetting).replace(acc);

  // Future deletePosSetting(int idMove) async {
  //   await (delete(posSetting)..where((tbl) => tbl.id.equals(idMove))).go();
  // }

  Future<PosSettingData> getPosSetting() async {
    final query = select(posSetting)..where((company) => company.id.equals(1));
    return await query.getSingle();
  }

}

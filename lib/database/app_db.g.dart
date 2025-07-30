// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $PosSettingTable extends PosSetting
    with TableInfo<$PosSettingTable, PosSettingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PosSettingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderWMeta = const VerificationMeta('orderW');
  @override
  late final GeneratedColumn<int> orderW = GeneratedColumn<int>(
      'order_w', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _productWMeta =
      const VerificationMeta('productW');
  @override
  late final GeneratedColumn<int> productW = GeneratedColumn<int>(
      'product_w', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _subWMeta = const VerificationMeta('subW');
  @override
  late final GeneratedColumn<int> subW = GeneratedColumn<int>(
      'sub_w', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _mainWMeta = const VerificationMeta('mainW');
  @override
  late final GeneratedColumn<int> mainW = GeneratedColumn<int>(
      'main_w', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _productItemMeta =
      const VerificationMeta('productItem');
  @override
  late final GeneratedColumn<int> productItem = GeneratedColumn<int>(
      'product_item', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _mainItemMeta =
      const VerificationMeta('mainItem');
  @override
  late final GeneratedColumn<int> mainItem = GeneratedColumn<int>(
      'main_item', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _subItemMeta =
      const VerificationMeta('subItem');
  @override
  late final GeneratedColumn<int> subItem = GeneratedColumn<int>(
      'sub_item', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _showMainMeta =
      const VerificationMeta('showMain');
  @override
  late final GeneratedColumn<bool> showMain = GeneratedColumn<bool>(
      'show_main', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_main" IN (0, 1))'));
  static const VerificationMeta _showSubMeta =
      const VerificationMeta('showSub');
  @override
  late final GeneratedColumn<bool> showSub = GeneratedColumn<bool>(
      'show_sub', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_sub" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderW,
        productW,
        subW,
        mainW,
        productItem,
        mainItem,
        subItem,
        showMain,
        showSub
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pos_setting';
  @override
  VerificationContext validateIntegrity(Insertable<PosSettingData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_w')) {
      context.handle(_orderWMeta,
          orderW.isAcceptableOrUnknown(data['order_w']!, _orderWMeta));
    }
    if (data.containsKey('product_w')) {
      context.handle(_productWMeta,
          productW.isAcceptableOrUnknown(data['product_w']!, _productWMeta));
    }
    if (data.containsKey('sub_w')) {
      context.handle(
          _subWMeta, subW.isAcceptableOrUnknown(data['sub_w']!, _subWMeta));
    }
    if (data.containsKey('main_w')) {
      context.handle(
          _mainWMeta, mainW.isAcceptableOrUnknown(data['main_w']!, _mainWMeta));
    }
    if (data.containsKey('product_item')) {
      context.handle(
          _productItemMeta,
          productItem.isAcceptableOrUnknown(
              data['product_item']!, _productItemMeta));
    }
    if (data.containsKey('main_item')) {
      context.handle(_mainItemMeta,
          mainItem.isAcceptableOrUnknown(data['main_item']!, _mainItemMeta));
    }
    if (data.containsKey('sub_item')) {
      context.handle(_subItemMeta,
          subItem.isAcceptableOrUnknown(data['sub_item']!, _subItemMeta));
    }
    if (data.containsKey('show_main')) {
      context.handle(_showMainMeta,
          showMain.isAcceptableOrUnknown(data['show_main']!, _showMainMeta));
    }
    if (data.containsKey('show_sub')) {
      context.handle(_showSubMeta,
          showSub.isAcceptableOrUnknown(data['show_sub']!, _showSubMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PosSettingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PosSettingData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderW: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_w']),
      productW: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_w']),
      subW: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sub_w']),
      mainW: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}main_w']),
      productItem: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_item']),
      mainItem: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}main_item']),
      subItem: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sub_item']),
      showMain: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_main']),
      showSub: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_sub']),
    );
  }

  @override
  $PosSettingTable createAlias(String alias) {
    return $PosSettingTable(attachedDatabase, alias);
  }
}

class PosSettingData extends DataClass implements Insertable<PosSettingData> {
  final int id;
  final int? orderW;
  final int? productW;
  final int? subW;
  final int? mainW;
  final int? productItem;
  final int? mainItem;
  final int? subItem;
  final bool? showMain;
  final bool? showSub;
  const PosSettingData(
      {required this.id,
      this.orderW,
      this.productW,
      this.subW,
      this.mainW,
      this.productItem,
      this.mainItem,
      this.subItem,
      this.showMain,
      this.showSub});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || orderW != null) {
      map['order_w'] = Variable<int>(orderW);
    }
    if (!nullToAbsent || productW != null) {
      map['product_w'] = Variable<int>(productW);
    }
    if (!nullToAbsent || subW != null) {
      map['sub_w'] = Variable<int>(subW);
    }
    if (!nullToAbsent || mainW != null) {
      map['main_w'] = Variable<int>(mainW);
    }
    if (!nullToAbsent || productItem != null) {
      map['product_item'] = Variable<int>(productItem);
    }
    if (!nullToAbsent || mainItem != null) {
      map['main_item'] = Variable<int>(mainItem);
    }
    if (!nullToAbsent || subItem != null) {
      map['sub_item'] = Variable<int>(subItem);
    }
    if (!nullToAbsent || showMain != null) {
      map['show_main'] = Variable<bool>(showMain);
    }
    if (!nullToAbsent || showSub != null) {
      map['show_sub'] = Variable<bool>(showSub);
    }
    return map;
  }

  PosSettingCompanion toCompanion(bool nullToAbsent) {
    return PosSettingCompanion(
      id: Value(id),
      orderW:
          orderW == null && nullToAbsent ? const Value.absent() : Value(orderW),
      productW: productW == null && nullToAbsent
          ? const Value.absent()
          : Value(productW),
      subW: subW == null && nullToAbsent ? const Value.absent() : Value(subW),
      mainW:
          mainW == null && nullToAbsent ? const Value.absent() : Value(mainW),
      productItem: productItem == null && nullToAbsent
          ? const Value.absent()
          : Value(productItem),
      mainItem: mainItem == null && nullToAbsent
          ? const Value.absent()
          : Value(mainItem),
      subItem: subItem == null && nullToAbsent
          ? const Value.absent()
          : Value(subItem),
      showMain: showMain == null && nullToAbsent
          ? const Value.absent()
          : Value(showMain),
      showSub: showSub == null && nullToAbsent
          ? const Value.absent()
          : Value(showSub),
    );
  }

  factory PosSettingData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PosSettingData(
      id: serializer.fromJson<int>(json['id']),
      orderW: serializer.fromJson<int?>(json['orderW']),
      productW: serializer.fromJson<int?>(json['productW']),
      subW: serializer.fromJson<int?>(json['subW']),
      mainW: serializer.fromJson<int?>(json['mainW']),
      productItem: serializer.fromJson<int?>(json['productItem']),
      mainItem: serializer.fromJson<int?>(json['mainItem']),
      subItem: serializer.fromJson<int?>(json['subItem']),
      showMain: serializer.fromJson<bool?>(json['showMain']),
      showSub: serializer.fromJson<bool?>(json['showSub']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderW': serializer.toJson<int?>(orderW),
      'productW': serializer.toJson<int?>(productW),
      'subW': serializer.toJson<int?>(subW),
      'mainW': serializer.toJson<int?>(mainW),
      'productItem': serializer.toJson<int?>(productItem),
      'mainItem': serializer.toJson<int?>(mainItem),
      'subItem': serializer.toJson<int?>(subItem),
      'showMain': serializer.toJson<bool?>(showMain),
      'showSub': serializer.toJson<bool?>(showSub),
    };
  }

  PosSettingData copyWith(
          {int? id,
          Value<int?> orderW = const Value.absent(),
          Value<int?> productW = const Value.absent(),
          Value<int?> subW = const Value.absent(),
          Value<int?> mainW = const Value.absent(),
          Value<int?> productItem = const Value.absent(),
          Value<int?> mainItem = const Value.absent(),
          Value<int?> subItem = const Value.absent(),
          Value<bool?> showMain = const Value.absent(),
          Value<bool?> showSub = const Value.absent()}) =>
      PosSettingData(
        id: id ?? this.id,
        orderW: orderW.present ? orderW.value : this.orderW,
        productW: productW.present ? productW.value : this.productW,
        subW: subW.present ? subW.value : this.subW,
        mainW: mainW.present ? mainW.value : this.mainW,
        productItem: productItem.present ? productItem.value : this.productItem,
        mainItem: mainItem.present ? mainItem.value : this.mainItem,
        subItem: subItem.present ? subItem.value : this.subItem,
        showMain: showMain.present ? showMain.value : this.showMain,
        showSub: showSub.present ? showSub.value : this.showSub,
      );
  @override
  String toString() {
    return (StringBuffer('PosSettingData(')
          ..write('id: $id, ')
          ..write('orderW: $orderW, ')
          ..write('productW: $productW, ')
          ..write('subW: $subW, ')
          ..write('mainW: $mainW, ')
          ..write('productItem: $productItem, ')
          ..write('mainItem: $mainItem, ')
          ..write('subItem: $subItem, ')
          ..write('showMain: $showMain, ')
          ..write('showSub: $showSub')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderW, productW, subW, mainW,
      productItem, mainItem, subItem, showMain, showSub);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PosSettingData &&
          other.id == this.id &&
          other.orderW == this.orderW &&
          other.productW == this.productW &&
          other.subW == this.subW &&
          other.mainW == this.mainW &&
          other.productItem == this.productItem &&
          other.mainItem == this.mainItem &&
          other.subItem == this.subItem &&
          other.showMain == this.showMain &&
          other.showSub == this.showSub);
}

class PosSettingCompanion extends UpdateCompanion<PosSettingData> {
  final Value<int> id;
  final Value<int?> orderW;
  final Value<int?> productW;
  final Value<int?> subW;
  final Value<int?> mainW;
  final Value<int?> productItem;
  final Value<int?> mainItem;
  final Value<int?> subItem;
  final Value<bool?> showMain;
  final Value<bool?> showSub;
  const PosSettingCompanion({
    this.id = const Value.absent(),
    this.orderW = const Value.absent(),
    this.productW = const Value.absent(),
    this.subW = const Value.absent(),
    this.mainW = const Value.absent(),
    this.productItem = const Value.absent(),
    this.mainItem = const Value.absent(),
    this.subItem = const Value.absent(),
    this.showMain = const Value.absent(),
    this.showSub = const Value.absent(),
  });
  PosSettingCompanion.insert({
    this.id = const Value.absent(),
    this.orderW = const Value.absent(),
    this.productW = const Value.absent(),
    this.subW = const Value.absent(),
    this.mainW = const Value.absent(),
    this.productItem = const Value.absent(),
    this.mainItem = const Value.absent(),
    this.subItem = const Value.absent(),
    this.showMain = const Value.absent(),
    this.showSub = const Value.absent(),
  });
  static Insertable<PosSettingData> custom({
    Expression<int>? id,
    Expression<int>? orderW,
    Expression<int>? productW,
    Expression<int>? subW,
    Expression<int>? mainW,
    Expression<int>? productItem,
    Expression<int>? mainItem,
    Expression<int>? subItem,
    Expression<bool>? showMain,
    Expression<bool>? showSub,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderW != null) 'order_w': orderW,
      if (productW != null) 'product_w': productW,
      if (subW != null) 'sub_w': subW,
      if (mainW != null) 'main_w': mainW,
      if (productItem != null) 'product_item': productItem,
      if (mainItem != null) 'main_item': mainItem,
      if (subItem != null) 'sub_item': subItem,
      if (showMain != null) 'show_main': showMain,
      if (showSub != null) 'show_sub': showSub,
    });
  }

  PosSettingCompanion copyWith(
      {Value<int>? id,
      Value<int?>? orderW,
      Value<int?>? productW,
      Value<int?>? subW,
      Value<int?>? mainW,
      Value<int?>? productItem,
      Value<int?>? mainItem,
      Value<int?>? subItem,
      Value<bool?>? showMain,
      Value<bool?>? showSub}) {
    return PosSettingCompanion(
      id: id ?? this.id,
      orderW: orderW ?? this.orderW,
      productW: productW ?? this.productW,
      subW: subW ?? this.subW,
      mainW: mainW ?? this.mainW,
      productItem: productItem ?? this.productItem,
      mainItem: mainItem ?? this.mainItem,
      subItem: subItem ?? this.subItem,
      showMain: showMain ?? this.showMain,
      showSub: showSub ?? this.showSub,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderW.present) {
      map['order_w'] = Variable<int>(orderW.value);
    }
    if (productW.present) {
      map['product_w'] = Variable<int>(productW.value);
    }
    if (subW.present) {
      map['sub_w'] = Variable<int>(subW.value);
    }
    if (mainW.present) {
      map['main_w'] = Variable<int>(mainW.value);
    }
    if (productItem.present) {
      map['product_item'] = Variable<int>(productItem.value);
    }
    if (mainItem.present) {
      map['main_item'] = Variable<int>(mainItem.value);
    }
    if (subItem.present) {
      map['sub_item'] = Variable<int>(subItem.value);
    }
    if (showMain.present) {
      map['show_main'] = Variable<bool>(showMain.value);
    }
    if (showSub.present) {
      map['show_sub'] = Variable<bool>(showSub.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PosSettingCompanion(')
          ..write('id: $id, ')
          ..write('orderW: $orderW, ')
          ..write('productW: $productW, ')
          ..write('subW: $subW, ')
          ..write('mainW: $mainW, ')
          ..write('productItem: $productItem, ')
          ..write('mainItem: $mainItem, ')
          ..write('subItem: $subItem, ')
          ..write('showMain: $showMain, ')
          ..write('showSub: $showSub')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDataBase extends GeneratedDatabase {
  _$AppDataBase(QueryExecutor e) : super(e);
  late final $PosSettingTable posSetting = $PosSettingTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [posSetting];
}

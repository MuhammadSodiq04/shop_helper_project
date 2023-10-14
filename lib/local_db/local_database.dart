import 'package:flutter/cupertino.dart';
import 'package:shop_helper_project/model/product_model.dart';
import 'package:shop_helper_project/model/universal_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._init();

  LocalDatabase._init();

  factory LocalDatabase() {
    return getInstance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("student.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    const intType = "INTEGER DEFAULT 0";

    await db.execute('''
    CREATE TABLE ${ProductModelFields.tableName} (
    ${ProductModelFields.id} $idType,
    ${ProductModelFields.name} $textType,
    ${ProductModelFields.count} $intType,
    ${ProductModelFields.code} $textType
    )
    ''');

    debugPrint("-------DB----------CREATED---------");
  }

  static Future<void> insertProduct(
      ProductModel productModel) async {
    final db = await getInstance.database;
    await db.insert(ProductModelFields.tableName, productModel.toJson());
  }

  static Future<UniversalData> getAllProduct() async {
    final db = await getInstance.database;
    return UniversalData(data: (await db.query(ProductModelFields.tableName))
        .map((e) => ProductModel.fromJson(e))
        .toList());
  }


  static Future<void> updateProduct({required ProductModel productModel}) async {
    final db = await getInstance.database;
    db.update(
      ProductModelFields.tableName,
      productModel.toJson(),
      where: "${ProductModelFields.id} = ?",
      whereArgs: [productModel.id],
    );
  }

  static Future<void> deleteProduct(int id) async {
    final db = await getInstance.database;
    await db.delete(
      ProductModelFields.tableName,
      where: "${ProductModelFields.id} = ?",
      whereArgs: [id],
    );
  }

}
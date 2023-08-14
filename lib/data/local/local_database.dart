import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:user_locations/data/model/adress_model.dart';

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
      _database = await _initDB("address.db");
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

    await db.execute('''
    CREATE TABLE ${AddressModelFields.tableName} (
    ${AddressModelFields.id} $idType,
    ${AddressModelFields.address} $textType,
    ${AddressModelFields.lat} $textType,
    ${AddressModelFields.long} $textType
    )
    ''');

    debugPrint("-------DB----------CREATED---------");
  }

  static Future<AddressModel> insertAddress(
      AddressModel addressModel) async {
    final db = await getInstance.database;
    final int id = await db.insert(
        AddressModelFields.tableName, addressModel.toJson());
    return addressModel.copyWith(id: id);
  }

  static Future<List<AddressModel>> getAllAddress() async {
    List<AddressModel> allAddress = [];
    final db = await getInstance.database;
    allAddress = (await db.query(AddressModelFields.tableName))
        .map((e) => AddressModel.fromJson(e))
        .toList();

    return allAddress;
  }

  // static updateNewsAuthor({required int id, required String author}) async {
  //   final db = await getInstance.database;
  //   db.update(
  //     NewsModelFields.table_name,
  //     {NewsModelFields.author: author},
  //     where: "${NewsModelFields.id} = ?",
  //     whereArgs: [id],
  //   );
  // }

  static updateAddress({required AddressModel addressModel}) async {
    final db = await getInstance.database;
    print("Failed SQL");
    await db.update(AddressModelFields.tableName, addressModel.toJson(), where: '${AddressModelFields.id}=?', whereArgs: [addressModel.id]);
    // db.update(
    //   AddressModelFields.tableName,
    //   addressModel.toJson(),
    //   where: "${AddressModelFields.id} = ?",
    //   whereArgs: [addressModel.id],
    // );
    print("Update SQL");
  }

  static Future<int> deleteAddress(int id) async {
    final db = await getInstance.database;
    int count = await db.delete(
    AddressModelFields.tableName,
      where: "${AddressModelFields.id} = ?",
      whereArgs: [id],
    );
    return count;
  }
}
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final _dbName = "terminalDb.db";
  static final _dbVersion = 1;

  DbHelper._privateConstructor();

  static final DbHelper instance = DbHelper._privateConstructor();

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await _initDb();
    return _db;
  }

  _initDb() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Users (
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        PIN INTEGER,
        KISI TEXT,
        BIRIM TEXT,
        PLAKA TEXT,
        ADMIN INTEGER,
        KARTDEC TEXT,
        KARTHEX TEXT,
        KARTTHEX TEXT,
        FACE TEXT
      )
      ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Transactions (
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        PIN INTEGER,
        DATE TEXT,
        ISLEM INTEGER
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> select(String table,
      {String where, List<Object> whereArgs}) async {
    Database db = await instance.db;
    return await db.query(table,
        where: where ?? null, whereArgs: whereArgs ?? null);
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    Database db = await instance.db;
    return db.insert(table, values);
  }

  Future<int> update(String table, int id, Map<String, dynamic> values) async {
    Database db = await instance.db;
    return db.update(table, values, where: "ID = ?", whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    Database db = await instance.db;
    return db.delete(table, where: "ID = ?", whereArgs: [id]);
  }

  Future<int> count(String table,
      {String where, List<Object> whereArgs}) async {
    Database db = await instance.db;
    var result = await db.query(table,
        where: where ?? null, whereArgs: whereArgs ?? null);
    return result.length;
  }

  /*
  Future<int> insert(String table, Map<String, dynamic> value) async {
    Database db = await instance.db;
    return await db.insert(table, value);
  }

  Future<int> update(String table, Map<String, dynamic> value) async {
    Database db = await instance.db;
    int id = value["id"];
    return await db.update(table, value, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    Database db = await instance.db;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
  */
}

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "database.db";
  static const _databaseVersion = 3;

  static const tableInventory = 'Inventaire';
  static const tableProduct = 'Produit';

  static const inventoryId = '_id';
  static const inventoryName = 'nom';
  static const productId = '_id';
  static const productName = 'nom';
  static const productQuantity = 'quantite';
  static const productInventoryExtKey = 'id_';
  static String path = "";

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _createTables);
  }

  // SQL code to create the database table
  Future _createTables(Database db, int version) async {
    print("test");
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableInventory (
            $inventoryId INTEGER PRIMARY KEY,
            $inventoryName TEXT NOT NULL
          )
        ''');
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableProduct (
            $productId INTEGER PRIMARY KEY,
            $productName TEXT NOT NULL,
            $productQuantity INTEGER NOT NULL,
            $productInventoryExtKey INTEGER NOT NULL
          )
        ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(table, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllInventory() async {
    Database? db = await instance.database;
    return await db!.query(DatabaseHelper.tableInventory);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryInventory(id) async {
    Database? db = await instance.database;
    return await db!.rawQuery('SELECT * FROM $tableInventory WHERE $inventoryId=$id');
  }

  Future<List<Map<String, dynamic>>> queryAllProducts(id) async {
    Database? db = await instance.database;
    return await db!.rawQuery('SELECT * FROM $tableProduct WHERE $productInventoryExtKey=$id');
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  /*Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!
        .update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }*/
  /*
  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }*/
}
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/inventory.dart';
import '../models/product.dart';

class DatabaseHelper {
  static const String _databaseName = "myDatabase.db";
  static const int _databaseVersion = 3;

  static const String tableInventory = 'Inventaire';
  static const String tableProduct = 'Produit';

  static const String inventoryId = '_id';
  static const String inventoryName = 'nom';
  static const String productId = '_id';
  static const String productName = 'nom';
  static const String productQuantity = 'quantite';
  static const String productInventoryExtKey = 'id_inventaire';
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
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  /// Renvoie tous les inventaires
  Future<List<Inventory>> queryAllInventories() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> tmp = await db!.query(DatabaseHelper.tableInventory);
    List<Inventory> result = [];
    for (var element in tmp) {
      result.add(Inventory.fromJson(element));
    }
    return result;
  }

  /// Renvoie l'inventaire lié à l'id passé en paramètre
  Future<Inventory> queryInventory(int id) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> tmp = await db!.rawQuery('SELECT * FROM $tableInventory WHERE $inventoryId=$id');
    Inventory result = Inventory.fromJson(tmp[0]);
    return result;
  }

  /// Renvoie les Produits liés à l'id d'un inventaire
  Future<List<Product>> queryAllProducts(int id) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> tmp = await db!.rawQuery('SELECT * FROM $tableProduct WHERE $productInventoryExtKey=$id');
    List<Product> result = [];
    for (var element in tmp) {
      result.add(Product.fromJson(element));
    }
    return result;
  }

  /// Renvoie les Produits liés à l'id d'un inventaire
  Future<Product> queryProduct(int id) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> tmp = await db!.rawQuery('SELECT * FROM $tableProduct WHERE $productId=$id');
    Product result = Product.fromJson(tmp[0]);
    return result;
  }
  
  /// Décrémente de 1 le produit lié à l'id passé en paramètre
  Future decrementQuantity(int id) async {
    Database? db = await instance.database;
    await db!.rawQuery('Update $tableProduct Set $productQuantity=$productQuantity-1 WHERE $productId=$id');
  }
  
  /// incrémente de 1 le produit lié à l'id passé en paramètre
  Future incrementQuantity(int id) async {
    Database? db = await instance.database;
    await db!.rawQuery('Update $tableProduct Set $productQuantity=$productQuantity+1 WHERE $productId=$id');
  }
  
  /// 
  Future updateProductName(int id, String name) async {
    Database? db = await instance.database;
    await db!.rawQuery('Update $tableProduct Set $productName="$name" WHERE $productId=$id');
  }

  ///
  Future updateInventoryName(int id, String name) async {
    Database? db = await instance.database;
    await db!.rawQuery('Update $tableInventory Set $inventoryName="$name" WHERE $inventoryId=$id');
  }

  ///
  Future deleteInventory(int id) async {
    Database? db = await instance.database;
    await db!.rawQuery('DELETE FROM $tableInventory WHERE $inventoryId=$id');
  }

  ///
  Future deleteProduct(int id) async {
    Database? db = await instance.database;
    await db!.rawQuery('DELETE FROM $tableProduct WHERE $productId=$id');
  }
}

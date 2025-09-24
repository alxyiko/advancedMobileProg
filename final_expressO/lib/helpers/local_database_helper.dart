import 'package:firebase_nexus/models/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLFliteDatabaseHelper {
  static final SQLFliteDatabaseHelper _instance = SQLFliteDatabaseHelper._internal();
  factory SQLFliteDatabaseHelper() => _instance;
  SQLFliteDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL, 
      price REAL NOT NULL,
      tags TEXT
      )
    ''');
  }

  
  //Insert Product
  Future<int> insertCart(String table, Product product) async {
    final db = await database;
    return await db.insert(
        'table', {...product.toMap()},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Insert Product
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert(
        'products', {...product.toMap()},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Get all Products
  Future<List<Product>> getCart() async {
    final db = await database;
    final result = await db.query('Cart');
    return result.map((map) {
      return Product.fromMap(
          {...map});
    }).toList();
  }

  //update product
  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
        'products', {...product.toMap()},
        where: 'id=?', whereArgs: [product.id]);
  }

  //delete product
  Future<int> deleteProduct(int? id) async {
    final db = await database;
    return await db.delete('products', where: 'id=?', whereArgs: [id]);
  }
}

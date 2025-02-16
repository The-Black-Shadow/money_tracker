import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  //Singeleton pattern to ensure only one instance of the db is created
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    // Get the path for the database
    String path = join(await getDatabasesPath(), 'money_trackerr.db');

    // Open or create the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the database schema
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        type TEXT,  -- 'income' or 'expense'
        date TEXT
      )
    ''');
  }

  // Insert a new transaction
  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    Database db = await database;
    return await db.insert('transactions', transaction);
  }

  // Fetch all transactions
  Future<List<Map<String, dynamic>>> getTransactions() async {
    Database db = await database;
    return await db.query('transactions');
  }

  // Delete a transaction by ID
  // Future<int> deleteTransaction(int id) async {
  //   Database db = await database;
  //   return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  // }
}

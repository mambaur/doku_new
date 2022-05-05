import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseInstance {
  final String _databaseName = "doku.db";
  final int _databaseVersion = 1;

  // Category Table
  final String categoryTable = 'categories';
  final String categoryId = 'id';
  final String categoryName = 'name';
  final String categoryType = 'type'; // {income, expense} (string)
  final String categoryCreatedAt = 'created_at';
  final String categoryUpdatedAt = 'updated_at';

  // Transaction Table
  final String transactionTable = 'transactions';
  final String transactionId = 'id';
  final String transactionDate = 'date';
  final String transactionNominal = 'nominal';
  final String transactionCategoryId = 'category_id';
  final String transactionNotes = 'notes';
  final String transactionCreatedAt = 'created_at';
  final String transactionUpdatedAt = 'updated_at';

  // only have a single app-wide reference to the database
  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $categoryTable (
            $categoryId INTEGER PRIMARY KEY,
            $categoryName TEXT NOT NULL,
            $categoryType TEXT NOT NULL,
            $categoryCreatedAt TEXT NOT NULL,
            $categoryUpdatedAt TEXT NOT NULL
          )
          ''');
    
    await db.execute('''
          CREATE TABLE $transactionTable (
            $transactionId INTEGER PRIMARY KEY,
            $transactionDate TEXT NOT NULL,
            $transactionNominal INTEGER NOT NULL,
            $transactionCategoryId INTEGER NOT NULL,
            $transactionNotes TEXT NOT NULL,
            $transactionCreatedAt TEXT NOT NULL,
            $transactionUpdatedAt TEXT NOT NULL
          )
          ''');
  }
}

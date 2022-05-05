import 'package:doku/database/database_instance.dart';
import 'package:sqflite/sqflite.dart';

class TransactionRepository{
  // reference to our single class that manages the database
  final dbInstance = DatabaseInstance();

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await dbInstance.database;
    return await db.insert(dbInstance.transactionTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await dbInstance.database;
    return await db.query(dbInstance.transactionTable);
  }
}
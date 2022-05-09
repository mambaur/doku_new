import 'package:doku/database/database_instance.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:sqflite/sqflite.dart';

class TransactionRepository {
  // reference to our single class that manages the database
  final dbInstance = DatabaseInstance();

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await dbInstance.database;
    return await db.insert(dbInstance.transactionTable, row);
  }

  Future<List<TransactionModel>> all() async {
    Database db = await dbInstance.database;
    final data = await db.query(
      dbInstance.transactionTable,
      orderBy: 'id desc',
      // where: type != null ? '"type" = ?' : null,
      // whereArgs: type != null ? [type] : null
    );
    List<TransactionModel> listTransactions =
        data.map((e) => TransactionModel.fromJson(e)).toList();
    return listTransactions;
  }

  Future<int?> queryRowCount() async {
    Database db = await dbInstance.database;
    return Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM ${dbInstance.transactionTable}'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await dbInstance.database;
    int id = row[dbInstance.transactionId];
    return await db.update(dbInstance.transactionTable, row,
        where: '${dbInstance.transactionId} = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await dbInstance.database;
    return await db.delete(dbInstance.transactionTable,
        where: '${dbInstance.transactionId} = ?', whereArgs: [id]);
  }
}

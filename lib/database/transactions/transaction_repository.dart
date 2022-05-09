import 'package:doku/database/database_instance.dart';
import 'package:doku/models/category_model.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:sqflite/sqflite.dart';

class TransactionRepository {
  // reference to our single class that manages the database
  final dbInstance = DatabaseInstance();

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await dbInstance.database;
    return await db.insert(dbInstance.transactionTable, row);
  }

  Future<List<TransactionModel>> all({String? type}) async {
    Database db = await dbInstance.database;
    String whereType = type != null
        ? 'AND ${dbInstance.categoryTable}.${dbInstance.categoryType}="$type"'
        : '';
    final data = await db.rawQuery(
        'SELECT ${dbInstance.transactionTable}.*, ${dbInstance.categoryTable}.${dbInstance.categoryName}, ${dbInstance.categoryTable}.${dbInstance.categoryType}, ${dbInstance.categoryTable}.${dbInstance.categoryDescription} FROM ${dbInstance.transactionTable} JOIN ${dbInstance.categoryTable} ON ${dbInstance.categoryTable}.${dbInstance.categoryId}=${dbInstance.transactionTable}.${dbInstance.transactionCategoryId} WHERE ${dbInstance.transactionTable}.${dbInstance.transactionDate} >= "2022-05-01" AND ${dbInstance.transactionTable}.${dbInstance.transactionDate} <= "2022-05-31" $whereType ORDER BY ${dbInstance.transactionTable}.${dbInstance.transactionId} DESC',
        []);

    List<TransactionModel> listTransactions = [];
    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        TransactionModel transactionModel = TransactionModel(
            id: int.parse(data[i]['id'].toString()),
            nominal: int.parse(data[i]['nominal'].toString()),
            date: data[i]['date'].toString(),
            notes: data[i]['notes'].toString(),
            category: CategoryModel(
              id: int.parse(data[i]['category_id'].toString()),
              name: data[i]['name'].toString(),
              description: data[i]['description'].toString(),
            ));
        listTransactions.add(transactionModel);
      }
    }

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

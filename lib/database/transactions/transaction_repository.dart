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

  Future<List<TransactionModel>> all(
      {String? type, int? limit, int? page}) async {
    // Setup pagination
    limit ??= 10;
    int offset = (limit * (page ?? 1)) - limit;

    Database db = await dbInstance.database;
    String whereType = type != null
        ? 'AND ${dbInstance.categoryTable}.${dbInstance.categoryType}="$type"'
        : '';
    final data = await db.rawQuery(
        'SELECT ${dbInstance.transactionTable}.*, ${dbInstance.categoryTable}.${dbInstance.categoryName}, ${dbInstance.categoryTable}.${dbInstance.categoryType}, ${dbInstance.categoryTable}.${dbInstance.categoryDescription} FROM ${dbInstance.transactionTable} JOIN ${dbInstance.categoryTable} ON ${dbInstance.categoryTable}.${dbInstance.categoryId}=${dbInstance.transactionTable}.${dbInstance.transactionCategoryId} $whereType ORDER BY ${dbInstance.transactionTable}.${dbInstance.transactionDate} DESC LIMIT $limit OFFSET $offset',
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
              type: data[i]['type'].toString(),
              name: data[i]['name'].toString(),
              description: data[i]['description'].toString(),
            ));
        listTransactions.add(transactionModel);
      }
    }

    return listTransactions;
  }

  Future<List<TransactionModel>> getTransactionDate({String? date}) async {
    Database db = await dbInstance.database;
    final data = await db.rawQuery(
        'SELECT ${dbInstance.transactionTable}.*, ${dbInstance.categoryTable}.${dbInstance.categoryName}, ${dbInstance.categoryTable}.${dbInstance.categoryType}, ${dbInstance.categoryTable}.${dbInstance.categoryDescription} FROM ${dbInstance.transactionTable} JOIN ${dbInstance.categoryTable} ON ${dbInstance.categoryTable}.${dbInstance.categoryId}=${dbInstance.transactionTable}.${dbInstance.transactionCategoryId} WHERE ${dbInstance.transactionTable}.${dbInstance.transactionDate}="$date"',
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
                type: data[i]['type'].toString()));
        listTransactions.add(transactionModel);
      }
    }
    return listTransactions;
  }

  Future<List<GroupingTransactionModel>> weeklyTransactions(
      {int weekNumber = 1,
      String? month,
      int? year,
      int? limit,
      int? page}) async {
    // Setup pagination
    limit ??= 10;
    int offset = (limit * (page ?? 1)) - limit;

    // 1 week is 7 day
    String startDay = ((7 * weekNumber) - 7).toString().padLeft(2, '0');
    String endDay = (int.parse(startDay) + 7).toString().padLeft(2, '0');

    Database db = await dbInstance.database;
    final data = await db.rawQuery(
        'SELECT ${dbInstance.transactionTable}.* FROM ${dbInstance.transactionTable} JOIN ${dbInstance.categoryTable} ON ${dbInstance.categoryTable}.${dbInstance.categoryId}=${dbInstance.transactionTable}.${dbInstance.transactionCategoryId} WHERE ${dbInstance.transactionTable}.${dbInstance.transactionDate} >= "$year-$month-$startDay" AND ${dbInstance.transactionTable}.${dbInstance.transactionDate} <= "$year-$month-$endDay" GROUP BY ${dbInstance.transactionTable}.${dbInstance.transactionDate} ORDER BY ${dbInstance.transactionTable}.${dbInstance.transactionDate} DESC LIMIT $limit OFFSET $offset',
        []);

    List<GroupingTransactionModel> listGroupTransactions = [];
    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        List<TransactionModel>? listTransactions =
            await getTransactionDate(date: data[i]['date'].toString());

        listGroupTransactions.add(GroupingTransactionModel(
            date: data[i]['date'].toString(),
            listTransactions: listTransactions));
      }
    }
    return listGroupTransactions;
  }

  Future<List<GroupingTransactionModel>> monthlyTransactions(
      {String? month, int? year, int? limit, int? page}) async {
    // Setup pagination
    limit ??= 10;
    int offset = (limit * (page ?? 1)) - limit;

    Database db = await dbInstance.database;
    final data = await db.rawQuery(
        'SELECT ${dbInstance.transactionTable}.* FROM ${dbInstance.transactionTable} JOIN ${dbInstance.categoryTable} ON ${dbInstance.categoryTable}.${dbInstance.categoryId}=${dbInstance.transactionTable}.${dbInstance.transactionCategoryId} WHERE ${dbInstance.transactionTable}.${dbInstance.transactionDate} >= "$year-$month-01" AND ${dbInstance.transactionTable}.${dbInstance.transactionDate} <= "$year-$month-31" GROUP BY ${dbInstance.transactionTable}.${dbInstance.transactionDate} ORDER BY ${dbInstance.transactionTable}.${dbInstance.transactionDate} DESC LIMIT $limit OFFSET $offset',
        []);

    List<GroupingTransactionModel> listGroupTransactions = [];
    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        List<TransactionModel>? listTransactions =
            await getTransactionDate(date: data[i]['date'].toString());

        listGroupTransactions.add(GroupingTransactionModel(
            date: data[i]['date'].toString(),
            listTransactions: listTransactions));
      }
    }
    return listGroupTransactions;
  }

  Future<List<GroupingTransactionModel>> annualTransactions(
      {int? year, int? limit, int? page}) async {
    // Setup pagination
    limit ??= 10;
    int offset = (limit * (page ?? 1)) - limit;

    Database db = await dbInstance.database;
    final data = await db.rawQuery(
        'SELECT ${dbInstance.transactionTable}.* FROM ${dbInstance.transactionTable} JOIN ${dbInstance.categoryTable} ON ${dbInstance.categoryTable}.${dbInstance.categoryId}=${dbInstance.transactionTable}.${dbInstance.transactionCategoryId} WHERE ${dbInstance.transactionTable}.${dbInstance.transactionDate} >= "$year-01-01" AND ${dbInstance.transactionTable}.${dbInstance.transactionDate} <= "$year-12-31" GROUP BY ${dbInstance.transactionTable}.${dbInstance.transactionDate} ORDER BY ${dbInstance.transactionTable}.${dbInstance.transactionDate} DESC LIMIT $limit OFFSET $offset',
        []);

    List<GroupingTransactionModel> listGroupTransactions = [];
    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        List<TransactionModel>? listTransactions =
            await getTransactionDate(date: data[i]['date'].toString());

        listGroupTransactions.add(GroupingTransactionModel(
            date: data[i]['date'].toString(),
            listTransactions: listTransactions));
      }
    }
    return listGroupTransactions;
  }

  Future<List<GroupingTransactionModel>> allTransactions(
      {int? limit, int? page}) async {
    // Setup pagination
    limit ??= 10;
    int offset = (limit * (page ?? 1)) - limit;

    Database db = await dbInstance.database;
    final data = await db.rawQuery(
        'SELECT ${dbInstance.transactionTable}.* FROM ${dbInstance.transactionTable} JOIN ${dbInstance.categoryTable} ON ${dbInstance.categoryTable}.${dbInstance.categoryId}=${dbInstance.transactionTable}.${dbInstance.transactionCategoryId} GROUP BY ${dbInstance.transactionTable}.${dbInstance.transactionDate} ORDER BY ${dbInstance.transactionTable}.${dbInstance.transactionDate} DESC LIMIT $limit OFFSET $offset',
        []);

    List<GroupingTransactionModel> listGroupTransactions = [];
    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        List<TransactionModel>? listTransactions =
            await getTransactionDate(date: data[i]['date'].toString());

        listGroupTransactions.add(GroupingTransactionModel(
            date: data[i]['date'].toString(),
            listTransactions: listTransactions));
      }
    }
    return listGroupTransactions;
  }

  Future<int?> totalTransaction(
      {String? month, int? year, String? type = "income"}) async {
    String whereType = type != null
        ? 'WHERE ${dbInstance.categoryTable}.${dbInstance.categoryType}="$type"'
        : '';

    String whereDate = '';
    if (month != null && year != null && whereType != '') {
      whereDate =
          'AND ${dbInstance.transactionTable}.${dbInstance.transactionDate} >= "$year-$month-01" AND ${dbInstance.transactionTable}.${dbInstance.transactionDate} <= "$year-$month-31"';
    }
    Database db = await dbInstance.database;
    final data = await db.rawQuery(
        'SELECT SUM(${dbInstance.transactionTable}.${dbInstance.transactionNominal}) as total_income FROM ${dbInstance.transactionTable} JOIN ${dbInstance.categoryTable} ON ${dbInstance.categoryTable}.${dbInstance.categoryId}=${dbInstance.transactionTable}.${dbInstance.transactionCategoryId} $whereType $whereDate');
    if (data.isNotEmpty) {
      if (data[0]['total_income'] != null) {
        return int.parse(data[0]['total_income'].toString());
      }
    }
    return 0;
  }

  Future<TransactionModel?> latestTransaction() async {
    Database db = await dbInstance.database;
    final data = await db.rawQuery(
        'SELECT ${dbInstance.transactionTable}.*, ${dbInstance.categoryTable}.${dbInstance.categoryName}, ${dbInstance.categoryTable}.${dbInstance.categoryType}, ${dbInstance.categoryTable}.${dbInstance.categoryDescription} FROM ${dbInstance.transactionTable} JOIN ${dbInstance.categoryTable} ON ${dbInstance.categoryTable}.${dbInstance.categoryId}=${dbInstance.transactionTable}.${dbInstance.transactionCategoryId} ORDER BY ${dbInstance.transactionTable}.${dbInstance.transactionDate} DESC LIMIT 1');
    if (data.isNotEmpty) {
      return TransactionModel(
          id: int.parse(data[0]['id'].toString()),
          nominal: int.parse(data[0]['nominal'].toString()),
          category: CategoryModel(
              name: data[0]['name'].toString(),
              type: data[0]['type'].toString()));
    }
    return null;
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

  Future<int> deleteByDate(String date) async {
    Database db = await dbInstance.database;
    return await db.delete(dbInstance.transactionTable,
        where: '${dbInstance.transactionDate} = ?', whereArgs: [date]);
  }
}

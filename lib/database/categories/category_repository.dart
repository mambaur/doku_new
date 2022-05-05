import 'package:doku/database/database_instance.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepository {
  // reference to our single class that manages the database
  final dbInstance = DatabaseInstance();

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await dbInstance.database;
    return await db.insert(dbInstance.categoryTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await dbInstance.database;
    return await db.query(dbInstance.categoryTable);
  }

  Future<int?> queryRowCount() async {
    Database db = await dbInstance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM ${dbInstance.categoryTable}'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await dbInstance.database;
    int id = row[dbInstance.categoryId];
    return await db.update(dbInstance.categoryTable, row, where: '${dbInstance.categoryId} = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await dbInstance.database;
    return await db.delete(dbInstance.categoryTable, where: '${dbInstance.categoryId} = ?', whereArgs: [id]);
  }
}

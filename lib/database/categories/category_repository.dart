import 'package:doku/database/database_instance.dart';
import 'package:doku/models/category_model.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepository {
  // reference to our single class that manages the database
  final dbInstance = DatabaseInstance();

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await dbInstance.database;
    return await db.insert(dbInstance.categoryTable, row);
  }

  Future<List<CategoryModel>> all({String? type}) async {
    Database db = await dbInstance.database;
    final data = await db.query(dbInstance.categoryTable,
        orderBy: 'id desc',
        where: type != null ? '"type" = ?' : null,
        whereArgs: type != null ? [type] : null);
    List<CategoryModel> listCategories =
        data.map((e) => CategoryModel.fromJson(e)).toList();
    return listCategories;
  }

  Future<int?> queryRowCount() async {
    Database db = await dbInstance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM ${dbInstance.categoryTable}'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await dbInstance.database;
    int id = row[dbInstance.categoryId];
    return await db.update(dbInstance.categoryTable, row,
        where: '${dbInstance.categoryId} = ?', whereArgs: [id]);
  }

  Future<CategoryModel?> firstWhereName(String name) async {
    Database db = await dbInstance.database;
    final data = await db.rawQuery(
        'SELECT * FROM ${dbInstance.categoryTable} WHERE ${dbInstance.categoryTable}.${dbInstance.categoryName}="$name" ORDER BY ${dbInstance.categoryTable}.${dbInstance.categoryCreatedAt} DESC LIMIT 1',
        []);
    if (data.isNotEmpty) {
      return CategoryModel.fromJson(data[0]);
    }
    return null;
  }

  Future<int> delete(int id) async {
    Database db = await dbInstance.database;
    return await db.delete(dbInstance.categoryTable,
        where: '${dbInstance.categoryId} = ?', whereArgs: [id]);
  }
}

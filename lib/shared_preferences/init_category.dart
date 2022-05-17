import 'package:doku/database/categories/category_repository.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitCategory {
  final CategoryRepository _categoryRepo = CategoryRepository();
  static const initCategory = 'is_init_category';

  Future<bool?> getInitCategory() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? category = prefs.getBool(initCategory);
    return category;
  }

  Future setCategory(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(initCategory, value);
  }

  Future<void> categoryData() async {
    bool? isCategory = await getInitCategory();
    if (isCategory == null) {
      final income = [
        {
          "name": "Gaji Bulanan",
          "description": "Kerja Utama",
          "type": "income",
          "created_at": DateInstance.timestamp(),
          "updated_at": DateInstance.timestamp(),
        },
        {
          "name": "THR",
          "description": "Tunjangan Hari Raya",
          "type": "income",
          "created_at": DateInstance.timestamp(),
          "updated_at": DateInstance.timestamp(),
        },
      ];

      for (var i = 0; i < income.length; i++) {
        await _categoryRepo.insert(income[i]);
      }

      final expense = [
        {
          "name": "SPP",
          "description": "Sumbangan Pembinaan Pendidikan",
          "type": "expense",
          "created_at": DateInstance.timestamp(),
          "updated_at": DateInstance.timestamp(),
        },
        {
          "name": "Makan",
          "description": "Kebutuhan Harian",
          "type": "expense",
          "created_at": DateInstance.timestamp(),
          "updated_at": DateInstance.timestamp(),
        },
        {
          "name": "Pulsa",
          "description": "Paket Data, PLN, Dll.",
          "type": "expense",
          "created_at": DateInstance.timestamp(),
          "updated_at": DateInstance.timestamp(),
        },
        {
          "name": "Investasi",
          "description": "Saham, Obligasi dan Pasar Uang.",
          "type": "expense",
          "created_at": DateInstance.timestamp(),
          "updated_at": DateInstance.timestamp(),
        },
      ];

      for (var i = 0; i < expense.length; i++) {
        await _categoryRepo.insert(expense[i]);
      }

      setCategory(true);
    }
  }
}

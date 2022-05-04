import 'package:doku/screens/categories/expense_category_screen.dart';
import 'package:doku/screens/categories/income_category_screen.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add),
            )
          ],
          elevation: 0.5,
          title: Text('Kategori'),
          bottom: TabBar(
            labelColor: Colors.green.shade500,
            labelPadding: EdgeInsets.all(15),
            indicatorColor: Colors.green.shade500,
            unselectedLabelColor: Colors.black.withOpacity(0.8),
            tabs: [
              Text('Pemasukan'),
              Text('Pengeluaran'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            IncomeCategoryScreen(),
            ExpenseCategoryScreen(),
          ],
        ),
      ),
    );
  }
}

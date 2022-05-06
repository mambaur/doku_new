import 'package:doku/screens/categories/expense_category_screen.dart';
import 'package:doku/screens/categories/income_category_screen.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  List<String> categoryType = ['Pemasukan', 'Pengeluaran'];
  String selectedCategoryType = 'Pemasukan';
  TabController? _tabController;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                _addCategoryDialog();
              },
              icon: Icon(Icons.add),
            )
          ],
          elevation: 0.5,
          title: Text('Kategori'),
          bottom: TabBar(
            controller: _tabController,
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
        body: TabBarView(
          controller: _tabController,
          children: [
            IncomeCategoryScreen(),
            ExpenseCategoryScreen(),
          ],
        ),
      ),
    );
  }

  Future<void> _addCategoryDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Kategori'),
          content: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Input nama kategori tidak boleh kosong.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green.shade700),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green.shade700),
                              ),
                              label: Text('Nama Kategori')),
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green.shade700),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green.shade700),
                              ),
                              label: Text('Deskripsi (Opsional)')),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownButton<String>(
                    itemHeight: 70.0,
                    value: selectedCategoryType,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    isExpanded: true,
                    style: TextStyle(color: Colors.green.shade400),
                    underline: Container(
                      height: 2,
                      color: Colors.green.shade400,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategoryType = newValue!;
                      });
                    },
                    items: categoryType
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Tambah'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  setState(() {
                    _tabController!.animateTo(
                        selectedCategoryType == 'Pengeluaran' ? 1 : 0);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}

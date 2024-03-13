// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:doku/database/categories/category_repository.dart';
import 'package:doku/models/category_model.dart';
import 'package:doku/screens/categories/expense_category_screen.dart';
import 'package:doku/screens/categories/income_category_screen.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  final int? initialIndex;
  const CategoryScreen({super.key, this.initialIndex});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  final CategoryRepository _categoryRepo = CategoryRepository();
  List<String> categoryType = ['Pemasukan', 'Pengeluaran'];
  String selectedCategoryTypeStore = 'Pemasukan';
  String selectedCategoryTypeEdit = 'Pemasukan';
  TabController? _tabController;

  final _formKeyStore = GlobalKey<FormState>();
  final TextEditingController _nameStoreController = TextEditingController();
  final TextEditingController _descriptionStoreController =
      TextEditingController();

  final _formKeyEdit = GlobalKey<FormState>();
  final TextEditingController _nameEditController = TextEditingController();
  final TextEditingController _descriptionEditController =
      TextEditingController();

  Future storeCategory() async {
    CategoryModel categoryModel = CategoryModel(
        name: _nameStoreController.text,
        description: _descriptionStoreController.text,
        type: selectedCategoryTypeStore == 'Pemasukan' ? 'income' : 'expense',
        createdAt: DateInstance.timestamp(),
        updatedAt: DateInstance.timestamp());
    await _categoryRepo.insert(categoryModel.toJson());
  }

  Future updateCategory(CategoryModel param) async {
    CategoryModel categoryModel = CategoryModel(
        id: param.id,
        name: _nameEditController.text,
        description: _descriptionEditController.text,
        type: selectedCategoryTypeEdit == 'Pemasukan' ? 'income' : 'expense',
        createdAt: param.createdAt,
        updatedAt: DateInstance.timestamp());
    await _categoryRepo.update(categoryModel.toJson());
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _tabController!.animateTo(widget.initialIndex ?? 0);
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
              icon: const Icon(Icons.add),
            )
          ],
          elevation: 0.5,
          title: const Text('Kategori'),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.green.shade500,
            labelPadding: const EdgeInsets.all(15),
            indicatorColor: Colors.green.shade500,
            unselectedLabelColor: Colors.black.withOpacity(0.8),
            tabs: const [
              Text('Pemasukan'),
              Text('Pengeluaran'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            IncomeCategoryScreen(
              onEdit: (categoryModel) {
                _editCategoryDialog(categoryModel!);
              },
            ),
            ExpenseCategoryScreen(
              onEdit: (categoryModel) {
                _editCategoryDialog(categoryModel!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCategoryDialog() async {
    _nameStoreController.text = '';
    _descriptionStoreController.text = '';
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
                    key: _formKeyStore,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameStoreController,
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
                              label: const Text('Nama Kategori')),
                        ),
                        TextFormField(
                          controller: _descriptionStoreController,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green.shade700),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green.shade700),
                              ),
                              label: const Text('Deskripsi (Opsional)')),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownButton<String>(
                    itemHeight: 70.0,
                    value: selectedCategoryTypeStore,
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
                        selectedCategoryTypeStore = newValue!;
                      });
                    },
                    items: categoryType
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
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
              onPressed: () async {
                if (_formKeyStore.currentState!.validate()) {
                  await storeCategory();
                  Navigator.of(context).pop();
                  CoolAlert.show(
                    title: 'Sukses!',
                    context: context,
                    type: CoolAlertType.success,
                    text:
                        "Kategori ${_nameStoreController.text} telah ditambahkan.",
                  );
                  setState(() {
                    _tabController!.animateTo(
                        selectedCategoryTypeStore == 'Pengeluaran' ? 1 : 0);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editCategoryDialog(CategoryModel categoryModel) async {
    _nameEditController.text = categoryModel.name ?? '';
    _descriptionEditController.text = categoryModel.description ?? '';
    selectedCategoryTypeEdit =
        categoryModel.type == 'income' ? 'Pemasukan' : 'Pengeluaran';
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Kategori'),
          content: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Form(
                    key: _formKeyEdit,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameEditController,
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
                              label: const Text('Nama Kategori')),
                        ),
                        TextFormField(
                          controller: _descriptionEditController,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green.shade700),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green.shade700),
                              ),
                              label: const Text('Deskripsi (Opsional)')),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownButton<String>(
                    itemHeight: 70.0,
                    value: selectedCategoryTypeEdit,
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
                        selectedCategoryTypeEdit = newValue!;
                      });
                    },
                    items: categoryType
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
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
              child: const Text('Update'),
              onPressed: () async {
                if (_formKeyEdit.currentState!.validate()) {
                  await updateCategory(categoryModel);
                  Navigator.of(context).pop();
                  CoolAlert.show(
                    title: 'Sukses!',
                    context: context,
                    type: CoolAlertType.success,
                    text: "Kategori ${_nameEditController.text} telah diubah.",
                  );
                  setState(() {
                    _tabController!.animateTo(
                        selectedCategoryTypeEdit == 'Pengeluaran' ? 1 : 0);
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

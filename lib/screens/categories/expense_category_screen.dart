// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:doku/database/categories/category_repository.dart';
import 'package:doku/models/category_model.dart';
import 'package:flutter/material.dart';

class ExpenseCategoryScreen extends StatefulWidget {
  final Function(CategoryModel?)? onEdit;
  const ExpenseCategoryScreen({super.key, this.onEdit});

  @override
  State<ExpenseCategoryScreen> createState() => _ExpenseCategoryScreenState();
}

class _ExpenseCategoryScreenState extends State<ExpenseCategoryScreen> {
  final CategoryRepository _categoryRepo = CategoryRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<CategoryModel>>(
          future: _categoryRepo.all(type: 'expense'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(children: [
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index].name ?? '',
                              ),
                              snapshot.data![index].description != null &&
                                      snapshot.data![index].description != ''
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        snapshot.data![index].description ?? '',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          )),
                          IconButton(
                              onPressed: () {
                                widget.onEdit!(snapshot.data![index]);
                              },
                              icon: Icon(Icons.edit_outlined,
                                  color: Colors.black.withOpacity(0.4))),
                          IconButton(
                              onPressed: () {
                                _deleteDialog(snapshot.data![index]);
                              },
                              icon: Icon(Icons.delete_outlined,
                                  color: Colors.black.withOpacity(0.4))),
                        ]));
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 1,
                      thickness: 0.7,
                    );
                  },
                  itemCount: snapshot.data!.length);
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.green.shade700,
                  strokeWidth: 2,
                ),
              );
            }
          }),
    );
  }

  Future<void> _deleteDialog(CategoryModel categoryModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Anda yakin ingin menghapus kategori ${categoryModel.name}?'),
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
              child: const Text('Ya, hapus'),
              onPressed: () async {
                await _categoryRepo.delete(categoryModel.id!);
                Navigator.of(context).pop();
                setState(() {});
                CoolAlert.show(
                  title: 'Sukses!',
                  context: context,
                  type: CoolAlertType.success,
                  text: "Kategori ${categoryModel.name} telah dihapus.",
                );
              },
            ),
          ],
        );
      },
    );
  }
}

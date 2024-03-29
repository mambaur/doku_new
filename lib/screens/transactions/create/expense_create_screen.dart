// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:doku/database/categories/category_repository.dart';
import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/category_model.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/screens/categories/category_screen.dart';
import 'package:doku/utils/currency_format.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:intl/intl.dart';

class ExpenseCreateScreen extends StatefulWidget {
  const ExpenseCreateScreen({super.key});

  @override
  State<ExpenseCreateScreen> createState() => _ExpenseCreateScreenState();
}

class _ExpenseCreateScreenState extends State<ExpenseCreateScreen> {
  DateTime now = DateTime.now();
  DateTime dateTransaction = DateTime.now();
  List<CategoryModel> listCategories = [];
  CategoryModel? selectedCategory;
  final CategoryRepository _categoryRepo = CategoryRepository();
  final TransactionRepository _transactionRepo = TransactionRepository();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<DateTime?> _selectDate(DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.green.shade600,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
        initialDate: initialDate,
        firstDate: DateTime((now.year - 100), 8),
        lastDate: DateTime(now.year + 1));
    return picked;
  }

  Future getCategory() async {
    List<CategoryModel>? data = await _categoryRepo.all(type: 'expense');

    if (data.isNotEmpty) {
      selectedCategory = data[0];
      setState(() {
        listCategories = data;
      });
    }
  }

  Future storeTransaction() async {
    await Future.delayed(const Duration(milliseconds: 500));
    TransactionModel transactionModel = TransactionModel(
        nominal: int.parse(CurrencyFormat.toNumber(_nominalController.text)),
        categoryId: selectedCategory!.id,
        date: _dateController.text,
        notes: _notesController.text,
        createdAt: DateInstance.timestamp(),
        updatedAt: DateInstance.timestamp());

    await _transactionRepo.insert(transactionModel.toJson());
  }

  void resetInput() {
    _nominalController.text = '0';
    _notesController.text = '';
  }

  @override
  void initState() {
    _nominalController.text = '0';
    String dateNow =
        '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    _dateController.text = dateNow;
    getCategory();
    super.initState();
  }

  @override
  void dispose() {
    Loader.hide();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengeluaran'),
        elevation: 0.5,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? picked =
                                await _selectDate(dateTransaction);
                            if (picked != null && picked != dateTransaction) {
                              setState(() {
                                dateTransaction = picked;
                                _dateController.text = dateTransaction
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0];
                              });
                            }
                          },
                          child: TextFormField(
                            controller: _dateController,
                            enabled: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tanggal transaksi tidak boleh kosong.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              labelText: 'Tanggal',
                              suffixIcon: Icon(Icons.date_range),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: TextFormField(
                          controller: _nominalController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == '0') {
                              return 'Nominal tidak boleh kosong.';
                            }
                            return null;
                          },
                          inputFormatters: [
                            ThousandsFormatter(
                                allowFraction: false,
                                formatter: NumberFormat.decimalPattern('id'))
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            labelText: 'Jumlah Uang',
                            suffixIcon: Icon(Icons.credit_card),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            const Text('Kategori :'),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: selectedCategory != null
                                  ? DropdownButton<CategoryModel?>(
                                      itemHeight: 70.0,
                                      value: selectedCategory,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      elevation: 2,
                                      isExpanded: true,
                                      style: TextStyle(
                                          color: Colors.green.shade400),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.green.shade400,
                                      ),
                                      onChanged: (CategoryModel? newValue) {
                                        setState(() {
                                          selectedCategory = newValue!;
                                        });
                                      },
                                      items: listCategories.map<
                                              DropdownMenuItem<CategoryModel?>>(
                                          (CategoryModel? value) {
                                        return DropdownMenuItem<CategoryModel?>(
                                          value: value,
                                          child: Text(
                                            value != null ? value.name! : '',
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            (MaterialPageRoute(
                                                builder: (builder) {
                                              return const CategoryScreen(
                                                initialIndex: 1,
                                              );
                                            }))).then((value) {
                                          getCategory();
                                        });
                                      },
                                      child: TextFormField(
                                        enabled: false,
                                        decoration: const InputDecoration(
                                          hintText: 'Tambah kategori',
                                          suffixIcon:
                                              Icon(Icons.arrow_drop_down),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey.shade100,
                        margin: const EdgeInsets.only(bottom: 3),
                        child: TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.top,
                          // expands: true,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              hintText: 'Keterangan (opsional)'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              // width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade400),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Loader.show(
                        context,
                        isSafeAreaOverlay: false,
                        isAppbarOverlay: true,
                        isBottomBarOverlay: true,
                        progressIndicator:
                            LoadingAnimationWidget.discreteCircle(
                                color: Colors.green,
                                size: MediaQuery.of(context).size.width * 0.15),
                      );
                      await storeTransaction();
                      Loader.hide();
                      Navigator.pop(context);
                      CoolAlert.show(
                        title: 'Sukses!',
                        context: context,
                        type: CoolAlertType.success,
                        text:
                            "Transaksi dengan kategori ${selectedCategory!.name} telah ditambahkan sebesar ${currencyId.format(int.parse(CurrencyFormat.toNumber(_nominalController.text)))}.",
                      );
                      // resetInput();
                    }
                  },
                  child: const Text('TAMBAH',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ))
        ],
      ),
    );
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/screens/transactions/edit/list_edit_transaction_screen.dart';
import 'package:doku/utils/currency_format.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as ex;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class AnnualReportScreen extends StatefulWidget {
  const AnnualReportScreen({super.key});

  @override
  State<AnnualReportScreen> createState() => _AnnualReportScreenState();
}

class _AnnualReportScreenState extends State<AnnualReportScreen> {
  final TransactionRepository _transactionRepo = TransactionRepository();
  final ScrollController _scrollController = ScrollController();
  List<int> years = [2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029];
  int selectedYear = 2022;

  DateTime now = DateTime.now();

  List<GroupingTransactionModel> transactions = [];
  int page = 1;
  int limit = 15;
  bool hasReachedMax = false;

  int? totalExpense;
  int? totalIncome;
  int? totalAll;

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll && !hasReachedMax) {
      page++;
      getTransactions();
    }
  }

  Future getTransactions() async {
    List<GroupingTransactionModel> data = await _transactionRepo
        .annualTransactions(year: selectedYear, page: page, limit: limit);

    if (data.isEmpty || data.length < limit) {
      hasReachedMax = true;
    }
    transactions.addAll(data);
    await getTotalTransaction();
    setState(() {});
  }

  int totalTransaction(List<TransactionModel> listTransactions) {
    int totalIncome = 0;
    int totalExpense = 0;

    for (var i = 0; i < listTransactions.length; i++) {
      if (listTransactions[i].category!.type == 'income') {
        totalIncome += listTransactions[i].nominal!;
      } else {
        totalExpense += listTransactions[i].nominal!;
      }
    }

    return totalIncome - totalExpense;
  }

  getTotalTransaction() async {
    totalExpense = await _transactionRepo.countAnnualTransactions(
        year: selectedYear, type: 'expense');

    totalIncome = await _transactionRepo.countAnnualTransactions(
        year: selectedYear, type: 'income');

    totalAll = totalIncome! - totalExpense!;
  }

  downloadExcel() async {
    List<GroupingTransactionModel> data = await _transactionRepo
        .annualTransactions(year: selectedYear, page: page, limit: 10000000);

    var excel = ex.Excel.createExcel();
    ex.Sheet sheet = excel[excel.getDefaultSheet()!];

    int indexRow = 0;
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < (data[i].listTransactions ?? []).length; j++) {
        var cellDate = sheet.cell(
            ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: indexRow));
        cellDate.value =
            ex.TextCellValue(data[i].listTransactions?[j].date ?? '');

        var cellDesc = sheet.cell(
            ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: indexRow));
        cellDesc.value =
            ex.TextCellValue(data[i].listTransactions?[j].notes ?? '');

        var cellCategory = sheet.cell(
            ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: indexRow));
        cellCategory.value =
            ex.TextCellValue(data[i].listTransactions?[j].category?.name ?? '');

        var cellType = sheet.cell(
            ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: indexRow));
        cellType.value =
            ex.TextCellValue(data[i].listTransactions?[j].category?.type ?? '');

        var cellNominal = sheet.cell(
            ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: indexRow));
        cellNominal.value =
            ex.IntCellValue(data[i].listTransactions?[j].nominal ?? 0);

        indexRow++;
      }
    }

    // excel.save(fileName: 'DOKU: Laporan Mingguan - ');

    var fileBytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();

    File file = File(join("$directory/DOKU: Laporan Bulanan.xlsx"))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    await DocumentFileSavePlus().saveFile(
        await file.readAsBytes(),
        "DOKU: Laporan Bulanan.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
  }

  @override
  void initState() {
    selectedYear = now.year;
    getTransactions();

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Tahunan'),
        elevation: 0.5,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              downloadExcel();
            },
          )
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                    floating: true,
                    automaticallyImplyLeading: false,
                    elevation: 0.5,
                    title: Container(
                      height: 40,
                      color: Colors.white,
                      child: ListView.builder(
                          itemCount: years.length,
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.only(bottom: 5, left: 5, top: 5),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                selectedYear = years[index];
                                transactions = [];
                                page = 1;
                                hasReachedMax = false;
                                getTransactions();
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                margin: const EdgeInsets.only(right: 7),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: years[index] == selectedYear
                                        ? Colors.green.shade400
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 0.5,
                                          blurRadius: 2,
                                          offset: const Offset(0, 1))
                                    ]),
                                child: Text(years[index].toString(),
                                    style: TextStyle(
                                        color: years[index] == selectedYear
                                            ? Colors.white
                                            : Colors.black.withOpacity(0.8))),
                              ),
                            );
                          }),
                    )),
                SliverList(
                    delegate: SliverChildListDelegate([
                  transactions.isEmpty
                      ? const Center(
                          child: Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Text(
                            'Transaksi masih kosong',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ))
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shrinkWrap: true,
                          itemCount: hasReachedMax
                              ? transactions.length
                              : transactions.length + 1,
                          itemBuilder: (context, index) {
                            if (index < transactions.length) {
                              return Container(
                                color: Colors.white,
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.date_range,
                                          size: 18,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(DateInstance.id(
                                            transactions[index].date!)),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (builder) {
                                              return ListEditTransactionScreen(
                                                date: transactions[index].date!,
                                              );
                                            })).then((value) {
                                              setState(() {});
                                            });
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(Icons.edit,
                                                  size: 18, color: Colors.grey),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text('Ubah Transaksi',
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                    for (TransactionModel item
                                        in transactions[index]
                                            .listTransactions!)
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                            '${item.category!.name}, ${(item.category!.type == "income" ? "Pemasukan" : "Pengeluaran")}',
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        subtitle: item.notes != null
                                            ? Text(item.notes ?? '')
                                            : null,
                                        dense: true,
                                        trailing: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Text(
                                            currencyId.format(item.nominal),
                                            style: TextStyle(
                                                color: item.category!.type ==
                                                        "income"
                                                    ? Colors.green.shade400
                                                    : Colors.orange.shade400,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    const Divider(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Total',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey.shade300),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Text(
                                            currencyId.format(totalTransaction(
                                                transactions[index]
                                                    .listTransactions!)),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green.shade700,
                                  strokeWidth: 2,
                                ),
                              );
                            }
                          }),
                  const SizedBox(
                    height: 80,
                  )
                ]))
              ]),
          Positioned(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Pemasukan', style: TextStyle(fontSize: 10)),
                        Text("+${currencyId.format(totalIncome ?? 0)}"),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Pengeluaran',
                            style: TextStyle(fontSize: 10)),
                        Text('-${currencyId.format(totalExpense ?? 0)}'),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                              fontSize: 10,
                            )),
                        Text(
                          currencyId.format(totalAll ?? 0),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: (totalAll ?? 0) >= 0
                                  ? Colors.green.shade700
                                  : Colors.orange.shade400),
                        ),
                      ],
                    )),
                  ],
                )),
          ))
        ],
      ),
    );
  }
}

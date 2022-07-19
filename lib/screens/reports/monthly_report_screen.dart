import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/screens/transactions/edit/list_edit_transaction_screen.dart';
import 'package:doku/utils/currency_format.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/material.dart';

class MonthlyReportScreen extends StatefulWidget {
  const MonthlyReportScreen({Key? key}) : super(key: key);

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  final TransactionRepository _transactionRepo = TransactionRepository();

  List<int> listYears = [2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030];

  String selectedMonth = 'Januari';
  int selectedYear = 2021;

  DateTime now = DateTime.now();

  @override
  void initState() {
    selectedYear = now.year;
    selectedMonth = idMonths[now.month - 1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Bulanan'),
        centerTitle: true,
        elevation: 0,
      ),
      body: CustomScrollView(
          // controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              automaticallyImplyLeading: false,
              elevation: 0.5,
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedMonth,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 1,
                        style: TextStyle(color: Colors.black.withOpacity(0.8)),
                        underline: Container(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMonth = newValue!;
                          });
                        },
                        items: idMonths
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedYear,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 1,
                        style: TextStyle(color: Colors.black.withOpacity(0.8)),
                        underline: Container(),
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedYear = newValue!;
                          });
                        },
                        items:
                            listYears.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              FutureBuilder<List<GroupingTransactionModel>>(
                  future: _transactionRepo.monthlyTransactions(
                      month: (idMonths.indexOf(selectedMonth) + 1)
                          .toString()
                          .padLeft(2, '0'),
                      year: selectedYear),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(DateInstance.id(
                                          snapshot.data![index].date!)),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (builder) {
                                            return ListEditTransactionScreen(
                                              date: snapshot.data![index].date!,
                                            );
                                          })).then((value) {
                                            setState(() {});
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text('Ubah Transaksi')
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                  for (TransactionModel item in snapshot
                                      .data![index].listTransactions!)
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                          '${item.category!.name}, ${(item.category!.type == "income" ? "Pemasukan" : "Pengeluaran")}',
                                          style: const TextStyle(fontSize: 14)),
                                      subtitle: item.notes != null
                                          ? Text(item.notes ?? '')
                                          : null,
                                      dense: true,
                                      trailing: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color:
                                                item.category!.type == "income"
                                                    ? Colors.green.shade400
                                                    : Colors.orange.shade400,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Text(
                                          currencyId.format(item.nominal),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.green.shade700,
                          strokeWidth: 2,
                        ),
                      );
                    }
                  })
            ])),
            SliverList(delegate: SliverChildListDelegate([])),
          ]),
    );
  }
}

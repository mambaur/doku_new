import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/screens/transactions/edit/list_edit_transaction_screen.dart';
import 'package:doku/utils/currency_format.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/material.dart';

class MonthlyReportScreen extends StatefulWidget {
  const MonthlyReportScreen({super.key});

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  final TransactionRepository _transactionRepo = TransactionRepository();
  final ScrollController _scrollController = ScrollController();

  List<int> listYears = [
    2021,
    2022,
    2023,
    2024,
    2025,
    2026,
    2027,
    2028,
    2029,
    2030
  ];

  String selectedMonth = 'Januari';
  int selectedYear = 2021;

  List<GroupingTransactionModel> transactions = [];
  int page = 1;
  int limit = 15;
  bool hasReachedMax = false;

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll && !hasReachedMax) {
      page++;
      getTransactions();
    }
  }

  Future getTransactions() async {
    List<GroupingTransactionModel> data =
        await _transactionRepo.monthlyTransactions(
            month: (idMonths.indexOf(selectedMonth) + 1)
                .toString()
                .padLeft(2, '0'),
            year: selectedYear,
            page: page,
            limit: limit);

    if (data.isEmpty || data.length < limit) {
      hasReachedMax = true;
    }
    transactions.addAll(data);
    setState(() {});
  }

  DateTime now = DateTime.now();

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

  @override
  void initState() {
    selectedYear = now.year;
    selectedMonth = idMonths[now.month - 1];

    getTransactions();

    _scrollController.addListener(onScroll);
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
          controller: _scrollController,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          selectedMonth = newValue!;
                          transactions = [];
                          page = 1;
                          hasReachedMax = false;
                          getTransactions();
                          setState(() {});
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
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          selectedYear = newValue!;
                          transactions = [];
                          page = 1;
                          hasReachedMax = false;
                          getTransactions();
                          setState(() {});
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
              ListView.builder(
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.date_range,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                    DateInstance.id(transactions[index].date!)),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return ListEditTransactionScreen(
                                        date: transactions[index].date!,
                                      );
                                    })).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: const Row(
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
                            const Divider(
                              thickness: 1,
                            ),
                            for (TransactionModel item
                                in transactions[index].listTransactions!)
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Text(
                                    currencyId.format(item.nominal),
                                    style: TextStyle(
                                        color: item.category!.type == "income"
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Text(
                                    currencyId.format(totalTransaction(
                                        transactions[index].listTransactions!)),
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
                  })
            ])),
            SliverList(delegate: SliverChildListDelegate([])),
          ]),
    );
  }
}

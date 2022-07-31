import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/screens/transactions/edit/list_edit_transaction_screen.dart';
import 'package:doku/utils/currency_format.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/material.dart';

class AllReportScreen extends StatefulWidget {
  const AllReportScreen({Key? key}) : super(key: key);

  @override
  State<AllReportScreen> createState() => _AllReportScreenState();
}

class _AllReportScreenState extends State<AllReportScreen> {
  final TransactionRepository _transactionRepo = TransactionRepository();
  final ScrollController _scrollController = ScrollController();

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

  Future getTransactions() async {
    List<GroupingTransactionModel> data =
        await _transactionRepo.allTransactions(page: page, limit: limit);

    if (data.isEmpty || data.length < limit) {
      hasReachedMax = true;
    }
    transactions.addAll(data);
    setState(() {});
  }

  @override
  void initState() {
    getTransactions();

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semua Laporan'),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: ListView.builder(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10),
          shrinkWrap: true,
          itemCount:
              hasReachedMax ? transactions.length : transactions.length + 1,
          itemBuilder: (context, index) {
            if (index < transactions.length) {
              return Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 18,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(DateInstance.id(transactions[index].date!)),
                        Spacer(),
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
                    for (TransactionModel item
                        in transactions[index].listTransactions!)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                            '${item.category!.name}, ${(item.category!.type == "income" ? "Pemasukan" : "Pengeluaran")}',
                            style: const TextStyle(fontSize: 14)),
                        subtitle:
                            item.notes != null ? Text(item.notes ?? '') : null,
                        dense: true,
                        trailing: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            currencyId.format(totalTransaction(
                                transactions[index].listTransactions!)),
                            style: TextStyle(
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
    );
  }
}

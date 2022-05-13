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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semua Laporan'),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: FutureBuilder<List<GroupingTransactionModel>>(
          future: _transactionRepo.allTransactions(),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.date_range,
                                size: 18,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                  DateInstance.id(snapshot.data![index].date!)),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (builder) {
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
                          for (TransactionModel item
                              in snapshot.data![index].listTransactions!)
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
                                    color: item.category!.type == "income"
                                        ? Colors.green.shade400
                                        : Colors.orange.shade400,
                                    borderRadius: BorderRadius.circular(15)),
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
          }),
    );
  }
}

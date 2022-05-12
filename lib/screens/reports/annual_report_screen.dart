import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/utils/currency_format.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/material.dart';

class AnnualReportScreen extends StatefulWidget {
  const AnnualReportScreen({Key? key}) : super(key: key);

  @override
  State<AnnualReportScreen> createState() => _AnnualReportScreenState();
}

class _AnnualReportScreenState extends State<AnnualReportScreen> {
  final TransactionRepository _transactionRepo = TransactionRepository();
  List<int> years = [2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029];
  int selectedYear = 2022;

  DateTime now = DateTime.now();

  @override
  void initState() {
    selectedYear = now.year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Tahunan'),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: CustomScrollView(
          // controller: _scrollController,
          physics: BouncingScrollPhysics(),
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
                      padding: EdgeInsets.only(bottom: 5, left: 5, top: 5),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedYear = years[index];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            margin: EdgeInsets.only(right: 7),
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
              FutureBuilder<List<GroupingTransactionModel>>(
                  future:
                      _transactionRepo.annualTransactions(year: selectedYear),
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
                                      Row(
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
            ]))
          ]),
    );
  }
}

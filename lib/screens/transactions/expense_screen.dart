import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/utils/currency_format.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TransactionRepository _transactionRepo = TransactionRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Pengeluaran'),
        centerTitle: true,
        elevation: 0.5,
      ),
      // backgroundColor: Colors.white,
      body: FutureBuilder<List<TransactionModel>>(
          future: _transactionRepo.all(type: 'expense'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () async {
                        await _transactionRepo
                            .delete(snapshot.data![index].id!);
                        Fluttertoast.showToast(msg: 'Transaksi telah dihapus.');
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(bottom: 10),
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateInstance.id(snapshot.data![index].date!),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  snapshot.data![index].category!.name ?? '',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                snapshot.data![index].notes != ''
                                    ? Text(
                                        'Catatan: ${snapshot.data![index].notes}')
                                    : Container(),
                              ],
                            )),
                            Text(
                                currencyId
                                    .format(snapshot.data![index].nominal),
                                style: TextStyle(
                                    color: Colors.orange.shade500,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
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

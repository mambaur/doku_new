import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/screens/transactions/edit/edit_transaction_screen.dart';
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
                        _optionEditDialog(snapshot.data![index]);
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
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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

  Future<void> _optionEditDialog(TransactionModel transactionModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) {
                      return EditTransactionScreen(
                        transactionModel: transactionModel,
                      );
                    })).then((value) {
                      setState(() {});
                    });
                  },
                  title: Text('Ubah Transaksi'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () async {
                    await _transactionRepo.delete(transactionModel.id!);

                    Navigator.pop(context);
                    setState(() {});
                    Fluttertoast.showToast(msg: 'Transaksi telah dihapus.');
                  },
                  title: Text('Hapus'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

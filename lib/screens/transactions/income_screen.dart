import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/screens/transactions/edit/edit_transaction_screen.dart';
import 'package:doku/utils/currency_format.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final TransactionRepository _transactionRepo = TransactionRepository();

  final ScrollController _scrollController = ScrollController();

  List<TransactionModel> transactions = [];
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
    List<TransactionModel> data =
        await _transactionRepo.all(type: 'income', page: page, limit: limit);

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
        title: const Text('Semua Pemasukan'),
        centerTitle: true,
        elevation: 0.5,
      ),
      // backgroundColor: Colors.white,
      body: ListView.builder(
          controller: _scrollController,
          itemCount:
              hasReachedMax ? transactions.length : transactions.length + 1,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (index < transactions.length) {
              return GestureDetector(
                onLongPress: () async {
                  _optionEditDialog(transactions[index]);
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
                            DateInstance.id(transactions[index].date!),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            transactions[index].category!.name ?? '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          transactions[index].notes != ''
                              ? Text('Catatan: ${transactions[index].notes}')
                              : Container(),
                        ],
                      )),
                      Text(currencyId.format(transactions[index].nominal),
                          style: TextStyle(
                              color: Colors.green.shade500,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
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

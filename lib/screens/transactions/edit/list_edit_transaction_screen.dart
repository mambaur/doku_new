import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/screens/transactions/edit/edit_transaction_screen.dart';
import 'package:doku/utils/currency_format.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListEditTransactionScreen extends StatefulWidget {
  final String? date;
  const ListEditTransactionScreen({Key? key, this.date}) : super(key: key);

  @override
  State<ListEditTransactionScreen> createState() =>
      _ListEditTransactionScreenState();
}

class _ListEditTransactionScreenState extends State<ListEditTransactionScreen> {
  final TransactionRepository _transactionRepo = TransactionRepository();
  List<TransactionModel>? listTransactions;

  Future getTransactionByDate() async {
    listTransactions =
        await _transactionRepo.getTransactionDate(date: widget.date ?? '');
    setState(() {});
  }

  @override
  void initState() {
    getTransactionByDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transaksi'),
        elevation: 0.5,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // _optionEditDialog();
              },
              icon: Icon(Icons.delete))
        ],
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
                  child: Center(
                      child: Text(
                    DateInstance.id(widget.date ?? ''),
                    style: TextStyle(fontWeight: FontWeight.normal),
                  )),
                )),
            SliverList(
                delegate: SliverChildListDelegate([
              listTransactions != null
                  ? ListView.builder(
                      itemCount: listTransactions!.length,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () async {
                            _optionEditDialog(index);
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
                                      DateInstance.id(
                                          listTransactions![index].date!),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      listTransactions![index].category!.name ??
                                          '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    listTransactions![index].notes != ''
                                        ? Text(
                                            'Catatan: ${listTransactions![index].notes}')
                                        : Container(),
                                  ],
                                )),
                                Text(
                                    currencyId.format(
                                        listTransactions![index].nominal),
                                    style: TextStyle(
                                        color: Colors.green.shade500,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        );
                      })
                  : Container()
            ]))
          ]),
    );
  }

  Future<void> _optionEditDialog(int index) async {
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
                        transactionModel: listTransactions![index],
                      );
                    })).then((value) {
                      getTransactionByDate();
                    });
                  },
                  title: Text('Ubah Transaksi'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () async {
                    await _transactionRepo.delete(listTransactions![index].id!);

                    Navigator.pop(context);
                    listTransactions!.removeAt(index);
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

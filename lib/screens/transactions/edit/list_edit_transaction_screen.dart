// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/screens/transactions/edit/edit_transaction_screen.dart';
import 'package:doku/utils/currency_format.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListEditTransactionScreen extends StatefulWidget {
  final String? date;
  const ListEditTransactionScreen({super.key, this.date});

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
                _deleteAllDialog(widget.date ?? '');
              },
              icon: const Icon(Icons.delete_outlined))
        ],
      ),
      body: CustomScrollView(
          // controller: _scrollController,
          physics: const BouncingScrollPhysics(),
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
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  )),
                )),
            SliverList(
                delegate: SliverChildListDelegate([
              listTransactions != null
                  ? ListView.builder(
                      itemCount: listTransactions!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () async {
                            _optionEditDialog(index);
                          },
                          onTap: () async {
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
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      listTransactions![index].category!.name ??
                                          '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
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
                                        color: listTransactions![index]
                                                    .category!
                                                    .type ==
                                                'income'
                                            ? Colors.green.shade500
                                            : Colors.orange.shade500,
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
                  title: const Text('Ubah Transaksi'),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () async {
                    await _transactionRepo.delete(listTransactions![index].id!);

                    Navigator.pop(context);
                    listTransactions!.removeAt(index);
                    setState(() {});
                    Fluttertoast.showToast(msg: 'Transaksi telah dihapus.');
                  },
                  title: const Text('Hapus'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteAllDialog(String? date) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Apakah kamu yakin ingin menghapus semua transaksi di tanggal $date?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ya, Hapus'),
              onPressed: () async {
                await _transactionRepo.deleteByDate(date!);
                setState(() {});
                Navigator.of(context).pop();
                Navigator.pop(context);
                CoolAlert.show(
                  title: 'Sukses!',
                  context: context,
                  type: CoolAlertType.success,
                  text: 'Semua transaksi tanggal $date telah dihapus.',
                );
              },
            ),
          ],
        );
      },
    );
  }
}

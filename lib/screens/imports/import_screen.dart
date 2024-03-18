// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:doku/database/categories/category_repository.dart';
import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/category_model.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/utils/currency_format.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  File? file;
  String text = '';

  importFile() async {
    text = '';
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);

      setState(() {});
    } else {
      // User canceled the picker
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMPORT'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pilih File',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Upload file .xlsx')
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600),
                        child: const Text('Import'),
                        onPressed: () {
                          importFile();
                        },
                      ),
                    ],
                  ),
                ),
                if (file != null)
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text((file?.path ?? '').split('/').last,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text('File uploaded')
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle_outline,
                              color: Colors.green.shade600)
                        ],
                      )),
                // Text(text)
              ],
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(15),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600),
                  child: const Text('SUBMIT'),
                  onPressed: () async {
                    if (file == null) {
                      Fluttertoast.showToast(
                          msg: "Silahkan pilih file terlebih dahulu");
                      return;
                    }

                    Loader.show(
                      context,
                      isSafeAreaOverlay: false,
                      isAppbarOverlay: true,
                      isBottomBarOverlay: true,
                      progressIndicator: LoadingAnimationWidget.discreteCircle(
                          color: Colors.green,
                          size: MediaQuery.of(context).size.width * 0.15),
                    );

                    var excel = Excel.decodeBytes(file!.readAsBytesSync());
                    TransactionRepository transactionRepo =
                        TransactionRepository();
                    CategoryRepository categoryRepo = CategoryRepository();

                    for (var table in excel.tables.keys) {
                      for (var row in excel.tables[table]!.rows) {
                        if (row.length <= 5) {
                          List<String> data = [];
                          for (var cell in row) {
                            // print(cell?.value ?? '');
                            text = '$text${cell!.value ?? ''} | ';

                            data.add(cell.value.toString());
                          }

                          CategoryModel? category =
                              await categoryRepo.firstWhereName(data[2]);

                          if (category == null) {
                            CategoryModel categoryData = CategoryModel(
                                name: data[2],
                                description: null,
                                type: data[3],
                                createdAt: DateInstance.timestamp(),
                                updatedAt: DateInstance.timestamp());
                            await categoryRepo.insert(categoryData.toJson());
                            category =
                                await categoryRepo.firstWhereName(data[2]);
                          }

                          TransactionModel transactionModel = TransactionModel(
                              nominal:
                                  int.parse(CurrencyFormat.toNumber(data[4])),
                              categoryId: category!.id,
                              date: data[0],
                              notes: data[1],
                              createdAt: DateInstance.timestamp(),
                              updatedAt: DateInstance.timestamp());

                          await transactionRepo
                              .insert(transactionModel.toJson());
                        }
                        text += '\n';
                      }
                    }

                    Loader.hide();

                    Fluttertoast.showToast(msg: "Data berhasil di import");
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

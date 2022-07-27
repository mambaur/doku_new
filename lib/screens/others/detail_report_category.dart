import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/utils/currency_format.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DetailReportCategory extends StatefulWidget {
  final String? transactionType;
  const DetailReportCategory({Key? key, this.transactionType})
      : super(key: key);

  @override
  State<DetailReportCategory> createState() => _DetailReportCategoryState();
}

class _DetailReportCategoryState extends State<DetailReportCategory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.transactionType == 'income' ? 'Pemasukan' : 'Pengeluaran'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: DetailReportChartScreen(
        transactionType: widget.transactionType,
      ),
    );
  }
}

class DetailReportChartScreen extends StatefulWidget {
  final String? transactionType;
  const DetailReportChartScreen({Key? key, this.transactionType})
      : super(key: key);

  @override
  State<DetailReportChartScreen> createState() =>
      _DetailReportChartScreenState();
}

class _DetailReportChartScreenState extends State<DetailReportChartScreen> {
  final TransactionRepository _transactionRepo = TransactionRepository();

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

  DateTime now = DateTime.now();
  List<TransactionByCategory> chartByCategory = [];

  Future getTransactionByCategory() async {
    chartByCategory = [];
    setState(() {});
    try {
      List<TransactionByCategory>? dataIncome =
          await _transactionRepo.getTransactionByCategory(
              (idMonths.indexOf(selectedMonth) + 1).toString().padLeft(2, '0'),
              selectedYear,
              type: widget.transactionType ?? 'income');
      chartByCategory = dataIncome ?? [];
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  void initState() {
    selectedYear = now.year;
    selectedMonth = idMonths[now.month - 1];
    getTransactionByCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
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
                          setState(() {
                            selectedMonth = newValue!;
                            getTransactionByCategory();
                          });
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
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
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
                          setState(() {
                            selectedYear = newValue!;
                            getTransactionByCategory();
                          });
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
            SizedBox(
              height: 10,
            ),
            for (TransactionByCategory item in chartByCategory)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (item.categoryModel?.name ?? '') +
                        ' (${currencyId.format(item.nominal)})',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 9,
                          child: LinearPercentIndicator(
                            lineHeight: 23.0,
                            animation: true,
                            percent: item.percent ?? 0,
                            padding: EdgeInsets.only(right: 10),
                            barRadius: Radius.circular(5),
                            backgroundColor: Colors.grey.shade100,
                            progressColor: widget.transactionType == 'income'
                                ? Colors.green.shade600
                                : Colors.orange.shade600,
                          ),
                        ),
                        Flexible(
                            flex: 2,
                            child: Text(
                              ((item.percent ?? 0) * 100).toStringAsFixed(1) +
                                  '%',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.transactionType == 'income'
                                      ? Colors.green.shade600
                                      : Colors.orange.shade600),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

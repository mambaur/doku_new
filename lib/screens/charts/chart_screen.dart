import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/screens/home_screen.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartScreen extends StatefulWidget {
  final String type;
  const ChartScreen({super.key, this.type = 'expense'});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final TransactionRepository _transactionRepository = TransactionRepository();
  DateTime now = DateTime.now();
  String monthTitle = '';

  List<String> dailyDay = [];
  List<int> dailyValue = [];

  List<String> weekDay = [];
  List<int> weekValue = [];

  List<String>? labelExpenseCharts = [];
  List<int>? valueExpenseCharts = [];

  Future daily() async {
    List<Map<String, dynamic>>? data =
        await _transactionRepository.getTransactionDaily(type: widget.type);
    for (var i = 0; i < data.length; i++) {
      dailyDay.add(data[i]['day']);
      dailyValue.add(data[i]['total']);
    }
    setState(() {});
  }

  Future weekly() async {
    List<Map<String, dynamic>>? data =
        await _transactionRepository.getTransactionWeek(type: widget.type);

    for (var i = 0; i < data.length; i++) {
      weekDay.add(data[i]['week'].toString());
      weekValue.add(data[i]['total']);
    }
    setState(() {});
  }

  Future monthly(int? month, int? year, {String? type}) async {
    labelExpenseCharts = [];
    valueExpenseCharts = [];

    int limitChartMonth = 4;
    int chartYear = now.year;
    for (var i = 0; i < limitChartMonth; i++) {
      if (month == 0) {
        month = 12;
        chartYear = chartYear - 1;
      }
      int? valueExpense = await _transactionRepository.totalTransaction(
        type: type,
        year: year,
        month: month.toString().padLeft(2, '0'),
      );
      labelExpenseCharts!.add(idMonths[month! - 1]);
      valueExpenseCharts!.add(valueExpense!);

      month = month - 1;
    }

    setState(() {});
  }

  @override
  void initState() {
    daily();
    weekly();
    monthly(now.month, now.year, type: widget.type);
    monthTitle = DateFormat('MMMM', 'id').format(now);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 'income'
            ? 'Grafik Pemasukan'
            : 'Grafik Pengeluaran'),
        centerTitle: true,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Grafik Harian',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: SimpleBarChart.withSampleData(
                            dailyDay.reversed.toList(),
                            dailyValue.reversed.toList(),
                            widget.type)),
                  ),
                ],
              ),
            ),
            const Divider(),
            SizedBox(
              height: 300,
              child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.date_range,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Grafik Mingguan ($monthTitle)',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.65),
                                  borderRadius: BorderRadius.circular(10)),
                              // height: 200,
                              child: SimpleBarChart.withSampleData(
                                  weekDay, weekValue, widget.type))),
                    ],
                  )),
            ),
            const Divider(),
            SizedBox(
              height: 300,
              child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.date_range,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Grafik Bulanan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: Container(
                              margin:
                                  const EdgeInsets.only(left: 15, right: 15),
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 200,
                              child: SimpleBarChart.withSampleData(
                                  labelExpenseCharts!.reversed.toList(),
                                  valueExpenseCharts!.reversed.toList(),
                                  widget.type))),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

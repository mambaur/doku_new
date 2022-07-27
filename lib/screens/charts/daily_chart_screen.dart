import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyChartScreen extends StatefulWidget {
  const DailyChartScreen({Key? key}) : super(key: key);

  @override
  State<DailyChartScreen> createState() => _DailyChartScreenState();
}

class _DailyChartScreenState extends State<DailyChartScreen> {
  TransactionRepository _transactionRepository = TransactionRepository();
  DateTime now = DateTime.now();
  String monthTitle = '';

  List<String> dailyDay = [];
  List<int> dailyValue = [];

  List<String> weekDay = [];
  List<int> weekValue = [];

  Future daily() async {
    List<Map<String, dynamic>>? data =
        await _transactionRepository.getTransactionDaily();

    for (var i = 0; i < data.length; i++) {
      dailyDay.add(data[i]['day']);
      dailyValue.add(data[i]['total']);
    }
    setState(() {});
  }

  Future weekly() async {
    List<Map<String, dynamic>>? data =
        await _transactionRepository.getTransactionWeek();

    for (var i = 0; i < data.length; i++) {
      weekDay.add(data[i]['week'].toString());
      weekValue.add(data[i]['total']);
    }
    setState(() {});
  }

  @override
  void initState() {
    daily();
    weekly();
    monthTitle = DateFormat('MMMM').format(now);
    super.initState();
  }

  bool isShowChart = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengeluaranmu'),
        // centerTitle: true,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.date_range,
                      size: 25,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Grafik Harian',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: isShowChart
                          ? SimpleBarChart.withSampleData(
                              dailyDay.reversed.toList(),
                              dailyValue.reversed.toList(),
                              'expense')
                          : Container()),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    Text(
                      'Grafik Mingguan ($monthTitle)',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.65),
                                borderRadius: BorderRadius.circular(10)),
                            // height: 200,
                            child: isShowChart
                                ? SimpleBarChart.withSampleData(
                                    weekDay, weekValue, 'expense')
                                : Container())),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

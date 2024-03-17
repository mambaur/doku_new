import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/screens/categories/category_screen.dart';
import 'package:doku/screens/charts/chart_screen.dart';
import 'package:doku/screens/imports/import_screen.dart';
import 'package:doku/screens/others/detail_report_category.dart';
import 'package:doku/screens/reports/all_report_screen.dart';
import 'package:doku/screens/reports/annual_report_screen.dart';
import 'package:doku/screens/reports/monthly_report_screen.dart';
import 'package:doku/screens/reports/weekly_report_screen.dart';
import 'package:doku/screens/settings/setting_screen.dart';
import 'package:doku/screens/transactions/create/expense_create_screen.dart';
import 'package:doku/screens/transactions/create/income_create_screen.dart';
import 'package:doku/screens/transactions/expense_screen.dart';
import 'package:doku/screens/transactions/income_screen.dart';
import 'package:doku/utils/currency_format.dart';
import 'package:doku/utils/date_instance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

enum StatusAd { initial, loaded }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TransactionRepository _transactionRepo = TransactionRepository();
  List<String> transactionPeriods = ['Mingguan', 'Bulanan', 'Tahunan', 'Semua'];
  int totalIncome = 0;
  int totalExpense = 0;
  int totalBalance = 0;
  bool isShowChart = false;

  BannerAd? myBanner;
  StatusAd statusAd = StatusAd.initial;

  BannerAdListener listener() => BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          if (kDebugMode) {
            print('Ad Loaded.');
          }
          setState(() {
            statusAd = StatusAd.loaded;
          });
        },
      );

  TransactionModel? latestTransaction;

  List<String>? labelIncomeCharts;
  List<int>? valueIncomeCharts;
  List<String>? labelExpenseCharts;
  List<int>? valueExpenseCharts;

  DateTime now = DateTime.now();

  Future getLatestTransaction() async {
    TransactionModel? data = await _transactionRepo.latestTransaction();
    if (data != null) {
      setState(() {
        latestTransaction = data;
      });
    }
  }

  List<TransactionByCategory> expenseByCategory = [];

  List<TransactionByCategory> incomeByCategory = [];

  Future getTransactionByCategory() async {
    incomeByCategory = [];
    expenseByCategory = [];
    setState(() {});
    try {
      List<TransactionByCategory>? dataIncome =
          await _transactionRepo.getTransactionByCategory(
              now.month.toString().padLeft(2, '0'), now.year,
              type: 'income', limit: 6);
      incomeByCategory = dataIncome ?? [];
      List<TransactionByCategory>? dataExpense =
          await _transactionRepo.getTransactionByCategory(
              now.month.toString().padLeft(2, '0'), now.year,
              type: 'expense', limit: 6);
      expenseByCategory = dataExpense ?? [];
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future getTotalIncomeMonth({String? type, int? year, String? month}) async {
    int? data = await _transactionRepo.totalTransaction(
        type: type, year: year, month: month);
    if (data != null) {
      setState(() {
        if (type == 'income') {
          totalIncome = data;
        } else {
          totalExpense = data;
        }
      });
    }
  }

  Future getBalance() async {
    int? income = await _transactionRepo.totalTransaction(type: 'income');
    int? expense = await _transactionRepo.totalTransaction(type: 'expense');
    if (income != null && expense != null) {
      setState(() {
        totalBalance = income - expense;
      });
    }
  }

  Future chartData(int? month, int? year, {String? type}) async {
    if (type == 'income') {
      labelIncomeCharts = [];
      valueIncomeCharts = [];
    } else {
      labelExpenseCharts = [];
      valueExpenseCharts = [];
    }

    int limitChartMonth = 4;
    int chartYear = now.year;
    for (var i = 0; i < limitChartMonth; i++) {
      if (month == 0) {
        month = 12;
        chartYear = chartYear - 1;
      }

      // code here
      if (type == 'income') {
        int? valueIncome = await _transactionRepo.totalTransaction(
            type: type, year: year, month: month.toString().padLeft(2, '0'));
        labelIncomeCharts!.add(idMonths[month! - 1]);
        valueIncomeCharts!.add(valueIncome!);
      } else {
        int? valueExpense = await _transactionRepo.totalTransaction(
            type: type, year: year, month: month.toString().padLeft(2, '0'));
        labelExpenseCharts!.add(idMonths[month! - 1]);
        valueExpenseCharts!.add(valueExpense!);
      }

      month = month - 1;
    }
    isShowChart = true;
    setState(() {});
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    initData();
    getTransactionByCategory();
  }

  void initData() {
    getTotalIncomeMonth(
        type: 'income',
        year: now.year,
        month: (now.month).toString().padLeft(2, '0'));
    getTotalIncomeMonth(
        type: 'expense',
        year: now.year,
        month: (now.month).toString().padLeft(2, '0'));
    getBalance();
    chartData(now.month, now.year, type: 'income');
    chartData(now.month, now.year, type: 'expense');
    getTransactionByCategory();
    getLatestTransaction();
  }

  @override
  void initState() {
    initData();

    if (!kDebugMode) {
      myBanner = BannerAd(
        adUnitId: kDebugMode
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-2465007971338713/2900622168',
        size: AdSize.banner,
        request: const AdRequest(),
        listener: listener(),
      );
      myBanner!.load();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'DOKU',
          style: TextStyle(fontSize: 20),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu),
        ),
        actions: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(15)),
                child: Text(
                  currencyId.format(totalBalance),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () async {
                  _optionTransactionDialog();
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey.shade200),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(padding: EdgeInsets.zero, children: [
            DrawerHeader(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(color: Colors.green.shade400),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "DOKU",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Dompet Saku",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                  _optionTransactionDialog();
                },
                leading: const Icon(Icons.add_circle),
                title: const Text("Tambah Transaksi")),
            ListTile(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ImportScreen();
                  }));
                },
                leading: const Icon(Icons.import_export),
                title: const Text("Import")),
            ListTile(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const CategoryScreen();
                  }));
                },
                leading: const Icon(Icons.category),
                title: const Text("Kategori")),
            ListTile(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SettingScreen();
                  }));
                },
                leading: const Icon(Icons.warning),
                title: const Text("Disclaimer")),
            ListTile(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SettingScreen();
                  }));
                },
                leading: const Icon(Icons.question_mark),
                title: const Text("FAQ")),
            ListTile(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SettingScreen();
                  }));
                },
                leading: const Icon(Icons.question_answer),
                title: const Text("Kritik & Saran")),
            ListTile(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SettingScreen();
                  }));
                },
                leading: const Icon(Icons.settings),
                title: const Text("Pengaturan")),
          ]),
        ),
      ),
      // backgroundColor: Colors.grey.shade400,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.green.shade700,
        displacement: 20,
        onRefresh: () => _refresh(),
        child: CustomScrollView(
            // controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 180,
                        child: ListView(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          padding: const EdgeInsets.all(15),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            Container(
                              width: 280,
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.lightGreen.shade600,
                                    Colors.green.shade600,
                                  ]),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Icon(
                                      Icons.payment,
                                      size: 150,
                                      color: Colors.black.withOpacity(0.03),
                                    ),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(
                                          left: 20, bottom: 15, right: 20),
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        currencyId.format(totalIncome),
                                        textAlign: TextAlign.end,
                                        softWrap: true,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      )),
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total Pemasukan \n${idMonths[now.month - 1]} ${now.year}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white
                                                  .withOpacity(0.2)),
                                          child: const Row(
                                            children: [
                                              Icon(Icons.payment,
                                                  size: 20,
                                                  color: Colors.white),
                                              SizedBox(width: 5),
                                              Text(
                                                'Income',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 280,
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.orangeAccent.shade200,
                                    Colors.orange.shade500,
                                  ]),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Icon(
                                      Icons.payment,
                                      size: 150,
                                      color: Colors.black.withOpacity(0.03),
                                    ),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(
                                          right: 20, left: 20, bottom: 15),
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        currencyId.format(totalExpense),
                                        textAlign: TextAlign.end,
                                        softWrap: true,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      )),
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total Pengeluaran \n${idMonths[now.month - 1]} ${now.year}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white
                                                  .withOpacity(0.2)),
                                          child: const Row(
                                            children: [
                                              Icon(Icons.payment,
                                                  size: 20,
                                                  color: Colors.white),
                                              SizedBox(width: 5),
                                              Text(
                                                'Expense',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(
                      //       bottom: 15, left: 15, right: 15),
                      //   child: Card(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     child: ListTile(
                      //       onTap: () {
                      //         Navigator.push(context,
                      //             MaterialPageRoute(builder: (builder) {
                      //           return const DailyChartScreen();
                      //         }));
                      //       },
                      //       leading: const Icon(Icons.bar_chart_outlined),
                      //       trailing: const Icon(Icons.chevron_right),
                      //       title: const Text('Grafik Pengeluaran Harian',
                      //           style: TextStyle(fontSize: 14)),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Transaksi Terakhir'),
                                const SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (latestTransaction!.category!.type ==
                                        "income") {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (builder) {
                                        return const IncomeScreen();
                                      }));
                                    } else {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (builder) {
                                        return const ExpenseScreen();
                                      }));
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 30,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                        latestTransaction != null
                                            ? '${currencyId.format(latestTransaction!.nominal)} (${latestTransaction!.category!.type == "income" ? "Pemasukan" : "Pengeluaran"})'
                                            : 'Belum ada transaksi',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pengaturan'),
                                const SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return const SettingScreen();
                                    }));
                                  },
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.settings,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text('Pengaturan',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 12)),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ])),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 10, top: 10),
                    child: const Text('Laporanmu',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: transactionPeriods.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (builder) {
                              if (transactionPeriods[index] == 'Mingguan') {
                                return const WeeklyReportScreen();
                              } else if (transactionPeriods[index] ==
                                  'Tahunan') {
                                return const AnnualReportScreen();
                              } else if (transactionPeriods[index] ==
                                  'Bulanan') {
                                return const MonthlyReportScreen();
                              } else {
                                return const AllReportScreen();
                              }
                            }));
                          },
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 7),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(transactionPeriods[index])),
                        );
                      }),
                )
              ])),
              incomeByCategory.isNotEmpty
                  ? SliverList(
                      delegate: SliverChildListDelegate([
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 5),
                          child: const Text('Pemasukanmu Bulan ini',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                      Container(
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          // height: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (TransactionByCategory item
                                  in incomeByCategory)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.categoryModel?.name ?? ''} (${currencyId.format(item.nominal)})',
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 9,
                                            child: LinearPercentIndicator(
                                              lineHeight: 23.0,
                                              animation: true,
                                              percent: item.percent ?? 0,
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              barRadius:
                                                  const Radius.circular(5),
                                              backgroundColor:
                                                  Colors.grey.shade100,
                                              progressColor:
                                                  Colors.green.shade600,
                                            ),
                                          ),
                                          Flexible(
                                              flex: 2,
                                              child: Text(
                                                '${((item.percent ?? 0) * 100).toStringAsFixed(1)}%',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.green.shade600),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (builder) {
                                    return const DetailReportCategory(
                                      transactionType: 'income',
                                    );
                                  }));
                                },
                                child: const Text('Lihat Semua',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              )
                            ],
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          height: 280,
                          child: Column(
                            children: [
                              Expanded(
                                child: isShowChart
                                    ? SimpleBarChart.withSampleData(
                                        labelIncomeCharts!.reversed.toList(),
                                        valueIncomeCharts!.reversed.toList(),
                                        'income')
                                    : Container(),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (builder) {
                                        return const ChartScreen(
                                            type: 'income');
                                      }));
                                    },
                                    child: Text(
                                      'Selengkapnya',
                                      style: TextStyle(
                                          color: Colors.green.shade600),
                                    )),
                              )
                            ],
                          ))
                    ]))
                  : SliverList(delegate: SliverChildListDelegate([])),
              expenseByCategory.isNotEmpty
                  ? SliverList(
                      delegate: SliverChildListDelegate([
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 5),
                          child: const Text('Pengeluaranmu Bulan ini',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                      Container(
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          // height: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (TransactionByCategory item
                                  in expenseByCategory)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.categoryModel?.name ?? ''} (${currencyId.format(item.nominal)})',
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 9,
                                            child: LinearPercentIndicator(
                                              lineHeight: 23.0,
                                              animation: true,
                                              percent: item.percent ?? 0,
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              barRadius:
                                                  const Radius.circular(5),
                                              backgroundColor:
                                                  Colors.grey.shade100,
                                              progressColor:
                                                  Colors.orange.shade600,
                                            ),
                                          ),
                                          Flexible(
                                              flex: 2,
                                              child: Text(
                                                '${((item.percent ?? 0) * 100).toStringAsFixed(1)}%',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.orange.shade600),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (builder) {
                                    return const DetailReportCategory(
                                      transactionType: 'expense',
                                    );
                                  }));
                                },
                                child: const Text('Lihat Semua',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              )
                            ],
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          height: 280,
                          child: Column(
                            children: [
                              Expanded(
                                child: isShowChart
                                    ? SimpleBarChart.withSampleData(
                                        labelExpenseCharts!.reversed.toList(),
                                        valueExpenseCharts!.reversed.toList(),
                                        'expense')
                                    : Container(),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (builder) {
                                        return const ChartScreen(
                                            type: 'expense');
                                      }));
                                    },
                                    child: Text(
                                      'Selengkapnya',
                                      style: TextStyle(
                                          color: Colors.orange.shade600),
                                    )),
                              )
                            ],
                          ))
                    ]))
                  : SliverList(delegate: SliverChildListDelegate([])),
              SliverList(
                  delegate: SliverChildListDelegate([
                statusAd == StatusAd.loaded
                    ? Container(
                        margin:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        alignment: Alignment.center,
                        width: myBanner!.size.width.toDouble(),
                        height: myBanner!.size.height.toDouble(),
                        child: AdWidget(ad: myBanner!),
                      )
                    : Container()
              ])),
              SliverList(
                  delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 15,
                ),
                Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: const Text('Lihat Transaksiku',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))),
                Container(
                  margin: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 15, right: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return const IncomeScreen();
                      }));
                    },
                    leading: const Icon(Icons.file_present),
                    trailing: const Icon(Icons.chevron_right),
                    title: const Text('Semua Pemasukan',
                        style: TextStyle(fontSize: 14)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10, left: 15, right: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return const ExpenseScreen();
                      }));
                    },
                    leading: const Icon(Icons.file_present),
                    trailing: const Icon(Icons.chevron_right),
                    title: const Text('Semua Pengeluaran',
                        style: TextStyle(fontSize: 14)),
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ])),
              SliverList(delegate: SliverChildListDelegate([])),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade400,
        onPressed: () {
          _optionTransactionDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _optionTransactionDialog() async {
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
                      return const IncomeCreateScreen();
                    })).then((value) {
                      initData();
                    });
                  },
                  title: const Text('Pemasukan'),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) {
                      return const ExpenseCreateScreen();
                    })).then((value) {
                      initData();
                    });
                  },
                  title: const Text('Pengeluaran'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SimpleBarChart extends StatefulWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool? animate;

  const SimpleBarChart(this.seriesList, {super.key, this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData(
      List<String> labels, List<int> values, String type) {
    return SimpleBarChart(
      _createSampleData(labels, values, type),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  State<SimpleBarChart> createState() => _SimpleBarChartState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData(
      List<String> labels, List<int> values, String type) {
    List<OrdinalSales> data = [];
    if (labels.isNotEmpty) {
      for (var i = 0; i < labels.length; i++) {
        data.add(OrdinalSales(labels[i], values[i]));
      }
    }

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        seriesColor: charts.ColorUtil.fromDartColor(
            type == 'income' ? Colors.green.shade400 : Colors.orange.shade400),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class _SimpleBarChartState extends State<SimpleBarChart> {
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    if (selectedDatum.isNotEmpty) {
      setState(() {
        if (selectedDatum.first.datum.sales.toString() != '0') {
          Fluttertoast.showToast(
              msg: currencyId.format(selectedDatum.first.datum.sales));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      widget.seriesList,
      animate: widget.animate ?? true,
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

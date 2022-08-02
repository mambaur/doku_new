import 'package:carousel_slider/carousel_slider.dart';
import 'package:doku/database/transactions/transaction_repository.dart';
import 'package:doku/models/transaction_model.dart';
import 'package:doku/screens/categories/category_screen.dart';
import 'package:doku/screens/charts/daily_chart_screen.dart';
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
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

enum StatusAd { initial, loaded }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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

  PackageInfo? packageInfo;
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

  Future getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
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
    await Future.delayed(Duration(seconds: 1));
    initData();
    getTransactionByCategory();
    print('Refresing...');
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
    getPackageInfo();
    initData();

    myBanner = BannerAd(
      // test banner
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      //
      adUnitId: 'ca-app-pub-2465007971338713/2900622168',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener(),
    );
    myBanner!.load();

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
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    currencyId.format(totalBalance),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () async {
                    _optionTransactionDialog();
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey.shade200),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
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
                decoration: BoxDecoration(color: Colors.green.shade400),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const CategoryScreen();
                    }));
                  },
                  leading: const Icon(Icons.category),
                  title: const Text("Kategori")),
              ListTile(
                  onTap: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SettingScreen();
                    }));
                  },
                  leading: const Icon(Icons.settings),
                  title: const Text("Pengaturan")),
              ListTile(
                  onTap: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                    // Navigator.push(context, MaterialPageRoute(builder: (context) {
                    //   return const Disclaimer();
                    // }));
                  },
                  leading: const Icon(Icons.info),
                  title: Text(
                      "Versi ${packageInfo != null ? packageInfo!.version : ''}")),
            ]),
          ),
        ),
        // backgroundColor: Colors.grey.shade200,
        body: Stack(
          children: [
            RefreshIndicator(
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
                        margin: const EdgeInsets.only(top: 15, bottom: 5),
                        child: CarouselSlider(
                          options: CarouselOptions(
                              autoPlay: true,
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 2000),
                              aspectRatio: 2.3 / 1,
                              enlargeCenterPage: true,
                              viewportFraction: 0.8),
                          items: [
                            Container(
                              width: double.infinity,
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
                                          right: 20, bottom: 15),
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        currencyId.format(totalIncome),
                                        textAlign: TextAlign.end,
                                        softWrap: true,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
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
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white
                                                  .withOpacity(0.2)),
                                          child: Row(
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
                              width: double.infinity,
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
                                          right: 20, bottom: 15),
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        currencyId.format(totalExpense),
                                        textAlign: TextAlign.end,
                                        softWrap: true,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      )),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total Pengeluaran \n${idMonths[now.month - 1]} ${now.year}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white
                                                  .withOpacity(0.2)),
                                          child: Row(
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
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Transaksi Terakhir'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                            latestTransaction != null
                                                ? '${currencyId.format(latestTransaction!.nominal)} (${latestTransaction!.category!.type == "income" ? "Pemasukan" : "Pengeluaran"})'
                                                : 'Belum ada transaksi',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 12)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Pengaturan'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (builder) {
                                            return SettingScreen();
                                          }));
                                        },
                                        child: Container(
                                          height: 30,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 12)),
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
                          margin: EdgeInsets.only(
                              left: 15, right: 15, bottom: 10, top: 10),
                          child: Text('Laporanmu',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                        height: 40,
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            itemCount: transactionPeriods.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (builder) {
                                    if (transactionPeriods[index] ==
                                        'Mingguan') {
                                      return WeeklyReportScreen();
                                    } else if (transactionPeriods[index] ==
                                        'Tahunan') {
                                      return AnnualReportScreen();
                                    } else if (transactionPeriods[index] ==
                                        'Bulanan') {
                                      return MonthlyReportScreen();
                                    } else {
                                      return AllReportScreen();
                                    }
                                  }));
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(right: 7),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey.shade200),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(transactionPeriods[index])),
                              );
                            }),
                      )
                    ])),
                    incomeByCategory.length != 0
                        ? SliverList(
                            delegate: SliverChildListDelegate([
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 15, right: 15, top: 10, bottom: 5),
                                child: Text('Pemasukanmu Bulan ini',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(15),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (item.categoryModel?.name ?? '') +
                                                ' (${currencyId.format(item.nominal)})',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
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
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    barRadius:
                                                        Radius.circular(5),
                                                    backgroundColor:
                                                        Colors.grey.shade100,
                                                    progressColor:
                                                        Colors.green.shade600,
                                                  ),
                                                ),
                                                Flexible(
                                                    flex: 2,
                                                    child: Text(
                                                      ((item.percent ?? 0) *
                                                                  100)
                                                              .toStringAsFixed(
                                                                  1) +
                                                          '%',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .green.shade600),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (builder) {
                                          return DetailReportCategory(
                                            transactionType: 'income',
                                          );
                                        }));
                                      },
                                      child: Text('Lihat Semua',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)),
                                    )
                                  ],
                                ))
                          ]))
                        : SliverList(delegate: SliverChildListDelegate([])),
                    expenseByCategory.length != 0
                        ? SliverList(
                            delegate: SliverChildListDelegate([
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 15, right: 15, top: 10, bottom: 5),
                                child: Text('Pengeluaranmu Bulan ini',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(15),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (item.categoryModel?.name ?? '') +
                                                ' (${currencyId.format(item.nominal)})',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
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
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    barRadius:
                                                        Radius.circular(5),
                                                    backgroundColor:
                                                        Colors.grey.shade100,
                                                    progressColor:
                                                        Colors.orange.shade600,
                                                  ),
                                                ),
                                                Flexible(
                                                    flex: 2,
                                                    child: Text(
                                                      ((item.percent ?? 0) *
                                                                  100)
                                                              .toStringAsFixed(
                                                                  1) +
                                                          '%',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .orange.shade600),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (builder) {
                                          return DetailReportCategory(
                                            transactionType: 'expense',
                                          );
                                        }));
                                      },
                                      child: Text('Lihat Semua',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)),
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
                                  EdgeInsets.only(top: 15, left: 15, right: 15),
                              alignment: Alignment.center,
                              child: AdWidget(ad: myBanner!),
                              width: myBanner!.size.width.toDouble(),
                              height: myBanner!.size.height.toDouble(),
                            )
                          : Container()
                    ])),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 5),
                          child: Text('Grafik Pemasukan',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          height: 200,
                          child: isShowChart
                              ? SimpleBarChart.withSampleData(
                                  labelIncomeCharts!.reversed.toList(),
                                  valueIncomeCharts!.reversed.toList(),
                                  'income')
                              : Container())
                    ])),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 5),
                          child: Text(
                            'Grafik Pengeluaran',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          height: 200,
                          child: isShowChart
                              ? SimpleBarChart.withSampleData(
                                  labelExpenseCharts!.reversed.toList(),
                                  valueExpenseCharts!.reversed.toList(),
                                  'expense')
                              : Container())
                    ])),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                          child: Text('Lihat Transaksiku',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, bottom: 10, left: 15, right: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (builder) {
                              return IncomeScreen();
                            }));
                          },
                          leading: Icon(Icons.file_present),
                          trailing: Icon(Icons.chevron_right),
                          title: Text('Semua Pemasukan',
                              style: TextStyle(fontSize: 14)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10, left: 15, right: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (builder) {
                              return ExpenseScreen();
                            }));
                          },
                          leading: Icon(Icons.file_present),
                          trailing: Icon(Icons.chevron_right),
                          title: Text('Semua Pengeluaran',
                              style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ])),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Container(
                          margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                          child: Text('Grafik Lainnya',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, bottom: 10, left: 15, right: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (builder) {
                              return DailyChartScreen();
                            }));
                          },
                          leading: Icon(Icons.bar_chart_outlined),
                          trailing: Icon(Icons.chevron_right),
                          title: Text('Grafik Pengeluaran Harian',
                              style: TextStyle(fontSize: 14)),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      )
                    ])),
                    SliverList(delegate: SliverChildListDelegate([])),
                  ]),
            ),
            GestureDetector(
              onTap: () {
                _optionTransactionDialog();
                // Navigator.push(context, MaterialPageRoute(builder: (builder){
                //   return OptionCreateScreen();
                // }));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Tambah Transaksi',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
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
                      return IncomeCreateScreen();
                    })).then((value) {
                      initData();
                    });
                  },
                  title: Text('Pemasukan'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) {
                      return ExpenseCreateScreen();
                    })).then((value) {
                      initData();
                    });
                  },
                  title: Text('Pengeluaran'),
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

class SimpleBarChart extends StatefulWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool? animate;

  SimpleBarChart(this.seriesList, {this.animate});

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
          print(selectedDatum.first.datum.sales);
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
        new charts.SelectionModelConfig(
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

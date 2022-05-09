import 'package:carousel_slider/carousel_slider.dart';
import 'package:doku/screens/categories/category_screen.dart';
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
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:package_info_plus/package_info_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> transactionPeriods = ['Mingguan', 'Bulanan', 'Tahunan', 'Semua'];

  PackageInfo? packageInfo;

  Future getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  void initState() {
    getPackageInfo();
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
                    currencyId.format(100000),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
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
            CustomScrollView(
                // controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, top: 15, bottom: 5),
                      child: CarouselSlider(
                        options: CarouselOptions(
                            autoPlay: true,
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 1000),
                            aspectRatio: 2,
                            enlargeCenterPage: true,
                            viewportFraction: 1),
                        items: [
                          Container(
                            height: 75,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.green.shade400,
                                borderRadius: BorderRadius.circular(15)),
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.payment,
                                    size: 200,
                                    color:
                                        Colors.green.shade500.withOpacity(0.5),
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.only(
                                        right: 15, bottom: 10),
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      currencyId.format(200000),
                                      textAlign: TextAlign.end,
                                      softWrap: true,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    )),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Total Pemasukan \nMaret 2022',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '(Income)',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 75,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.orange.shade400,
                                borderRadius: BorderRadius.circular(15)),
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.payment,
                                    size: 200,
                                    color:
                                        Colors.orange.shade500.withOpacity(0.5),
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.only(
                                        right: 15, bottom: 10),
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      currencyId.format(200000),
                                      textAlign: TextAlign.end,
                                      softWrap: true,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    )),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Pengeluaran \nMaret 2022',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '(Expense)',
                                        style: TextStyle(color: Colors.white),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Transaksi Terakhir'),
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
                                      child: Text('Rp 2.000.000 (Pengeluaran)',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Pengaturan'),
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
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
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
                        margin: EdgeInsets.only(
                            left: 15, right: 15, bottom: 10, top: 5),
                        child: Text('Periode Transaksi')),
                    Container(
                      height: 34,
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
                                  if (transactionPeriods[index] == 'Mingguan') {
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
                                  margin: EdgeInsets.only(right: 5),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Text(transactionPeriods[index])),
                            );
                          }),
                    )
                  ])),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: Text('Grafik Pemasukan')),
                    Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        height: 200,
                        child: SimpleBarChart.withSampleData())
                  ])),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: Text('Grafik Pengeluaran')),
                    Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        height: 200,
                        child: SimpleBarChart.withSampleData())
                  ])),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: Text('Lihat Transaksiku')),
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
                    SizedBox(
                      height: 70,
                    )
                  ])),
                  SliverList(delegate: SliverChildListDelegate([])),
                ]),
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
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      color: Colors.green.shade400,
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
                    }));
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
                    }));
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

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool? animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

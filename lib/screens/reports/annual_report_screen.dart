import 'package:doku/utils/currency_format.dart';
import 'package:flutter/material.dart';

class AnnualReportScreen extends StatefulWidget {
  const AnnualReportScreen({Key? key}) : super(key: key);

  @override
  State<AnnualReportScreen> createState() => _AnnualReportScreenState();
}

class _AnnualReportScreenState extends State<AnnualReportScreen> {
  List<int> years = [2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Tahunan'),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: CustomScrollView(
          // controller: _scrollController,
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
                floating: true,
                automaticallyImplyLeading: false,
                elevation: 1,
                title: Container(
                  height: 40,
                  color: Colors.white,
                  child: ListView.builder(
                      itemCount: years.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                        bottom: 5,
                        left: 5,
                        top: 5
                      ),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          margin: EdgeInsets.only(right: 7),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: index == 0
                                  ? Colors.green.shade400
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 0.5,
                                    blurRadius: 2,
                                    offset: Offset(0, 1))
                              ]),
                          child: Text(years[index].toString(),
                              style: TextStyle(
                                  color: index == 0
                                      ? Colors.white
                                      : Colors.black.withOpacity(0.8))),
                        );
                      }),
                )),
            SliverList(delegate: SliverChildListDelegate([
              ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.date_range,
                                size: 18,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Rabu, 04 Mei 2022'),
                              Spacer(),
                              Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text('Ubah Transaksi')
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Gaji Bulanan, Pemasukan',
                                style: TextStyle(fontSize: 14)),
                            subtitle: Text('Bulanan THR'),
                            dense: true,
                            trailing: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade400,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                currencyId.format(1000000),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Gaji Bulanan, Pemasukan',
                                style: TextStyle(fontSize: 14)),
                            subtitle: Text('Bulanan THR'),
                            dense: true,
                            trailing: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade400,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                currencyId.format(1000000),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  })
            ]))
          ]),
    );
  }
}

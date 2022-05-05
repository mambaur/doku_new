import 'package:doku/utils/currency_format.dart';
import 'package:flutter/material.dart';

class WeeklyReportScreen extends StatefulWidget {
  const WeeklyReportScreen({Key? key}) : super(key: key);

  @override
  State<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends State<WeeklyReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Mingguan'),
        centerTitle: true,
        elevation: 0,
      ),
      body: CustomScrollView(
          // controller: _scrollController,
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              // forceElevated: true,
              floating: true,
              automaticallyImplyLeading: false,
              elevation: 1,
              title: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: 'Minggu',
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 1,
                      style: TextStyle(color: Colors.black.withOpacity(0.8)),
                      underline: Container(
                        height: 1,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          // dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Minggu', 'Senin']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: 'Mei',
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 1,
                      style: TextStyle(color: Colors.black.withOpacity(0.8)),
                      underline: Container(
                        height: 1,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          // dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Mei', 'Senin']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: '2022',
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 1,
                      style: TextStyle(color: Colors.black.withOpacity(0.8)),
                      underline: Container(
                        height: 1,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          // dropdownValue = newValue!;
                        });
                      },
                      items: <String>['2022', 'Senin']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
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
            ])),
            SliverList(delegate: SliverChildListDelegate([])),
          ]),
    );
  }
}

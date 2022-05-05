import 'package:doku/utils/currency_format.dart';
import 'package:flutter/material.dart';

class AllReportScreen extends StatefulWidget {
  const AllReportScreen({Key? key}) : super(key: key);

  @override
  State<AllReportScreen> createState() => _AllReportScreenState();
}

class _AllReportScreenState extends State<AllReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semua Laporan'),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: ListView.builder(
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
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
          }),
    );
  }
}

import 'package:flutter/material.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semua Pemasukan'),
        centerTitle: true,
        elevation: 0.5,
      ),
      // backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: 10,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 10),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kamis, 04-05-2022',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        'Gaji Bulanan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Note: Uang dari pak bos'),
                    ],
                  )),
                  Text('Rp 2.000.000',
                      style: TextStyle(
                          color: Colors.green.shade500,
                          fontWeight: FontWeight.bold))
                ],
              ),
            );
          }),
    );
  }
}

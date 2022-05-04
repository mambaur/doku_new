import 'package:flutter/material.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({ Key? key }) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semua Pengeluaran'),
        elevation: 0.5,
      ),
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
                      Text('Kamis, 04-05-2022', style: TextStyle(fontSize: 12, color: Colors.grey),),
                      Text('Gaji Bulanan', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('Note: Uang dari pak bos'),
                    ],
                  )),
                  Text('Rp 2.000.000', style: TextStyle(color: Colors.orange.shade500, fontWeight: FontWeight.bold))
                ],
              ),
            );
          }),
    );
  }
}
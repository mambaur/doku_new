import 'package:flutter/material.dart';

class IncomeCreateScreen extends StatefulWidget {
  const IncomeCreateScreen({Key? key}) : super(key: key);

  @override
  State<IncomeCreateScreen> createState() => _IncomeCreateScreenState();
}

class _IncomeCreateScreenState extends State<IncomeCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pemasukan'),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Tanggal',
                      suffixIcon: Icon(Icons.date_range),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Jumlah Uang',
                      suffixIcon: Icon(Icons.credit_card),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Kategori',
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey.shade200,
                  margin: EdgeInsets.only(bottom: 3),
                  child: TextField(
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.top,
                    // expands: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        hintText: 'Keterangan'),
                  ),
                ),
              ],
            ),
          ),
          Container(
              // width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green.shade400),
                  onPressed: () {},
                  child: Text('TAMBAH',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: const Text('Tentang Dompet Saku'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                'DOKU (Dompet Saku) adalah aplikasi yang dapat membantu anda mengelola pemasukan dan pengeluaran anda setiap harinya, seperti seperti pemasukan gaji bulanan, uang saku, hadiah dan untuk pengeluaran seperti biaya listrik, makan, belanja, dan lain sebagainya.',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.black.withOpacity(0.8))),
            SizedBox(
              height: 15,
            ),
            Text(
                'Dengan dompet saku, anda akan menjadi lebih hemat, karena doku merupakan aplikasi catatan keuangan yang dapat melacak setiap pemasukan maupun pengeluaran anda setiap harinya.',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.black.withOpacity(0.8))),
            SizedBox(
              height: 15,
            ),
            Text(
                'Fitur-fitur yang ditawarkan pada aplikasi doku: \n- Transaksi pemasukan dan pengeluaran\n- Kategori transaksi\n- Laporan mingguan\n- Laporan bulanan\n- Laporan tahunan',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.black.withOpacity(0.8))),
            SizedBox(
              height: 15,
            ),
            Text(
                'Aplikasi doku ini sangat baik karena memiliki performa yang cepat dan ringan untuk segala jenis smartphone. Bentuk desain yang menarik dan mudah dipahami.',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.black.withOpacity(0.8))),
            // Text(
            //     'Kode Pengembangan ${packageInfo != null ? packageInfo!.buildNumber : ""}'),
          ],
        ),
      ),
    );
  }
}

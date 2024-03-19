import 'package:flutter/material.dart';

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disclaimer'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Disclaimer Aplikasi DOKU',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Aplikasi DOKU merupakan aplikasi catatan keuangan pribadi yang dirancang untuk membantu pengguna dalam mencatat dan mengelola pemasukan serta pengeluaran keuangan mereka. Aplikasi ini tidak berhubungan dengan keuangan tunai bank manapun, baik bank konvensional maupun bank digital.',
                  textAlign: TextAlign.justify,
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Penyimpanan Data',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Data yang dimasukkan oleh pengguna ke dalam aplikasi DOKU disimpan secara lokal pada perangkat Android pengguna. Aplikasi tidak mengirimkan data ke server eksternal atau pihak ketiga. Pengguna bertanggung jawab penuh atas keamanan dan backup data mereka sendiri.',
                  textAlign: TextAlign.justify,
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Privasi Pengguna',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Privasi pengguna sangat penting bagi kami. Aplikasi DOKU tidak mengumpulkan, menyimpan, atau membagikan informasi pribadi pengguna tanpa izin. Kami tidak menyimpan informasi login, nomor rekening, atau informasi keuangan pribadi lainnya dalam aplikasi.',
                  textAlign: TextAlign.justify,
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Konsultasi Keuangan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Aplikasi DOKU dirancang untuk memberikan bantuan dalam pencatatan keuangan pribadi. Meskipun demikian, pengguna disarankan untuk tetap berkonsultasi dengan profesional keuangan sebelum membuat keputusan keuangan yang penting.',
                  textAlign: TextAlign.justify,
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Penggunaan Informasi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Informasi yang disediakan oleh aplikasi DOKU hanya bersifat informatif dan tidak boleh dijadikan sebagai saran atau rekomendasi keuangan. Pengguna bertanggung jawab sepenuhnya atas keputusan keuangan yang diambil berdasarkan informasi dalam aplikasi.',
                  textAlign: TextAlign.justify,
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Perubahan dan Perbaikan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Kami berusaha untuk terus memperbarui dan meningkatkan aplikasi DOKU. Namun, kami tidak bertanggung jawab atas kerugian atau kerusakan yang disebabkan oleh penggunaan atau ketergantungan pada informasi yang disediakan dalam aplikasi.',
                  textAlign: TextAlign.justify,
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Perubahan dan Perbaikan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Jika Anda memiliki pertanyaan atau masukan tentang aplikasi DOKU, jangan ragu untuk menghubungi kami di support@caraguna.com.',
                  textAlign: TextAlign.justify,
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Dengan menggunakan aplikasi DOKU, pengguna dianggap telah membaca, memahami, dan menyetujui disclaimer ini. Kami sarankan untuk membaca disclaimer ini secara berkala untuk memahami perubahan atau tambahan yang mungkin terjadi.',
                  textAlign: TextAlign.justify,
                )),
          ],
        ),
      ),
    );
  }
}

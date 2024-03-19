import 'package:flutter/material.dart';

enum StatusAd { initial, loaded }

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<FaqModel> faqs = [
    FaqModel(
        title: "Apa itu Aplikasi DOKU?",
        description:
            "Aplikasi DOKU adalah aplikasi catatan keuangan pribadi yang dirancang untuk membantu anda mencatat dan mengelola pemasukan serta pengeluaran keuangan anda.",
        isExpanded: false),
    FaqModel(
        title: "Bagaimana Cara Menggunakan Aplikasi DOKU?",
        description:
            "Anda dapat memulai dengan mengunduh dan menginstal aplikasi DOKU dari Google Play Store. Setelah itu, anda dapat membuat akun dan mulai mencatat pemasukan dan pengeluaran keuangan harian anda.",
        isExpanded: false),
    FaqModel(
        title: "Apakah Aplikasi DOKU Aman Digunakan?",
        description:
            "Ya, aplikasi DOKU aman digunakan. Data yang dimasukkan oleh anda disimpan secara lokal pada perangkat Android anda dan tidak dibagikan dengan pihak ketiga.",
        isExpanded: false),
    FaqModel(
        title:
            "Apakah Aplikasi DOKU Tersedia untuk Platform Lain Selain Android?",
        description:
            "Saat ini, Aplikasi DOKU hanya tersedia untuk platform Android. Namun, kami sedang mempertimbangkan untuk mengembangkan versi untuk platform lain di masa mendatang.",
        isExpanded: false),
    FaqModel(
        title: "Apakah Aplikasi DOKU Menyediakan Fitur Laporan Keuangan?",
        description:
            "Ya, Aplikasi DOKU menyediakan fitur laporan keuangan yang memungkinkan anda untuk melihat ringkasan pemasukan dan pengeluaran anda dalam periode waktu tertentu.",
        isExpanded: false),
    FaqModel(
        title:
            "Apakah Aplikasi DOKU Mengirimkan Data Saya ke Server Eksternal?",
        description:
            "Tidak, Aplikasi DOKU tidak mengirimkan data anda ke server eksternal. Semua data disimpan secara lokal pada perangkat anda.",
        isExpanded: false),
    FaqModel(
        title: "Bagaimana Cara Menghubungi Tim Dukungan Aplikasi DOKU?",
        description:
            "Anda dapat menghubungi tim dukungan Aplikasi DOKU melalui email di support@caraguna.com untuk pertanyaan atau masalah teknis.",
        isExpanded: false),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          // controller: _scrollController,
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                margin: const EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ExpansionPanelList(
                    elevation: 0,
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        faqs[index].isExpanded = !faqs[index].isExpanded;
                      });
                    },
                    children: faqs.map<ExpansionPanel>((FaqModel item) {
                      return ExpansionPanel(
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: const Icon(Icons.help_outline),
                            title: Text(item.title ?? '',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: item.isExpanded == true
                                        ? FontWeight.bold
                                        : null,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.color)),
                          );
                        },
                        body: Container(
                          padding: const EdgeInsets.only(
                              bottom: 15, left: 15, right: 15),
                          // color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(item.description ?? '')],
                          ),
                        ),
                        isExpanded: faqs
                            .firstWhere(
                                (element) => element.title == item.title)
                            .isExpanded,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ])),
            SliverList(delegate: SliverChildListDelegate([])),
          ]),
    );
  }
}

class FaqModel {
  String? title, description;
  bool isExpanded;
  FaqModel({this.title, this.description, this.isExpanded = false});
}

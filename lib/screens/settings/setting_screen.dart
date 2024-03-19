import 'package:doku/screens/about/about_screen.dart';
import 'package:doku/screens/categories/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String urlGooglePlay =
      'https://play.google.com/store/apps/details?id=com.caraguna.dompet_apps';
  void _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }

  // PackageInfo? packageInfo;

  // Future getPackageInfo() async {
  //   packageInfo = await PackageInfo.fromPlatform();
  //   setState(() {});
  // }

  @override
  void initState() {
    // getPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Utama',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return const CategoryScreen();
                      }));
                    },
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Kategori',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  // ListTile(
                  //   onTap: () {
                  //     Fluttertoast.showToast(
                  //         msg: 'Fitur akan segera tersedia.');
                  //   },
                  //   contentPadding: EdgeInsets.zero,
                  //   title: const Text(
                  //     'Bahasa',
                  //     style: TextStyle(fontSize: 14),
                  //   ),
                  //   trailing: const Icon(Icons.chevron_right),
                  // ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    onTap: () {
                      _launchUrl(urlGooglePlay);
                    },
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Info Update',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return const AboutScreen();
                      }));
                    },
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Tentang Aplikasi',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  // ListTile(
                  //   onTap: () {
                  //     _launchUrl('https://saweria.co/bauroziq');
                  //   },
                  //   contentPadding: EdgeInsets.zero,
                  //   title: Text(
                  //     'Dukung Pengembangan',
                  //     style: TextStyle(fontSize: 14),
                  //   ),
                  //   trailing: Icon(Icons.chevron_right),
                  // ),
                  // ListTile(
                  //   contentPadding: EdgeInsets.zero,
                  //   title: Text(
                  //     'Versi ${packageInfo != null ? packageInfo!.version : ''}',
                  //     style: TextStyle(fontSize: 14),
                  //   ),
                  //   trailing: Icon(Icons.chevron_right),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

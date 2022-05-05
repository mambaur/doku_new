import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({ Key? key }) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Utama', style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Kategori', style: TextStyle(fontSize: 14),),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Bahasa', style: TextStyle(fontSize: 14),),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
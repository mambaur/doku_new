import 'package:doku/screens/home_screen.dart';
import 'package:doku/shared_preferences/init_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:upgrader/upgrader.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  InitCategory initCategory = InitCategory();
  initCategory.categoryData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOKU',
      theme: ThemeData(
          textTheme: GoogleFonts.nunitoTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              actionsIconTheme:
                  IconThemeData(color: Colors.black.withOpacity(0.8)),
              iconTheme: IconThemeData(color: Colors.black.withOpacity(0.8)))),
      home: UpgradeAlert(
          showIgnore: false,
          showLater: false,
          showReleaseNotes: false,
          child: const HomeScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}

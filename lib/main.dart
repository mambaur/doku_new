import 'package:doku/screens/home_screen.dart';
import 'package:doku/screens/onboarding_screen.dart';
import 'package:doku/shared_preferences/init_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

int introduction = 0;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  InitCategory initCategory = InitCategory();
  initCategory.categoryData();
  await initIntroduction();
  await initializeDateFormatting('id');
  runApp(const MyApp());
}

Future initIntroduction() async {
  final prefs = await SharedPreferences.getInstance();
  int? intro = prefs.getInt('introduction');

  if (intro != null && intro == 1) {
    return introduction = 1;
  }
  prefs.setInt('introduction', 1);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOKU',
      theme: ThemeData(
          useMaterial3: false,
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
      // home: UpgradeAlert(
      //     showIgnore: false,
      //     showLater: false,
      //     showReleaseNotes: false,
      //     child: introduction == 0
      //         ? const OnBoardingScreen()
      //         : const HomeScreen()),
      home: introduction == 0 ? const OnBoardingScreen() : const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:grock/grock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_fit/screens/intro_page1.dart';
import 'package:take_fit/services/services.dart';

import 'contans/app_text.dart';

import 'screens/login_screen.dart';

bool _seen = false;
Future<void> _checkIntroSeen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _seen = (prefs.getBool('seen') ?? false);

}

void main() async {
  var backgroundMessaging;
  WidgetsFlutterBinding.ensureInitialized(); // Flutter bağlamını başlat
  FirebaseMessaging.onBackgroundMessage(FirebaseNotificationService.backgrounMessage);
  WidgetsFlutterBinding.ensureInitialized();
  await _checkIntroSeen();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? selectedLanguage = prefs.getString('selectedLanguage');
  int? selectedThemeIndex = prefs.getInt('selectedThemeIndex');
  runApp(MyApp(selectedLanguage: selectedLanguage, selectedThemeIndex: selectedThemeIndex));
}

class MyApp extends StatelessWidget {
  final String? selectedLanguage;
  final int? selectedThemeIndex;

  const MyApp({Key? key, this.selectedLanguage, this.selectedThemeIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Grock.navigationKey,
      scaffoldMessengerKey: Grock.scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      translations: LocalString(),
      locale: _getLocale(selectedLanguage),
      theme: _getThemeData(selectedThemeIndex),
      home: _seen ? LoginScreen() : IntroPage1(),
    );
  }

  Locale _getLocale(String? languageCode) {
    switch (languageCode) {
      case 'tr':
        return Locale("tr", "TR");
      case 'en':
        return Locale("en", "US");
      default:
        return Locale("tr", "TR");
    }
  }

  ThemeData _getThemeData(int? themeIndex) {
    return themeIndex == 1 ? _darkMode() : _lightMode();
  }

  ThemeData _lightMode() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      fontFamily: 'Roboto',
    );
  }

  ThemeData _darkMode() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
      fontFamily: 'Roboto',
    );
  }
}

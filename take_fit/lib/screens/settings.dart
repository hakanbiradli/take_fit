import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../contans/appcolors.dart';
import '../main.dart';
import '../models/KayitOlModel.dart';
import '../widgets/drawer.dart';

class SettingsScreen extends StatefulWidget {
  final KayitOlModel? kullanici;
  SettingsScreen({required this.kullanici});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late RxInt selectedThemeIndex; // Tema indeksi değişkenini tanımladık
  RxString language = "en".tr.obs;

  @override
  void initState() {
    super.initState();
    _getSelectedLanguage();
    _getSelectedTheme(); // Tema indeksini almak için fonksiyonu çağırıyoruz
  }

  void _getSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? selectedLanguage = prefs.getString('selectedLanguage');
    if (selectedLanguage != null) {
      Locale currentLocale;
      switch (selectedLanguage) {
        case 'en':
          currentLocale = Locale('en', 'US');
          break;
        case 'tr':
          currentLocale = Locale('tr', 'TR');
          break;
        default:
          currentLocale = Locale('tr', 'TR');
          break;
      }
      Get.updateLocale(currentLocale);
      language.value = selectedLanguage.tr;
    }
  }

  void _updateLanguage(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', locale.languageCode);
    Get.updateLocale(locale);
    language.value = locale.languageCode.tr;
  }

  void _getSelectedTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedThemeIndex = RxInt(prefs.getInt('selectedThemeIndex') ?? 0);
    });
  }

  void _updateTheme(int themeIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedThemeIndex', themeIndex);
    setState(() {
      selectedThemeIndex = RxInt(themeIndex);
      runApp(MyApp(selectedLanguage: language.value, selectedThemeIndex: selectedThemeIndex.value));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ayarlar".tr),
      ),
      drawer: drawer(kullanici: widget.kullanici),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  "temalar".tr,
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.greyy,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CheckboxListTile(
                        title: Text('beyaztema'.tr,style: TextStyle(color: AppColors.black),),
                        value: selectedThemeIndex.value == 0,
                        onChanged: (value) {
                          if (value != null && value) {
                            _updateTheme(0); // Beyaz temayı seçin
                          }
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                            color: AppColors.greyy,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CheckboxListTile(
                          title: Text(
                            'siyahtema'.tr,
                            style: TextStyle(color: Colors.white),
                          ),
                          value: selectedThemeIndex.value == 1,
                          onChanged: (value) {
                            if (value != null && value) {
                              _updateTheme(1); // Siyah temayı seçin
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50,left: 30,right: 30),
                child: Container(

                  child: Center(
                    child: Center(
                      child: languageElement(
                        "assets/images/GB.png",
                        "en".tr,
                        Locale("en", "US"),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 50,left: 30,right: 30),
                child: Container(

                  child: Center(
                    child: languageElement(
                      "assets/images/TR.png",
                      "tr".tr,
                      Locale("tr", "TR"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell languageElement(String flag, String text, Locale locale) {
    return InkWell(
      onTap: () {
        _updateLanguage(locale);
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: AppColors.greyy,
            width: 5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(flag),
            ),
            SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                    () => Padding(
                  padding: EdgeInsets.zero,
                  child: language.value == text.tr
                      ? Image.asset("assets/icons/checkboxHelal.png")
                      : language.value.tr == "en"
                      ? Image.asset("assets/icons/emptyCheckboxHelal.png")
                      : Image.asset("assets/icons/emptyCheckboxHelal.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_fit/screens/aboutus_screen.dart';
import 'package:take_fit/screens/gemini_screen.dart';
import 'package:take_fit/screens/home_screen.dart';
import 'package:take_fit/screens/nutrien_input_screen.dart';
import 'package:take_fit/screens/profile_screen.dart';
import 'package:take_fit/screens/settings.dart';
import 'package:take_fit/screens/training_screen.dart';

import '../models/KayitOlModel.dart';
import '../models/StepCounterModel.dart';
import '../models/YapilanSporlarModel.dart';
import '../screens/login_screen.dart';
import 'menu_item.dart';

class drawer extends StatelessWidget {
  KayitOlModel? kullanici;
  drawer({required this.kullanici});

  List<YapilanSporlarModel> yapilan_sporlar_list = [];

  List<YapilanSporlarModel> yapilan_sporlar_filtredList = [];

  List<StepCounterModel> adim_sayar_list = [];

  List<StepCounterModel> adim_sayar_filteredList = [];

  int AdimSayisiBugun = 0;

  double YakilanKcalHepsi = 0;

  double SporlarTumuKcal = 0;
// SharedPreferences'e veri kaydetmek için asenkron bir fonksiyon
  Future<void> changeLoginInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('beni_hatirla_username', "");
    prefs.setString('beni_hatirla_password', "");
    prefs.setBool('beni_hatirla_isChecked',false);}
  //ADIM SAYAR BACKEND
  Future<List<StepCounterModel>> getStepCounterList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('adim_sayar_liste');
    if (jsonList != null) {
      return jsonList
          .map((json) => StepCounterModel.fromJson(jsonDecode(json)))
          .toList();
    } else {
      return [];
    }
  }

  // Gün ve id'ye göre filtrelenecek veriyi döndüren fonksiyon
  List<StepCounterModel> filterByDateAndIdStep(
      List<StepCounterModel> list, String tarih, int id) {
    print(tarih);
    print(id);
    return list
        .where((element) => element.tarih == tarih && element.id == id)
        .toList();
  }

  //YAPILAN SPORLAR BACKEND
  Future<List<YapilanSporlarModel>> getYapilanSporlarList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('yapilan_sporlar_liste');
    if (jsonList != null) {
      return jsonList
          .map((json) => YapilanSporlarModel.fromJson(jsonDecode(json)))
          .toList();
    } else {
      return [];
    }
  }

  List<YapilanSporlarModel> filterByDateAndIdYapilanSporlar(
      List<YapilanSporlarModel> list, String tarih, int id) {
    return list
        .where((element) => element.date_and_time == tarih && element.id == id)
        .toList();
  }

  Future<void> initializeData() async {
    adim_sayar_list = await getStepCounterList();
    yapilan_sporlar_list = await getYapilanSporlarList();
    //Zaman Verisini Al
    DateTime now = DateTime.now();
    String gun = now.day.toString();
    String ay = now.month.toString();
    String yil = now.year.toString();
    String tarih = "$gun/$ay/$yil";
    // Adım Sayar Filtreleme
    try {
      adim_sayar_filteredList = await filterByDateAndIdStep(
          adim_sayar_list, tarih, kullanici!.id!);
      AdimSayisiBugun = adim_sayar_filteredList[0].adim_sayisi!;
    }catch(e){

    }
    try {
      yapilan_sporlar_filtredList = await filterByDateAndIdYapilanSporlar(
          yapilan_sporlar_list, tarih, kullanici!.id!);



    }catch(e) {

    }
    //Yakılan Kcal Hesapla
    for(int i =0;i<yapilan_sporlar_filtredList.length;i++){
      if(yapilan_sporlar_filtredList[i].consumed_kcal != null) {
        SporlarTumuKcal += yapilan_sporlar_filtredList[i].consumed_kcal!;
      }
    }
    YakilanKcalHepsi = (AdimSayisiBugun*0.05)+SporlarTumuKcal;

  }

  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height;
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
            children: [
          Column(
            children: [
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(kullanici: kullanici))),
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 15, top: 30, right: 15, bottom: 10),
                  child: Row(children: [
                    SizedBox(
                      width: 75,
                      height: 75,
                      child: kullanici?.picture == ""
                          ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:
                                AssetImage('assets/images/kullanici.jpg'),
                                fit: BoxFit.cover)),
                      )
                          : Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: FileImage(File(kullanici!.picture!)),
                                  fit: BoxFit.cover))),
                    ),
                    Gap(25),
                    Row(
                      children: [
                        Text(kullanici!.name.toString().toUpperCase()),
                        Gap(10),
                        Text(kullanici!.surname.toString().toUpperCase())
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ]),
                ),
              ),
              Column(
                children: [
                  MenuItem(
                    title: "anasayfa".tr,
                    icon: Icon(Icons.home),
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(kullanici: kullanici),)),
                  ),
                  MenuItem(
                    title: "antrenman".tr,
                    icon: Icon(Icons.people),
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TrainingScreen(kullanici: kullanici))),
                  ),
                  MenuItem(
                      title: "besinler".tr,
                      icon: Icon(Icons.fastfood),
                      onTap: () async{
                        await initializeData();
                        print("yakılan"+YakilanKcalHepsi.toString());
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NutrientScreen(
                                      yakilan_kcal: YakilanKcalHepsi, id: kullanici!.id, kullanici: kullanici,)));

                      }),

                  MenuItem(
                    title: "gemini".tr,
                    icon: Icon(Icons.face),
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GeminiChatScreen(kullanici: kullanici))),
                  ),
                  MenuItem(
                    title: "hakkimizda".tr,
                    icon: Icon(Icons.info),
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AboutUsScreen(kullanici: kullanici))),
                  ),
                  MenuItem(
                    title: "ayarlar".tr,
                    icon: Icon(Icons.settings),
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SettingsScreen(kullanici: kullanici))),
                  ),

                ],
              ),
            ],
          ),
          SizedBox(height: height/4.5),
          MenuItem(
            icon: Icon(Icons.logout),
            onTap: () {
              changeLoginInfo();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen()),(route) => false,);
            },
            title: "cikis".tr,
          ),
        ]),
      ),
    );
  }
}

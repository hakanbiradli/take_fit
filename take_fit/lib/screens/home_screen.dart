// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_fit/contans/appcolors.dart';
import 'package:take_fit/services/services.dart';
import 'package:take_fit/widgets/AnimatedPercentagePainter.dart';
import '../models/KayitOlModel.dart';
import '../models/NutrienDataModel.dart';
import '../models/StepCounterModel.dart';
import '../models/YapilanSporlarModel.dart';
import '../widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  KayitOlModel? kullanici;

  HomeScreen({required this.kullanici});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //listeler
  List<Nutrien_Data_Model> nutrien_list = [];
  List<Nutrien_Data_Model> nutrien_filteredList = [];
  List<YapilanSporlarModel> yapilan_sporlar_list = [];
  List<YapilanSporlarModel> yapilan_sporlar_filtredList = [];
  List<YapilanSporlarModel> yapilan_sporlar_filtredListDun = [];
  List<YapilanSporlarModel> yapilan_sporlar_filtredListOncekiGun = [];
  List<StepCounterModel> adim_sayar_list = [];
  List<StepCounterModel> adim_sayar_filteredList = [];
  List<StepCounterModel> adim_sayar_filteredListDun = [];
  List<StepCounterModel> adim_sayar_filteredListOncekiGun = [];

  //değişkenler
  int SuMiktari = 0;
  int SuOrani = 0;
  int AlinanKalori = 0;
  String image_path = "";
  String yuruyus_image = "https://trthaberstatic.cdn.wp.trt.com.tr/resimler/1610000/yuruyus-1611418.jpg";
  int AdimSayisiBugun = 0;
  int AdimSayisiDun = 0;
  int AdimSayisiOncekiGun = 0;
  double YakilanKcalHepsi = 0;
  double SporlarTumuKcal = 0;

  //NUTRİEN BACKEND
  // SharedPreferences'den Nutrien veriyi almak için yardımcı fonksiyon
  Future<List<Nutrien_Data_Model>> getNutrienList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('nutrien_list');
    if (jsonList != null) {
      return jsonList
          .map((json) => Nutrien_Data_Model.fromJson(jsonDecode(json)))
          .toList();
    } else {
      return [];
    }
  }

  // Gün ve id'ye göre besinler listesinin filtrelenecek veriyi döndüren fonksiyon
  List<Nutrien_Data_Model> filterByDateAndIdNutrien(
      List<Nutrien_Data_Model> list, String tarih, int id) {
    return list
        .where((element) => element.tarih == tarih && element.id == id)
        .toList();
  }

  //YAPILAN SPORLAR BACKEND
  // SharedPreferences'den Nutrien veriyi almak için yardımcı fonksiyon
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

  //ADIM SAYAR BACKEND
  // SharedPreferences'den veriyi almak için yardımcı fonksiyon
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
    return list
        .where((element) => element.tarih == tarih && element.id == id)
        .toList();
  }

  Future<void> initializeData() async {

    // Listeleri Sharedtan Al
    nutrien_list = await getNutrienList();
    yapilan_sporlar_list = await getYapilanSporlarList();
    adim_sayar_list = await getStepCounterList();

    //Zaman Verisini Al
    DateTime now = DateTime.now();
    String gun = now.day.toString();
    String dun = (now.day-1).toString();
    String oncekigun = (now.day-2).toString();
    String ay = now.month.toString();
    String yil = now.year.toString();
    String tarih = "$gun/$ay/$yil";
    String tarihdun = "$dun/$ay/$yil";
    String tarihoncekigun = "$oncekigun/$ay/$yil";

    //Su Ve Kcal Verisi Alındı
    try {
      nutrien_filteredList = await filterByDateAndIdNutrien(
          nutrien_list, tarih, widget.kullanici!.id!);
      SuMiktari = nutrien_filteredList[0].su_miktari!;
      SuOrani = ((100 * SuMiktari) / 2640).toInt();
      AlinanKalori = nutrien_filteredList[0].kahvalti_kcal! +
          nutrien_filteredList[0].ogle_yemegi_kcal! +
          nutrien_filteredList[0].aksam_yemegi_kcal!;
    } catch (e) {}
    // Yapılan Sporlar Filtreleme
    try {
      yapilan_sporlar_filtredList = await filterByDateAndIdYapilanSporlar(
          yapilan_sporlar_list, tarih, widget.kullanici!.id!);

      yapilan_sporlar_filtredListDun = await filterByDateAndIdYapilanSporlar(yapilan_sporlar_list, tarihdun, widget.kullanici!.id!);
      yapilan_sporlar_filtredListOncekiGun = await filterByDateAndIdYapilanSporlar(yapilan_sporlar_list, tarihoncekigun, widget.kullanici!.id!);

    } catch (e) {}
    // Adım Sayar Filtreleme
    try {
      adim_sayar_filteredList = await filterByDateAndIdStep(
          adim_sayar_list, tarih, widget.kullanici!.id!);
      AdimSayisiBugun = adim_sayar_filteredList[0].adim_sayisi!;
    } catch (e) {}
    try {
      adim_sayar_filteredListDun = await filterByDateAndIdStep(
          adim_sayar_list, tarihdun, widget.kullanici!.id!);
      AdimSayisiDun = adim_sayar_filteredListDun[0].adim_sayisi!;
    }catch(e){

    }
    try{
      adim_sayar_filteredListOncekiGun = await filterByDateAndIdStep(
          adim_sayar_list, tarihoncekigun, widget.kullanici!.id!);
      AdimSayisiOncekiGun = adim_sayar_filteredListOncekiGun[0].adim_sayisi!;
  }catch(e){

  }


    //Yakılan Kcal Hesapla
    for(int i =0;i<yapilan_sporlar_filtredList.length;i++){
      if(yapilan_sporlar_filtredList[i].consumed_kcal != null) {
        SporlarTumuKcal += yapilan_sporlar_filtredList[i].consumed_kcal!;
      }
    }
    YakilanKcalHepsi = (AdimSayisiBugun*0.05)+SporlarTumuKcal;
    setState(() {});
  }

  //firebase
  final _service = FirebaseNotificationService();
  @override
  void initState() {
    print("merhaba ramazan");
    _service.connectNotification();

    initializeData();
    //firebase
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(centerTitle: true,
          title: Text("Take Fit"),
        ),
        drawer: drawer(kullanici: widget.kullanici),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Grafik
              Stack(
                children: [
                  Center(
                    child: Container(
                      child: IgnorePointer(
                        ignoring: false,
                        child: ResponsiveAnimatedPercentageCircle(
                          percentage: ((100 * AlinanKalori) / 2500) / 100,
                          colors: AppColors.green,
                          size: screenWidth * 0.6,
                          bool1: true,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        child: IgnorePointer(
                          ignoring: false,
                          child: ResponsiveAnimatedPercentageCircle(
                            percentage: SuOrani / 100,
                            colors: AppColors.blue,
                            size: screenWidth * 0.4,
                            bool1: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  width: screenWidth * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${AlinanKalori} /2500 KCAL",
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${SuMiktari} ml H2O",
                        style: TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Bugün
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text("bugun".tr),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Divider(height: 3,),
              ),
              AdimSayar(
                  screenWidth: screenWidth,
                  image_path: yuruyus_image,
                  AdimSayisi: AdimSayisiBugun),
              SizedBox(
                width: screenWidth - 50,
                height: yapilan_sporlar_filtredList.length*135,
                child: ListView.builder(
                    itemCount: yapilan_sporlar_filtredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (yapilan_sporlar_filtredList[index].spor_name == 'isinmaegzersiz') {
                        image_path =
                            "https://blog.bodyforumtr.com/wp-content/uploads/2018/10/isinma-hareketleri.jpg";
                      }else if(yapilan_sporlar_filtredList[index].spor_name == 'tumvucutb'){
                        image_path = "https://shreddedbrothers.com/uploads/blogs/ckeditor/files/kad%C4%B1nlar-i%C3%A7in-fitness-4.jpg";
                      }
                      else if(yapilan_sporlar_filtredList[index].spor_name == 'tumvucuto'){
                        image_path = "https://blog.bodyforumtr.com/wp-content/uploads/2017/03/machine-flye.jpg";
                      }
                      else if(yapilan_sporlar_filtredList[index].spor_name == 'tumvucuti'){
                        image_path = "https://www.sporty.com.tr/wp-content/uploads/2017/02/vucut-gelistirme-erkek-sporcu.jpg";
                      }
                      else if(yapilan_sporlar_filtredList[index].spor_name == 'planko'){
                        image_path = "https://hthayat.haberturk.com/im/2017/03/31/1048809_1b5e87ef80a20133dbfa06aa8a3d85bc_600x600.jpg";
                      }
                      else if(yapilan_sporlar_filtredList[index].spor_name == 'karinb'){
                        image_path = "https://buuon.com.tr/wp-content/uploads/2020/09/en-iyi-karin-kasi-hareketleri.jpg";
                      }
                      else if(yapilan_sporlar_filtredList[index].spor_name == 'tabatao'){
                        image_path = "https://i.nefisyemektarifleri.com/2023/01/19/tabata-antrenmani-kalorileri-evden-cikmadan-yakin-7.jpg";
                      }
                      else if(yapilan_sporlar_filtredList[index].spor_name == 'tekrarorta'){
                        image_path = "https://gymbat.com/wp-content/uploads/definisyon-gymbat.jpg";
                      }
                      else if(yapilan_sporlar_filtredList[index].spor_name == 'yanlarindanorta'){
                        image_path = "https://imgrosetta.mynet.com.tr/file/16809201/16809201-530x400.jpg";
                      }
                      return SizedBox(
                        height: 130,
                        child: Card(
                            color: Colors.grey,
                            child: Stack(
                              children: [
                                //arka plan resmi
                                SizedBox(
                                    width: screenWidth - 50,
                                    child: Opacity(
                                        opacity: 0.3,
                                        child: Image.network(
                                          image_path,
                                          fit: BoxFit.cover,
                                        ))),
                                Column(children: [
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(yapilan_sporlar_filtredList[index].spor_name!.tr,style: TextStyle(fontWeight: FontWeight.bold),),
                                  )),
                                  Expanded(child: Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 40),
                                            child: Text(yapilan_sporlar_filtredList[index].step_value!.toString()+" set",style: TextStyle(fontSize: 20),),
                                          )),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.only(right: 40),
                                        child: Text(yapilan_sporlar_filtredList[index].spent_time.toString()+" dk",textAlign: TextAlign.end,style: TextStyle(fontSize: 20),),
                                      )),
                                    ],
                                  )),
                                ],)
                              ],
                            )),
                      );
                    }),
              ),
              Gap(20),
              //Dün
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text("dun".tr),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Divider(height: 3,),
              ),
              AdimSayar(
                  screenWidth: screenWidth,
                  image_path: yuruyus_image,
                  AdimSayisi: AdimSayisiDun),
              SizedBox(
                width: screenWidth - 50,
                height: yapilan_sporlar_filtredListDun.length*135,
                child: ListView.builder(
                    itemCount: yapilan_sporlar_filtredListDun.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (yapilan_sporlar_filtredListDun[index].spor_name == 'isinmaegzersiz') {
                        image_path =
                        "https://blog.bodyforumtr.com/wp-content/uploads/2018/10/isinma-hareketleri.jpg";
                      }else if(yapilan_sporlar_filtredListDun[index].spor_name == 'tumvucutb'){
                        image_path = "https://shreddedbrothers.com/uploads/blogs/ckeditor/files/kad%C4%B1nlar-i%C3%A7in-fitness-4.jpg";
                      }
                      else if(yapilan_sporlar_filtredListDun[index].spor_name == 'tumvucuto'){
                        image_path = "https://blog.bodyforumtr.com/wp-content/uploads/2017/03/machine-flye.jpg";
                      }
                      else if(yapilan_sporlar_filtredListDun[index].spor_name == 'tumvucuti'){
                        image_path = "https://www.sporty.com.tr/wp-content/uploads/2017/02/vucut-gelistirme-erkek-sporcu.jpg";
                      }
                      else if(yapilan_sporlar_filtredListDun[index].spor_name == 'planko'){
                        image_path = "https://hthayat.haberturk.com/im/2017/03/31/1048809_1b5e87ef80a20133dbfa06aa8a3d85bc_600x600.jpg";
                      }
                      else if(yapilan_sporlar_filtredListDun[index].spor_name == 'karinb'){
                        image_path = "https://buuon.com.tr/wp-content/uploads/2020/09/en-iyi-karin-kasi-hareketleri.jpg";
                      }
                      else if(yapilan_sporlar_filtredListDun[index].spor_name == 'tabatao'){
                        image_path = "https://i.nefisyemektarifleri.com/2023/01/19/tabata-antrenmani-kalorileri-evden-cikmadan-yakin-7.jpg";
                      }
                      else if(yapilan_sporlar_filtredListDun[index].spor_name == 'tekrarorta'){
                        image_path = "https://gymbat.com/wp-content/uploads/definisyon-gymbat.jpg";
                      }
                      else if(yapilan_sporlar_filtredListDun[index].spor_name == 'yanlarindanorta'){
                        image_path = "https://imgrosetta.mynet.com.tr/file/16809201/16809201-530x400.jpg";
                      }
                      return SizedBox(
                        height: 130,
                        child: Card(
                            color: Colors.grey,
                            child: Stack(
                              children: [
                                //arka plan resmi
                                SizedBox(
                                    width: screenWidth - 50,
                                    child: Opacity(
                                        opacity: 0.3,
                                        child: Image.network(
                                          image_path,
                                          fit: BoxFit.cover,
                                        ))),
                                Column(children: [
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(yapilan_sporlar_filtredListDun[index].spor_name!.tr,style: TextStyle(fontWeight: FontWeight.bold),),
                                  )),
                                  Expanded(child: Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 40),
                                            child: Text(yapilan_sporlar_filtredListDun[index].step_value!.toString()+" set",style: TextStyle(fontSize: 20),),
                                          )),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.only(right: 40),
                                        child: Text(yapilan_sporlar_filtredListDun[index].spent_time.toString()+" dk",textAlign: TextAlign.end,style: TextStyle(fontSize: 20),),
                                      )),
                                    ],
                                  )),
                                ],)
                              ],
                            )),
                      );
                    }),
              ),
              Gap(20),
              //Önceki Gün
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text("onceki".tr),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Divider(height: 3,),
              ),
              AdimSayar(
                  screenWidth: screenWidth,
                  image_path: yuruyus_image,
                  AdimSayisi: AdimSayisiOncekiGun),
              SizedBox(
                width: screenWidth - 50,
                height: yapilan_sporlar_filtredListOncekiGun.length*135,
                child: ListView.builder(
                    itemCount: yapilan_sporlar_filtredListOncekiGun.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (yapilan_sporlar_filtredListOncekiGun[index].spor_name == 'isinmaegzersiz') {
                        image_path =
                        "https://blog.bodyforumtr.com/wp-content/uploads/2018/10/isinma-hareketleri.jpg";
                      }else if(yapilan_sporlar_filtredListOncekiGun[index].spor_name == 'tumvucutb'){
                        image_path = "https://shreddedbrothers.com/uploads/blogs/ckeditor/files/kad%C4%B1nlar-i%C3%A7in-fitness-4.jpg";
                      }
                      else if(yapilan_sporlar_filtredListOncekiGun[index].spor_name == 'tumvucuto'){
                        image_path = "https://blog.bodyforumtr.com/wp-content/uploads/2017/03/machine-flye.jpg";
                      }
                      else if(yapilan_sporlar_filtredListOncekiGun[index].spor_name == 'tumvucuti'){
                        image_path = "https://www.sporty.com.tr/wp-content/uploads/2017/02/vucut-gelistirme-erkek-sporcu.jpg";
                      }
                      else if(yapilan_sporlar_filtredListOncekiGun[index].spor_name == 'planko'){
                        image_path = "https://hthayat.haberturk.com/im/2017/03/31/1048809_1b5e87ef80a20133dbfa06aa8a3d85bc_600x600.jpg";
                      }
                      else if(yapilan_sporlar_filtredListOncekiGun[index].spor_name == 'karinb'){
                        image_path = "https://buuon.com.tr/wp-content/uploads/2020/09/en-iyi-karin-kasi-hareketleri.jpg";
                      }
                      else if(yapilan_sporlar_filtredListOncekiGun[index].spor_name == 'tabatao'){
                        image_path = "https://i.nefisyemektarifleri.com/2023/01/19/tabata-antrenmani-kalorileri-evden-cikmadan-yakin-7.jpg";
                      }
                      else if(yapilan_sporlar_filtredListOncekiGun[index].spor_name == 'tekrarorta'){
                        image_path = "https://gymbat.com/wp-content/uploads/definisyon-gymbat.jpg";
                      }
                      else if(yapilan_sporlar_filtredListOncekiGun[index].spor_name == 'yanlarindanorta'){
                        image_path = "https://imgrosetta.mynet.com.tr/file/16809201/16809201-530x400.jpg";
                      }
                      return SizedBox(
                        height: 130,
                        child: Card(
                            color: Colors.grey,
                            child: Stack(
                              children: [
                                //arka plan resmi
                                SizedBox(
                                    width: screenWidth - 50,
                                    child: Opacity(
                                        opacity: 0.3,
                                        child: Image.network(
                                          image_path,
                                          fit: BoxFit.cover,
                                        ))),
                                Column(children: [
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(yapilan_sporlar_filtredListOncekiGun[index].spor_name!.tr,style: TextStyle(fontWeight: FontWeight.bold),),
                                  )),
                                  Expanded(child: Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 40),
                                            child: Text(yapilan_sporlar_filtredListOncekiGun[index].step_value!.toString()+" set",style: TextStyle(fontSize: 20),),
                                          )),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.only(right: 40),
                                        child: Text(yapilan_sporlar_filtredListOncekiGun[index].spent_time.toString()+" dk",textAlign: TextAlign.end,style: TextStyle(fontSize: 20),),
                                      )),
                                    ],
                                  )),
                                ],)
                              ],
                            )),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdimSayar extends StatelessWidget {
  const AdimSayar({
    super.key,
    required this.screenWidth,
    required this.image_path,
    required this.AdimSayisi,
  });

  final double screenWidth;
  final String image_path;
  final int AdimSayisi;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth - 50,
      height: 150,
      child: Card(
        color: Colors.grey,
        child: Stack(
          children: [
            //arka plan resmi
            SizedBox(
                width: screenWidth - 50,
                child: Opacity(
                    opacity: 0.4,
                    child: Image.network(
                      image_path,
                      fit: BoxFit.cover,
                    ))),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Center(
                        child: Text(
                      AdimSayisi.toString(),
                      style: TextStyle(fontSize: 60, color: Colors.green),
                    ))),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          ((AdimSayisi * 0.65) / 1000).toStringAsFixed(2),
                          style: TextStyle(fontSize: 30),
                        ),
                        Icon(Icons.navigation),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

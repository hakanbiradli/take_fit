import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_fit/models/NutrienDataModel.dart';


import '../contans/appcolors.dart';
import '../models/KayitOlModel.dart';
import '../widgets/AnimatedPercentagePainter.dart';
import '../widgets/AnimatedPercentagePainterNutrien.dart';
import '../widgets/drawer.dart';

class NutrientScreen extends StatefulWidget {
  int? id;
  double? yakilan_kcal;
  final KayitOlModel? kullanici;
  NutrientScreen({
    required this.id,
    required this.yakilan_kcal,
  required this.kullanici});

  @override
  State<NutrientScreen> createState() => _NutrientScreenState();
}

class _NutrientScreenState extends State<NutrientScreen> {
  //Besin Listesi
  List<Nutrien_Data_Model> nutrien_list = [];
  List<Nutrien_Data_Model> filteredList = [];

  //controllerlar
  TextEditingController suController = TextEditingController();
  TextEditingController karbonhidratController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController yagController = TextEditingController();

  //değişkenler
  int su_miktari = 0;
  int su_orani = 0;
  int karbonhidrat_miktari = 0;
  int protein_miktari = 0;
  int yag_miktari = 0;
  int kahvalti_kcal = 0;
  int ogle_yemegi_kcal = 0;
  int aksam_yemegi_kcal = 0;
  int alinan_kcal =0;
  //HAFIZA İŞLEMLERİ (BACKEND)

  // SharedPreferences üzerindeki veriyi güncellemek için yardımcı fonksiyon
  Future<void> saveNutrienList(List<Nutrien_Data_Model> list) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = list.map((model) => model.toJson()).map((json) => jsonEncode(json)).toList();
    await prefs.setStringList('nutrien_list', jsonList);
  }

// SharedPreferences'den veriyi almak için yardımcı fonksiyon
  Future<List<Nutrien_Data_Model>> getNutrienList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('nutrien_list');
    if (jsonList != null) {
      return jsonList.map((json) => Nutrien_Data_Model.fromJson(jsonDecode(json))).toList();
    } else {
      return [];
    }
  }

// Gün ve id'ye göre filtrelenecek veriyi döndüren fonksiyon
  List<Nutrien_Data_Model> filterByDateAndId(List<Nutrien_Data_Model> list, String tarih, int id) {
    return list.where((element) => element.tarih == tarih && element.id == id).toList();
  }


// Veriyi güncelleyen fonksiyon
  List<Nutrien_Data_Model> updateNutrien(List<Nutrien_Data_Model> list, String tarih, int id, int newSuMiktari, int newKarbonhidratMiktari, int newProteinMiktari, int newYagMiktari,int newKahvaltiKcal,int newOgleYemegiKcal,int newAksamYemegiKcal) {
    if(list.length == 0){
      Nutrien_Data_Model yeni_data= new Nutrien_Data_Model(id: id, su_miktari: newSuMiktari, karbonhidrat_miktari: newKarbonhidratMiktari, protein_miktari: newProteinMiktari, yag_miktari: newYagMiktari, kahvalti_kcal: newKahvaltiKcal, ogle_yemegi_kcal: newOgleYemegiKcal, aksam_yemegi_kcal: newAksamYemegiKcal, tarih: tarih);
      list.add(yeni_data);
    }
    for (var i = 0; i < list.length; i++) {
      if (list[i].tarih == tarih && list[i].id == id) {
        list[i].su_miktari= newSuMiktari;
        list[i].karbonhidrat_miktari= newKarbonhidratMiktari;
        list[i].protein_miktari= newProteinMiktari;
        list[i].yag_miktari= newYagMiktari;
        list[i].kahvalti_kcal= newKahvaltiKcal;
        list[i].ogle_yemegi_kcal= newOgleYemegiKcal;
        list[i].aksam_yemegi_kcal= newAksamYemegiKcal;
        return list;
      }else{
        Nutrien_Data_Model yeni_data= new Nutrien_Data_Model(id: id, su_miktari: newSuMiktari, karbonhidrat_miktari: newKarbonhidratMiktari, protein_miktari: newProteinMiktari, yag_miktari: newYagMiktari, kahvalti_kcal: newKahvaltiKcal, ogle_yemegi_kcal: newOgleYemegiKcal, aksam_yemegi_kcal: newAksamYemegiKcal, tarih: tarih);
        list.add(yeni_data);
      }
    }
    return list;
  }


  Future<void> initializeData() async {
    //sharedtan verilei al
    nutrien_list = await getNutrienList();

    // Gün ve id'ye göre filtrelenmiş liste
    DateTime now = DateTime.now();
    String gun = now.day.toString();
    String ay = now.month.toString();
    String yil = now.year.toString();
    String tarih = "$gun/$ay/$yil";
    try {
      List<Nutrien_Data_Model> filteredList = await filterByDateAndId(
          nutrien_list, tarih, widget.id!);
      su_miktari = filteredList[0].su_miktari!;
      kahvalti_kcal = filteredList[0].kahvalti_kcal!;
      ogle_yemegi_kcal = filteredList[0].ogle_yemegi_kcal!;
      aksam_yemegi_kcal = filteredList[0].aksam_yemegi_kcal!;
      protein_miktari = filteredList[0].protein_miktari!;
      karbonhidrat_miktari = filteredList[0].karbonhidrat_miktari!;
      yag_miktari = filteredList[0].yag_miktari!;
    }catch(e){

    }
    su_orani = ((100 * su_miktari) / 2640)
        .toInt();
    alinan_kcal = kahvalti_kcal+ogle_yemegi_kcal+aksam_yemegi_kcal;
    setState(() {

    });
  }

  @override
  void initState() {
    initializeData();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("besinler".tr),
      ),
      drawer: drawer(kullanici: widget.kullanici),
      body: SingleChildScrollView(
          child: Column(
            children: [
              //GRAFİKLER
              Stack(children: [
                Container(
                  width: screenWidth,
                  height: screenHeight*0.4,
                  color: AppColors.green3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Gap(30),
                                Text(
                                  "alinan".tr,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.orange.shade400,fontWeight: FontWeight.bold),
                                ),
                                Gap(10),
                                Text(
                                  "$alinan_kcal",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "kcal".tr,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                     ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          child: IgnorePointer(
                                            ignoring: false,
                                            child: InkWell(
                                              child: ResponsiveAnimatedPercentageCircleNutrien(
                                                percentage: 1,
                                                colors: Colors.orange.shade400,
                                                size: 150,
                                                bool1: false,
                                              ),
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
                                              child: InkWell(
                                                child: ResponsiveAnimatedPercentageCircleNutrien(
                                                  percentage: alinan_kcal < 1 ? 0 : ((100*widget.yakilan_kcal!) / alinan_kcal) /100,//(((100*widget.yakilan_kcal!)/ (alinan_kcal==0?1:alinan_kcal))/100)> 10? 0:(((100*widget.yakilan_kcal!)/ (alinan_kcal==0?1:alinan_kcal))/100),
                                                  colors: Colors.brown,
                                                  size: 110,
                                                  bool1: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Gap(30),
                                  Text(
                                    "yakilan".tr,
                                    style:
                                    TextStyle(fontSize: 15, color:Colors.brown,fontWeight: FontWeight.bold),
                                  ),
                                  Gap(10),
                                  Text(
                                    widget.yakilan_kcal!.toStringAsFixed(1),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "kcal".tr,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Gap(190),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: SizedBox(
                          width: screenWidth,
                          height: 100,
                          child: Card(
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                      children: [
                                        Gap(15),
                                        Text("karbonhidrat".tr),
                                        Container(
                                            width: 90,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Color(0xffdbc4cc))),
                                        Gap(5),
                                        Text(
                                          "$karbonhidrat_miktari gr",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                                Expanded(
                                    child: Column(
                                      children: [
                                        Gap(15),
                                        Text("protein".tr),
                                        Container(
                                            width: 90,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Color(0xffdee6f9))),
                                        Gap(5),
                                        Text(
                                          "$protein_miktari gr",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                                Expanded(
                                    child: Column(
                                      children: [
                                        Gap(15),
                                        Text("yag".tr),
                                        Container(
                                            width: 90,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Color(0xfff9ecda))),
                                        Gap(5),
                                        Text(
                                          "$yag_miktari gr",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          )),
                    ),
                  ],
                )
              ]),
              Gap(30),
              //SU GİRİŞİ,
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                    width: screenWidth,
                    height: 200,
                    child: Card(
                      child: Column(
                        children: [
                          Gap(15),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Gap(15),
                                Icon(
                                  Icons.water_drop,
                                  color: Colors.blueAccent,
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    " $su_miktari / 2640 ml",
                                    style: TextStyle(
                                        fontSize: 20),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      "$su_orani%",
                                      style: TextStyle(
                                           fontSize: 20),
                                    )),
                              ],
                            ),
                          ),
                          Gap(30),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Stack(children: [
                                SizedBox(
                                  width: screenWidth,
                                  height: 40,
                                  child: Card(
                                    color: Colors.blue[100],
                                  ),
                                ),
                                SizedBox(
                                  width: (((screenWidth-20) * su_orani) / 100) ,
                                  height: 40,
                                  child: Card(
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          Gap(20),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Gap(20),
                                GestureDetector(
                                  onTap: () {
                                    suController.text = "";
                                    // AlertDialog'u göster
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: SingleChildScrollView(
                                            child: AlertDialog(
                                              title: Icon(
                                                Icons.water_drop,
                                                color: Colors.blueAccent,
                                              ),
                                              content: TextField(
                                                controller: suController,
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                    hintText: "ml",
                                                    hintStyle: TextStyle(fontSize: 20)),
                                              ),
                                              actions: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 20),
                                                  child: TextButton(
                                                    onPressed: () async{
                                                      if(suController.text != null && suController.text != "") {
                                                        su_miktari +=
                                                            int.parse(
                                                                suController.text);
                                                        su_orani =
                                                            ((100 * su_miktari) / 2640)
                                                                .toInt();
                                                        suController.text = "";
                                                        //backendi güncelle
                                                        DateTime now = DateTime.now();
                                                        String gun = now.day.toString();
                                                        String ay = now.month
                                                            .toString();
                                                        String yil = now.year
                                                            .toString();
                                                        String tarih = "$gun/$ay/$yil";
                                                        int newSuMiktari = su_miktari;
                                                        int newKarbonhidratMiktari = su_miktari;
                                                        int newProteinMiktari = protein_miktari;
                                                        int newYagMiktari = yag_miktari;
                                                        int newKahvaltiKcal = kahvalti_kcal;
                                                        int newOgleYemegiKcal = ogle_yemegi_kcal;
                                                        int newAksamYemegiKcal = aksam_yemegi_kcal;
                                                        nutrien_list =
                                                        await updateNutrien(
                                                            nutrien_list,
                                                            tarih,
                                                            widget.id!,
                                                            newSuMiktari,
                                                            newKarbonhidratMiktari,
                                                            newProteinMiktari,
                                                            newYagMiktari,
                                                            newKahvaltiKcal,
                                                            newOgleYemegiKcal,
                                                            newAksamYemegiKcal);
                                                        await saveNutrienList(
                                                            nutrien_list);
                                                        setState(() {});
                                                        // AlertDialog'u kapat
                                                        Navigator.of(context).pop();
                                                      }else{
                                                        suController.text = "bos".tr;
                                                      }
                                                    },
                                                    child: Text('tamam'.tr),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    child: Center(
                                        child: Text(
                                          "+",
                                          style:
                                          TextStyle(fontSize: 25),
                                        )),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                        Border.all( width: 3)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              Gap(40),
              //KAHVALTI
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: GestureDetector(
                  onTap: () {
                    karbonhidratController.text = "";
                    proteinController.text = "";
                    yagController.text = "";
                    // AlertDialog'u göster
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: SingleChildScrollView(
                            child: AlertDialog(
                              title: Icon(
                                Icons.local_dining,
                                color: Colors.orange[300],
                              ),
                              actions: <Widget>[
                                Center(
                                    child: Text(
                                      "karbonhidrat".tr,
                                      style: TextStyle(fontSize: 20),
                                    )),
                                TextField(
                                  controller: karbonhidratController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      hintText: "gr", hintStyle: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Center(
                                      child: Text(
                                        "protein".tr,
                                        style:
                                        TextStyle(fontSize: 20),
                                      )),
                                ),
                                TextField(
                                  controller: proteinController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      hintText: "gr", hintStyle: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Center(
                                      child: Text(
                                        "yag".tr,
                                        style:
                                        TextStyle(fontSize: 20),
                                      )),
                                ),
                                TextField(
                                  controller: yagController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      hintText: "gr", hintStyle: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: TextButton(
                                    onPressed: () async{
                                      if (karbonhidratController.text != null &&
                                          karbonhidratController.text != "" &&
                                          proteinController.text != null &&
                                          proteinController.text != "" &&
                                          yagController.text != null &&
                                          yagController.text != "") {
                                        karbonhidrat_miktari +=
                                            int.parse(karbonhidratController.text);
                                        protein_miktari +=
                                            int.parse(proteinController.text);
                                        yag_miktari += int.parse(yagController.text);
                                        kahvalti_kcal += (int.parse(karbonhidratController.text)*4) + (int.parse(proteinController.text)*4) + (int.parse(yagController.text)*9);
                                        alinan_kcal = kahvalti_kcal+ogle_yemegi_kcal+aksam_yemegi_kcal;
                                        //backendi güncelle
                                        DateTime now = DateTime.now();
                                        String gun = now.day.toString();
                                        String ay = now.month.toString();
                                        String yil = now.year.toString();
                                        String tarih = "$gun/$ay/$yil";
                                        int newSuMiktari = su_miktari;
                                        int newKarbonhidratMiktari = su_miktari;
                                        int newProteinMiktari = protein_miktari;
                                        int newYagMiktari = yag_miktari;
                                        int newKahvaltiKcal = kahvalti_kcal;
                                        int newOgleYemegiKcal = ogle_yemegi_kcal;
                                        int newAksamYemegiKcal = aksam_yemegi_kcal;
                                        await updateNutrien(nutrien_list, tarih, widget.id!, newSuMiktari, newKarbonhidratMiktari, newProteinMiktari, newYagMiktari, newKahvaltiKcal, newOgleYemegiKcal, newAksamYemegiKcal);
                                        await saveNutrienList(nutrien_list);
                                        setState(() {});
                                        // AlertDialog'u kapat
                                        Navigator.of(context).pop();
                                      } else {
                                        karbonhidratController.text = "bos".tr;
                                        proteinController.text = "bos".tr;
                                        yagController.text = "bos".tr;
                                        setState(() {});
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text('tamam'.tr,style: TextStyle(color: Colors.orange[300]),),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: SizedBox(
                      width: screenWidth,
                      height: 100,
                      child: Card(
                        child: Row(
                          children: [
                            Gap(10),
                            Icon(
                              Icons.local_dining,
                              color: Colors.orange[300],
                              size: 35,
                            ),
                            Gap(10),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "sabah".tr,
                                style: TextStyle( fontSize: 20),
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Gap(25),
                                  Text("$kahvalti_kcal",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    "kcal".tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                ">",
                                style: TextStyle(fontSize: 20,),
                              ),
                            )
                          ],
                        ),

                      )),
                ),
              ),
              Gap(30),
              //ÖĞLE YEMEĞİ
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: GestureDetector(
                  onTap: () {
                    karbonhidratController.text = "";
                    proteinController.text = "";
                    yagController.text = "";
                    // AlertDialog'u göster
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: SingleChildScrollView(
                            child: AlertDialog(
                              title: Icon(
                                Icons.fastfood,
                                color: Colors.orange[800],
                              ),
                              actions: <Widget>[
                                Center(
                                    child: Text(
                                      "karbonhidrat",
                                      style: TextStyle(fontSize: 20,),
                                    )),
                                TextField(
                                  controller: karbonhidratController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      hintText: "gr", hintStyle: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Center(
                                      child: Text(
                                        "protein".tr,
                                        style:
                                        TextStyle(fontSize: 20),
                                      )),
                                ),
                                TextField(
                                  controller: proteinController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      hintText: "gr", hintStyle: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Center(
                                      child: Text(
                                        "yag".tr,
                                        style:
                                        TextStyle(fontSize: 20,),
                                      )),
                                ),
                                TextField(
                                  controller: yagController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      hintText: "gr", hintStyle: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: TextButton(
                                    onPressed: () async{
                                      if (karbonhidratController.text != null &&
                                          karbonhidratController.text != "" &&
                                          proteinController.text != null &&
                                          proteinController.text != "" &&
                                          yagController.text != null &&
                                          yagController.text != "") {
                                        karbonhidrat_miktari +=
                                            int.parse(karbonhidratController.text);
                                        protein_miktari +=
                                            int.parse(proteinController.text);
                                        yag_miktari += int.parse(yagController.text);
                                        ogle_yemegi_kcal += (int.parse(karbonhidratController.text)*4) + (int.parse(proteinController.text)*4) + (int.parse(yagController.text)*9);
                                        alinan_kcal = kahvalti_kcal+ogle_yemegi_kcal+aksam_yemegi_kcal;
                                        //backendi güncelle
                                        DateTime now = DateTime.now();
                                        String gun = now.day.toString();
                                        String ay = now.month.toString();
                                        String yil = now.year.toString();
                                        String tarih = "$gun/$ay/$yil";
                                        int newSuMiktari = su_miktari;
                                        int newKarbonhidratMiktari = su_miktari;
                                        int newProteinMiktari = protein_miktari;
                                        int newYagMiktari = yag_miktari;
                                        int newKahvaltiKcal = kahvalti_kcal;
                                        int newOgleYemegiKcal = ogle_yemegi_kcal;
                                        int newAksamYemegiKcal = aksam_yemegi_kcal;
                                        await updateNutrien(nutrien_list, tarih, widget.id!, newSuMiktari, newKarbonhidratMiktari, newProteinMiktari, newYagMiktari, newKahvaltiKcal, newOgleYemegiKcal, newAksamYemegiKcal);
                                        await saveNutrienList(nutrien_list);
                                        setState(() {});
                                        // AlertDialog'u kapat
                                        Navigator.of(context).pop();
                                      } else {
                                        karbonhidratController.text = "bos".tr;
                                        proteinController.text =  "bos".tr;;
                                        yagController.text =  "bos".tr;
                                        setState(() {});
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text('tamam'.tr,style: TextStyle(color: Colors.orange[800]),),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: SizedBox(
                      width: screenWidth,
                      height: 100,
                      child: Card(
                        child: Row(
                          children: [
                            Gap(10),
                            Icon(
                              Icons.fastfood,
                              color: Colors.orange[800],
                              size: 35,
                            ),
                            Gap(10),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "ogle".tr,
                                style: TextStyle( fontSize: 20),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Gap(25),
                                  Text("$ogle_yemegi_kcal",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                      )),
                                  Text(
                                    "kcal".tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                ">",
                                style: TextStyle(fontSize: 20, ),
                              ),
                            )
                          ],
                        ),

                      )),
                ),
              ),
              Gap(30),
              //AKŞAM YEMEĞİ
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: GestureDetector(
                  onTap: () {
                    karbonhidratController.text = "";
                    proteinController.text = "";
                    yagController.text = "";
                    // AlertDialog'u göster
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: SingleChildScrollView(
                            child: AlertDialog(
                              title: Icon(
                                Icons.restaurant,
                                color: Colors.blueAccent[100],
                              ),
                              actions: <Widget>[
                                Center(
                                    child: Text(
                                      "karbonhidrat".tr,
                                      style: TextStyle(fontSize: 20,),
                                    )),
                                TextField(
                                  controller: karbonhidratController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      hintText: "gr", hintStyle: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Center(
                                      child: Text(
                                        "protein".tr,
                                        style:
                                        TextStyle(fontSize: 20,),
                                      )),
                                ),
                                TextField(
                                  controller: proteinController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      hintText: "gr", hintStyle: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Center(
                                      child: Text(
                                        "yag".tr,
                                        style:
                                        TextStyle(fontSize: 20),
                                      )),
                                ),
                                TextField(
                                  controller: yagController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      hintText: "gr", hintStyle: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: TextButton(
                                    onPressed: () async{
                                      if (karbonhidratController.text != null &&
                                          karbonhidratController.text != "" &&
                                          proteinController.text != null &&
                                          proteinController.text != "" &&
                                          yagController.text != null &&
                                          yagController.text != "") {
                                        karbonhidrat_miktari +=
                                            int.parse(karbonhidratController.text);
                                        protein_miktari +=
                                            int.parse(proteinController.text);
                                        yag_miktari += int.parse(yagController.text);
                                        aksam_yemegi_kcal += (int.parse(karbonhidratController.text)*4) + (int.parse(proteinController.text)*4) + (int.parse(yagController.text)*9);
                                        alinan_kcal = kahvalti_kcal+ogle_yemegi_kcal+aksam_yemegi_kcal;
                                        //backendi güncelle
                                        DateTime now = DateTime.now();
                                        String gun = now.day.toString();
                                        String ay = now.month.toString();
                                        String yil = now.year.toString();
                                        String tarih = "$gun/$ay/$yil";
                                        int newSuMiktari = su_miktari;
                                        int newKarbonhidratMiktari = su_miktari;
                                        int newProteinMiktari = protein_miktari;
                                        int newYagMiktari = yag_miktari;
                                        int newKahvaltiKcal = kahvalti_kcal;
                                        int newOgleYemegiKcal = ogle_yemegi_kcal;
                                        int newAksamYemegiKcal = aksam_yemegi_kcal;
                                        await updateNutrien(nutrien_list, tarih, widget.id!, newSuMiktari, newKarbonhidratMiktari, newProteinMiktari, newYagMiktari, newKahvaltiKcal, newOgleYemegiKcal, newAksamYemegiKcal);
                                        await saveNutrienList(nutrien_list);
                                        setState(() {});
                                        // AlertDialog'u kapat
                                        Navigator.of(context).pop();
                                      } else {
                                        karbonhidratController.text = "bos".tr;
                                        proteinController.text = "bos".tr;
                                        yagController.text = "bos".tr;
                                        setState(() {});
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text('tamam'.tr,style: TextStyle(color: Colors.blueAccent[100]),),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: SizedBox(
                      width: screenWidth,
                      height: 100,
                      child: Card(
                        child: Row(
                          children: [
                            Gap(10),
                            Icon(
                              Icons.restaurant,
                              color: Colors.blueAccent[100],
                              size: 35,
                            ),
                            Gap(10),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "aksam".tr,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Gap(25),
                                  Text("$aksam_yemegi_kcal",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    "kcal".tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                ">",
                                style: TextStyle(fontSize: 20,),
                              ),
                            )
                          ],
                        ),

                      )),
                ),
              ),
            ],
    )
      )
    );
  }

}



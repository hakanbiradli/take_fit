import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_fit/models/YapilanSporlarModel.dart';

class Training_Program_Prepare extends StatefulWidget {
  int? id;
  String? program_name;
  int? kcal_info;
  double? dk_info;
  String? baslik;

  Training_Program_Prepare(
      {required this.id,
      required this.program_name,
      required this.kcal_info,
      required this.dk_info,
      required this.baslik});

  @override
  State<Training_Program_Prepare> createState() =>
      _Training_Program_PrepareState();
}

class _Training_Program_PrepareState extends State<Training_Program_Prepare> {
  //tüm spor etkinliklerinin listesi
  List<YapilanSporlarModel> yapilan_sporlar_liste = [];


// Adım sayısını ve diğer alanları güncelleyen fonksiyon
  List<YapilanSporlarModel> updateValues(List<YapilanSporlarModel> list, String date, int id, int newStepValue, double newConsumedKcal, int newSpentTime) {
    if(list.length == 0){
      YapilanSporlarModel yeni_data= new YapilanSporlarModel(id: id, spor_name: widget.program_name!, consumed_kcal: newConsumedKcal, step_value: newStepValue, spent_time: newSpentTime, date_and_time: date);
      list.add(yeni_data);
    }
    for (var i = 0; i < list.length; i++) {
      if (list[i].date_and_time == date && list[i].id == id && list[i].spor_name == widget.program_name) {
        list[i].step_value = newStepValue;
        list[i].consumed_kcal = newConsumedKcal;
        list[i].spent_time = newSpentTime;
        return list;
      }
      else{
        YapilanSporlarModel yeni_data= new YapilanSporlarModel(id: id, spor_name: widget.program_name!, consumed_kcal: newConsumedKcal, step_value: newStepValue, spent_time: newSpentTime, date_and_time: date);
        list.add(yeni_data);
      }
    }
    return list;
  }


// SharedPreferences üzerindeki veriyi güncellemek için yardımcı fonksiyon
  Future<void> saveYapilanSporlarList(List<YapilanSporlarModel> list) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = list.map((model) => model.toJson()).map((json) => jsonEncode(json)).toList();
    await prefs.setStringList('yapilan_sporlar_liste', jsonList);
  }

// SharedPreferences'den veriyi almak için yardımcı fonksiyon
  Future<List<YapilanSporlarModel>> getYapilanSporlarList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('yapilan_sporlar_liste');
    if (jsonList != null) {
      return jsonList.map((json) => YapilanSporlarModel.fromJson(jsonDecode(json))).toList();
    } else {
      return [];
    }
  }


  // tasarım değişkenleri
  bool _stepselectvisibility = true;
  bool _stepshowvisibility = false;
  bool _startbuttonvisibility = true;
  bool _stopbuttonvisibility = false;
  bool _sifirlabuttonvisibility = false;

  //matematiksel değişkenler
  int _selectedvalue = 1;
  Timer? timer;
  double kcalvalueofsecond = 1;
  double time_now = 1.00;
  int step_sayac = 1;

  //backende gidecek veriler
  int yapilan_step = 0;
  double consumed_kcal = 0;
  int harcanan_saniye = 0;

  Future<void> initializeData() async {
    DateTime now = DateTime.now();
    String gun = now.day.toString();
    String ay = now.month.toString();
    String yil = now.year.toString();
    String date_and_time = "$gun/$ay/$yil";
    // SharedPreferences'ten veriyi al
    yapilan_sporlar_liste = await getYapilanSporlarList();
    for(int i =0;i<yapilan_sporlar_liste.length;i++){
      if(yapilan_sporlar_liste[i].id == widget.id && yapilan_sporlar_liste[i].spor_name == widget.program_name && yapilan_sporlar_liste[i].date_and_time == date_and_time){
        consumed_kcal = yapilan_sporlar_liste[i].consumed_kcal!;
        yapilan_step = yapilan_sporlar_liste[i].step_value!;
      }
    }
  }
  @override
  void initState(){
    kcalvalueofsecond = (widget.kcal_info! / (60*widget.dk_info!));
    time_now = widget.dk_info!;
    initializeData(); // Aynı zamanda Future döndüren bir fonksiyon çağırıyoruz

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("program".tr),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(30),
            Center(
              child: Text(
                widget.baslik!,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("( " + widget.kcal_info.toString() + "Kcal )"),
                Icon(Icons.whatshot)
        
              ],
            ),
            Gap(50),
            Visibility(
              visible: _stepselectvisibility,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    "set".tr,
                    style: TextStyle(fontSize: 15),
                  ),
                Gap(10),
                Icon(Icons.sports_gymnastics),
                  Gap(10),
                  DropdownButton<int>(
                    value: _selectedvalue,
                    items: List.generate(
                      20,
                      (index) => DropdownMenuItem<int>(
                        value: index + 1,
                        child: SizedBox(
                            width: 60,
                            height: 50,
                            child: Center(
                              child: Text(
                                (index + 1).toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                            )),
                      ),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        step_sayac = newValue!;
                        _selectedvalue = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            Gap(70),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Visibility(
                    visible: _stepshowvisibility,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(10)),
        
                      ),
                      width: 50,
                      height: 30,
                      child: Center(
                        child: Text(
                          step_sayac.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
        
                      ),
                      width: 150,
                      height: 100,
                      child: Center(
                          child: Text(
                        time_now.toStringAsFixed(2),
                        style: TextStyle(letterSpacing: 1, fontSize: 40),
                      )),
                    ),
                    Gap(10),
                    Icon(Icons.access_alarm,size: 30,),
                  ],
                ),
              ],
            ),
        
            Gap(150),
            //START BUTTON
            Visibility(
              visible: _startbuttonvisibility,
              child: SizedBox(
                width: 100,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    _startbuttonvisibility = false;
                    _stopbuttonvisibility = true;
                    _stepselectvisibility = false;
                    _stepshowvisibility = true;
                    _sifirlabuttonvisibility = true;
                    setState(() {});
                    timer = Timer.periodic(Duration(seconds: 1), (timer) {
                      double fractionalPart = time_now % 1;
                      if (fractionalPart < 0.01) {
                        if (time_now < 0.01) {
                          step_sayac--;
                          yapilan_step++;
                          time_now = widget.dk_info! + 0.01;
                          consumed_kcal += kcalvalueofsecond * harcanan_saniye;
                          DateTime now = DateTime.now();
                          String gun = now.day.toString();
                          String ay = now.month.toString();
                          String yil = now.year.toString();
                          String date_and_time = "$gun/$ay/$yil";
                          int newStepValue = yapilan_step;
                          double newConsumedKcal = consumed_kcal;
                          int newSpentTime = (widget.dk_info!*yapilan_step).toInt();
        
                          updateValues(yapilan_sporlar_liste, date_and_time, widget.id!, newStepValue, newConsumedKcal, newSpentTime);
        
                          try {
                            // Güncellenmiş veriyi SharedPreferences'e kaydet
                            saveYapilanSporlarList(yapilan_sporlar_liste);
                            print("Başarıyla aktivite kaydedildi");
                          } catch (e) {
                            print("kaydedilemedi!");
                          }
                        }
        
                        time_now--;
                        int tamsayiPart = time_now.toInt();
                        time_now = tamsayiPart + 0.60;
        
                        if (step_sayac < 1) {
                          timer.cancel();
                          time_now = widget.dk_info! + 0.01;
                          _startbuttonvisibility = true;
                          _stopbuttonvisibility = false;
                          _stepselectvisibility = true;
                          _stepshowvisibility = false;
                          _sifirlabuttonvisibility = false;
                          step_sayac = 1;
                          _selectedvalue = 1;
                        }
                      }
        
                      time_now -= 0.01;
                      harcanan_saniye++;
                      setState(() {});
                      // Her saniye bu mesajı yazdır
                    });
                  },
                  child: Icon(Icons.play_arrow,size: 55,),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                        BorderSide(width: 3, color: Colors.grey.shade300)),
                  ),
                ),
              ),
            ),
            //STOP BUTTON
            Visibility(
              visible: _stopbuttonvisibility,
              child: SizedBox(
                width: 100,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    timer!.cancel();
                    _stopbuttonvisibility = false;
                    _startbuttonvisibility = true;
                    setState(() {});
                  },
                  child: Icon(Icons.pause,size: 55,color: Colors.green[400],),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade100),
                    side: MaterialStateProperty.all(
                        BorderSide(width: 3, color: Colors.grey.shade200)),
                  ),
                ),
              ),
            ),
            Gap(20),
            //SIFIRLA BUTTON
            Visibility(
                visible: _sifirlabuttonvisibility,
                child: SizedBox(
                  width: 75,
                  height: 75,
                  child: TextButton(
                    onPressed: () {
                      timer!.cancel();
                      _stepselectvisibility = true;
                      _stepshowvisibility = false;
                      _startbuttonvisibility = true;
                      _stopbuttonvisibility = false;
                      _sifirlabuttonvisibility = false;
                      time_now = widget.dk_info!;
                      step_sayac = 1;
                      _selectedvalue = 1;
                      setState(() {});
                    },
                    child: Icon(Icons.close,color: Colors.red,size: 55,),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

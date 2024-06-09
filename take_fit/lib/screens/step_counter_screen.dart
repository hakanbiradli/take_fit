import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_fit/models/StepCounterModel.dart';

class StepCounterScreen extends StatefulWidget {
  int? id;

  StepCounterScreen({required this.id});

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  //tüm spor etkinliklerinin listesi
  List<StepCounterModel> adim_sayar_liste = [];
  List<StepCounterModel> filteredList = [];
  int stepCount = 0;
  double kal = 0;
  double km = 0;
  double threshold = 2;
  double sensordipdegeri = -0.65;
  bool peakDetected = false;
  bool valleyDetected = false;
  bool _startbuttonvisibility = true;
  bool _stopbuttonvisibility = false;
  StreamSubscription? _streamSubscription;

  // SharedPreferences üzerindeki veriyi güncellemek için yardımcı fonksiyon
  Future<void> saveStepCounterList(List<StepCounterModel> list) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = list
        .map((model) => model.toJson())
        .map((json) => jsonEncode(json))
        .toList();
    await prefs.setStringList('adim_sayar_liste', jsonList);
  }

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
  List<StepCounterModel> filterByDateAndId(
      List<StepCounterModel> list, String tarih, int id) {
    return list
        .where((element) => element.tarih == tarih && element.id == id)
        .toList();
  }

  int getStepCount(List<StepCounterModel> filteredList) {
    if (filteredList.isNotEmpty) {
      return filteredList[0].adim_sayisi ?? 0;
    } else {
      return 0;
    }
  }

// Veriyi güncelleyen fonksiyon
  List<StepCounterModel> updateStepCount(
      List<StepCounterModel> list, String tarih, int id, int newStepCount) {
    if (list.length == 0) {
      StepCounterModel yeni_data =
          new StepCounterModel(id: id, adim_sayisi: newStepCount, tarih: tarih);
      list.add(yeni_data);
    }
    for (var i = 0; i < list.length; i++) {
      if (list[i].tarih == tarih && list[i].id == id) {
        list[i].adim_sayisi = newStepCount;
        return list;
      } else {
        StepCounterModel yeni_data = new StepCounterModel(
            id: id, adim_sayisi: newStepCount, tarih: tarih);
        list.add(yeni_data);
      }
    }
    return list;
  }

  Future<void> initializeData() async {
    // SharedPreferences'ten veriyi al
    adim_sayar_liste = await getStepCounterList();
    DateTime now = DateTime.now();
    String gun = now.day.toString();
    String ay = now.month.toString();
    String yil = now.year.toString();
    String tarih = "$gun/$ay/$yil";
    // Gün ve id'ye göre filtrelenmiş liste
    try {
      List<StepCounterModel> filteredList =
          filterByDateAndId(adim_sayar_liste, tarih, widget.id!);

      stepCount = getStepCount(filteredList);
    } catch (e) {}
    km = (stepCount * 0.65) / 1000;
    kal = stepCount * 0.05;
    setState(() {});
  }

  @override
  void initState() {
    initializeData(); // Aynı zamanda Future döndüren bir fonksiyon çağırıyoruz

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("adimsayar".tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    stepCount.toString(),
                    style: TextStyle(fontSize: 60),
                  ),
                ),
                Gap(5),
                Icon(Icons.directions_run)
              ],
            ),
            Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          kal.toStringAsFixed(3),
                          style: TextStyle(color: Colors.blue[700], fontSize: 25),
                        ),
                        Icon(Icons.whatshot)
                      ],
                    ),
                    Text("Kal")
                  ],
                ),
                Gap(30),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          km.toStringAsFixed(2),
                          style: TextStyle(color: Colors.blue[700], fontSize: 25),
                        ),
                        Icon(Icons.navigation)
                      ],
                    ),
                    Text("km")
                  ],
                )
              ],
            ),
            Gap(250),
            Visibility(
              visible: _startbuttonvisibility,
              child: SizedBox(
                  width: 130,
                  height: 130,
                  child: ElevatedButton(
                    onPressed: () {
                      _startbuttonvisibility = false;
                      _stopbuttonvisibility = true;
                      setState(() {});
                      _streamSubscription =
                          accelerometerEvents.listen((AccelerometerEvent event) {
                        // Y eksenindeki ivme ölçüsünü kontrol etme
                        if (event.y > threshold && !peakDetected) {
                          // Tepe noktası tespit edildi
                          peakDetected = true;
                          valleyDetected = false;
                        } else if (event.y < sensordipdegeri &&
                            !valleyDetected &&
                            peakDetected) {
                          // Dip noktası tespit edildi ve önceki tepe noktası tespit edildi
                          stepCount++;
                          kal = stepCount * 0.05;
                          km = (stepCount * 0.65) / 1000;
                          setState(() {});
                          // Adım sayısını güncelleme
                          int newStepCount = stepCount;
                          DateTime now = DateTime.now();
                          String gun = now.day.toString();
                          String ay = now.month.toString();
                          String yil = now.year.toString();
                          String tarih = "$gun/$ay/$yil";
                          adim_sayar_liste = updateStepCount(
                              adim_sayar_liste, tarih, widget.id!, newStepCount);
        
                          // Güncellenmiş veriyi SharedPreferences'e kaydetme
                          saveStepCounterList(adim_sayar_liste);
        
                          peakDetected = false;
                          valleyDetected = true;
                        }
                      });
                    },
                    child: Icon(
                      Icons.play_arrow,
                      size: 65,
                    ),
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          BorderSide(width: 5, color: Colors.grey.shade400)),
                    ),
                  )),
            ),
            Visibility(
              visible: _stopbuttonvisibility,
              child: SizedBox(
                  width: 130,
                  height: 130,
                  child: ElevatedButton(
                    onPressed: () {
                      _streamSubscription!.cancel();
                      _startbuttonvisibility = true;
                      _stopbuttonvisibility = false;
                      setState(() {});
                    },
                    child: Icon(
                      Icons.pause,
                      size: 65,
                      color: Colors.green[400],
                    ),
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          BorderSide(width: 5, color: Colors.grey.shade300)),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

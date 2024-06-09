// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_fit/screens/login_screen.dart';

import '../models/KayitOlModel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? selectedimage;
  String selectedimagepath = "";

  //resim alma
  void _selectImage(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        selectedimage = File(result.files.single.path!);
        selectedimagepath = selectedimage!.path;
        setState(() {});
      }

    } catch (e) {
      print('Hata: $e');
    }
  }

  List<KayitOlModel> kayitli_kullanicilar = [];
  // SharedPreferences'ten veri yüklemek için asenkron bir fonksiyon
  Future<void> loadDataFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Eğer kayıtlı notlar varsa al, yoksa boş bir liste oluştur
    kayitli_kullanicilar =
        await (prefs.getStringList('kayitli_kullanicilar') ?? [])
            .map((json) => KayitOlModel.fromJson(jsonDecode(json)))
            .toList();

    setState(() {});
  }

  // SharedPreferences'e veri kaydetmek için asenkron bir fonksiyon
  Future<void> savedataYeniKullanici() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Notları JSON formatına dönüştürüp kaydet
    final List<String> jsonKayitliKullanicilar = kayitli_kullanicilar
        .map((kullanici) => jsonEncode(kullanici.toJson()))
        .toList();
    prefs.setStringList('kayitli_kullanicilar', jsonKayitliKullanicilar);
    setState(() {});
  }

  @override
  void initState() {
    loadDataFromPrefs();
    // TODO: implement initState
    super.initState();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController kiloController = TextEditingController();

  // CİNSİYET
  List<String> cinsiyetItems = [
    "erkek",
    "kadin",
  ];
  late String btnSelectedCinsiyet = cinsiyetItems[0]; // Başlangıç değeri atayın
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF039DF8),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Gap(30),
              SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.asset("assets/logo/logo.png")),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Container(
                  height: 600,
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Gap(30),
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: GestureDetector(
                          onTap: () => _selectImage(context),
                          child: selectedimagepath != ""
                              ? Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: FileImage(selectedimage!),
                                          fit: BoxFit.cover),
                                      border: Border.all(
                                          color: Colors.black, width: 1)),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[300],
                                      border: Border.all(
                                          color: Colors.black, width: 1)),
                                  child: Icon(
                                    Icons.add_photo_alternate_rounded,
                                    size: 30,
                                  ),
                                ),
                        ),
                      ),
                      Gap(30),
                      //İSİM VE SOYİSİM
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "isim".tr,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                controller: surnameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "soyisim".tr,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Gap(30),
                      //KULLANICI ADI VE ŞİFRE
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "kullanici".tr,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "sifre".tr,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Gap(30),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextField(
                                controller: ageController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "yas".tr),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: DropdownButton<String>(
                                value: btnSelectedCinsiyet,
                                onChanged: (String? value) {
                                  setState(() {
                                    btnSelectedCinsiyet = value!;
                                  });
                                },
                                //isExpanded: false,
                                itemHeight: 50,
                                items: cinsiyetItems
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: SizedBox(
                                        width: 130,
                                        height: 100,
                                        child: Center(
                                          child: Text(
                                            value.tr,
                                            textAlign: TextAlign.center,
                                          ),
                                        )),
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        ],
                      ),
                      Gap(15),
                      Row(children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            controller: lengthController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(), hintText: "boy".tr),
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: TextField(
                            controller: kiloController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(), hintText: "kilo".tr),
                          ),
                        ))
                      ]),
                      Gap(20),
                      SizedBox(
                        width: 130,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            bool kullanici_yok = true;
                            int? id = 0;
                            for (int i = 0;
                                i < kayitli_kullanicilar.length;
                                i++) {
                              //id bilgisini alıyoruz
                              id = kayitli_kullanicilar[i].id! + 1!;
                              if (kayitli_kullanicilar[i].username ==
                                  usernameController.text) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Icon(Icons.warning),
                                      content: Text(
                                        "kullaniciyok".tr,
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        Center(
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => LoginScreen()),(route) => false,);
                                              },
                                              child: Text("tamam".tr)),
                                        )
                                      ],
                                    );
                                  },
                                );
                                kullanici_yok = false;
                                break;
                              }
                            }
                            if (kullanici_yok) {
                              if (nameController.text != null &&
                                  nameController.text != "" &&
                                  surnameController.text != null &&
                                  surnameController.text != "" &&
                                  usernameController.text != "" &&
                                  usernameController.text != null &&
                                  passwordController.text != "" &&
                                  passwordController.text != null &&
                                  ageController.text != "" &&
                                  ageController.text != null &&
                                  lengthController.text != "" &&
                                  lengthController.text != null &&
                                  kiloController.text != "" &&
                                  kiloController.text != null) {
                                KayitOlModel yeni_kayit = new KayitOlModel(
                                    id: id,
                                    name: nameController.text,
                                    surname: surnameController.text,
                                    age: int.parse(ageController.text),
                                    length: int.parse(lengthController.text),
                                    kilo: int.parse(kiloController.text),
                                    username: usernameController.text,
                                    password: passwordController.text,
                                    picture: selectedimagepath,
                                    cinsiyet: btnSelectedCinsiyet);
                                kayitli_kullanicilar.add(yeni_kayit);
                                setState(() {});
                                savedataYeniKullanici();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Icon(Icons.done),
                                      content: Text(
                                        "basarili".tr,
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        Center(
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                                              },
                                              child: Text("tamam".tr)),
                                        )
                                      ],
                                    );
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                        child:
                                            Text('alanbos'.tr)),
                                    duration: Duration(
                                        seconds:
                                            3), // Snackbar'ın ne kadar süreyle görüntüleneceği
                                  ),
                                );
                              }
                            }

                          },
                          child: Text(
                            "kayitol".tr,
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey.shade300),
                          ),
                        ),
                      ),
                      Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "zatenhesap".tr,
                          ),
                          Gap(10),
                          InkWell(
                            onTap: () {  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen()));},
                            child: Text(
                              "giris".tr,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

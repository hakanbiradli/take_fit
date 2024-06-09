import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/KayitOlModel.dart';
import '../widgets/drawer.dart';

class ProfileScreen extends StatefulWidget {
  KayitOlModel? kullanici;

  ProfileScreen({required this.kullanici});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<KayitOlModel> kayitli_kullanicilar = [];
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


  Future<void> loadDataFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Eğer kayıtlı notlar varsa al, yoksa boş bir liste oluştur
    kayitli_kullanicilar =
        await (prefs.getStringList('kayitli_kullanicilar') ?? [])
            .map((json) => KayitOlModel.fromJson(jsonDecode(json)))
            .toList();
    setState(() {});
  }

  @override
  void initState() {
    loadDataFromPrefs();
    nameController.text = widget.kullanici!.name!;
    surnameController.text = widget.kullanici!.surname!;
    usernameController.text = widget.kullanici!.username!;
    passwordController.text = widget.kullanici!.password!;
    ageController.text = widget.kullanici!.age!.toString();
    lengthController.text = widget.kullanici!.length!.toString();
    kiloController.text = widget.kullanici!.kilo!.toString();
    //resimleri yükle
    selectedimagepath = widget.kullanici!.picture!;
    selectedimage = File(selectedimagepath);
    // TODO: implement initState
    super.initState();
  }

  // SharedPreferences'e veri kaydetmek için asenkron bir fonksiyon
  Future<void> savedataKullaniciUpdate(
      String name,
      String surname,
      String username,
      String password,
      int age,
      String cinsiyet,
      int length,
      int kilo,
      String picture) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // veriyi güncelle
    KayitOlModel update = new KayitOlModel(
        id: widget.kullanici!.id!,
        name: name,
        surname: surname,
        age: age,
        length: length,
        kilo: kilo,
        username: username,
        password: password,
        picture: picture,
        cinsiyet: cinsiyet);
    kayitli_kullanicilar[widget.kullanici!.id!] = (update);
    // Notları JSON formatına dönüştürüp kaydet
    final List<String> jsonKayitliKullanicilar = kayitli_kullanicilar
        .map((kullanici) => jsonEncode(kullanici.toJson()))
        .toList();
    prefs.setStringList('kayitli_kullanicilar', jsonKayitliKullanicilar);
    setState(() {});
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
  late String btnSelectedCinsiyet = widget.kullanici!.cinsiyet!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(),
      ),
      drawer: drawer(kullanici: widget.kullanici),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _selectImage(context),
              child: SizedBox(
                width: 150,
                height: 150,
                child: selectedimagepath == ""
                    ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('assets/images/kullanici.jpg'),
                                fit: BoxFit.cover)),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:
                                    FileImage(selectedimage!),
                                fit: BoxFit.cover)),
                      ),
              ),
            ),
            Gap(50),
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
                        hintText: widget.kullanici!.name!.toUpperCase(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: surnameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: widget.kullanici!.surname!.toUpperCase(),
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
                        hintText: "Nick : " + widget.kullanici!.username!,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
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
            //YAŞ VE CİNSİYET
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
                          hintText: widget.kullanici!.age!.toString() + " Yaş"),
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
                          .map<DropdownMenuItem<String>>((String value) {
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
            //BOY VE KİLO
            Row(children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  controller: lengthController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: widget.kullanici!.length!.toString() + " Cm"),
                ),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: TextField(
                  controller: kiloController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: widget.kullanici!.kilo!.toString() + " Kg"),
                ),
              ))
            ]),
            Gap(30),
            SizedBox(
                width: 120,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      try {
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
                          savedataKullaniciUpdate(
                              nameController.text,
                              surnameController.text,
                              usernameController.text,
                              passwordController.text,
                              int.parse(ageController.text),
                              btnSelectedCinsiyet,
                              int.parse(lengthController.text),
                              int.parse(kiloController.text),
                              selectedimagepath);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Center(child: Text('guncellendi'.tr)),
                              duration: Duration(
                                  seconds:
                                      3), // Snackbar'ın ne kadar süreyle görüntüleneceği
                            ),
                          );
                          setState(() {});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                  child: Text('alanbos'.tr)),
                              duration: Duration(
                                  seconds:
                                      3), // Snackbar'ın ne kadar süreyle görüntüleneceği
                            ),
                          );
                        }

                        //Navigator.pushNamedAndRemoveUntil(
                        //  context, '/login', (route) => false);
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Icon(Icons.warning),
                              content: Text(
                                "bilgilerguncellendi".tr,
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                Center(
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("tamam".tr)),
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text("guncelle".tr)))
          ],
        ),
      )),
    );
  }
}

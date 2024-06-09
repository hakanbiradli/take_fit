// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_fit/models/KayitOlModel.dart';
import 'package:take_fit/screens/home_screen.dart';
import 'package:take_fit/screens/register_screen.dart';
import '../bloc/cubit_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = false;
  bool textVisible = false;

  List<KayitOlModel> kayitli_kullanicilar = [];

// SharedPreferences'ten veri yüklemek için asenkron bir fonksiyon
  Future<void> loadDataFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Eğer kayıtlı notlar varsa al, yoksa boş bir liste oluştur
    kayitli_kullanicilar =
        await (prefs.getStringList('kayitli_kullanicilar') ?? [])
            .map((json) => KayitOlModel.fromJson(jsonDecode(json)))
            .toList();
    usernameController.text = prefs.getString('beni_hatirla_username') ?? "";
    passwordController.text = prefs.getString('beni_hatirla_password') ?? "";
    isChecked = prefs.getBool('beni_hatirla_isChecked') ?? false;
    setState(() {});
    if (isChecked) {
      for (int i = 0; i < kayitli_kullanicilar.length; i++) {
        if (kayitli_kullanicilar[i].username == usernameController.text &&
            kayitli_kullanicilar[i].password == passwordController.text) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                    kullanici:
                    kayitli_kullanicilar[i])),(route) => false,);
        }
      }
    }
  }

// SharedPreferences'e veri kaydetmek için asenkron bir fonksiyon
  Future<void> saveLoginInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('beni_hatirla_username', usernameController.text);
    prefs.setString('beni_hatirla_password', passwordController.text);
    prefs.setBool('beni_hatirla_isChecked', isChecked);
  }

  @override
  void initState() {
    loadDataFromPrefs();
    setState(() {});
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckboxCubit(isChecked),
      child: Scaffold(
          backgroundColor: Colors.blue,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Gap(30),
                  SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset("assets/logo/logo.png")),
                  Gap(100),
                  Container(
                    width: 300,
                    height: 475,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Gap(30),
                        Text(
                          "Take Fit",
                          style: TextStyle(fontSize: 20),
                        ),
                        Gap(30),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "kullanici".tr,
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                        ),
                        Gap(30),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "sifre".tr,
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                        ),
                        Gap(10),
                        Row(
                          children: [
                            Gap(35),
                            BlocBuilder<CheckboxCubit, CheckboxState>(
                              builder: (context, state) {
                                return Checkbox(
                                  value: isChecked,
                                  onChanged: (newValue) {
                                    isChecked = newValue!;
                                    context
                                        .read<CheckboxCubit>()
                                        .toggleCheckbox();
                                  },
                                );
                              },
                            ),
                            Text("benihatirla".tr),
                            Gap(10),
                          ],
                        ),
                        Gap(20),
                        SizedBox(
                          width: 170,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () async {
                              for (int i = 0;
                                  i < kayitli_kullanicilar.length;
                                  i++) {
                                if (kayitli_kullanicilar[i].username ==
                                        usernameController.text &&
                                    kayitli_kullanicilar[i].password ==
                                        passwordController.text) {
                                  await saveLoginInfo();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen(
                                              kullanici:
                                                  kayitli_kullanicilar[i])),(route) => false,);
                                }
                              }
                              textVisible = true;
                              setState(() {});
                            },
                            child: Text(
                              "girisyap".tr,
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey.shade300),
                            ),
                          ),
                        ),
                        Gap(10),
                        if (textVisible)
                          Text("KayBulun".tr,
                              style: TextStyle(color: Colors.red)),
                        Gap(10),
                        SizedBox(
                            width: 100,
                            height: 45,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen()));
                                },
                                child: Text(
                                  "kayitol".tr,
                                  style: TextStyle(
                                      color: Colors.lightBlue, fontSize: 20),
                                )))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

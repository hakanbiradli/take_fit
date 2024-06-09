// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/KayitOlModel.dart';
import '../widgets/drawer.dart';

class AboutUsScreen extends StatefulWidget {
  KayitOlModel? kullanici;
  AboutUsScreen({required this.kullanici});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  instagram() {
    final Uri uri = Uri.parse("https://www.instagram.com/ensar.mese/");
    launchUrl(uri);
  }

  mail() {
    final Uri uri = Uri.parse(
        "mailto:ensarmese1@gmail.com?subject=Destek Talebi&body=Merhaba uygulamayla ilgili problemim var.");
    launchUrl(uri);
  }

  linkedin() {
    final Uri uri =
        Uri.parse("https://www.linkedin.com/in/ensar-me%C5%9Fe-095676268/");
    launchUrl(uri);
  }

  call() {
    final Uri uri = Uri.parse("tel:+905458838941");
    launchUrl(uri);
  }

  whatsapp() {
    String text="merhabayardl".tr;
    final Uri uri = Uri.parse(
        "https://wa.me/+905458839841?text=$text");
    launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hakkimizda".tr),
      ),
      drawer: drawer(kullanici: widget.kullanici),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 330),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        "bizeulas".tr,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: linkedin,
                      child: Image.asset(
                        "assets/images/linkedin.png",
                        width: 50,
                      ),
                    ),
                    InkWell(
                      onTap: whatsapp,
                      child: Image.asset(
                        "assets/images/whatsapp.png",
                        width: 50,
                      ),
                    ),
                    InkWell(
                        onTap: instagram,
                        child: Image.asset(
                          "assets/images/instagram.png",
                          width: 50,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

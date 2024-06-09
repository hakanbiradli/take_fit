// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:take_fit/core/storage.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  checkLogin() async{
    Storage storage = Storage();

    final user = await storage.loadUser();

    if(user!=null){
      Navigator.pushReplacementNamed(context, "/home");
    }
    else{
      Navigator.pushReplacementNamed(context, "/login");
    }
  }


  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 68, 238, 42)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white, ),
              Gap(20),
              Text("TakeFit",style: TextStyle(fontSize: 30,color: Colors.white),),
            ],
          ),
        ),
      ),
    );
  }
}

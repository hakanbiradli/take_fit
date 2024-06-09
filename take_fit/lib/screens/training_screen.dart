import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:take_fit/screens/step_counter_screen.dart';
import 'package:take_fit/screens/training_program_start_screen.dart';

import '../models/KayitOlModel.dart';
import '../widgets/CustomWidget.dart';
import '../widgets/drawer.dart';

class TrainingScreen extends StatefulWidget {
  KayitOlModel? kullanici;
  TrainingScreen({required this.kullanici});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("antrenman".tr),
      ),
      drawer: drawer(kullanici: widget.kullanici),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(10,),
            CustomWidget(
              text: 'yuruyus'.tr,
              imageUrl: 'https://trthaberstatic.cdn.wp.trt.com.tr/resimler/1610000/yuruyus-1611418.jpg',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StepCounterScreen(id:  widget.kullanici!.id,)),
                );
              },
            ),
            Gap(20,),
            CustomWidget(
              text: 'isinmaegzersiz'.tr,
              imageUrl: 'https://blog.bodyforumtr.com/wp-content/uploads/2018/10/isinma-hareketleri.jpg',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Training_Program_Prepare(id:widget.kullanici!.id,dk_info:3 ,kcal_info:15,program_name: 'isinmaegzersiz',baslik:'isinmaegzersiz'.tr)),
                );
              },
            ),
            Gap(20,),
            CustomWidget(
              text: 'tumvucutb'.tr,
              imageUrl: 'https://shreddedbrothers.com/uploads/blogs/ckeditor/files/kad%C4%B1nlar-i%C3%A7in-fitness-4.jpg',
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Training_Program_Prepare(id:widget.kullanici!.id ,dk_info:4 ,kcal_info:20,program_name: 'tumvucutb',baslik:'tumvucutb'.tr)),
                );
              },
            ),
            Gap(20,),
            CustomWidget(
              text: 'tumvucuto'.tr,
              imageUrl: 'https://blog.bodyforumtr.com/wp-content/uploads/2017/03/machine-flye.jpg',
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Training_Program_Prepare(id:widget.kullanici!.id ,dk_info:4.5 ,kcal_info:35,program_name: 'tumvucuto',baslik:'tumvucuto'.tr)),
                );
              },
            ),
            Gap(20,),
            CustomWidget(
              text: 'tumvucuti'.tr,
              imageUrl: 'https://www.sporty.com.tr/wp-content/uploads/2017/02/vucut-gelistirme-erkek-sporcu.jpg',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Training_Program_Prepare(id:widget.kullanici!.id ,dk_info:5 ,kcal_info:53,program_name: 'tumvucuti',baslik:'tumvucuti'.tr)),
                );
              },
            ),
            Gap(20,),
            CustomWidget(
              text: 'planko'.tr,
              imageUrl: 'https://hthayat.haberturk.com/im/2017/03/31/1048809_1b5e87ef80a20133dbfa06aa8a3d85bc_600x600.jpg',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Training_Program_Prepare(id:widget.kullanici!.id ,dk_info:3.5 ,kcal_info:27,program_name: 'planko',baslik:'planko'.tr)),
                );
              },
            ),
            Gap(20,),
            CustomWidget(
              text: 'karinb'.tr,
              imageUrl: 'https://buuon.com.tr/wp-content/uploads/2020/09/en-iyi-karin-kasi-hareketleri.jpg',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Training_Program_Prepare(id:widget.kullanici!.id ,dk_info:3.5 ,kcal_info:18,program_name: 'karinb',baslik:'karinb'.tr)),
                );
              },
            ),
            Gap(20,),
            CustomWidget(
              text: 'tabatao'.tr,
              imageUrl: 'https://i.nefisyemektarifleri.com/2023/01/19/tabata-antrenmani-kalorileri-evden-cikmadan-yakin-7.jpg',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Training_Program_Prepare(id:widget.kullanici!.id ,dk_info:3 ,kcal_info:23,program_name: 'tabatao',baslik:'tabatao'.tr)),
                );
              },
            ),
            Gap(20,),
            CustomWidget(
              text: 'tekrarorta'.tr,
              imageUrl: 'https://gymbat.com/wp-content/uploads/definisyon-gymbat.jpg',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Training_Program_Prepare(id:widget.kullanici!.id ,dk_info:3 ,kcal_info:23,program_name: 'tekrarorta',baslik:'tekrarorta'.tr)),
                );
              },
            ),
            Gap(20,),
            CustomWidget(
              text: 'yanlarindanorta'.tr,
              imageUrl: 'https://imgrosetta.mynet.com.tr/file/16809201/16809201-530x400.jpg',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Training_Program_Prepare(id:widget.kullanici!.id ,dk_info:3.5 ,kcal_info:27,program_name: 'yanlarindanorta',baslik:'yanlarindanorta'.tr)),
                );
              },
            ),
            Gap(20,),

          ],
        ),
      ),
    );
  }




}

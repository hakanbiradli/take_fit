import 'package:flutter/material.dart';

class QuestionBubble extends StatelessWidget {
  String yazi;
  final void Function() onPressed;
  QuestionBubble({required this.yazi,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue), // Arka plan rengi
          foregroundColor: MaterialStateProperty.all(Colors.white), // Yazı rengi
          elevation: MaterialStateProperty.all(8), // Yükseklik (shadow)
          shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.2)), // Shadow rengi ve opaklığı
          overlayColor: MaterialStateProperty.all(Colors.blue[200]), // Butona tıklandığında belirginleşen renk
          shape: MaterialStateProperty.all(BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Düğmenin kenar yuvarlaklığı (10 değeri dumble gibi bir görünüm elde etmek için belirlendi)
          )),
        ),
        child: Text(yazi),
      ),


    );
  }
}

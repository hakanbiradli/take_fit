import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:take_fit/widgets/QuestionBubble.dart';

import '../contans/appcolors.dart';
import '../models/KayitOlModel.dart';
import '../widgets/drawer.dart';


class GeminiChatScreen extends StatefulWidget {
  KayitOlModel? kullanici;
  GeminiChatScreen({required this.kullanici});

  @override
  State<GeminiChatScreen> createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  TextEditingController _userInput =TextEditingController();

  static const apiKey = "AIzaSyAmnVil8_yyk3ZV73BR2US67XML9xeyiHs";

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  bool isloading = true;

  Future<void> sendMessage() async{
    isloading=false;
    final message = _userInput.text;
    _userInput.text="";

    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    final content = [Content.text(message)];
    final response = await model.generateContent(content);


    setState(() {
      _messages.add(Message(isUser: false, message: response.text?? "", date: DateTime.now()));

    });
    isloading = true;
  }
  bool _isQuestionVisible = true; // Butonların görünürlüğünü kontrol etmek için bir değişken
@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    double screenWidth= MediaQuery.of(context).size.width;
    double screenHeight= MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("gemini".tr,style: TextStyle(fontSize: 20)),
        ),
        drawer: drawer(kullanici: widget.kullanici),
        body:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/logo/logo.png'),
                    fit: BoxFit.contain
                )
            ),
              child:Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Expanded(
                    child: ListView.builder(itemCount:_messages.length,itemBuilder: (context,index){
                      final message = _messages[index];
                      return Messages(isUser: message.isUser, message: message.message, date: DateFormat('HH:mm').format(message.date));
                    })
                ),
                isloading?Container():Center(child: CircularProgressIndicator()),
                if (_isQuestionVisible) SingleChildScrollView(scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    QuestionBubble(yazi: "verebilirim".tr, onPressed:(){_handleQuestionButtonPress("verebilirim".tr);}),
                    QuestionBubble(yazi: "diyetProgrol".tr, onPressed:(){_handleQuestionButtonPress("diyetProgrol".tr);}),
                    QuestionBubble(yazi: "egzersizprogol".tr, onPressed:(){_handleQuestionButtonPress("egzersizprogol".tr);}),
                  ],),
                ) else Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 15,
                        child: TextFormField(
                          style: TextStyle(color: AppColors.black),
                          controller: _userInput,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.blue), // Cerceve rengi
                            ),
                            labelText: 'soruyazabilirsiniz'.tr, // label'ın Text widget olduğunu unutmayın
                          ),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          padding: EdgeInsets.all(12),
                          iconSize: 30,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blue),
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(CircleBorder())
                          ),
                          onPressed: (){
                            sendMessage();
                          },
                          icon: Icon(Icons.send))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _handleQuestionButtonPress(String yazi) {
    // Butona tıklandığında yapılacak işlemler
    setState(() {
      _userInput.text=yazi;
      _isQuestionVisible = false;
      sendMessage();
    });
  }

}

class Message{
  final bool isUser;
  final String message;
  final DateTime date;

  Message({ required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {

  final bool isUser;
  final String message;
  final String date;

  const Messages(
      {
        super.key,
        required this.isUser,
        required this.message,
        required this.date
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15).copyWith(
          left: isUser ? 100:10,
          right: isUser ? 10: 100
      ),
      decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.green.shade400,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: isUser ? Radius.circular(10): Radius.zero,
              topRight: Radius.circular(10),
              bottomRight: isUser ? Radius.zero : Radius.circular(10)
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 16,color: isUser ? Colors.white: Colors.white),
          ),
          Text(
            date,
            style: TextStyle(fontSize: 10,color: isUser ? Colors.white: Colors.white,),
          )
        ],
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(

      child: Scaffold(

appBar: AppBar(title: Text("Message"),),
        resizeToAvoidBottomInset: false,
        body: Container(

          margin: EdgeInsets.fromLTRB(24, 24, 24, 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _header(context),
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
_header(context){
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Message",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)
      ],
    ),
  );
  
}


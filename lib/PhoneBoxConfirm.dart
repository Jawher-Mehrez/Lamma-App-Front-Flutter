import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneBoxConfirm extends StatefulWidget {
  const PhoneBoxConfirm({Key? key}) : super(key: key);

  @override
  State<PhoneBoxConfirm> createState() => _PhoneBoxConfirmState();
}

class _PhoneBoxConfirmState extends State<PhoneBoxConfirm> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(

        child: Scaffold(


      body: Container(
        margin: EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [




          ],
        ),
      ),

    ));
  }
}

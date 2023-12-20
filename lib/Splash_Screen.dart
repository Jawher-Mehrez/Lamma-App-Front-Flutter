import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splach_Screen extends StatefulWidget {
  const Splach_Screen({Key? key});

  @override
  State<Splach_Screen> createState() => _Splach_ScreenState();
}

class _Splach_ScreenState extends State<Splach_Screen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF43868), // Set the background color here
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          child: Container(
            margin: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 120,
                      width: 250,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Lottie.network(
                          'https://assets8.lottiefiles.com/temporary_files/22EL64.json',
                          height: 250,
                          width: 250,
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/cubs.png',
                    height: 100,
                    width: 300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

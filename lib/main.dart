import 'package:flutter/material.dart';
import 'package:lamma/RoomUpdate2.dart';

import 'JoinRoom.dart';
import 'RoomData2.dart';
import 'login.dart';
import 'ForgetPassword.dart';
import 'ChangePassword.dart';
import 'AccountInformation.dart';
import 'CreateAccount.dart';
import 'ProfileListe.dart';
import 'PhoneVerification.dart';
import 'Pin_Text_Field.dart';
import 'DropdownExample.dart';
import 'Serial_Number.dart';
import 'Result.dart';

import 'Dashboard.dart';
import 'List_Search.dart';
import 'Simple_Filtre.dart';
import 'List_Search_Room.dart';
import 'Splash_Screen.dart';
import 'SupportPage.dart';
import 'BeloteStatisticsPage.dart';
import 'Chart.dart';
import 'MenuBottomBar.dart';
import 'Message.dart';
import 'GeolocatorExample.dart';
import 'RoomUpdate.dart';
import 'RoomData.dart';
import 'RecoverPassword.dart';



void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/Splach_Screen',
      routes: {
        '/': (context) => LoginPage(),
        '/ForgetPassword': (context) => ForgetPassword(),
        '/ChangePassword': (context) => ChangePassword(),
        '/RecoverPassword': (context) => RecoverPassword(),
        '/AccountInformation': (context) => AccountInformation(),
        '/CreateAccount': (context) => CreateAccount(),
        '/ProfileListe': (context) => ProfileListe(),
        '/PhoneVerification': (context) => PhoneVerification(),
        '/Serial_Number': (context) => Serial_Number(),
        '/Pin_Text_Field': (context) => Pin_Text_Field(),
        '/DropdownExample': (context) => DropdownExample(),
        '/Result': (context) => Result(),
        '/JoinRoom': (context) => JoinRoom(),
        '/RoomData2': (context) => RoomData2(),
        '/Dashboard': (context) => Dashboard(),
        '/List_Search': (context) => List_Search(),
        '/Simple_Filtre': (context) => Simple_Filtre(),
        '/List_Search_Room': (context) => List_Search_Room(),
        '/Splach_Screen': (context) => Splach_Screen(),
        '/SupportPage': (context) => SupportPage(),
        '/BeloteStatisticsPage': (context) => BeloteStatisticsPage(),
        '/Chart': (context) => Chart(),
        '/MenuBottomBar': (context) => Menu_Bottom_Bar(),
        '/Message': (context) => Message(),
        '/GeolocatorExample': (context) => GeolocatorExample(),
        '/RoomUpdate': (context) => RoomUpdate(),
        '/RoomUpdate2': (context) => RoomUpdate2(),
        '/RoomData': (context) => RoomData(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF2a0d2e),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFf43868),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF2a0d2e),
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFf43868)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFf43868)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        cardTheme: CardTheme(
          color: Color(0xFFf43868),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
          subtitle1: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
    );

  }
}

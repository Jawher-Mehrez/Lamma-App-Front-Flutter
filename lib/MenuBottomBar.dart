import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lamma/Dashboard.dart';
import 'package:lamma/DropdownExample.dart';
import 'package:lamma/JoinRoom.dart';
import 'package:lamma/List_Search.dart';
import 'package:lamma/List_Search_Room.dart';
import 'package:lamma/Message.dart';
import 'package:lamma/Serial_Number.dart';

import 'AccountInformation.dart';
import 'SupportPage.dart';

class Menu_Bottom_Bar extends StatefulWidget {
  const Menu_Bottom_Bar({super.key});

  @override
  State<Menu_Bottom_Bar> createState() => _Menu_Bottom_BarState();
}

class _Menu_Bottom_BarState extends State<Menu_Bottom_Bar> {
  int selectedPage = 0;
  final _pageOptions = [List_Search_Room(), DropdownExample(), JoinRoom(), Message(), Dashboard()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pageOptions[selectedPage],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color(0xFFf43868), // Specify the desired color here
        items: [
          TabItem(icon: Icons.search, title: 'Search'),
          TabItem(icon: Icons.home, title: 'Room'),
          TabItem(icon: Icons.add, title: 'Join'),
          TabItem(icon: Icons.message, title: 'Message'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: 0, //optional, default as 0
        onTap: (int index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),

    );
  }
}

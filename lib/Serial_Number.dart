import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'RoomData.dart';
import 'RoomUpdate.dart';
import 'serial_number.dart';

class Serial_Number extends StatefulWidget {
  final String? code; // Make the 'code' field nullable by using '?'.
  final int? roomId; // Add 'roomId' field to store the room ID.

  const Serial_Number({Key? key, this.code, this.roomId}) : super(key: key);

  @override
  State<Serial_Number> createState() => _SerialNumberState();
}

class _SerialNumberState extends State<Serial_Number>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _pageOptions = [
    // List_Search_Room(),
    // SupportPage(),
    // SupportPage(),
    // AccountInformation(),
  ];

  String? _enteredCode; // To store the code entered in the text field

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Log the route passed to the widget
    print("Route passed to Serial_Number: ${widget.code}");
    print("Room ID passed to Serial_Number: ${widget.roomId}");
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToPage(String route) {
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Game'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTabBar(context),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildFirstTabContent(),
                    _buildSecondTabContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[200],
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          // Handle tab selection
        },
        tabs: [
          Tab(
            icon: Icon(Icons.numbers),
          ),
          Tab(
            icon: Icon(Icons.qr_code),
          ),
        ],
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue,
      ),
    );
  }

  Widget _buildFirstTabContent() {
    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Serial Number",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFf43868),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Kindly fill the box with the serial number found on the back of the cards packet",
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _enteredCode = value; // Store the entered code
                });
              },
              decoration: InputDecoration(
                hintText: "Serial Number",
                prefixIcon: Icon(Icons.numbers, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_enteredCode == widget.code) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.topSlide,
                    showCloseIcon: true,
                    title: 'Verification Successful',
                    desc: "You now have full access to our system",
                    btnOkOnPress: () {
                      Navigator.pushNamed(context, '/RoomData',
                          arguments: widget.roomId);
                    },
                  ).show();
                } else {
                  if (_enteredCode == null || _enteredCode!.isEmpty) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: 'Error 1',
                      desc: "Please enter the serial number!",
                      btnOkOnPress: () {},
                    ).show();
                  } else {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: 'Error 2',
                      desc: "Invalid serial number entered!",
                      btnOkOnPress: () {},
                    ).show();
                  }
                }
              },
              child: Text("Next"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondTabContent() {
    return Center(
      // ... Rest of the code
    );
  }
}
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JoinRoom extends StatefulWidget {
  final String? code;

  const JoinRoom({Key? key, this.code}) : super(key: key);

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _enteredCode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    print("Route passed to JoinRoom: ${widget.code}");

    // Retrieve the playerId and code from SharedPreferences and log them to the console
    _getPlayerIdAndCodeFromSharedPreferences();
  }

  Future<void> _savePlayerIdAndCode(int playerId, String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('playerId', playerId);
    await prefs.setString('code', code);
  }

  Future<void> _getPlayerIdAndCodeFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? playerId = prefs.getInt('playerId');
    String? code = prefs.getString('code');
    print("Player ID room from SharedPreferences: $playerId");
    print("Code from SharedPreferences: $code");
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
              onPressed: () async {
                if (_enteredCode != null && _enteredCode!.isNotEmpty) {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  int? playerId = prefs.getInt('playerId');
                  print("Player ID room from id: $playerId");

                  if (playerId != null) {
                    // Perform the API GET request with the retrieved player ID
                    final apiUrl =
                        'http://127.0.0.1:8000/api/player/$playerId/join-room?room_code=$_enteredCode';
                    final response = await http.post(Uri.parse(apiUrl));

                    if (response.statusCode == 200) {
                      // If the response is successful, parse the response body
                      Map<String, dynamic> responseData =
                      json.decode(response.body);

                      // Extract the 'id' field from the response data
                      int playerId = responseData['id'];

                      // Save the 'id' and 'code' in SharedPreferences
                      await _savePlayerIdAndCode(playerId, _enteredCode!);

                      // Show a success dialog
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.topSlide,
                        showCloseIcon: true,
                        title: 'Verification Successful',
                        desc: "You now have full access to our system",
                        btnOkOnPress: () {
                          // Navigate to the RoomData page with the saved playerId as an argument
                          Navigator.pushNamed(context, '/RoomData2');
                        },
                      ).show();
                    } else {
                      // If the response is not successful, show an error dialog
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.topSlide,
                        showCloseIcon: true,
                        title: 'Error',
                        desc: "Invalid serial number entered!",
                        btnOkOnPress: () {},
                      ).show();
                    }
                  }
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.topSlide,
                    showCloseIcon: true,
                    title: 'Error',
                    desc: "Please enter the serial number!",
                    btnOkOnPress: () {},
                  ).show();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "QR Code",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFf43868),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Scan the QR code to join the room",
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          // You can add your QR code scanning widget here
        ],
      ),
    );
  }
}

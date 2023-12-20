import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'RoomData.dart';
import 'RoomUpdate.dart';
import 'serial_number.dart';

class List_Search_Room extends StatefulWidget {
  final String? locationName;

  const List_Search_Room({Key? key, this.locationName}) : super(key: key);

  @override
  _ListSearchRoomState createState() => _ListSearchRoomState();
}

class _ListSearchRoomState extends State<List_Search_Room> {
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _foundUsers = [];
  String _selectedFilter = 'Filter by Room Name';
  int? _selectedRoomId; // To store the selected room ID

  @override
  void initState() {
    _fetchRoomsData();
    super.initState();
  }

  Future<void> _fetchRoomsData() async {
    String apiUrl = 'http://127.0.0.1:8000/api/rooms';

    if (widget.locationName != null) {
      // If a locationName is passed from the route, filter rooms by the name
      apiUrl += '?location=${widget.locationName}';
    }

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _allUsers = data.map((room) => {
          "id": room["id"],
          "name": room["name"],
          "description": room["description"],
          "code": room["code"],
        }).toList();
        _foundUsers = _allUsers;
      });

      // Get the previously selected room ID and room code from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? storedRoomId = prefs.getInt('selected_room_id');
      String? storedRoomCode = prefs.getString('selected_room_code');

      setState(() {
        _selectedRoomId = storedRoomId;
      });
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allUsers;
    } else {
      results = _allUsers
          .where((room) =>
          room["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundUsers = results;
    });
  }

  void _navigateToListSearch() {
    Navigator.pushNamed(context, '/List_Search');
  }

  void _navigateToSerial(String code, int roomId) async {
    // Store the selected room ID and room code in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_room_id', roomId);
    await prefs.setString('selected_room_code', code);

    // Update the _selectedRoomId variable with the new selected room ID
    setState(() {
      _selectedRoomId = roomId;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Serial_Number(code: code),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search By Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text(
                "Filter By Room",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            DropdownButton<String>(
              value: _selectedFilter,
              items: <String>[
                'Filter by Room Name',
                'Filter by Location',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
              dropdownColor: Color(0xFF53183B),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
                if (_selectedFilter == 'Filter by Location') {
                  _navigateToListSearch();
                }
              },
            ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                labelText: 'Enter Room Name',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return _foundUsers.isNotEmpty
        ? ListView.builder(
      itemCount: _foundUsers.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Map<String, dynamic> roomData = _foundUsers[index];
          String roomCode = roomData["code"];
          int roomId = roomData["id"]; // Access the 'id' field from the roomData map.
          _navigateToSerial(
              roomCode, roomId); // Pass the 'code' and 'id' fields to the _navigateToSerial method.
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Card(
            key: ValueKey(_foundUsers[index]["id"]),
            color: Color(0xFF53183B),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/sign.png'),
              ),
              title: Text(
                _foundUsers[index]['name'],
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _foundUsers[index]['description'],
                style: TextStyle(color: Colors.white),
              ),
              // Add a checkmark icon for the selected room
              trailing: _selectedRoomId == _foundUsers[index]["id"]
                  ? Icon(Icons.check, color: Colors.white)
                  : null,
            ),
          ),
        ),
      ),
    )
        : Center(
      child: Text(
        'No results found',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

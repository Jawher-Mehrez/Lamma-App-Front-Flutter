import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'List_Search_Room.dart'; // Import the List_Search_Room widget

class List_Search extends StatefulWidget {
  const List_Search({Key? key}) : super(key: key);

  @override
  _List_SearchState createState() => _List_SearchState();
}

class _List_SearchState extends State<List_Search> {
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _foundUsers = [];
  String? _selectedLocationName;
  String _selectedLocation = 'All Locations';
  String _selectedOption = 'Search by Location'; // Selected option

  @override
  void initState() {
    _fetchLocations();
    super.initState();
  }

  Future<void> _fetchLocations() async {
    final response =
    await http.get(Uri.parse('http://127.0.0.1:8000/api/locations'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];
      setState(() {
        _allUsers = data
            .map((location) =>
        {"id": location['id'], "name": location['name']})
            .toList();
        _foundUsers = _allUsers;
      });
    } else {
      // Handle error response
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (_selectedLocation == 'All Locations') {
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
      user["location"]['name']
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()) &&
          user["location"]['name']
              .toLowerCase()
              .contains(_selectedLocation.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundUsers = results;
    });
  }

  void _onDropdownItemSelected(String? newValue) {
    setState(() {
      _selectedOption = newValue!;
    });

    if (_selectedOption == 'Search by Room Name') {
      _navigateToListSearchRoom(); // Navigate to List_Search_Room widget
    }
  }

  void _getCurrentLocation() {
    Navigator.pushNamed(context, '/GeolocatorExample');
  }

  void _navigateToListSearchRoom() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const List_Search_Room(),
      ),
    );
  }

  void _navigateToListSearchRoomByLocation(String? locationName) {
    setState(() {
      _selectedLocationName = locationName;
    });

    print('location${locationName}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => List_Search_Room(locationName: locationName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search By Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text(
                "Filter By Location",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            DropdownButton<String>(
              value: _selectedOption,
              items: <String>[
                'Search by Location', // Additional option
                'Search by Room Name', // Additional option
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.white, // Set the text color to white
                    ),
                  ),
                );
              }).toList(),
              dropdownColor: Color(0xFF53183B), // Set the background color of the dropdown menu when opened
              onChanged: _onDropdownItemSelected,
            ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                labelText: 'Enter Location',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
                border: OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF53183B),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.white), // Add the icon here
                  SizedBox(width: 8),
                  Text(
                    'Get Current Location',
                    style: TextStyle(
                      fontSize: 16.5,
                      backgroundColor: Color(0xFF53183B),
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _foundUsers.isNotEmpty
                  ? ListView.builder(
                itemCount: _foundUsers.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(_foundUsers[index]["id"]),
                  color: Color(0xFF53183B),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () => _navigateToListSearchRoomByLocation(_foundUsers[index]['name']),
                    child: ListTile(
                      leading: Text(
                        _foundUsers[index]['name'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

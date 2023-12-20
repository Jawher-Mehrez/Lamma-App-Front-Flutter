import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'RoomData.dart';

class RoomUpdate2 extends StatefulWidget {
  const RoomUpdate2({Key? key}) : super(key: key);

  @override
  _RoomUpdate2State createState() => _RoomUpdate2State();
}

class _RoomUpdate2State extends State<RoomUpdate2> {
  int? roomIdFromSharedPreferences; // Variable to store the room ID from SharedPreferences
  String? roomCodeFromSharedPreferences;
  String? selectedOption;
  String? selectedOption1;

  // Updated category options list
  List<Map<String, dynamic>> options = [
    {'id': 1, 'name': 'Belote'},
    {'id': 2, 'name': 'Soon...'},
    {'id': 3, 'name': 'Soon...'},
  ];

  List<Map<String, dynamic>> locationOptions = [];

  TextEditingController _gameNameController = TextEditingController();
  TextEditingController _numberOfPlayersController = TextEditingController();
  TextEditingController _winnersPriceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();

  DateTime? fromDate;
  TimeOfDay? fromTime;
  DateTime? toDate;
  TimeOfDay? toTime;

  bool sendEmail = false;
  bool sendNotification = false;

  @override
  void initState() {
    print('Code from Route: ${roomIdFromSharedPreferences}');
    fetchLocationOptions();
    getRoomIdFromSharedPreferences(); // Call the method to retrieve the room ID
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // This method will be called when the widget is initialized or whenever the dependencies change.
    // In this case, it will be called whenever the widget is created or updated.
    getRoomIdFromSharedPreferences(); // Call the method to retrieve the room ID
    super.didChangeDependencies();
  }

  void getRoomIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedRoomId = prefs.getInt('playerId');
    String? storedRoomCode = prefs.getString('code');

    setState(() {
      roomIdFromSharedPreferences = storedRoomId;
      roomCodeFromSharedPreferences = storedRoomCode;
    });

    if (roomIdFromSharedPreferences != null) {
      print('Room ID from SharedPreferences: $roomIdFromSharedPreferences');
      // Fetch room data here if required, like calling fetchRoomData()
    } else {
      print('No room ID found in SharedPreferences.');
    }
  }
  Future<void> fetchLocationOptions() async {
    String apiUrl = 'http://127.0.0.1:8000/api/locations';
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> locations = data['data'];

      setState(() {
        locationOptions = List<Map<String, dynamic>>.from(locations);
      });
    } else {
      print('Failed to fetch location options');
    }
  }

  Future<void> fetchRoomData() async {
    String apiUrl = 'http://127.0.0.1:8000/api/rooms/2';
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Map<String, dynamic> roomData = data['data'];

      setState(() {
        _gameNameController.text = roomData['name'];
        _categoryController.text = roomData['category_name'];
        _locationController.text = roomData['location_name'];
        _numberOfPlayersController.text = roomData['max_players'].toString();
        _winnersPriceController.text = roomData['winners_prize'].toString();
        _descriptionController.text = roomData['description'];

        // Parse and update dates and other fields based on their types
        // and update the corresponding controllers or variables accordingly.
      });
    } else {
      print('Failed to fetch room data');
    }
  }

  @override
  Widget build(BuildContext context) {



    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Update Room'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(screenWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            'Schedule Game',
            style: TextStyle(fontSize: screenWidth * 0.065, fontWeight: FontWeight.bold, color: Color(0xFFf43868)),
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _gameNameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "Game Name",
            prefixIcon: Icon(Icons.description, color: Colors.white),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Category",
              style: TextStyle(fontSize: screenWidth * 0.05),
            ),
            SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2a0d2e),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Color(0xFF53183B), width: 1),
              ),
              child: DropdownButton<String>(
                value: selectedOption,
                onChanged: (String? newValue) {
                  if (newValue != 'Soon...') {
                    setState(() {
                      selectedOption = newValue;
                    });
                  }
                },
                dropdownColor: Color(0xFF53183B),
                items: options.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['name'],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Text(
              "Location",
              style: TextStyle(fontSize: screenWidth * 0.05),
            ),
            SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2a0d2e),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Color(0xFF53183B), width: 1),
              ),
              child: DropdownButton<int>( // Use int as the type for selectedOption1
                value: selectedOption1 != null
                    ? int.tryParse(selectedOption1!) // Parse the selectedOption1 as int
                    : null,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedOption1 = newValue != null ? newValue.toString() : null;
                  });
                },
                dropdownColor: Color(0xFF53183B),
                items: locationOptions.map((location) {
                  return DropdownMenuItem<int>( // Use int as the type for value
                    value: location['id'] as int, // Convert 'id' to int
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        location['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          ],
        ),
        SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      fromDate = selectedDate;
                      fromTime = selectedTime;

                      if (toDate != null && toTime != null) {
                        final selectedDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        final toDateTime = DateTime(
                          toDate!.year,
                          toDate!.month,
                          toDate!.day,
                          toTime!.hour,
                          toTime!.minute,
                        );
                        if (selectedDateTime.isAfter(toDateTime)) {
                          fromDate = null;
                          fromTime = null;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color(0xFF53183B),
                                title: Text(
                                  'Invalid Date',
                                  style: TextStyle(color: Color(0xFFf43868)),
                                ),
                                content: Text(
                                  'The "To" date must be later than the "From" date.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      'OK',
                                      style: TextStyle(color: Color(0xFFf43868)),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    });
                  }
                }
              },
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "From",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  SizedBox(width: 8),
                  if (fromDate != null && fromTime != null)
                    Text(
                      '${fromDate!.toString().split(' ')[0]} ${fromTime!.format(context)}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        backgroundColor: Color(0xFF53183B),
                      ),
                    ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(screenWidth * 0.04),
                backgroundColor: Color(0xFF53183B),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      toDate = selectedDate;
                      toTime = selectedTime;

                      if (fromDate != null && fromTime != null) {
                        final selectedDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        final fromDateTime = DateTime(
                          fromDate!.year,
                          fromDate!.month,
                          fromDate!.day,
                          fromTime!.hour,
                          fromTime!.minute,
                        );
                        if (selectedDateTime.isBefore(fromDateTime)) {
                          toDate = null;
                          toTime = null;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color(0xFF53183B),
                                title: Text(
                                  'Invalid Date',
                                  style: TextStyle(color: Color(0xFFf43868)),
                                ),
                                content: Text(
                                  'The "To" date must be later than the "From" date',
                                  style: TextStyle(color: Colors.white),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      'OK',
                                      style: TextStyle(color: Color(0xFFf43868)),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    });
                  }
                }
              },
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "To",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  SizedBox(width: 8),
                  if (toDate != null && toTime != null)
                    Text(
                      '${toDate!.toString().split(' ')[0]} ${toTime!.format(context)}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(screenWidth * 0.04),
                backgroundColor: Color(0xFF53183B),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Form(
          child: TextFormField(
            controller: _numberOfPlayersController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1), // Limit the input to 1 digit (0-4)
            ],
            decoration: InputDecoration(
              hintText: "Number of players (Max 4)",
              prefixIcon: Icon(Icons.people, color: Colors.white),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the number of players';
              }

              int? numberOfPlayers = int.tryParse(value);
              if (numberOfPlayers == null || numberOfPlayers < 4) {
                return 'Number of players must be at least 4';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 8),
        Text(
          'How many required players for this combat?',
          style: TextStyle(fontSize: screenWidth * 0.035),
        ),
        SizedBox(height: 16),
        Form(
          child: TextFormField(
            controller: _winnersPriceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: "Winners Price",
              prefixIcon: Icon(Icons.monetization_on_outlined, color: Colors.white),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Winners Price';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Description",
            prefixIcon: Icon(Icons.description, color: Colors.white),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Text(
            'Reminder',
            style: TextStyle(fontSize: screenWidth * 0.05),
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Checkbox(
                  value: sendEmail,
                  onChanged: (bool? newValue) {
                    setState(() {
                      sendEmail = newValue ?? false;
                    });
                  },
                ),
                Text('Send Email'),
              ],
            ),
            SizedBox(width: 8),
            Row(
              children: [
                Checkbox(
                  value: sendNotification,
                  onChanged: (bool? newValue) {
                    setState(() {
                      sendNotification = newValue ?? false;
                    });
                  },
                ),
                Text('Send Notification'),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () {
              _putData();
            },
            child: Text(
              "Update",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(95, 14, 95, 14),
            ),
          ),
        ),
      ],
    );
  }

  void _putData() {
    String apiUrl = 'http://127.0.0.1:8000/api/rooms/$roomIdFromSharedPreferences?_method=PUT';


    // Get the selected category ID from the options list
    int? selectedCategoryId;
    for (var category in options) {
      if (category['name'] == selectedOption) {
        selectedCategoryId = category['id'];
        break;
      }
    }

    // Get the selected location ID from the options list
    int? selectedLocationId;
    for (var location in locationOptions) {
      if (location['id'].toString() == selectedOption1) {
        selectedLocationId = location['id'] as int;
        break;
      }
    }

    // Create DateTime objects for start and end dates with the selected times
    DateTime? fromDateTime;
    DateTime? toDateTime;
    if (fromDate != null && fromTime != null) {
      fromDateTime = DateTime(
        fromDate!.year,
        fromDate!.month,
        fromDate!.day,
        fromTime!.hour,
        fromTime!.minute,
      );
    }
    if (toDate != null && toTime != null) {
      toDateTime = DateTime(
        toDate!.year,
        toDate!.month,
        toDate!.day,
        toTime!.hour,
        toTime!.minute,
      );
    }

    Map<String, dynamic> requestData = {
      'code': roomCodeFromSharedPreferences,
      'name': _gameNameController.text,
      'category_id': selectedCategoryId,
      'location_id': selectedLocationId,
      'start_date': fromDateTime != null ? fromDateTime.toIso8601String() : null,
      'end_date': toDateTime != null ? toDateTime.toIso8601String() : null,
      'max_players': _numberOfPlayersController.text,
      'status': 'closed',
      'winners_prize': _winnersPriceController.text,
      'description': _descriptionController.text,
      'send_email': sendEmail,
      'send_notification': sendNotification,
    };

    http.put(
      Uri.parse(apiUrl),
      body: json.encode(requestData),
      headers: {
        'Content-Type': 'application/json',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        showAwesomeDialog(context, ' Room Updated Successfull');

        // Navigate to the RoomData page and pass the room data as arguments
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RoomData(roomData: requestData),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFF53183B),
              title: Text(
                'Error',
                style: TextStyle(color: Color(0xFFf43868)),
              ),
              content: Text(
                'Failed to schedule game. Please try again.',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: Color(0xFFf43868)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }).catchError((error) {
      print('Error: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF53183B),
            title: Text(
              'Error',
              style: TextStyle(color: Color(0xFFf43868)),
            ),
            content: Text(
              'An error occurred while scheduling the game. Please try again later.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Color(0xFFf43868)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Room Updated Successfully"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );

  }
  void showAwesomeDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Success ',
          style: TextStyle(
            color: Colors.white, // Text color
          ),
        ),
        backgroundColor: Color(0xFF53183B), // Background color
        content: Text(
          message,
          style: TextStyle(
            color: Color(0xFFf43868), // Text color
            fontSize: 18,fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/RoomData');
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
            ),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

import 'package:elegant_notification/elegant_notification.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'RoomData.dart';
import 'RoomUpdate.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DropdownExample(),
  ));
}

class DropdownExample extends StatefulWidget {
  const DropdownExample({Key? key});

  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
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
    super.initState();
    fetchLocationOptions();
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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Room'),
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
              child: SingleChildScrollView(
                child: DropdownButton<String>(
                  value: selectedOption1,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption1 = newValue;
                    });
                  },
                  dropdownColor: Color(0xFF53183B),
                  items: locationOptions.map((location) {
                    return DropdownMenuItem<String>(
                      value: location['id'].toString(),
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
            ],
            decoration: InputDecoration(
              hintText: "Number of players (0-4)",
              prefixIcon: Icon(Icons.people, color: Colors.white),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the number of players';
              }

              int? numberOfPlayers = int.tryParse(value);
              if (numberOfPlayers == null || numberOfPlayers < 0 || numberOfPlayers > 4) {
                return 'Please enter a valid integer between 0 and 4';
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
        TextField(
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
              _postData();
            },
            child: Text(
              "Publish",
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

  void _postData() async {
    String apiUrl = 'http://127.0.0.1:8000/api/rooms';

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
      'name': _gameNameController.text,
      'category_id': selectedCategoryId,
      'location_id': selectedLocationId,
      'start_date': fromDateTime != null ? fromDateTime.toIso8601String() : null,
      'end_date': toDateTime != null ? toDateTime.toIso8601String() : null,
      'max_players': int.parse(_numberOfPlayersController.text),
      'winners_prize': double.parse(_winnersPriceController.text),
      'description': _descriptionController.text,
      'send_email': sendEmail,
      'send_notification': sendNotification,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(requestData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print(responseData);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFF53183B),
              title: Text(
                'Success',
                style: TextStyle(color: Colors.green),
              ),
              content: Text(
                'Room created successfully!',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
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
                'Failed to schedule the game. Please try again.',
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
    } catch (error) {
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
    }
  }


}




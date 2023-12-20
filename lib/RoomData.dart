import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Player {
  String username = ''; // Initialize to an empty string
  final String imagePath;
  bool isConnected;

  Player({
    required this.imagePath,
    this.isConnected = true, required String username,
  });
}

class RoomData extends StatefulWidget {
  final Map<String, dynamic>? roomData;
  final int? roomId;
  const RoomData({Key? key, this.roomData,this.roomId}) : super(key: key);
  @override
  State<RoomData> createState() => _RoomDataState();
}

class _RoomDataState extends State<RoomData> {
List<Player> players = [];
String description = '';
String startDate = '';
String endDate = '';
List<double> winnersPrizes = [0.0, 0.0, 0.0, 0.0];
int? _roomId; // Variable to store the fetched roomId from shared preferences
int? _playerId;
List<int> playerIds = [];
List<String> playerUsernames = [];

@override
void initState() {
  super.initState();
  _fetchStoredRoomId(); // Fetch the stored roomId from shared preferences
  _fetchStoredPlayerId(); // Call the method to fetch and log the player ID

  // Initialize the player list with static avatar images and no names
  players = [
    Player(
      username: '', // Empty username for now
      imagePath: 'assets/login.png',
      isConnected: true,
    ),
    Player(
      username: '', // Empty username for now
      imagePath: 'assets/login.png',
      isConnected: true,
    ),
    Player(
      username: '', // Empty username for now
      imagePath: 'assets/login.png',
      isConnected: true,
    ),
    Player(
      username: '', // Empty username for now
      imagePath: 'assets/login.png',
      isConnected: true,
    ),
  ];

  // Call the _fetchRoomData method with the fetched roomId
  if (_roomId != null) {
    _fetchRoomData(_roomId!,_playerId!);
  }
}


  Future<void> _fetchStoredRoomId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedRoomId = prefs.getInt('selected_room_id');
    int? playerId = prefs.getInt('userId'); // Assuming you store player ID with the key 'userId'

    setState(() {
      _roomId = storedRoomId; // Update the _roomId with the stored value
      _playerId=playerId;
    });

    if (_roomId != null || _playerId !=null) {
      print('Fetched Room ID  ID: $_roomId');
      print('Fetched Player ID with room id: $_playerId');

      _fetchRoomData(
          _roomId!,_playerId!); // Fetch the room data based on the stored room ID
    }
  }

Future<void> _fetchStoredPlayerId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? playerId = prefs.getInt('userId'); // Assuming you store player ID with the key 'userId'
  setState(() {
    // You can store the player ID in a variable for future use if needed
    // For this example, let's just print it
    print('Fetched Player ID: $playerId');
  });
}

void _fetchRoomData(int roomId,int playerId) async {
  final roomUrl = 'http://127.0.0.1:8000/api/rooms/$roomId';
  final playerUrl = 'http://127.0.0.1:8000/api/room-players/$roomId/join-player/$playerId';

  try {
    final playerResponse = await http.put(Uri.parse(playerUrl));
    final roomResponse = await http.get(Uri.parse(roomUrl));
    if (roomResponse.statusCode == 200 && playerResponse.statusCode == 200) {
      final roomData = json.decode(roomResponse.body);
      final playerData = json.decode(playerResponse.body);

      setState(() {
        description = roomData['description'];
        startDate = roomData['start_date'];
        endDate = roomData['end_date'];

        // Split winners_prizes equally among 4 players
        final totalPrize = double.parse(roomData['winners_prize']);
        final prizePerPlayer = totalPrize * 0.1;
        winnersPrizes = [prizePerPlayer, prizePerPlayer, prizePerPlayer, prizePerPlayer];

        // Extract player data from the roomData
        if (roomData['room_players'] is List) {
          List<dynamic> roomPlayers = roomData['room_players'];
          for (var i = 0; i < roomPlayers.length; i++) {
            var player = roomPlayers[i];
            if (player['player'] is Map<String, dynamic>) {
              var playerUsername = player['player']['username'];

              if (playerUsername is String && i < players.length) {
                // Update the players list with fetched player data
                players[i].username = playerUsername;
              }
            }
          }
        }

        // Log the extracted data
        print('Description: $description');
        print('Start Date: $startDate');
        print('End Date: $endDate');
        print('Player Usernames: $playerUsernames');
      });
    } else if (playerResponse.statusCode == 400) {
      showAwesomeDialog(context, ' You have already been kicked');

    }
    else {
      print('Failed to fetch data. Status code: ${roomResponse.statusCode}, ${playerResponse.statusCode}');
    }
  } catch (e) {
    print('Error occurred while fetching data: $e');
  }
}



void _leaveRoom() async {
  if (_roomId != null) {
    final url = 'http://127.0.0.1:8000/api/room-players/$_roomId/leave/$_playerId?_method=PUT';
    try {
      final response = await http.put(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Successfully left the room!');

        // Show the success dialog
        _showSuccessDialog();

        // Remove the stored room ID from shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('selected_room_id');
      } else {
        print('Failed to leave the room. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while leaving the room: $e');
    }
  } else {
    print('Stored room ID is null.');
  }
}

void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF53183B), // Set the background color
        title: Text('Success', style: TextStyle(color: Color(0xFFf43868))), // Set the text color
        content: Text(
          'You have left the room successfully !',
          style: TextStyle(color: Colors.white), // Set the text color
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/MenuBottomBar');
            },
            child: Text(
              'OK',
              style: TextStyle(color: Color(0xFFf43868)), // Set the text color
            ),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {

    Map<String, dynamic>? roomData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String? roomId = roomData?['id'];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Room informations'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, '/RoomUpdate');
              },
            ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(24, 24, 24, 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(),
                _middleText(),
                SizedBox(height: 4),
                _Box2(context),
                SizedBox(height: 15),
                _midleSimple(),
                SizedBox(height: 15),
                _Button(context),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _leaveRoom,
          child: Icon(Icons.exit_to_app, color: Color(0xFF53183B)),
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
        ),

      ),
    );
  }

Widget _header() {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFF53183B),
      borderRadius: BorderRadius.circular(20),
    ),
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _playerWidget(players[0]),
            SizedBox(width: 16),
            Text('+', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(width: 16),
            _playerWidget(players[1]),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'VS',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _playerWidget(players[2]),
            SizedBox(width: 16),
            Text('+', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(width: 16),
            _playerWidget(players[3]),
          ],
        ),
      ],
    ),
  );
}

Widget _playerWidget(Player player) {
  void _kickPlayer(Player player) async {
    final url = 'http://127.0.0.1:8000/api/room-players/$_roomId/kick/9?_method=PUT'; // Replace with actual URL and data
    try {
      final response = await http.put(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Player kicked successfully!');
        setState(() {
          player.isConnected = false;
        });
      } else {
        print('Failed to kick the player. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while kicking the player: $e');
    }
  }

  return Column(
    children: [
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Color(0xFFf43868), width: 4),
        ),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundImage: AssetImage(player.imagePath),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: player.isConnected ? Colors.green : Colors.red,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 8),
      if (player.username.isNotEmpty) // Show the username if not empty
        Text(
          player.username,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      SizedBox(height: 8),
      ElevatedButton(
        onPressed: () {
          _kickPlayer(player);
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFf43868),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          minimumSize: Size(80, 30),
        ),
        child: Text(
          'Kick',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
  Widget _middleText() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Description',
                style: TextStyle(
                  color: Color(0xFFf43868),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _Box2(context) {
    // Calculate percentages
    final totalPrize = winnersPrizes.reduce((a, b) => a + b);
    final firstPositionPrize = (totalPrize * 0.4).toStringAsFixed(2);
    final secondPositionPrize = (totalPrize * 0.4).toStringAsFixed(2);
    final thirdPositionPrize = (totalPrize * 0.1).toStringAsFixed(2);
    final fourthPositionPrize = (totalPrize * 0.1).toStringAsFixed(2);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1ST POSITION",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf43868),
                ),
              ),
              Text(
                "$firstPositionPrize D (${(0.4 * 100).toStringAsFixed(0)}%)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "2ND POSITION",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf43868),
                ),
              ),
              Text(
                "$secondPositionPrize D (${(0.4 * 100).toStringAsFixed(0)}%)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "3RD POSITION",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf43868),
                ),
              ),
              Text(
                "$thirdPositionPrize D (${(0.1 * 100).toStringAsFixed(0)}%)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "4TH POSITION",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf43868),
                ),
              ),
              Text(
                "$fourthPositionPrize D (${(0.1 * 100).toStringAsFixed(0)}%)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _midleSimple() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF53183B),
      ),
      padding: EdgeInsets.all(13),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'From',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf43868),
                ),
              ),
              SizedBox(width: 8),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFf43868), width: 1),
                ),
                child: Text(
                  startDate,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFf43868),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                'To',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf43868),
                ),
              ),
              SizedBox(width: 8),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFf43868), width: 1),
                ),
                child: Text(
                  endDate,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFf43868),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _Button(context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Result');
          // Add your button action here
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFf43868),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Finish',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


void showAwesomeDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'You can\'t join this room! ',
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
            Navigator.pushNamed(context, '/MenuBottomBar');
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

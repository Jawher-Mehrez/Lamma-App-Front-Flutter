import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(BeloteStatisticsPage());
}

class BeloteStatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Statistiques de Belote',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFf43868, {
          50: Color(0xFFf43868),
          100: Color(0xFFf43868),
          200: Color(0xFFf43868),
          300: Color(0xFFf43868),
          400: Color(0xFFf43868),
          500: Color(0xFFf43868),
          600: Color(0xFFf43868),
          700: Color(0xFFf43868),
          800: Color(0xFFf43868),
          900: Color(0xFFf43868),
        }),
        scaffoldBackgroundColor: Color(0xFF2a0d2e),
      ),
      home: BeloteStatisticsScreen(),
    );
  }
}

class BeloteStatisticsScreen extends StatefulWidget {
  @override
  _BeloteStatisticsScreenState createState() => _BeloteStatisticsScreenState();
}

class _BeloteStatisticsScreenState extends State<BeloteStatisticsScreen> {
  List<BeloteGameStats> gameStatsList = [];
  FilterOption selectedFilterOption = FilterOption.all;

  Future<void> fetchGameStats(int id) async {
    final apiUrl = 'http://127.0.0.1:8000/api/room-players/$id/history'; // Replace with your API URL
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      setState(() {
        gameStatsList = jsonData.map((item) => BeloteGameStats.fromJson(item)).toList();
      });
    } else {
      // Handle API error here
      print('Failed to fetch data from the API');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch data from shared preferences
    fetchSharedPreferencesData();
    print(fetchSharedPreferencesData());
  }

  Future<void> fetchSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId') ; // Default value is 3
    fetchGameStats(userId!);
  }

  List<BeloteGameStats> getFilteredStats() {
    if (selectedFilterOption == FilterOption.all) {
      return gameStatsList;
    } else if (selectedFilterOption == FilterOption.wins) {
      return gameStatsList.where((stats) => stats.rank <= 2).toList();
    } else {
      return gameStatsList.where((stats) => stats.rank > 2).toList();
    }
  }

  int getTotalGames() {
    return gameStatsList.length;
  }

  int getTotalWins() {
    return gameStatsList.where((stats) => stats.rank <= 2).length;
  }

  int getTotalLosses() {
    return gameStatsList.where((stats) => stats.rank > 2).length;
  }

  void deleteGameStats(int index) {
    setState(() {
      gameStatsList.removeAt(index);
    });
  }

  void clearGameStats() {
    setState(() {
      gameStatsList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique de Belote'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0),
          Text(
            'Historique des parties de Belote',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.0),
          DropdownButton<FilterOption>(
            value: selectedFilterOption,
            onChanged: (FilterOption? option) {
              if (option != null) {
                setState(() {
                  selectedFilterOption = option;
                });
              }
            },
            items: FilterOption.values.map<DropdownMenuItem<FilterOption>>((FilterOption option) {
              return DropdownMenuItem<FilterOption>(
                value: option,
                child: Container(
                  color: option == selectedFilterOption ? Color(0xFF53183B) : Colors.transparent,
                  child: Text(
                    option == FilterOption.all
                        ? 'Tous'
                        : option == FilterOption.wins
                        ? 'Gagnés'
                        : 'Perdus',
                    style: TextStyle(
                      color: option == selectedFilterOption ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total parties: ${getTotalGames()}',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              SizedBox(width: 10.0),
              Text(
                'Gagnés: ${getTotalWins()}',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              SizedBox(width: 10.0),
              Text(
                'Perdus: ${getTotalLosses()}',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: getFilteredStats().length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(gameStatsList[index].roomName),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    deleteGameStats(index);
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    color: Colors.red[900],
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: BeloteGameStatsCard(
                    gameStats: getFilteredStats()[index],
                    onDelete: () {
                      deleteGameStats(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: clearGameStats,
        child: Icon(Icons.delete),
      ),
    );
  }
}

enum FilterOption {
  all,
  wins,
  losses,
}

class BeloteGameStats {
  final String roomName;
  final int score;
  final Duration playTimeByMinutes;
  final int playTimeByHours;
  final int rank;

  BeloteGameStats({
    required this.roomName,
    required this.score,
    required this.playTimeByMinutes,
    required this.playTimeByHours,
    required this.rank,
  });

  factory BeloteGameStats.fromJson(Map<String, dynamic> json) {
    return BeloteGameStats(
      roomName: json['room']['name'],
      score: json['score'],
      playTimeByMinutes: Duration(minutes: int.parse(json['play_time_by_minutes'].split('m')[0])),
      playTimeByHours: json['play_time_by_hours'],
      rank: json['rank'],
    );
  }
}

class BeloteGameStatsCard extends StatelessWidget {
  final BeloteGameStats gameStats;

  final VoidCallback onDelete;

  BeloteGameStatsCard({required this.gameStats, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    IconData resultIcon = gameStats.rank <= 2 ? Icons.check_circle : Icons.cancel;

    return Card(
      color: gameStats.rank <= 2 ? Colors.green : Colors.red[900],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  resultIcon,
                  color: Colors.white,
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Room: ${gameStats.roomName}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Text(
                  'Rank: ${gameStats.rank}',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Text(
                  'Score: ${gameStats.score}',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(width: 20.0),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Text(
                  'Play Time: ${gameStats.playTimeByHours}h ',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Text(
                  'Play Time: ${gameStats.playTimeByMinutes.inMinutes}m',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

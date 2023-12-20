import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(Chart());
}

class Chart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Percent Indicators',
      theme: ThemeData(
        backgroundColor: Color(0xFFf43868),
      ),
      home: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final data = snapshot.data;
            return CircularPercentIndicatorsPage(
              winsCount: data['wins']['count'],
              winsPercent: data['wins']['percentage'],
              lossCount: data['loss']['count'],
              lossPercent: data['loss']['percentage'],
              totalPlayTime: data['total_play_time'],
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    Uri url = Uri.parse('http://127.0.0.1:8000/api/room-players/$userId/stats');
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }
}

class CircularPercentIndicatorsPage extends StatelessWidget {
  final double winsCount;
  final double winsPercent;
  final double lossCount;
  final double lossPercent;
  final double totalPlayTime;

  CircularPercentIndicatorsPage({
    required this.winsCount,
    required this.winsPercent,
    required this.lossCount,
    required this.lossPercent,
    required this.totalPlayTime,
  });

  double calculateWinPercentage() {
    return winsPercent;
  }

  double calculateLossPercentage() {
    return lossPercent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
        backgroundColor: Color(0xFFf43868),
      ),
      backgroundColor: Color(0xFF2a0d2e),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              'Match Statistics',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 8.0,
              percent: calculateWinPercentage() / 100,
              header: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Wins : ${winsCount}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              center: Icon(
                Icons.star,
                size: 40.0,
                color: Colors.yellow,
              ),
              backgroundColor: Colors.grey,
              progressColor: Colors.green,
            ),
            SizedBox(height: 16.0),
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 8.0,
              percent: calculateLossPercentage() / 100,
              header: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Losses : ${lossCount}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900],
                  ),
                ),
              ),
              center: Icon(
                Icons.close,
                size: 50.0,
                color: Colors.red,
              ),
              backgroundColor: Colors.grey,
              progressColor: Colors.red,
            ),
            SizedBox(height: 16.0),
            Text(
              'Total Matches: ${winsCount + lossCount}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.access_time,
                  color: Colors.grey,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Total Hours Played: ${totalPlayTime}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFf43868),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Win Percentage',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    '${calculateWinPercentage().toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Loss Percentage',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    '${calculateLossPercentage().toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

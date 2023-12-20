import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final List<String> playerColors = ['green', 'red', 'blue', 'yellow'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Winners"),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _header0(context),
                SizedBox(height: 20),
                _buildWinnerCard(
                  context,
                  'Ala Yaacoub',
                  'assets/login.png',
                  'TOP 1',
                  '10 D',
                  '130 D',
                  '18.000',
                  'Hi players, I\'m from Sousse and I love playing Card Games with fellow players',
                  0, // Green color for the first player
                ),
                SizedBox(height: 20),
                _buildWinnerCard(
                  context,
                  'Yeser',
                  'assets/login.png',
                  'TOP 2',
                  '10 D',
                  '130 D',
                  '18.000',
                  'Some bio description about the player',
                  1, // Red color for the second player
                ),
                SizedBox(height: 20),
                _buildWinnerCard(
                  context,
                  'Another Player',
                  'assets/login.png',
                  'TOP 3',
                  '10 D',
                  '130 D',
                  '18.000',
                  'Some bio description about the player',
                  2, // Blue color for the third player
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header0(BuildContext context) {
    return Text(
      "Winners",
      style: TextStyle(
        color: Colors.amber[400],
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildWinnerCard(
      BuildContext context,
      String playerName,
      String playerImage,
      String rank,
      String earned,
      String stacked,
      String points,
      String bio,
      int playerIndex, // Index of the player for determining color
      ) {
    String playerColor = playerColors[playerIndex];
    Color cardBackgroundColor = Color(0xFF53183B); // Set card background color
    Color textColor = Colors.white; // Set text color to white

    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color(0xFFf43868),
          width: 1,
        ),
        color: cardBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: playerColor == 'green'
                  ? Colors.green
                  : playerColor == 'red'
                  ? Colors.red
                  : playerColor == 'blue'
                  ? Colors.blue
                  : Colors.yellow,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(playerImage),
                        radius: 50,
                      ),
                    ),
                    if (playerIndex == 0) // Only for P1
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: FractionallySizedBox(
                          widthFactor: null,
                          heightFactor: null,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green, // Change to green for P1
                            ),
                            padding: EdgeInsets.all(4),
                            child: Center(
                              child: Text(
                                "P${playerIndex + 1}",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              playerName,
              style: TextStyle(
                fontSize: 16,
                color: Colors.amber[400],
              ),
            ),
            SizedBox(height: 10),
            Text(
              rank,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFf43868),
              ),
            ),
            SizedBox(height: 11),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoColumn('Earned', earned),
                SizedBox(width: 20),
                _buildInfoColumn('Stacked', stacked),
                SizedBox(width: 20),
                _buildInfoColumn('Points', points),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 11),
            Text(
              'Bio',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFf43868),
              ),
            ),
            SizedBox(height: 5),
            Text(
              bio,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 11),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Result(),
    theme: ThemeData(
      scaffoldBackgroundColor: Color(0xFF2a0d2e),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFFf43868),
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.white),
        subtitle1: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
  ));
}

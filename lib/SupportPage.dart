import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  final List<Map<String, dynamic>> cardData = [
    {
      'icon': Icons.place,
      'title': 'Adresse',
      'content': 'Sousse, Tunis',
    },
    {
      'icon': Icons.phone,
      'title': 'Téléphone',
      'content': '2222222',
    },
    {
      'icon': Icons.email,
      'title': 'Email',
      'content': 'email@gmail.com',
    },
    {
      'icon': Icons.place,
      'title': 'Horaires Support Techniques',
      'content': '24h/24jrs',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 10),
                child: Center(
                  child: Text(
                    'Contacter-Nous',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cardData.length,
              itemBuilder: (context, index) {
                final card = cardData[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Color(0xFF53183B), // Set the background color here
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(card['icon']),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(card['content']),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

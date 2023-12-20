import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Simple_Filtre extends StatefulWidget {
  const Simple_Filtre({super.key});

  @override
  State<Simple_Filtre> createState() => _Simple_FiltreState();
}

class _Simple_FiltreState extends State<Simple_Filtre> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _header(context),
            ],
          ),
        ),
      ),
    );;
  }
}
Widget _header(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 0, 30),
          child: Text(
            "Filter",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(
            "Sort By",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  Icons.room,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Location",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              Icon(
                Icons.meeting_room,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Room Name",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(
                Icons.question_mark,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Example",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 45),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/ProfileListe');
            },
            child: Text(
              "Apply",
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
    ),
  );
}

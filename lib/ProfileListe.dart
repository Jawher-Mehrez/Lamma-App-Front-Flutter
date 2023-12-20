import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:raised_buttons/raised_buttons.dart';

class ProfileListe extends StatefulWidget {
  const ProfileListe({Key? key}) : super(key: key);

  @override
  State<ProfileListe> createState() => _ProfileListeState();
}

class _ProfileListeState extends State<ProfileListe> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
          body: Container(
margin: EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                _quit(context),
                _photo(context),
_header(context),
              ],
            ),
            
            
          ),
          
          
    ));
  }
}

_quit(context){
  return Row(

mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton.icon(onPressed: () {
Navigator.pushNamed(context, '/');
      }, icon:  Icon(Icons.arrow_circle_left_outlined,size: 30),
          label: Text(" ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )
          )
      ),


    ],
  );
}

_photo(context){
  return Column(


    children: [

      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 50,

              backgroundColor: Colors.pink,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/login.png"),
                        radius: 50,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: FractionallySizedBox(
                        widthFactor: null,
                        heightFactor: null,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          padding: EdgeInsets.all(4),
                          child: Center(
                            child: Text(
                              "P1",
                              style: TextStyle(
                                color: Colors.white,
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

            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("User 1",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.hotel_class,color: Colors.amber,size: 15),
                    Text("Gold Player ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.amber)),
                  ],
                ),

                Text(" Online",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.green)),

              ],

            ),
          ],
        ),
      )


    ],
  );
}






_header(context){
  return Center(
    child: Column(

      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(Icons.person),
            SizedBox(width: 15),
    TextButton(

      onPressed: () {
        Navigator.pushNamed(context, '/MenuBottomBar');
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "My informations",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.history),
            SizedBox(width: 15),
  TextButton(

  onPressed: () {
    Navigator.pushNamed(context, '/Room_Information');
  },
  child: Align(
  alignment: Alignment.centerRight,
  child: Text(
  "History",
  style: TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,
  ),
  ),
  ),
  ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.stacked_bar_chart),
            SizedBox(width: 15),
  TextButton(

  onPressed: () {
    Navigator.pushNamed(context, '/Serial_Number');
  },
  child: Align(
  alignment: Alignment.centerRight,
  child: Text(
  "Statistics",
  style: TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,
  ),
  ),
  ),
  ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.place),
            SizedBox(width: 15),
  TextButton(

  onPressed: () {
    Navigator.pushNamed(context, '/DropdownExample');
  },
  child: Align(
  alignment: Alignment.centerRight,
  child: Text(
  "Discover Rooms",
  style: TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,
  ),
  ),
  ),
  ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.message),
            SizedBox(width: 15),
  TextButton(

  onPressed: () {
Navigator.pushNamed(context, '/List_Search');
  },

  child: Text(
  "Support",
  style: TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,

  ),
  ),

  ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.change_circle_outlined),
            SizedBox(width: 10),
  TextButton(

  onPressed: () {
    Navigator.pushNamed(context, '/Result');
  },
  child: Align(
  alignment: Alignment.centerRight,
  child: Text(
  "Change Languages",
  style: TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,
  ),
  ),
  ),
  ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.ac_unit),
            SizedBox(width: 15),
  TextButton(

  onPressed: () {
    Navigator.pushNamed(context, '/Dashboard');
  },
  child: Align(
  alignment: Alignment.centerRight,
  child: Text(
  "Change App Skin",
  style: TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,
  ),
  ),
  ),
  ),
          ],
        ),

        Row(
          children: [
            Icon(Icons.password_outlined),
            SizedBox(width: 15),
            TextButton(

              onPressed: () {
                Navigator.pushNamed(context, '/ChangePassword');
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),SizedBox(height: 12),
            TextButton.icon(onPressed: () {
               Navigator.pushNamed(context, '/Simple_Filtre');

            }, icon: Icon(Icons.backspace_outlined),
            label: Text("Logout",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )
            )
            ),





      ],
    ),
  );
}
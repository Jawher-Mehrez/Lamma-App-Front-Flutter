import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(MaterialApp(
    home: GeolocatorExample(),
  ));
}

class GeolocatorExample extends StatefulWidget {
  @override
  _GeolocatorExampleState createState() => _GeolocatorExampleState();
}

class _GeolocatorExampleState extends State<GeolocatorExample> {
  double _latitude = 0.0;
  double _longitude = 0.0;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _showPopup('', '')); // Open the popup when the page is loaded
  }

  void _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      print('Location permission granted.');
    } else if (status.isDenied) {
      print('Location permission denied.');
    } else if (status.isPermanentlyDenied) {
      print('Location permission permanently denied.');
    }
  }

  void _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final addresses = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final address = addresses.first;

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      _showPopup(address.subThoroughfare ?? '', address.locality ?? '');
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void _showPopup(String address, String city) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pushNamed(context, '/MenuBottomBar');
            return true; // Return true to allow popping the route
          },
          child: AlertDialog(
            title: Center(
              child: Text(
                'Current Location',
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Color(0xFF53183B),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'City : $city',
                    style: TextStyle(fontSize: 21, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: ElevatedButton(
                    onPressed: _getCurrentLocation,
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFf43868),
                    ),
                    child: Text(
                      'Get Current Location',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _requestLocationPermission,
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFf43868),
                  ),
                  child: Text(
                    'Get Location Permission',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/MenuBottomBar');
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFf43868),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}

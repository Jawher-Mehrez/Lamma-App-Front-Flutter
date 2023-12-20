import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AccountInformation extends StatefulWidget {
  final int? userId; // Make userId optional by adding '?' after 'int'
  const AccountInformation({Key? key, this.userId}) : super(key: key);

  @override
  State<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Show Awesome Dialog with success or error message
  void _showSuccessDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: 'Account Updated Successfully',
      btnOkOnPress: () {
        Navigator.pushNamed(context, '/MenuBottomBar');
      },
    ).show();
  }

  @override
  void initState() {
    super.initState();

      // Fetch the user's account information when the page loads if userId is available
      _fetchAccountInformation();

  }

  // Fetch the user's account information from the API
  Future<void> _fetchAccountInformation() async {
    // Fetch the user's ID from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId != null) {
      final url = 'http://127.0.0.1:8000/api/users/$userId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Store the data in Shared Preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('username', data['username']);
        prefs.setString('email', data['email']);
        prefs.setString('phone_number', data['phone_number']);

        // Update the text controllers with the fetched data
        usernameController.text = data['username'];
        emailController.text = data['email'];
        phoneNumberController.text = data['phone_number'];

        // Log the fetched data to the console
        print('Fetched account information:');
        print('Username: ${data['username']}');
        print('Email: ${data['email']}');
        print('Phone Number: ${data['phone_number']}');
      } else {
        print('Failed to fetch account information');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Account Information'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                _inputField(),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
          child: Text(
            "Account",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFf43868),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 15),
          child: Text(
            "Information",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFf43868),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 7, 2, 32),
          child: Text(
            "All your account information can be accessed and edited here "
                "but your mail will still remain un-edited",
            style: TextStyle(fontSize: 14.5),
          ),
        ),
      ],
    );
  }

  Widget _inputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: "Username",
            filled: true,
            prefixIcon: Icon(Icons.person, color: Colors.white),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your username';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: "Email",
            filled: true,
            prefixIcon: Icon(Icons.email, color: Colors.white),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your email';
            } else if (!RegExp(
                r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})(\s*)$')
                .hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: phoneNumberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Phone Number",
            filled: true,
            prefixIcon: Icon(Icons.mobile_friendly, color: Colors.white),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your phone number';
            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Password",
            filled: true,
            prefixIcon: Icon(Icons.lock, color: Colors.white),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _submitButton() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Form is valid, perform desired actions

              final username = usernameController.text;
              final email = emailController.text;
              final phoneNumber = phoneNumberController.text;
              final password = passwordController.text;

              // Create a map of the data to be sent in the request body
              final data = {
                'username': username,
                'email': email,
                'password': password,
                'phone_number': phoneNumber,
              };

              // Convert the data to JSON format
              final jsonData = jsonEncode(data);

              // Determine the URL for the API request
              String url;
              if (widget.userId == null) {
                // If userId is available, it means we are updating an existing account
                url = 'http://127.0.0.1:8000/api/users/${17}';
              } else {
                // userId is null, so we don't add _method=PUT for a POST request
                url = 'http://127.0.0.1:8000/api/users';
              }

              // Make the request to the API (PUT or POST)
              http.put(
                Uri.parse(url),
                headers: {'Content-Type': 'application/json'},
                body: jsonData,
              ).then((response) {
                if (response.statusCode == 200) {
                  // Request successful, handle the response
                  if (widget.userId != null) {
                    print('Account updated successfully');
                  } else {
                    print('Account created successfully');
                  }
                  _showSuccessDialog(); // Show the success dialog
                } else {
                  // Request failed, handle the error
                  print('Failed to create/update account');
                }
              }).catchError((error) {
                // Error occurred during the request
                print('Error: $error');
              });
            }
          },
          child: Center(
            child: Text(
            "Update Account" ,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(100, 14, 100, 14),
          ),
        ),
      ],
    );
  }
}

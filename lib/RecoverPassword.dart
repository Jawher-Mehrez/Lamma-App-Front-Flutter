import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class RecoverPassword extends StatefulWidget {
  final int? pinKey;
  final String? email; // Add the email field

  const RecoverPassword({Key? key, this.pinKey, this.email}) : super(key: key);

  @override
  State<RecoverPassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<RecoverPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Change Password")),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              children: [
                _header(),
                _inputField(),
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
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 50, 0, 4),
          child: Text(
            "Change ",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFFf43868),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 0, 25),
          child: Text(
            "Password",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFFf43868),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 7, 5, 5),
          child: Text(
            "Feeling worried about your account being easily preyed on? Change that password now!",
            style: TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _inputField() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: TextEditingController(text: widget.email),
            decoration: InputDecoration(
              hintText: "Email",
              prefixIcon: Icon(Icons.email, color: Colors.white),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an email';
              } else if (!_isValidEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),   const SizedBox(height: 10),
          TextFormField(
            obscureText: true,
            controller: newPasswordController,
            decoration: InputDecoration(
              hintText: "New Password",
              prefixIcon: const Icon(Icons.password_outlined, color: Colors.white),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a new password.';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters long.';
              }
              return null;
            },
          ),


          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updatePassword();
                }
              },
              child: const Text(
                "Recover Password",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(100, 14, 100, 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updatePassword() async {
    final String? emailFromRoute = widget.email;
    final int keyFromRoute = widget.pinKey!;
    final String newPassword = newPasswordController.text;

    if (emailFromRoute == null || keyFromRoute == null) {
      // Invalid email or key from the route, show an error
      _showErrorDialog();
      return;
    }

    // Prepare the data for the API call
    final Map<String, dynamic> data = {
      'email': emailFromRoute,
      'key': keyFromRoute.toString(),
      'password': newPassword,
    };

    // Make the API call to verify if the email and key are correct
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/auth/recover-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final bool isEmailAndKeyValid = responseData['is_valid'];

      if (isEmailAndKeyValid) {
        // Email and key are valid, proceed with password update
        _performPasswordUpdate();
      } else {
        // Invalid email or key from the route, show an error
        _showErrorDialog();
      }
    } else {
      // Error in API response, show an error
      _showErrorDialog();
    }
  }

  void _performPasswordUpdate() async {
    final String? emailFromRoute = widget.email;
    final int keyFromRoute = widget.pinKey!;
    final String newPassword = newPasswordController.text;

    // Prepare the data for the API call
    final Map<String, dynamic> data = {
      'email': emailFromRoute,
      'key': keyFromRoute.toString(),
      'password': newPassword,
    };

    // Make the API call to update the password using PUT method
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/auth/recover-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Password updated successfully
      _showSuccessDialog();
    } else {
      // Error updating password
      _showErrorDialog();
    }
  }

  void _showSuccessDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      title: 'Password updated successfully!',
      desc: 'Password updated successfully!',
      btnOkText: 'OK',
      btnOkOnPress: () {
        Navigator.pushNamed(context, '/MenuBottomBar');
      },
    )..show();
  }

  void _showErrorDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.SCALE,
      title: 'Password update failed',
      desc: 'There was an error updating the password.',
    )..show();
  }

  bool _isValidEmail(String email) {
    // Regular expression to check email format
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})(\s*)$');
    return emailRegex.hasMatch(email);
  }
}
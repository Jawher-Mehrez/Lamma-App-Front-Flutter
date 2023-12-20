import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamma/Pin_Text_Field.dart';

import 'RecoverPassword.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  int? _key;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.all(24),
            child: Column(
              children: [
                _header(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image(
              image: AssetImage('assets/reset.png'),
              width: 400,
              height: 300,
            ),
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 0, 5),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 7, 5, 5),
                child: Text(
                  "Enter your email address below, and we'll send you an email with instructions on how to change your password",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: TextFormField(
                  controller: _emailController,
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
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _sendPasswordResetEmail();
                    }
                  },
                  child: Text(
                    "Recover Password",
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(86, 14, 86, 14),
                    primary: Color(0xFF53183B),
                  ),
                ),
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    // Regular expression to check email format
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})(\s*)$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _sendPasswordResetEmail() async {
    final email = _emailController.text;
    final apiUrl = 'http://127.0.0.1:8000/api/auth/request-key?email=$email';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      setState(() {
        _errorMessage = null;
        _key = responseData['key'];
      });

      // TODO: Implement email sending functionality using the received key

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Pin_Text_Field(pinKey: _key),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RecoverPassword(email: email, pinKey: _key), // Navigate to the RecoverPassword screen with email and key
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Failed to send email. Please try again.';
      });
    }
  }
}

class PinTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int? key = ModalRoute.of(context)?.settings.arguments as int?;
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Pin'),
      ),
      body: Center(
        child: Text('Pin: $key'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ForgetPassword(),
    routes: {
      '/Pin_Text_Field': (context) => PinTextField(),
    },
  ));
}

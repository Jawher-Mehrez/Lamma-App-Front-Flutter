import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool passwordObscured = false;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      Map<String, dynamic> requestBody = {
        'email': email,
        'password': password,
      };

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/auth/login'),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        int id = responseData['data']['id'];
        String username = responseData['data']['username'];

        // Save id and username to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', id);
        await prefs.setString('username', username);

        // Print shared preferences data to console
        print('Shared Preferences - userId: $id, username: $username');

        // Show success dialog and navigate to MenuBottomBar
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          title: 'Welcome $username',
          desc: responseData['message'],
        )..show().then((_) {
          Navigator.pushNamed(context, '/MenuBottomBar');
        });
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          title: 'Error',
          desc: 'Login failed. Please check your credentials.',
        )..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.fromLTRB(24, 24, 24, 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
                Form(
                  key: _formKey,
                  child: _inputField(context),
                ),
                _forgotPassword(context),
                _signup(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image(
            image: AssetImage('assets/sign.png'),
            width: 200,
            height: 200,
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: SizedBox(
            width: 250.0,
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 22,
                fontFamily: 'Bobbers',
                color: Color(0xFFf43868),
                fontWeight: FontWeight.bold,
              ),
              child: Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText('Welcome Back'),
                    TyperAnimatedText('Kindly Login To Lamma'),
                  ],
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 25),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Email",
            prefixIcon: Icon(Icons.email, color: Colors.white),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }

            final emailRegex = RegExp(
                r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})(\s*)$');

            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email address';
            }

            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            prefixIcon: Icon(Icons.password, color: Colors.white),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  passwordObscured = !passwordObscured;
                });
              },
              icon: Icon(
                passwordObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }

            if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }

            return null;
          },
          obscureText: !passwordObscured,
        ),
        SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: _handleLogin,
            child: Text(
              "Let's Combat !",
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
    );
  }

  Widget _forgotPassword(context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/ForgetPassword');
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "Forgot password?",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFFf43868),
          ),
        ),
      ),
    );
  }

  Widget _signup(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        Text(
          "Connect With: ",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Handle Facebook avatar click
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/facebook.png'),
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                // Handle Google+ avatar click

              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/google+.png'),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/CreateAccount');
              },
              child: Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf43868),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_text_field/password_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool passwordObscured = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
                Form(
                  key: _formKey,
                  child: _inputField(context),
                ),
                SizedBox(height: 20), // Add space between the password field and the button
                _button(context),
                SizedBox(height: 20), // Add space between the password field and the button

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
            image: AssetImage("assets/login.png"),
            width: 500,
            height: 200,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Create Account",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFFf43868)),
        ),
        SizedBox(height: 10),
        Text(
          "Hi, Kindly fill in the form to proceed in LAMA",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _inputField(context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: "Username",
              prefixIcon: Icon(Icons.person, color: Colors.white),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _fullNameController,
            decoration: InputDecoration(
              hintText: "Full Name",
              prefixIcon: Icon(Icons.person, color: Colors.white),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: "Phone Number",
              prefixIcon: Icon(Icons.mobile_friendly, color: Colors.white),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (!isPhoneNumber(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
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
              if (!isEmail(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: !passwordObscured,
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
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Choose another password';
              }
              // Add any other validation logic for the password field
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _button(context) {
    return SizedBox(
      height: 50,
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid, perform registration or account creation logic
            String username = _usernameController.text;
            String fullName = _fullNameController.text;
            String phoneNumber = _phoneNumberController.text;
            String email = _emailController.text;
            String password = _passwordController.text;

            // Send user data to the API
            createUser(username, fullName, phoneNumber, email, password);
          }
        },
        child: Text(
          "Create Account",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),

          ),
        ),
      ),
    );
  }

  Widget _signup(context) {
    return Column(
      children: [
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
                // Action to perform when the Facebook avatar is clicked
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/facebook.png'),
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                // Action to perform when the Google avatar is clicked
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/google+.png'),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account? ",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: Text(
                "Login",
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

  bool isEmail(String value) {
    // Email validation logic
    // This is a basic validation, you can use a library or more complex logic
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})(\s*)$');
    return emailRegex.hasMatch(value);
  }

  bool isPhoneNumber(String value) {
    // Phone number validation logic
    // This ensures the value only contains digits (0-9)
    final phoneRegex = RegExp(r'^\d+$');
    return phoneRegex.hasMatch(value);
  }

  Future<void> createUser(String username, String fullName, String phoneNumber, String email, String password) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/users');

    final response = await http.post(
      url,
      body: {
        'username': username,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // User created successfully
      print('User created!');
      _showSuccessDialog();
    } else {
      // Error occurred while creating the user
      print('Failed to create user. Error: ${response.body}');
    }
  }

  void _showSuccessDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: 'Account Created Successfully',
      desc: "You now have full access to our system",
      btnOkOnPress: () {
        Navigator.pushNamed(context, '/');
      },
    ).show();
  }
}

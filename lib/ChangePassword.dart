import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _newPasswordConfirmationController = TextEditingController();

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
            obscureText: true,
            controller: _oldPasswordController,
            decoration: InputDecoration(
              hintText: "Old Password",
              prefixIcon: const Icon(Icons.password_outlined, color: Colors.white),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your old password.';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            obscureText: true,
            controller: _newPasswordController,
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
          const SizedBox(height: 10),
          TextFormField(
            obscureText: true,
            controller: _newPasswordConfirmationController,
            decoration: InputDecoration(
              hintText: "Retype New Password",
              prefixIcon: const Icon(Icons.password_outlined, color: Colors.white),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please retype the new password.';
              } else if (value != _newPasswordController.text) {
                return 'Passwords do not match.';
              }
              return null;
            },
          ),
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _showSuccessDialog();
                }
              },
              child: const Text(
                "Update",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(125, 14, 125, 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _showSuccessDialog() async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;
    String newPasswordConfirmation = _newPasswordConfirmationController.text;

    // Perform the API call to update the password
    String apiUrl = 'http://127.0.0.1:8000/api/auth/17/change-password?_method=PUT';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'old_password': oldPassword,
          'password': newPassword,
          'password_confirmation': newPasswordConfirmation,
        },
      );

      if (response.statusCode == 200) {
        // Password updated successfully
        _showDialogSuccess(); // Show the success dialog
        Navigator.pushNamed(context, '/MenuBottomBar');
      } else {
        // Handle API errors or invalid response codes here
        _showDialogError(); // Show the error dialog
      }
    } catch (e) {
      // Handle any exceptions or connection errors here
      _showDialogError(); // Show the error dialog
    }
  }

  void _showDialogSuccess(){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: 'Password Updated Successfully',
      desc: "Your password has been updated successfully!",
      btnOkOnPress: () {
        Navigator.pushNamed(context, '/');
      },
    ).show();
  }

  void _showDialogError(){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: 'Password Update Failed',
      desc: "There was an error updating your password. Please try again.",
      btnOkOnPress: () {
        // You can add any action here if needed
      },
    ).show();
  }

}

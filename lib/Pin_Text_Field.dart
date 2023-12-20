import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Pin_Text_Field extends StatefulWidget {
  final int? pinKey;


  const Pin_Text_Field({Key? key, this.pinKey}) : super(key: key);

  @override
  State<Pin_Text_Field> createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<Pin_Text_Field> {
  String currentPin = '';

  @override
  Widget build(BuildContext context) {
    final int? key = ModalRoute.of(context)?.settings.arguments as int?;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _header(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Verification Code",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFf43868)),
          ),
          SizedBox(height: 10),
          Text(
            "SMS Verification code has been sent to:",
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          PinCodeTextField(
            appContext: context,
            length: 4,
            onChanged: (String value) {
              setState(() {
                currentPin = value;
              });
            },
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              inactiveColor: Colors.red,
              activeColor: Colors.greenAccent,
            ),
            onCompleted: (value) {
              // Vérifier la valeur du code PIN
              if (value == widget.pinKey.toString()) {
                // Code PIN valide
                setState(() {
                  currentPin = ''; // Clear the currentPin variable
                });
                _showSuccessDialog();
              } else {
                // Code PIN invalide
                _showErrorDialog();
              }
            },
          ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (currentPin == widget.pinKey.toString()) {
                  // Code PIN valide
                  setState(() {
                    currentPin = ''; // Clear the currentPin variable
                  });
                  _showSuccessDialog();
                } else {
                  // Code PIN invalide
                  _showErrorDialog();
                }
              },
              child: Text(
                "Next",
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

  void _showSuccessDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: 'Verification Successful',
      desc: "You now have full access to our system",
      btnOkOnPress: () {
        Navigator.pushNamed(context, '/RecoverPassword');
      },
    ).show();
  }

  void _showErrorDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: 'Verification Failed',
      desc: "Invalid verification code",
    ).show().then((value) {
      setState(() {
        currentPin = ''; // Clear the currentPin variable
      });
    });
  }


}

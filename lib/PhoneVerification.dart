import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({Key? key}) : super(key: key);

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
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

  Widget _header(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Mobile Number",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFf43868),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Confirm the country code and enter your mobile number",
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          IntlPhoneField(
            pickerDialogStyle: PickerDialogStyle(
              backgroundColor: Color(0xFF53183B),
              searchFieldInputDecoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(color: Colors.white),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
            dropdownIcon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            decoration: const InputDecoration(
              suffixIconColor: Color.fromARGB(255, 0, 0, 0),
              iconColor: Colors.white,
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              labelStyle: TextStyle(color: Colors.white),
            ),
            initialCountryCode: 'TN',
            dropdownTextStyle: const TextStyle(color: Colors.white),
            style: const TextStyle(color: Colors.white),
            onChanged: (phone) {
              setState(() {
                phoneNumber = phone.completeNumber;
              });
            },
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              if (phoneNumber != null) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  animType: AnimType.topSlide,
                  showCloseIcon: true,
                  title: 'Phone Number Confirmation',
                  desc: "We will send a verification code to the following number:\n\n$phoneNumber",
                  descTextStyle: TextStyle(color: Colors.black),
                  btnCancelOnPress: () {
                    // Add your onCancel logic here
                  },
                  btnOkOnPress: () {
                    Navigator.pushNamed(context, '/Pin_Text_Field');
                  },
                ).show();
              } else {
                print('Phone number is null');
              }
            },
            child: Text("Next"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(86, 14, 86, 14),
              backgroundColor: Color(0xFF53183B),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PhoneVerification(),
  ));
}

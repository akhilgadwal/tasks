import 'package:flutter/material.dart';

import '../../../../main.dart';

class LoginwithOtp extends StatelessWidget {
  LoginwithOtp({super.key});

  final TextEditingController emailPassController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? validateEmailOrNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email or number';
    }

    // Check if the input matches either email or phone number format
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    final numberRegex = RegExp(r'^[0-9]{10}$');

    if (!emailRegex.hasMatch(value) && !numberRegex.hasMatch(value)) {
      return 'Please enter a valid email or 10-digit number';
    }

    return null;
  }

  String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your OTP';
    }

    if (value.length < 6) {
      return 'OTP must be at least 6 characters long';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: bgColorprimary, title: const Text('OTP')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 80,
              ),
              const Text(
                'Hello',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Login with OTP',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: emailPassController,
                decoration: InputDecoration(
                  labelText: 'Email-Number',
                  labelStyle: TextStyle(color: bgColorSecondary),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: bgColorprimary),
                  ),
                ),
                validator:
                    validateEmailOrNumber, // Validate email or number input
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                //obscureText: true,
                //controller: emailPassController,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  labelStyle: TextStyle(color: bgColorSecondary),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: bgColorprimary),
                  ),
                ),
                validator: validateOtp, // Validate email or number input
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: bgColorprimary),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // Validation passed, do something with the data
                        // For example, submit the form
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'verify',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  const Text('Check your Email'),
                  TextButton(onPressed: () {}, child: const Text('Resend the code'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

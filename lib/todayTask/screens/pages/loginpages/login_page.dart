import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../http/api.dart';
import '../../../utlis/global/global_var.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController emailPassController = TextEditingController();
  final TextEditingController passcontroller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? validateEmailOrNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email or number';
    }

    // Check if the input matches either email or phone number format
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    final numberRegex = RegExp(r'^[0-9]{10}$');

    if (!emailRegex.hasMatch(value) && !numberRegex.hasMatch(value)) {
      return 'Please enter a valid email or 10-digit number';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: bgColorprimary, title: Text('Login Page')),
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
              Text(
                'Hello',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              Text(
                'Welcome back',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: emailPassController,
                decoration: InputDecoration(
                  labelText: 'Email-Number',
                  labelStyle: TextStyle(color: bgColorSecondary),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: bgColorprimary),
                  ),
                ),
                // validator:
                //     validateEmailOrNumber, // Validate email or number input
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: passcontroller,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: bgColorSecondary),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: bgColorprimary),
                  ),
                ),
                validator: validatePassword, // Validate email or number input
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: bgColorprimary),
                    onPressed: () async {
                      user = await ApiServices.login(emailPassController.text,
                          passcontroller.text, context);
                      //if (formKey.currentState!.validate()) {
                      // Validation passed, do something with the data
                      // For example, submit the form
                      //Navigator.pop(context);
                      //}
                    },
                    child: const Text(
                      'Submit',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

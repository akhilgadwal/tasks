import 'package:flutter/material.dart';

import '../../../../main.dart';

class LoginPageUI extends StatefulWidget {
  const LoginPageUI({super.key});

  @override
  State<LoginPageUI> createState() => _LoginPageUIState();
}

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

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }

  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }

  return null;
}

class _LoginPageUIState extends State<LoginPageUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              bgColorprimary,
              bgColorprimary.withOpacity(0.20),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(children: [
          const Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    )
                  ]),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.20),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  bottomLeft: Radius.circular(35),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      bottomLeft: Radius.circular(35),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 80,
                            ),
                            const Text(
                              'Email/Number',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: 250,
                              child: TextFormField(
                                controller: emailPassController,
                                decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Change the color of the underline when the TextField is enabled
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            bgColorprimary), // Change the color of the underline when the TextField is focused
                                  ),
                                  labelText: 'Email-Number',
                                  labelStyle: const TextStyle(color: Colors.black54),
                                  //border: OutlineInputBorder(),
                                ),
                                validator:
                                    validateEmailOrNumber, // Validate email or number input
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Password',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              width: 250,
                              child: TextFormField(
                                obscureText: true,
                                //controller: emailPassController,
                                decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Change the color of the underline when the TextField is enabled
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            bgColorprimary), // Change the color of the underline when the TextField is focused
                                  ),
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(color: Colors.black54),
                                  //border: OutlineInputBorder(),
                                ),
                                validator:
                                    validatePassword, // Validate email or number input
                              ),
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
                                      Navigator.of(context).pop();
                                    }
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
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    ));
  }
}

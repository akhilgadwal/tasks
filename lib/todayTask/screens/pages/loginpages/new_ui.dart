import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../../main.dart';

class UiPageNew extends StatelessWidget {
  UiPageNew({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            Container(
              height: 200,
              child: Image.asset(
                  'lib/todayTask/screens/pages/loginpagelogo-removebg-preview.png'),
            ),
            Center(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Text(
                      'Hi there!',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "let's Get Started",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          controller: emailPassController,
                          validator: validateEmailOrNumber,
                          decoration: InputDecoration(
                            //border: InputBorder.none,
                            hintText: 'Username',
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            // enabledBorder: UnderlineInputBorder(
                            //   borderSide: BorderSide(
                            //     color: bgColorprimary,
                            //   ),
                            // ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      bgColorprimary), // Set your desired color for the focused underline
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          obscureText: true,
                          validator: validatePassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(
                              Icons.key,
                              color: Colors.black,
                            ),
                            // enabledBorder: UnderlineInputBorder(
                            //   borderSide: BorderSide(
                            //     color: bgColorprimary,
                            //   ),
                            // ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      bgColorprimary), // Set your desired color for the focused underline
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[700],
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Create an Account',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        Container(
                          height: 1.5, // height of the line
                          width: 140, // width of the line
                          color: Colors.white, // color of the line
                        ),
                        const SizedBox(
                            width: 10), // spacing between the lines and text
                        const Text(
                          'Or',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(
                            width:
                                10), // spacing between the text and the second line
                        Container(
                          height: 1.5, // height of the line
                          width: 140, // width of the line
                          color: Colors.white, // color of the line
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.30),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

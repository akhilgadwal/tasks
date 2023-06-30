import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../main.dart';
import '../../../http/api.dart';

class PlantUi extends StatelessWidget {
  PlantUi({super.key});
  final TextEditingController emailPassController = TextEditingController();
  final TextEditingController paswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Color kDarkGreenColor = const Color(0xFF184A2C);
  Color kSpiritedGreen = const Color(0xFFC1DFCB);
  bool _isLoading = false;
  String? validateEmailOrNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email or number';
    }

    // Check if the input matches either email or phone number format
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    //final numberRegex = RegExp(r'^[0-9]{10}$');

    if (!emailRegex.hasMatch(value)) {
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
      body: Stack(
        alignment: Alignment.bottomRight,
        fit: StackFit.expand,
        children: [
          ClipPath(
            clipper: ImageClipper(),
            child: Image.network(
              'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1527&q=80',
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            top: 30.0,
            left: 20.0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20.0,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: bgColorprimary,
                  size: 24.0,
                ),
              ),
            ),
          ),
          Positioned(
              height: MediaQuery.of(context).size.height * 0.66,
              width: MediaQuery.of(context).size.width,
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.66,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome Back',
                              style: GoogleFonts.poppins(
                                  fontSize: 32, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Login to your account',
                              style: GoogleFonts.poppins(
                                //color: kGreyColor,
                                fontSize: 15.0,
                              ),
                            )
                          ],
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 250,
                                decoration: BoxDecoration(
                                  color: kSpiritedGreen,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: TextFormField(
                                    controller: emailPassController,
                                    // validator: validateEmailOrNumber,
                                    decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      hintText: 'Username',
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.black,
                                      ),

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
                                  color: kSpiritedGreen,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: TextFormField(
                                    controller: paswordController,
                                    obscureText: true,
                                    validator: validatePassword,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      prefixIcon: Icon(
                                        Icons.key,
                                        color: Colors.black,
                                      ),
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
                                    color: kSpiritedGreen, // color of the line
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // spacing between the lines and text
                                  Text(
                                    'Or',
                                    style: TextStyle(
                                        fontSize: 16, color: kDarkGreenColor),
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // spacing between the text and the second line
                                  Container(
                                    height: 1.5, // height of the line
                                    width: 140, // width of the line
                                    color: kSpiritedGreen, // color of the line
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  ApiServices.login(emailPassController.text,
                                      paswordController.text, context);
                                  if (formKey.currentState!.validate()) {
                                    //Navigator.of(context).pop();
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: 250,
                                  decoration: BoxDecoration(
                                      color: kDarkGreenColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          color: kSpiritedGreen,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class ImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height * 0.30);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.36,
      size.width * 0.70,
      size.height * 0.30,
    );
    path.lineTo(size.width, size.height * 0.25);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// class CurvePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint();
//     // paint.color = kSpiritedGreen;
//     paint.style = PaintingStyle.fill;

//     var path = Path();

//     path.moveTo(0, size.height * 0.70);

//     path.quadraticBezierTo(
//       size.width * 0.40,
//       size.height * 0.80,
//       size.width * 0.75,
//       size.height * 0.60,
//     );
//     path.quadraticBezierTo(
//       size.width * 0.95,
//       size.height * 0.48,
//       size.width,
//       size.height * 0.32,
//     );

//     path.lineTo(size.width, 20);
//     path.quadraticBezierTo(size.width, 0, size.width - 20, 0);
//     path.lineTo(20, 0);
//     path.quadraticBezierTo(0, 0, 0, 20);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CurvePainter oldDelegate) => false;

//   @override
//   bool shouldRebuildSemantics(CurvePainter oldDelegate) => false;
// }

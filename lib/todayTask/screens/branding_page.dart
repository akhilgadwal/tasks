import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'home.dart';
//import '../components/elevated_button.dart';

class BrandingPage extends StatefulWidget {
  const BrandingPage({super.key});

  @override
  State<BrandingPage> createState() => _BrandingPageState();
}

class _BrandingPageState extends State<BrandingPage> {
  void changeColor(Color color) {
    setState(() {
      bgColorprimary = color;
      saveColor(bgColorprimary);
    });
  }

  void changeSecondColor(Color color) {
    setState(() {
      bgColorSecondary = color;
      saveColorSecondart(bgColorSecondary);
    });
  }

  Future<void> saveColor(Color bgColorprimary) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('primaryColor', bgColorprimary.value);
    //print(prefs);
  }

  Future<void> saveColorSecondart(Color bgColorSecondary) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('secondaryColor', bgColorSecondary.value);
    //print(prefs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColorprimary,
        title: const Text('Branding Page'),
      ),
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: bgColorSecondary),
            child: const Text('Change primary Color'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Pick a color'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: bgColorprimary,
                        onColorChanged: changeColor,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (_) => false);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: bgColorSecondary),
            child: const Text('Change Secondary Color'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Pick a color'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: bgColorSecondary,
                        onColorChanged: changeSecondColor,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (_) => false);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ]),
      ),
    );
  }
// }
}

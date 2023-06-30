import 'package:flutter/material.dart';
import 'package:tasks/todayTask/screens/pages.dart';
import 'package:tasks/todayTask/screens/pages/loginpages/login_page.dart';
import 'package:tasks/todayTask/screens/pages/loginpages/new_ui.dart';
import 'package:tasks/todayTask/screens/pages/loginpages/opt_page.dart';
import 'package:tasks/todayTask/screens/pages/loginpages/page3.dart';
import 'package:tasks/todayTask/screens/pages/loginpages/plant_ui.dart';

import '../../main.dart';
import '../components/buttom.dart';
import '../utlis/constants/string_const.dart';
import 'branding_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool useTestData = false;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getColor();
    super.initState();
  }

  void getColor() async {
    final int colorcode = (prefs!.getInt('primaryColor') ?? 0xFFF50057);
    final int colorCode = (prefs!.getInt('secondaryColor') ?? 0xFFFFEBEE);
    setState(() {
      bgColorprimary = Color(colorcode);
      bgColorSecondary = Color(colorCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: bgColorSecondary,
      appBar: AppBar(
          backgroundColor: bgColorprimary,
          title: Text('HomePage', style: TextStyle(color: bgColorSecondary)),
          elevation: 0),
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: bgColorprimary,
              ),
              child: const Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Use Test Data'),
              onTap: () {},
              trailing: Switch(
                activeColor: bgColorSecondary,
                onChanged: (bool value) {},
                value: useTestData,
              ),
            ),
            ListTile(
              title: const Text('Set Branding'),
              onTap: () {
                // Navigate to the branding page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BrandingPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          //ElevatedButton(onPressed: () {}, child: Text('hello')),
          Center(
            child: Column(children: [
              const SizedBox(
                height: 50,
              ),
              MyButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const Pages(
                  //       title: StringConst.page1,
                  //     ),
                  //   ),
                  // );
                },
                text: StringConst.page1,
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginwithOtp()),
                  );
                },
                text: StringConst.page2,
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductListScreen()),
                  );
                },
                text: StringConst.page3,
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlantUi()),
                  );
                },
                text: StringConst.page4,
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Pages(
                        title: StringConst.page5,
                      ),
                    ),
                  );
                },
                text: StringConst.page5,
              ),
            ]),
          )
          // MyButton(onTap: () {}, text: 'Button 1'),
          // const SizedBox(
          //   height: 10,
          // ),
          // MyButton(onTap: () {}, text: 'Button 2'),
          // const SizedBox(
          //   height: 10,
          // ),
          // MyButton(onTap: () {}, text: 'Button 3'),
          // const SizedBox(
          //   height: 10,
          // ),
          // MyButton(onTap: () {}, text: 'Button 4'),
          // const SizedBox(
          //   height: 10,
          // ),
          // MyButton(onTap: () {}, text: 'Button 5'),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks/todayTask/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

Color bgColorprimary = Colors.teal;
Color bgColorSecondary = Colors.grey.shade300;
SharedPreferences? prefs;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          appBarTheme:
              AppBarTheme(iconTheme: IconThemeData(color: bgColorSecondary)),
          primaryColor: bgColorprimary,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: bgColorSecondary)),
      home: const HomeScreen(),
    );
  }
}

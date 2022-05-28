// ignore_for_file: prefer_const_constructors_in_immutables, non_constant_identifier_names, unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthomeapp/screen/login_screen/login_page.dart';
import 'package:smarthomeapp/screen/login_screen/select_home_screen.dart';
import 'screen/drawer_screen/homepage_screen/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String user_id = "";
  String home_id = "";
  Future get_user_id() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("user_id") == null) {
      preferences.setString("user_id", "");
    } else {
      setState(() {
        user_id = preferences.getString('user_id')!;
      });
    }
  }

  Future get_home_id() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("home_id") == null) {
      preferences.setString("home_id", "");
    } else {
      setState(() {
        home_id = preferences.getString("home_id")!;
      });
    }
  }

  @override
  void initState() {
    get_user_id();
    get_home_id();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: user_id == null || user_id == ""
            ? LoginPage()
            : home_id == null || home_id == ""
                ? SelectHomeScreen()
                : HomePage());
  }
}

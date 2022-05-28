// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, sized_box_for_whitespace, non_constant_identifier_names, avoid_print, unused_local_variable, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthomeapp/ipcon.dart';
import 'package:http/http.dart' as http;
import 'package:smarthomeapp/screen/drawer_screen/homepage_screen/homepage.dart';

class SelectHomeScreen extends StatefulWidget {
  SelectHomeScreen({Key? key}) : super(key: key);
  @override
  State<SelectHomeScreen> createState() => _SelectHomeScreenState();
}

class _SelectHomeScreenState extends State<SelectHomeScreen> {
  String? user_id;
  List homeList = [];
  String? home_name;
  String? home_id;
  get_select_home() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response = await http
        .get(Uri.parse("$ipcon/home/get_select_home.php?user_id=$user_id"));
    var data = json.decode(response.body);
    setState(() {
      homeList = data;
    });

    print(homeList);
  }

  select_home(home_id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("home_id", home_id);
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return HomePage();
    }));
  }

  @override
  void initState() {
    get_select_home();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade300,
              Colors.pink.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Text(
                  "กรุณาเลือกบ้าน",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: homeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          home_id = homeList[index]['home_id'];
                          select_home(home_id);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 2,
                                  offset: Offset(3, 5), // Shadow position
                                ),
                              ],
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${homeList[index]['home_name']}",
                                style: TextStyle(fontSize: 24),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

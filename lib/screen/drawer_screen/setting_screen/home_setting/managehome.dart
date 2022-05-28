// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names, avoid_print, unused_local_variable
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthomeapp/ipcon.dart';
import 'package:smarthomeapp/screen/drawer_screen/setting_screen/home_setting/edit_home_screen.dart';

class ManageHomePage extends StatefulWidget {
  ManageHomePage({Key? key}) : super(key: key);

  @override
  State<ManageHomePage> createState() => _ManageHomePageState();
}

class _ManageHomePageState extends State<ManageHomePage> {
  final textstyle = TextStyle(
    fontSize: 24,
  );
  List homeList = [];
  String? user_id;
  String? home_number;
  String? soi;
  String? parish;
  String? district;
  String? province;
  String? zip_code;
  String? home_id;
  String? home_name;
  get_home() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      home_id = preferences.getString('home_id');
    });
    final response =
        await http.get(Uri.parse("$ipcon/home/get_home.php?home_id=$home_id"));
    var data = json.decode(response.body);
    if (data == null) {
    } else {
      setState(() {
        homeList = data;
      });
      home_name = homeList[0]['home_name'];
      home_number = homeList[0]['home_number'];
      soi = homeList[0]['soi'];
      parish = homeList[0]['parish'];
      district = homeList[0]['district'];
      province = homeList[0]['province'];
      zip_code = homeList[0]['zip_code'];
    }
    print(homeList);
  }

  @override
  void initState() {
    get_home();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
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
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'รายละเอียดที่อยู่',
                          style: GoogleFonts.redHatText(
                            textStyle: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 40),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  "ชื่อบ้าน",
                                  style: textstyle,
                                ),
                              ),
                              Text(
                                "$home_name",
                                style: textstyle,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  "บ้านเลขที่",
                                  style: textstyle,
                                ),
                              ),
                              Text(
                                "$home_number",
                                style: textstyle,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ซอย",
                                style: textstyle,
                              ),
                              Text(
                                "$soi",
                                style: textstyle,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ตำบล / แขวง",
                                style: textstyle,
                              ),
                              Text(
                                "$parish",
                                style: textstyle,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "อำเภอ / เขต",
                                style: textstyle,
                              ),
                              Text(
                                "$district",
                                style: textstyle,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "จังหวัด",
                                style: textstyle,
                              ),
                              Text(
                                "$province",
                                style: textstyle,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  "รหัสไปรษณีย์",
                                  style: textstyle,
                                ),
                              ),
                              Text(
                                "$zip_code",
                                style: textstyle,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.teal[100],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: Colors.black54,
                          offset: Offset(2, 5),
                        )
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return EditHomeScreen(
                            home_id: home_id,
                          );
                        }));
                      },
                      child: Text(
                        "แก้ไข",
                        style: GoogleFonts.redHatText(
                          textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

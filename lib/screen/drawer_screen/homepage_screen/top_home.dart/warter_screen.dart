// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, non_constant_identifier_names, avoid_print, unnecessary_string_interpolations
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthomeapp/ipcon.dart';
import 'package:http/http.dart' as http;

class WarterScreen extends StatefulWidget {
  WarterScreen({Key? key}) : super(key: key);

  @override
  State<WarterScreen> createState() => _WarterScreenState();
}

class _WarterScreenState extends State<WarterScreen> {
  List waterList = [];
  String? home_id;
  String? unit;
  double? bath;
  double? vat;
  double? result;
  String? month;
  String? unit_last;
  get_water() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      home_id = preferences.getString("home_id");
    });
    final response = await http
        .get(Uri.parse("$ipcon/water/get_water.php?home_id=$home_id"));
    var data = json.decode(response.body);
    if (data != null) {
      setState(() {
        waterList = data;
      });
      unit_last = waterList[0]['water_unit'];
      print(waterList);
    }
  }

  @override
  void initState() {
    get_water();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ค่าน้ำทั้งหมด",
                        style: GoogleFonts.redHatText(
                          textStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        iconSize: 30,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                CircleAvatar(
                  radius: 140,
                  backgroundColor: Color(0xff2b2e2d),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "เดือนล่าสุด",
                          style: GoogleFonts.redHatText(
                            textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      unit_last == null
                          ? Text(
                              "0",
                              style: GoogleFonts.redHatText(
                                textStyle: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )
                          : Text(
                              "$unit_last",
                              style: GoogleFonts.redHatText(
                                textStyle: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                      Text(
                        "_ _ _ _ _ _",
                        style: GoogleFonts.redHatText(
                          textStyle: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "หน่วย",
                        style: GoogleFonts.redHatText(
                          textStyle: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "รวมค่าน้ำต่อเดือน",
                      style: GoogleFonts.redHatText(
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Text(
                      "จำนวน (บาท)",
                      style: GoogleFonts.redHatText(
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: waterList.length,
                    itemBuilder: (BuildContext context, int index) {
                      month = waterList[index]['water_month'];
                      unit = waterList[index]['water_unit'];
                      bath = (double.parse(unit.toString()) * 16);
                      vat = (bath! * 0.07);
                      result = (bath! + vat!);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.23,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 3,
                                  offset: Offset(3, 6),
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      "$month",
                                      style: GoogleFonts.redHatText(
                                        textStyle: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "ค่าน้ำ",
                                      style: GoogleFonts.redHatText(
                                        textStyle: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    bath == null
                                        ? Text(
                                            "0",
                                            style: GoogleFonts.redHatText(
                                              textStyle: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          )
                                        : Text(
                                            "$bath",
                                            style: GoogleFonts.redHatText(
                                              textStyle: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "ภาษีมูลค่าเพิ่ม",
                                      style: GoogleFonts.redHatText(
                                        textStyle: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    vat == null
                                        ? Text(
                                            "0",
                                            style: GoogleFonts.redHatText(
                                              textStyle: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          )
                                        : Text(
                                            "${vat!.toStringAsFixed(2)} ",
                                            style: GoogleFonts.redHatText(
                                              textStyle: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "รวม",
                                      style: GoogleFonts.redHatText(
                                        textStyle: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    result == null
                                        ? Text(
                                            "0",
                                            style: GoogleFonts.redHatText(
                                              textStyle: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          )
                                        : Text(
                                            "${result!.toStringAsFixed(2)}",
                                            style: GoogleFonts.redHatText(
                                              textStyle: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                  ],
                                ),
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
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, non_constant_identifier_names, avoid_print, unnecessary_string_interpolations
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthomeapp/ipcon.dart';
import 'package:http/http.dart' as http;

class ElecScreen extends StatefulWidget {
  ElecScreen({Key? key}) : super(key: key);

  @override
  State<ElecScreen> createState() => _ElecScreenState();
}

class _ElecScreenState extends State<ElecScreen> {
  String? select;
  List<String> month_items = [
    'มกราคม',
    'กุมภาพันธุ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฏาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม'
  ];
  String? home_id;
  List elecList = [];
  List monthList = [];
  String? unit;
  String? unit_select;
  double? bath;
  double? bath_select;
  double? vat;
  double? vat_select;
  double? result;
  double? result_select;
  String? month;
  String? month_select;

  select_month(select) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      home_id = preferences.getString("home_id");
    });
    final response = await http.get(Uri.parse(
        "$ipcon/month/get_month_elec.php?elec_month=$select&home_id=$home_id"));
    var data = json.decode(response.body);
    if (data != null) {
      setState(() {
        monthList = data;
      });
      month_select = monthList[0]['elec_month'];
      unit_select = monthList[0]['elec_unit'];
      bath_select = (double.parse(unit_select.toString()) * 4);
      vat_select = (bath_select! * 0.07);
      result_select = (bath_select! + vat_select!);
    } else {
      setState(() {
        monthList = [];
      });
    }
  }

  get_electic() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      home_id = preferences.getString("home_id");
    });
    final response = await http
        .get(Uri.parse("$ipcon/electic/get_electic.php?home_id=$home_id"));
    var data = json.decode(response.body);
    if (data != null) {
      setState(() {
        elecList = data;
      });
      unit = elecList[0]['elec_unit'];
      month = elecList[0]['elec_month'];
      unit = elecList[0]['elec_unit'];
      bath = (double.parse(unit.toString()) * 4);
      vat = (bath! * 0.07);
      result = (bath! + vat!);
    }
  }

  @override
  void initState() {
    get_electic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                          vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ค่าไฟทั้งหมด",
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
                          Text(
                            "เดือนล่าสุด",
                            style: GoogleFonts.redHatText(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          unit == null
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
                                  "$unit",
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "รวมค่าไฟต่อเดือน",
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.26,
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "เดือน",
                                    style: GoogleFonts.redHatText(
                                      textStyle: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
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
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "หน่วยพลังงาน",
                                    style: GoogleFonts.redHatText(
                                      textStyle: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  unit == null
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
                                          "$unit",
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
                                    "ค่าพลังงานไฟฟ้า",
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ดูเดือนอื่น',
                            style: GoogleFonts.redHatText(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  iconSize: 50,
                                  borderRadius: BorderRadius.circular(20),
                                  value: select,
                                  items: month_items.map((e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: SizedBox(
                                          width: 100,
                                          child: Text(
                                            e,
                                            style: GoogleFonts.redHatText(
                                              textStyle: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          )),
                                    );
                                  }).toList(),
                                  onChanged: (v) {
                                    setState(() {
                                      select = v.toString();
                                    });
                                    //  print(select);
                                    select_month(select);
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    monthList.isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.26,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          "$month_select",
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
                                          "หน่วยพลังงาน",
                                          style: GoogleFonts.redHatText(
                                            textStyle: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        unit_select == null
                                            ? Text(
                                                "0",
                                                style: GoogleFonts.redHatText(
                                                  textStyle: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              )
                                            : Text(
                                                "$unit_select",
                                                style: GoogleFonts.redHatText(
                                                  textStyle: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                          "ค่าพลังงานไฟฟ้า",
                                          style: GoogleFonts.redHatText(
                                            textStyle: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        bath_select == null
                                            ? Text(
                                                "0",
                                                style: GoogleFonts.redHatText(
                                                  textStyle: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              )
                                            : Text(
                                                "$bath_select",
                                                style: GoogleFonts.redHatText(
                                                  textStyle: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                        vat_select == null
                                            ? Text(
                                                "0",
                                                style: GoogleFonts.redHatText(
                                                  textStyle: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              )
                                            : Text(
                                                "${vat_select!.toStringAsFixed(2)} ",
                                                style: GoogleFonts.redHatText(
                                                  textStyle: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                        result_select == null
                                            ? Text(
                                                "0",
                                                style: GoogleFonts.redHatText(
                                                  textStyle: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              )
                                            : Text(
                                                "${result_select!.toStringAsFixed(2)}",
                                                style: GoogleFonts.redHatText(
                                                  textStyle: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

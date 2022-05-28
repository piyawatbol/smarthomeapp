// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, non_constant_identifier_names, avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthomeapp/ipcon.dart';

class GasScreen extends StatefulWidget {
  GasScreen({Key? key}) : super(key: key);

  @override
  State<GasScreen> createState() => _GasScreenState();
}

class _GasScreenState extends State<GasScreen> {
  String? home_id;
  List gasList = [];
  String? unit;
  get_gas() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      home_id = preferences.getString("home_id");
    });
    final response =
        await http.get(Uri.parse("$ipcon/gas/get_gas.php?home_id=$home_id"));
    var data = json.decode(response.body);
    if (data != null) {
      setState(() {
        gasList = data;
      });
      unit = gasList[0]['gas_unit'];
      print(gasList);
    }
  }

  @override
  void initState() {
    get_gas();
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
                      "ค่าแก๊ส",
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
                    SizedBox(height: 10),
                    Text(
                      "ppm",
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
            ],
          ),
        ),
      ),
    );
  }
}

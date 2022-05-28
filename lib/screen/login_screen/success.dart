// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarthomeapp/screen/login_screen/login_page.dart';


class SuccessPage extends StatefulWidget {
  SuccessPage({Key? key}) : super(key: key);

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Center(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 170,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "ดำเนินการเรียบร้อย",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 120,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return LoginPage();
                    }));
                  },
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 2,
                          offset: Offset(3, 5), // Shadow position
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.teal, Colors.pink],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 35, top: 5),
                      child: Text(
                        "ตกลง",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

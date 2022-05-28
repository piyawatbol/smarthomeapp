// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'แจ้งเตือน',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: 350,
                  height: 115,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3,
                            color: Colors.black54,
                            offset: Offset(2, 5))
                      ]),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 20,
                        top: 38,
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/exclamation.png'),
                          radius: 20,
                        ),
                      ),
                      Positioned(
                        left: 69,
                        top: 19,
                        child: Container(
                          width: 200,
                          height: 70,
                          //color: Colors.red,
                          child: ListTile(
                            title: Text(
                              "น้ำ",
                              style: GoogleFonts.redHatText(
                                textStyle: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Text(
                              "คุณลืมปิดน้ำ กรุณาปิดน้ำ",
                              style: GoogleFonts.redHatText(
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        bottom: 10,
                        child: Container(
                          height: 30,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.teal[50],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "ปิด",
                                style: GoogleFonts.redHatText(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

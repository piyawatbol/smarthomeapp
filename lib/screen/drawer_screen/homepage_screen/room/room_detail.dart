// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers, must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, avoid_print, unused_local_variable, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_brace_in_string_interps, prefer_if_null_operators
// ignore_forfile: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthomeapp/ipcon.dart';
import 'package:smarthomeapp/screen/drawer_screen/homepage_screen/homepage.dart';

class RoomDetail extends StatefulWidget {
  String? room_id;

  RoomDetail({required this.room_id});

  @override
  State<RoomDetail> createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
  String? name;
  List dataList = [];
  String? room_name_edit;
  List eqList = [];
  String? home_id;
  String? room_id;
  TextEditingController? room_name;
  bool off_all = false;
  String? eq_status;
  String? eq_id;
  List swList = [];
  String? sw_all;

  get_room_eq() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      home_id = preferences.getString('home_id');
    });
    final response = await http.get(Uri.parse(
        "$ipcon/equipment/get_room_eq.php?room_id=${widget.room_id}&home_id=$home_id"));
    var data = json.decode(response.body);
    if (data != null) {
      setState(() {
        eqList = data;
      });
    }
  }

  get_data() async {
    final response = await http.get(
        Uri.parse("$ipcon/room/get_detail_room.php?room_id=${widget.room_id}"));
    var data = json.decode(response.body);
    setState(() {
      dataList = data;
    });
    room_id = dataList[0]['room_id'];
    room_name_edit = dataList[0]['room_name'];
  }

  setTextController() async {
    await get_data();
    room_name = TextEditingController(text: '$room_name_edit');
  }

  Future edit_room() async {
    final uri = Uri.parse("$ipcon/room/edit_room.php");
    var request = http.MultipartRequest('POST', uri);

    request.fields['room_id'] = widget.room_id.toString();
    request.fields['room_name'] = room_name!.text;
    var response = await request.send();
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "บันทึกเสร็จสิ้น",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return RoomDetail(room_id: widget.room_id);
      }));
    }
  }

  edit_status(eq_status, eq_id) async {
    final uri = Uri.parse("$ipcon/equipment/edit_switch_room.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['room_eq_id'] = eq_id.toString();
    request.fields['eq_status'] = eq_status.toString();
    var response = await request.send();
  }

  close_switch_all() async {
    final uri = Uri.parse("$ipcon/equipment/close_switch_all.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['room_id'] = widget.room_id.toString();
    var response = await request.send();
  }

  get_all_switch() async {
    final response = await http.get(Uri.parse(
        "$ipcon/equipment/get_switch_all.php?room_id=${widget.room_id}"));
    var data = json.decode(response.body);

    setState(() {
      swList = data;
    });
    sw_all = swList[0]['Sum(eq_status)'];
    print(sw_all);
    if (sw_all == '0') {
      off_all = true;
    } else {
      off_all = false;
    }
  }

  @override
  void initState() {
    setTextController();
    get_room_eq();
    get_all_switch();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return HomePage();
                            }));
                          },
                          child: Image.asset('assets/images/arrow-left 1.png'),
                        ),
                        Text(
                          "${room_name_edit}",
                          style: GoogleFonts.redHatText(
                            textStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            openDialog();
                          },
                          icon: Icon(Icons.edit),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: Container(
                        width: 360,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              color: Colors.black38,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "ปิด อุปกรณ์ทั้งหมด",
                              style: GoogleFonts.redHatText(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            FlutterSwitch(
                              activeColor: Colors.green,
                              inactiveColor: Colors.red,
                              activeTextColor: Colors.black,
                              inactiveTextColor: Colors.black,
                              width: 60.0,
                              height: 28.0,
                              valueFontSize: 18.0,
                              toggleSize: 22.0,
                              value: off_all,
                              borderRadius: 20.0,
                              onToggle: (val) {
                                if (val == true) {
                                  close_switch_all();
                                }
                                setState(() {
                                  off_all = val;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Divider(
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Text(
                          "อุปกรณ์ในห้อง",
                          style: GoogleFonts.redHatText(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: eqList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 50),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 1,
                                        color: Colors.black38,
                                        offset: Offset(4, 5),
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.network(
                                        "$ipcon/images/${eqList[index]['img']}"),
                                    FlutterSwitch(
                                      activeColor: Colors.green,
                                      inactiveColor: Colors.red,
                                      activeTextColor: Colors.black,
                                      inactiveTextColor: Colors.black,
                                      width: 60.0,
                                      height: 28.0,
                                      valueFontSize: 18.0,
                                      toggleSize: 22.0,
                                      value: off_all == false
                                          ? eqList[index]['eq_status'] != '0'
                                              ? true
                                              : false
                                          : false,
                                      borderRadius: 20.0,
                                      onToggle: (val) {
                                        setState(() {
                                          off_all = false;
                                        });
                                        if (off_all == false) {
                                          if (val == false) {
                                            setState(() {
                                              eqList[index]['eq_status'] = '0';
                                            });
                                          } else {
                                            setState(() {
                                              eqList[index]['eq_status'] = '1';
                                            });
                                          }
                                          eq_id = eqList[index]['room_eq_id'];
                                          eq_status =
                                              eqList[index]['eq_status'];
                                          edit_status(eq_status, eq_id);
                                        }
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )));
  }

  Future<String?> openDialog() => showDialog<String?>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("แก้ไขชื่อห้อง"),
          content: TextField(
            autofocus: true,
            controller: room_name,
            decoration: InputDecoration(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                edit_room();
              },
              child: Text(
                "บันทึก",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "ยกเลิก",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      );
}

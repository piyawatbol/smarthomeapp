// ignore_for_file: prefer_const_constructors_in_immutables, non_constant_identifier_names, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unrelated_type_equality_checks, unnecessary_null_comparison
// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthomeapp/screen/drawer_screen/setting_screen/room_setting/edit_room.dart';

import '../../../../ipcon.dart';
import 'insertroom.dart';

class RoomPage extends StatefulWidget {
  RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  String? room_id;
  List roomList = [];
  String? home_id;
  get_data_room() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      home_id = preferences.getString('home_id');
    });
    final response = await http
        .get(Uri.parse("$ipcon/room/get_data_room.php?home_id=$home_id"));
    var data = json.decode(response.body);
    if (data == null) {
    } else {
      setState(() {
        roomList = data;
      });
    }
    print(roomList);
  }

  delete_room(room_id) async {
    var url = Uri.parse("$ipcon/room/delete_room.php");
    var response = await http.post(url, body: {
      "room_id": room_id.toString(),
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "ลบเสร็จสิ้น",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return RoomPage();
      }));
    }
  }

  @override
  void initState() {
    get_data_room();
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
            ])),
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
                      'รายการห้อง',
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
              SizedBox(height: 50),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3,
                          color: Colors.black54,
                          offset: Offset(2, 5))
                    ]),
                child: roomList == null || roomList == ''
                    ? Container()
                    : ListView.builder(
                        itemCount: roomList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(1),
                            child: ListTile(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return EditRoom(
                                      room_id: roomList[index]['room_id'],
                                    );
                                  }));
                                },
                                trailing: GestureDetector(
                                    onTap: () {
                                      room_id = roomList[index]['room_id'];
                                      openDialog();
                                    },
                                    child: Icon(Icons.delete)),
                                title: Text(
                                  '${roomList[index]['room_name']}',
                                  style: TextStyle(fontSize: 20),
                                )),
                          );
                        },
                      ),
              ),
              SizedBox(
                height: 40,
              ),
              MyDevider(),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      color: Colors.black54,
                      offset: Offset(2, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InsertRoomPage()));
                      },
                      child: Text(
                        "เพิ่มห้อง",
                        style: GoogleFonts.redHatText(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> openDialog() => showDialog<String?>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("คุณต้องการที่จะลบห้องหรือไม่"),
          actions: [
            TextButton(
              onPressed: () {
                delete_room(room_id);
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
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          ],
        ),
      );
}

Widget ContactItem(String name, bool isSelected, int index) {
  return ListTile(
    title: Text(
      name,
      style: GoogleFonts.redHatText(
        textStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ),
    trailing: isSelected
        ? Icon(Icons.check_circle, color: Colors.teal)
        : Icon(
            Icons.check_circle_outline,
            color: Colors.grey,
          ),
  );
}

Widget MyDevider() {
  return const Divider(
    //height: 10,
    thickness: 3,
    indent: 20,
    endIndent: 20,
    color: Colors.black,
  );
}

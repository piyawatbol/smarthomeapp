// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, unnecessary_brace_in_string_interps, non_constant_identifier_names, avoid_print, duplicate_ignore, depend_on_referenced_packages, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarthomeapp/ipcon.dart';
import 'package:smarthomeapp/screen/login_screen/success.dart';
import 'package:http/http.dart' as http;

class RegisPage extends StatefulWidget {
  RegisPage({Key? key}) : super(key: key);

  @override
  State<RegisPage> createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  Future register() async {
    var url = Uri.parse("${ipcon}/login/register.php");
    var response = await http.post(url, body: {
      "name": name.text,
      "phone": phone.text,
      "email": email.text,
      "username": username.text,
      "password": password.text,
    });
    var data = json.decode(response.body);
    print(data.toString());
    if (data == 'duplicate_username') {
      Fluttertoast.showToast(
          msg: "ชื่อผู้ใช้นี้ได้ถูกใช้ไปแล้ว",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (data == 'duplicate_email') {
      Fluttertoast.showToast(
          msg: "email นี้ถูกใช้ไปแล้ว",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (data == 'duplicate_phone') {
      Fluttertoast.showToast(
          msg: "เบอร์โทรศัพท์ นี้ถูกใช้ไปแล้ว",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (data == 'succes') {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return SuccessPage();
      }));
    }
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70, bottom: 20),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'ลงทะเบียนผู้ใช้งาน',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                      child: TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          labelText: 'ชื่อ-สกุล',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                      child: TextFormField(
                        controller: phone,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          labelText: 'เบอร์โทรศัพท์',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          labelText: 'อีเมล์',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ('กรุณากรอกชื่อผู้ใช้งาน');
                          }
                          return null;
                        },
                        controller: username,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          labelText: 'ชื่อผู้ใช้งาน',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ('กรุณากรอกชื่อผู้ใช้งาน');
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: password,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          labelText: 'รหัสผ่าน',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // print(name.text);
                      // print(phone.text);
                      // print(email.text);
                      // print(username.text);
                      // print(password.text);
                      register();
                    },
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 2,
                            offset: Offset(3, 5),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.teal,
                            Colors.pink,
                          ],
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
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 3,
                            offset: Offset(2, 5),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.teal.shade200,
                            Colors.pink.shade200,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 21, top: 5),
                        child: Text(
                          "ย้อนกลับ",
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
            ],
          ),
        ),
      ),
    );
  }
}

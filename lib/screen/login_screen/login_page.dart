// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_print, non_constant_identifier_names, unnecessary_brace_in_string_interps, depend_on_referenced_packages, sort_child_properties_last
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthomeapp/forgot/forgotpassword.dart';
import 'package:smarthomeapp/screen/login_screen/regis_screen.dart';
import 'package:smarthomeapp/screen/login_screen/select_home_screen.dart';

import '../../ipcon.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  Future login() async {
    var url = Uri.parse('${ipcon}/login/login.php');
    var response = await http.post(url, body: {
      "username": username.text,
      "password": password.text,
    });
    var data = json.decode(response.body);
    if (data == "miss") {
      Fluttertoast.showToast(
          msg: "ชื่อผู้ใช้ หรือ รหัสผ่านไม่ถูกต้อง",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('user_id', data[0]['user_id']);
      
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return 
        
        SelectHomeScreen();
      }));
    }
  }

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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/mart.png',
                  width: 250,
                  height: 250,
                ),
              ),
              Center(
                child: Text(
                  'Smart Home',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                ),
              ),
              SizedBox(height: 15),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: username,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ('กรุณากรอกชื่อผู้ใช้');
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
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
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ('กรุณากรอกรหัสผ่าน');
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
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
              Padding(
                padding: const EdgeInsets.only(left: 260),
                child: TextButton(
                  onPressed: () {
                    //forgot password screen
                    Navigator.push(
                        context,
                        (MaterialPageRoute(
                            builder: (context) => ForgotPage())));
                  },
                  child: const Text(
                    'ลืมรหัสผ่าน',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      final isValid = formKey.currentState!.validate();
                      if (isValid) {
                        login();
                      }
                    },
                    child: Container(
                      width: 190,
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
                          colors: [Colors.teal.shade400, Colors.pink.shade400],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 55, top: 5),
                        child: Text(
                          "เข้าสู่ระบบ",
                          style: GoogleFonts.redHatText(
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
                ],
              ),
              Row(
                children: <Widget>[
                  const Text(
                    'คุณยังไม่มีบัญชีผู้ใช้งาน?',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                    child: const Text(
                      'สมัครสมาชิก',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                    onPressed: () {
                      //signup screen
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RegisPage()));
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

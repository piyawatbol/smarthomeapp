// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, unused_import, non_constant_identifier_names, avoid_print, unnecessary_brace_in_string_interps, depend_on_referenced_packages, sized_box_for_whitespace, use_build_context_synchronously, unused_field
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:smarthomeapp/ipcon.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  TextEditingController? name;
  TextEditingController? phone;
  TextEditingController? email;
  String? user_id;
  List dataList = [];
  String? name_user;
  String? phone_user;
  String? email_user;
  String? img_user;

  get_user_id() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    print(user_id);
    get_data_user();
  }

  get_data_user() async {
    final response = await http
        .get(Uri.parse("$ipcon/login/get_data_user.php?user_id=$user_id"));
    var data = json.decode(response.body);
    print("data : ${data}");
    setState(() {
      dataList = data;
      name_user = dataList[0]['name'];
      phone_user = dataList[0]['phone'];
      email_user = dataList[0]['email'];
      img_user = dataList[0]['img'];
    });
  }

  setTextController() async {
    await get_user_id();
    await get_data_user();
    name = TextEditingController(text: '${name_user}');
    phone = TextEditingController(text: '${phone_user}');
    email = TextEditingController(text: '${email_user}');
  }

  Future edit_user() async {
    final uri = Uri.parse("${ipcon}/login/edit_user.php");
    var request = http.MultipartRequest('POST', uri);
    if (_image != null) {
      var img = await http.MultipartFile.fromPath("img", _image!.path);
      request.files.add(img);
    }
    request.fields['user_id'] = user_id.toString();
    request.fields['name'] = name!.text;
    request.fields['phone'] = phone!.text;
    request.fields['email'] = email!.text;

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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ProfilePage();
      }));
      Navigator.pop(context);
    }
  }

  get_image(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ),
    );
    if (image != null) {
      setState(() {
        _image = File(image!.path);
      });
    } else {
      _image = File('');
    }
  }

  @override
  void initState() {
    setTextController();
    super.initState();
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
                        "ข้อมูลส่วนตัว",
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
                Stack(
                  children: [
                    _image == null
                        ? img_user == null || img_user == ''
                            ? CircleAvatar(
                                radius: 110,
                                backgroundColor: Colors.grey,
                                backgroundImage: AssetImage(
                                    "assets/images/profile_empty.jpg"),
                              )
                            : CircleAvatar(
                                radius: 110,
                                backgroundColor: Colors.blue,
                                backgroundImage:
                                    NetworkImage('$ipcon/images/$img_user'),
                              )
                        : CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 110,
                            backgroundImage: FileImage(_image!),
                          ),
                    Positioned(
                      right: 20,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {
                          get_image(ImgSource.Gallery);
                        },
                        child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.edit,
                              size: 25,
                            )),
                      ),
                    )
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 70,
                            child: Text(
                              "ชื่อผู้ใช้",
                              style: GoogleFonts.redHatText(
                                textStyle: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '$name_user',
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 20),
                              ),
                              IconButton(
                                onPressed: () {
                                  openDialog1();
                                },
                                icon: Icon(Icons.edit),
                              )
                            ],
                          )
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              "เบอร์โทรศัพท์",
                              style: GoogleFonts.redHatText(
                                textStyle: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '$phone_user',
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 20),
                              ),
                              IconButton(
                                onPressed: () {
                                  openDialog2();
                                },
                                icon: Icon(
                                  Icons.edit,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "E-mail",
                            style: GoogleFonts.redHatText(
                              textStyle: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '$email_user',
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 20),
                              ),
                              IconButton(
                                onPressed: () {
                                  openDialog3();
                                },
                                icon: Icon(
                                  Icons.edit,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
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
                          offset: Offset(2, 5))
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      edit_user();
                    },
                    child: Text(
                      "บันทึก",
                      style: GoogleFonts.redHatText(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> openDialog1() => showDialog<String?>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("แก้ไขชื่อผู้ใช้"),
          content: TextField(
            controller: name,
          ),
          actions: [
            TextButton(
              onPressed: () {
                edit_user();
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
  Future<String?> openDialog2() => showDialog<String?>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("แก้ไขชื่อผู้ใช้"),
          content: TextField(
            controller: phone,
          ),
          actions: [
            TextButton(
              onPressed: () {
                edit_user();
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
  Future<String?> openDialog3() => showDialog<String?>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("แก้ไขชื่อผู้ใช้"),
          content: TextField(
            controller: email,
          ),
          actions: [
            TextButton(
              onPressed: () {
                edit_user();
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

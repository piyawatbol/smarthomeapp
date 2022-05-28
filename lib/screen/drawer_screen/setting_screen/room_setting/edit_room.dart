// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:smarthomeapp/ipcon.dart';

import 'room.dart';

class EditRoom extends StatefulWidget {
  String? room_id;
  EditRoom({Key? key, required this.room_id}) : super(key: key);

  @override
  State<EditRoom> createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  TextEditingController? room_name;
  final formKey = GlobalKey<FormState>();
  File? _image;
  List roomList = [];
  String? img;
  String? room_name_edit;

  get_data_room() async {
    final response = await http.get(
        Uri.parse("$ipcon/room/get_detail_room.php?room_id=${widget.room_id}"));
    var data = json.decode(response.body);
    setState(() {
      roomList = data;
     
    });
     room_name_edit = roomList[0]['room_name'];
      img = roomList[0]['img'];
    
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

  Future edit_room() async {
    final uri = Uri.parse("$ipcon/room/edit_room.php");
    var request = http.MultipartRequest('POST', uri);
    if (_image != null) {
      var img = await http.MultipartFile.fromPath("img", _image!.path);
      request.files.add(img);
    }
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
        return RoomPage();
      }));
    }
  }

  setTextController() async {
    await get_data_room();
    room_name = TextEditingController(text: '$room_name_edit');
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
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      GestureDetector(
                        child: Image.asset('assets/images/arrow-left 1.png'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "แก้ไขห้อง",
                      style: GoogleFonts.redHatText(
                        textStyle: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 50),
                    Stack(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    barrierColor: Colors.black26,
                                    context: this.context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30),
                                      ),
                                    ),
                                    builder: (context) {
                                      return showmodal();
                                    });
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: _image == null
                                      ? img == null || img == ''
                                          ? Center(child: Text('...'))
                                          : Image(
                                              image: NetworkImage(
                                                  '$ipcon/images/$img'),
                                              fit: BoxFit.cover,
                                            )
                                      : Image(
                                          image: FileImage(_image!),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ('กรุณากรอกชื่อห้อง');
                            }
                            return null;
                          },
                          controller: room_name,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                            labelText: 'ชื่อห้อง',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
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
                          final isValid = formKey.currentState!.validate();
                          if (isValid) {
                            edit_room();
                          }
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  showmodal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    blurRadius: 2, color: Colors.black26, offset: Offset(2, 5))
              ],
            ),
            child: Center(
                child: GestureDetector(
                    onTap: () {
                      get_image(ImgSource.Gallery);
                      Navigator.pop(context);
                    },
                    child: img == null
                        ? Text(
                            "เพิ่มรูปภาพ",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        : Text('แก้ไขรูปภาพ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)))),
          )
        ],
      ),
    );
  }
}

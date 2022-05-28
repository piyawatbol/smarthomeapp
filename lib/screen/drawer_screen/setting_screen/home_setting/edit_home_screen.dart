// ignore_for_file: prefer_const_constructors_in_immutables, non_constant_identifier_names, unused_local_variable, must_be_immutable, prefer_const_constructors, avoid_print, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarthomeapp/ipcon.dart';
import 'package:http/http.dart' as http;
import 'package:smarthomeapp/screen/drawer_screen/setting_screen/home_setting/managehome.dart';

class EditHomeScreen extends StatefulWidget {
  String? home_id;

  EditHomeScreen({Key? key, required this.home_id}) : super(key: key);

  @override
  State<EditHomeScreen> createState() => _EditHomeScreenState();
}

class _EditHomeScreenState extends State<EditHomeScreen> {
  final inputstyle = InputDecoration(
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2.0),
    ),
    labelStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
    ),
  );
  final textstyle = TextStyle(
    fontSize: 22,
  );

  List homeList = [];
  TextEditingController? home_name;
  TextEditingController? home_num;
  TextEditingController? soi;
  TextEditingController? parish;
  TextEditingController? district;
  TextEditingController? province;
  TextEditingController? zip_code;
  String? home_num_edit;
  String? home_name_edit;
  String? soi_edit;
  String? parish_edit;
  String? district_edit;
  String? province_edit;
  String? zip_code_edit;

  get_home_edit() async {
    final response = await http.get(
        Uri.parse("$ipcon/home/get_home_edit.php?home_id=${widget.home_id}"));
    var data = json.decode(response.body);
    setState(() {
      homeList = data;
    });
    home_name_edit = homeList[0]['home_name'];
    home_num_edit = homeList[0]['home_number'];
    soi_edit = homeList[0]['soi'];
    parish_edit = homeList[0]['parish'];
    district_edit = homeList[0]['district'];
    province_edit = homeList[0]['province'];
    zip_code_edit = homeList[0]['zip_code'];
  }

  setTextController() async {
    await get_home_edit();
    home_name = TextEditingController(text: "$home_name_edit");
    home_num = TextEditingController(text: "$home_num_edit");
    soi = TextEditingController(text: "$soi_edit");
    parish = TextEditingController(text: "$parish_edit");
    district = TextEditingController(text: "$district_edit");
    province = TextEditingController(text: "$province_edit");
    zip_code = TextEditingController(text: "$zip_code_edit");
  }

  edit_home() async {
    final uri = Uri.parse("$ipcon/home/edit_home.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['home_id'] = widget.home_id.toString();
    request.fields['home_name'] = home_name!.text;
    request.fields['home_number'] = home_num!.text;
    request.fields['soi'] = soi!.text;
    request.fields['parish'] = parish!.text;
    request.fields['district'] = district!.text;
    request.fields['province'] = province!.text;
    request.fields['zip_code'] = zip_code!.text;

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
        return ManageHomePage();
      }));
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
        child: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        "แก้ไขรายระเอียดที่อยู่",
                        style: GoogleFonts.redHatText(
                          textStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 50),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ชื่อบ้าน",
                                style: textstyle,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                    controller: home_name,
                                    decoration: inputstyle),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  "บ้านเลขที่",
                                  style: textstyle,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                    controller: home_num,
                                    decoration: inputstyle),
                              ),
                              Text(
                                "ซอย",
                                style: textstyle,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                    controller: soi, decoration: inputstyle),
                              ),
                              Text(
                                "ตำบล / แขวง",
                                style: textstyle,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                    controller: parish, decoration: inputstyle),
                              ),
                              Text(
                                "อำเภอ / เขต",
                                style: textstyle,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                    controller: district,
                                    decoration: inputstyle),
                              ),
                              Text(
                                "จังหวัด",
                                style: textstyle,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                    controller: province,
                                    decoration: inputstyle),
                              ),
                              SizedBox(
                                width: 150,
                                child: Text(
                                  "รหัสไปรษณีย์",
                                  style: textstyle,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                    controller: zip_code,
                                    decoration: inputstyle),
                              ),
                              SizedBox(height: 50),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                          offset: Offset(2, 5),
                                        )
                                      ],
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        edit_home();
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/images/arrow-left 1.png'),
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

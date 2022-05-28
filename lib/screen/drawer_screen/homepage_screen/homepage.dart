// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, unused_import, sized_box_for_whitespace, avoid_print, import_of_legacy_library_into_null_safe, unused_local_variable, non_constant_identifier_names, unnecessary_brace_in_string_interps, depend_on_referenced_packages, unrelated_type_equality_checks,  unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthomeapp/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:smarthomeapp/screen/drawer_screen/drawer.dart';
import 'package:smarthomeapp/screen/drawer_screen/homepage_screen/top_home.dart/electic_screen.dart';
import 'package:smarthomeapp/screen/drawer_screen/homepage_screen/top_home.dart/gas_screen.dart';
import 'package:smarthomeapp/screen/drawer_screen/homepage_screen/room/room_detail.dart';
import 'package:smarthomeapp/screen/drawer_screen/homepage_screen/top_home.dart/warter_screen.dart';
import '../../../ipcon.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List home_climateList = [];
  List roomList = [];
  List eqList = [];
  String? temp;
  String? humi;
  String? pm_25;
  String? user_id;
  String? eq_name;
  String? home_id;
  String? eq_status;
  String? home_eq_id;
  String? eq_id;
  get_eq() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      home_id = preferences.getString('home_id');
    });
    final response = await http
        .get(Uri.parse("$ipcon/equipment/get_home_eq.php?home_id=$home_id"));
    var eq = json.decode(response.body);
    if (eq != null) {
      setState(() {
        eqList = eq;
      });
    }
  }

  get_data_room() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      home_id = preferences.getString('home_id');
    });
    final response = await http
        .get(Uri.parse("$ipcon/room/get_data_room.php?home_id=$home_id"));
    var data = json.decode(response.body);
    if (data != null) {
      setState(() {
        roomList = data;
      });
    }
  }

  get_home_climate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      home_id = preferences.getString("home_id");
    });
    final response = await http.get(
        Uri.parse("$ipcon/home_climate/get_home_climate.php?home_id=$home_id"));
    var data = json.decode(response.body);
    setState(() {
      home_climateList = data;
    });
    temp = home_climateList[0]['temp'];
    humi = home_climateList[0]['humi'];
    pm_25 = home_climateList[0]['pm_25'];
  }

  Future refresh() async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return HomePage();
    }));
  }

  edit_status(eq_status, eq_id) async {
    final uri = Uri.parse("$ipcon/equipment/edit_switch_home.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['home_eq_id'] = eq_id.toString();
    request.fields['eq_status'] = eq_status.toString();
    var response = await request.send();
  }

  @override
  void initState() {
    get_data_room();
    get_home_climate();
    get_eq();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        drawer: NavigationDrawer(),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
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
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 24),
                        Text(
                          'Smart Home',
                          style: TextStyle(color: Colors.black, fontSize: 26),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              SizedBox(width: 18),
                              Text(
                                "สภาพอากาศในบ้าน",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                height: 142.0,
                                width: 112.0,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.teal,
                                      blurRadius: 4,
                                      offset: Offset(2, 5),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Image.asset(
                                            'assets/images/celsius_1.png'),
                                      ),
                                      temp == null
                                          ? Text(" ... ")
                                          : Text(
                                              '$temp °c',
                                              style: GoogleFonts.redHatText(
                                                textStyle: TextStyle(
                                                  fontSize: 26,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                      Text(
                                        "temperature",
                                        style: GoogleFonts.redHatText(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Container(
                              height: 142.0,
                              width: 112.0,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.teal,
                                      blurRadius: 4,
                                      offset: Offset(2, 5),
                                    ),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Image.asset(
                                            'assets/images/humidity 1.png'),
                                      ),
                                      humi == null
                                          ? Text(" ... ")
                                          : Text(
                                              '$humi',
                                              style: GoogleFonts.redHatText(
                                                  textStyle: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black)),
                                            ),
                                      Text(
                                        "humidity",
                                        style: GoogleFonts.redHatText(
                                            textStyle: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black)),
                                      ),
                                    ]),
                              ),
                            ),
                            Container(
                              height: 142.0,
                              width: 112.0,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.teal,
                                      blurRadius: 4,
                                      offset: Offset(2, 5),
                                    ),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Image.asset(
                                            'assets/images/air-pollution 1.png'),
                                      ),
                                      pm_25 == null
                                          ? Text(" ... ")
                                          : Text(
                                              '$pm_25',
                                              style: GoogleFonts.redHatText(
                                                  textStyle: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black)),
                                            ),
                                      Text(
                                        "pm 2.5",
                                        style: GoogleFonts.redHatText(
                                            textStyle: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black)),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ElecScreen()));
                              },
                              child: Container(
                                height: 112.0,
                                width: 112.0,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.teal,
                                        blurRadius: 4,
                                        offset: Offset(2, 5),
                                      ),
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Image.asset(
                                            'assets/images/electrical 1.png'),
                                      ),
                                      Text(
                                        "ไฟฟ้า",
                                        style: GoogleFonts.redHatText(
                                          textStyle: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WarterScreen()));
                              },
                              child: Container(
                                height: 112.0,
                                width: 112.0,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.teal,
                                        blurRadius: 4,
                                        offset: Offset(2, 5),
                                      ),
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2),
                                          child: Image.asset(
                                              'assets/images/water-pipe 1.png'),
                                        ),
                                        Text(
                                          "ประปา",
                                          style: GoogleFonts.redHatText(
                                              textStyle: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black)),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GasScreen()));
                              },
                              child: Container(
                                height: 112.0,
                                width: 112.0,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.teal,
                                        blurRadius: 4,
                                        offset: Offset(2, 5),
                                      ),
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Image.asset(
                                            'assets/images/manometer 1.png'),
                                      ),
                                      Text(
                                        "แก๊ส",
                                        style: GoogleFonts.redHatText(
                                          textStyle: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        eqList.isEmpty
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Row(
                                  children: [
                                    SizedBox(width: 18),
                                    Text(
                                      "อุปกรณ์ในบ้าน",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          height: 130,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: eqList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 7),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 1,
                                        offset: Offset(2, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            eqList[index]['img'] == null ||
                                                    eqList[index]['img'] == ""
                                                ? Container()
                                                : SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.22,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                    child: Image.network(
                                                        "${ipcon}/images/${eqList[index]['img']}"),
                                                  ),
                                            FlutterSwitch(
                                              activeColor: Colors.green,
                                              inactiveColor: Colors.red,
                                              activeTextColor: Colors.black,
                                              inactiveTextColor: Colors.black,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.17,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                              value: eqList[index]
                                                          ['eq_status'] !=
                                                      "0"
                                                  ? true
                                                  : false,
                                              borderRadius: 30,
                                              showOnOff: false,
                                              onToggle: (val) {
                                                if (val == false) {
                                                  setState(() {
                                                    eqList[index]['eq_status'] =
                                                        '0';
                                                  });
                                                } else {
                                                  setState(() {
                                                    eqList[index]['eq_status'] =
                                                        '1';
                                                  });
                                                }
                                                eq_id =
                                                    eqList[index]['home_eq_id'];
                                                eq_status =
                                                    eqList[index]['eq_status'];
                                                edit_status(eq_status, eq_id);
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "${eqList[index]['eq_name']}",
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        roomList.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      "ห้อง",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: roomList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return RoomDetail(
                                          room_id: roomList[index]['room_id']);
                                    }));
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 320,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 250,
                                          decoration: BoxDecoration(
                                              //  color: Colors.red,
                                              ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15)),
                                            child: Image.network(
                                              "$ipcon/images/${roomList[index]['img']}",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 70,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            //color: Colors.green,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      roomList[index]
                                                              ['room_name']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Builder(
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal,
                            blurRadius: 4,
                            offset: Offset(2, 5),
                          ),
                        ],
                      ),
                      child: IconButton(
                          iconSize: 20,
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          icon: Image.asset(
                            'assets/images/menu_bar.png',
                          )),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors_in_immutables, non_constant_identifier_names, avoid_print, prefer_void_to_null, use_build_context_synchronously, prefer_const_constructors, sort_child_properties_last
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:smarthomeapp/ipcon.dart';
import 'package:smarthomeapp/screen/drawer_screen/setting_screen/setting_screen.dart';
import 'package:smarthomeapp/screen/login_screen/login_page.dart';
import 'package:smarthomeapp/screen/login_screen/select_home_screen.dart';
import 'homepage_screen/homepage.dart';
import 'notification_screen/notification.dart';
import 'setting_screen/profile_setting/self.dart';

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({Key? key}) : super(key: key);
  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  List userList = [];
  String? user_id;
  String? name;
  String? mail;
  String? img;
  get_user_id() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    print(user_id);
    get_user();
  }

  get_user() async {
    final response = await http
        .get(Uri.parse("$ipcon/login/get_data_user.php?user_id=$user_id"));
    var data = json.decode(response.body);
    print("user : $data");
    setState(() {
      userList = data;
      name = userList[0]['name'];
      mail = userList[0]['email'];
      img = userList[0]['img'];
    });
  }

  select_home() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("home_id", "");
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return SelectHomeScreen();
    }));
  }

  @override
  void initState() {
    get_user_id();
    super.initState();
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return LoginPage();
    }));
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );
  Widget buildHeader(BuildContext context) => Material(
        color: Colors.teal.shade300,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilePage(),
            ));
          },
          child: Container(
            child: Column(
              children: [
                img == '' || img == null
                    ? CircleAvatar(
                        radius: 72,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            AssetImage("assets/images/profile_empty.jpg"),
                      )
                    : CircleAvatar(
                        radius: 72,
                        backgroundImage: NetworkImage('$ipcon/images/$img'),
                      ),
                SizedBox(height: 12),
                Text(
                  '$name',
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
                SizedBox(height: 5),
                Text(
                  '$mail',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top,
              bottom: 20,
            ),
          ),
        ),
      );
  Widget buildMenuItems(BuildContext context) => Container(
        padding: EdgeInsets.all(20),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: Icon(Icons.home_rounded),
              iconColor: Colors.black,
              title: Text(
                "หน้าแรก",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.notifications_active),
              iconColor: Colors.black,
              title: Text(
                "แจ้งเตือน",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // close drawer
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotificationPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              iconColor: Colors.black,
              title: Text(
                "ตั้งค่า",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // close drawer
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SettingPage(),
                  ),
                );
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(Icons.home),
              iconColor: Colors.red.shade300,
              title: Text(
                'เลือกบ้าน',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                select_home();
              },
            ),
            ListTile(
              leading: Icon(Icons.output_rounded),
              iconColor: Colors.red,
              title: Text(
                'ออกจากระบบ',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      );
}

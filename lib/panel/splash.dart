import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mypastry/class/myconfig.dart';
import 'package:mypastry/class/user.dart';
import 'package:mypastry/panel/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'mainpage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  late double screenHeight, screenWidth, resWidth = 0;

  @override
  void initState() {
    super.initState();
    _checkPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth * 0.85;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "MY PASTRY",
            style: TextStyle(
                fontSize: resWidth * 0.15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
              child: Image.asset(
                'assets/images/background.png',
                scale: 2,
              ),
              width: resWidth),
          const CircularProgressIndicator(),
          Text(
            "Pekan Nanas",
            style: TextStyle(
                fontSize: resWidth * 0.05, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Future<void> _checkPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String phone = (pref.getString('phone')) ?? '';
    String password = (pref.getString('password')) ?? '';
    late User user;
    if (phone.length > 1 && password.length > 1) {
      http.post(Uri.parse(MyConfig.server + "/mypastry/php/logindb.php"),
          body: {"phone": phone, "password": password}).then((response) {
        if (response.statusCode == 200 && response.body != "failed") {
          final jsonResponse = json.decode(response.body);
          user = User.fromJson(jsonResponse);
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (content) => MainPage(user: user))));
        } else {
          user = User(
              id: "na",
              phone: "na",
              name: "na",
              email: "na",
              address: "na",
              datereg: "na",
              otp: "na", 
              loc: 'na');
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (content) => const Register())));
        }
      }).timeout(const Duration(seconds: 5));
    } else {
      user = User(
              id: "na",
              phone: "na",
              name: "na",
              email: "na",
              address: "na",
              datereg: "na",
              otp: "na", loc: 'na');
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (content) => const Register())));
    }
  }
}
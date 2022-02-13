import 'package:flutter/material.dart';
import 'package:mypastry/panel/splash.dart';

import 'panel/login.dart';

//import 'panel/splash.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: (ThemeData(primarySwatch: Colors.lightBlue)),
        title: 'MyPastry',
        home: const Scaffold(
          body: Splash()
          //body: Login(),
        ));
  }
}
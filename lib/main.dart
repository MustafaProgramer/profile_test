import 'package:flutter/material.dart';
import './ui/LocationList.dart';
import './ui/Home.dart';
import './ui/Login.dart';
void main() => runApp(new MaterialApp(
  routes: {
    // When we navigate to the "/" route, build the FirstScreen Widget
    '/Locations': (context) => Locations(),
    'Login':(context) => Login(),
    'Home':(context) => ProfileTwoPage(),
    // When we navigate to the "/second" route, build the SecondScreen Widget
  },
  home: new Login(),
));


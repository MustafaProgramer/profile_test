import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import './ui/LocationList.dart';
import './ui/Profile.dart';
import './ui/Login.dart';
import './ui/Mapview.dart';
import './ui/Home.dart';
import './ui/Future.dart';
void main() {
  MapView.setApiKey("AIzaSyBth-j1JK30_yCR8PtJgWHixcl020ILtNk");
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
  routes: {
    // When we navigate to the "/" route, build the FirstScreen Widget
    '/Locations': (context) => Loc(),
    'Login':(context) => Login(),
    'Profile':(context) => ProfileTwoPage(),
    'Map': (context) => Map(),
    'Home':(context) => Nav()
    // When we navigate to the "/second" route, build the SecondScreen Widget
  },
  home: new Login(),
));
} 


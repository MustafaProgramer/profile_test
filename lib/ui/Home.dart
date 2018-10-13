import 'package:flutter/material.dart';
import 'Profile.dart';
import 'Mpas.dart';
class Nav extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NavState();
  }
}

class NavState extends State<Nav> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    GMaps(),
    ProfileTwoPage(),
    //GMaps()
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          
          resizeToAvoidBottomPadding: true,
            bottomNavigationBar: BottomNavigationBar(
              onTap: onTabTapped, // new
              currentIndex: _currentIndex, // new
              items: [
                new BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  title: Text('Home'),
                ),
                /*
         new BottomNavigationBarItem(
           icon: Icon(Icons.mail),
           title: Text('Messages'),
         ),
         */
                new BottomNavigationBarItem(
                    icon: Icon(Icons.person), title: Text('Profile'))
              ],
            ),
           
            body: _children[_currentIndex]));
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

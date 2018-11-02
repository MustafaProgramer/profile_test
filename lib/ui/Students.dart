import 'package:flutter/material.dart';
import './data/Firebase.dart';
import 'StudentList.dart';
import './Route.dart';
class StudentList extends StatefulWidget {
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList>
    with SingleTickerProviderStateMixin {
  TabController _tabcontroller;

  @override
  void initState() {
    super.initState();
    _tabcontroller = new TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("Student List"),
        centerTitle: true,
        bottom: new TabBar(
          controller: _tabcontroller,
          indicatorColor: Colors.white,
          tabs: <Tab>[
            new Tab(
              text: 'Students',
            ),
            new Tab(
              text: 'Up Comming Route',
            )
          ],
        ),
      ),
      body: new TabBarView(
        controller: _tabcontroller,
        children: <Widget>[
          StudentsList(),
          StRoute(),
        ],
      ),
    );
  }
}

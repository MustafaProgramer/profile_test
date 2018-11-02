import 'dart:async';
//import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'chat_model.dart';
import './data/Firebase.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:dio/dio.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
class StudentsList extends StatefulWidget {
  _StudentsListState createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  Dio dio = new Dio();
  Response response;
  var stList = Students.getStudents();
  var d = "a";
  Location _location = new Location();
  final Distance distance = new Distance();
  StreamSubscription<Map<String, double>> _locationSubscription;
  Map<String, double> _currentLocation;
  void initState() {
    super.initState();

    getLocation();
    //_calcDist();
    /*
    _locationSubscription =
        _location.onLocationChanged().listen((Map<String,double> result) {
          print(_currentLocation);
          //print(stList[0]["S_Home"]["Lat"]+stList[0]["S_Home"]["Long"]);
          //print("abcd");
             _calcDist();
          // print(distance);
          setState(() {
            _currentLocation = result;
          });
          
        });
        */
  }

  void getLocation() async {
    Map<String, double> location = await _location.getLocation();
    print(location.toString());
  }

  List _SearchRes = [];
  bool _notFound = false;
  var _list = <Widget>[new Padding(padding: EdgeInsets.only(top: 30.0))];

  _searchList() {
    _list = [];
    for (int i = 0; i < _SearchRes.length; i++) {
      //print(_SearchRes);

    }
  }

  _search(student) {
    _SearchRes =[];
    for (int i = 0; i < stList.length; i++) {
      
      if (stList[i]["S_Name"].toLowerCase().contains(student.toLowerCase())) {
       // print(stList[i]["S_Name"].toLowerCase()+", "+student);
        _SearchRes.add(stList[i]);
      }
     
    }
    //print(_SearchRes.length);
     return _SearchRes;
  }

  TextEditingController _searchInput = new TextEditingController();
  
  Widget searchBar() => new Card(
          child: new TextField(
        onChanged: (v) {
          if (v.isNotEmpty) {
            var result = _search(v);
            if (result.isEmpty) {
              _notFound = true;
            }
            setState(() {
             
            });
          }
          else{ _SearchRes = []; _notFound=false;
          setState(() {
                      
                    });
          }
        },
        controller: _searchInput,
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          hintText: "Search for Student..",
          suffix: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchInput.clear();
                setState(() {
                  _notFound=false;
                  _SearchRes = [];
                });
              }),
        ),
      ));

  _calcDist() async {
    //print(stList[0]["S_Name"]);
    var lat = double.parse(stList[0]["S_Home"]["Lat"]);
    var long = double.parse(stList[0]["S_Home"]["Long"]);
    var key =
        "Aq1jwviqtvFbD1TJYenEOvVCXf8rg2CjrZe0SpnPHDO7_FyXrgggW0B3QxrBemhU";
    var url2 =
        "https://dev.virtualearth.net/REST/v1/Routes/DistanceMatrix?origins=26.2285,50.5859983&destinations=26.192682,50.551346&travelMode=driving&key=$key";
    response = await dio.get(url2);

    d = response.data['resourceSets'][0]['resources'][0]['results'][0]
            ['travelDistance']
        .toString();

    print("distance in kilo=" + d);
    return d;
  }

  Widget stuList(List list) => Expanded(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) => new Column(
                children: <Widget>[
                  new Divider(
                    height: 10.0,
                  ),
                  new ListTile(
                    leading: new CircleAvatar(
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.grey,
                      backgroundImage: new NetworkImage(list[i]["avatar"]),
                    ),
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          list[i]["S_Name"],
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        
                        new Text(
                          dummyData[i].time,
                          style:
                              new TextStyle(color: Colors.grey, fontSize: 14.0),
                        ),
                        
                      ],
                    ),
                    subtitle: new Container(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                        list[i]["S_Home"]["P_Name"],
                        style:
                            new TextStyle(color: Colors.grey, fontSize: 15.0),
                      ),
                      new InkWell(
                        child: Icon(Icons.call),
                        onTap:()=> launch("tel://${list[i]["S_Phone"]}"),
                      ),
                     


                        ],
                      ) ,
                      
                    ),
                  )
                ],
              ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    //print(_SearchRes.length);
    return Column(
      children: <Widget>[
        searchBar(),
        _SearchRes.isEmpty && !_notFound? stuList(stList):stuList(_SearchRes),
      ],
    );
  }
}

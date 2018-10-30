import 'dart:async';
//import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'chat_model.dart';
import './data/Firebase.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:dio/dio.dart';
import 'package:latlong/latlong.dart';

class StudentsList extends StatefulWidget {
  _StudentsListState createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  Dio dio = new Dio();
 Response response;
  var stList = Students.getStudents();
  var d="a";
  Location _location = new Location();
  final Distance distance = new Distance();
  StreamSubscription<Map<String, double>> _locationSubscription;
  Map<String, double> _currentLocation;
  void initState() {
    super.initState();

    getLocation();
    _calcDist();
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

  _calcDist() async {
    //print(stList[0]["S_Name"]);
    
    var lat = double.parse(stList[0]["S_Home"]["Lat"]);
    var long = double.parse(stList[0]["S_Home"]["Long"]);
    var p1 = {lat: 26.2285, long: 50.5859983};
    var p2 = {lat: 26.192682, long: 50.551346};
      var key = "Aq1jwviqtvFbD1TJYenEOvVCXf8rg2CjrZe0SpnPHDO7_FyXrgggW0B3QxrBemhU" ;
     var url2 = "https://dev.virtualearth.net/REST/v1/Routes/DistanceMatrix?origins=26.2285,50.5859983&destinations=26.192682,50.551346&travelMode=driving&key=$key";
     response=await dio.get(url2);
    /*
    print(
        p1[lat].toString() + "llllllllllllllllllllllllllllllllllaaaaaaaaaaaat");
    final meter = distance.as(LengthUnit.Kilometer,
        new LatLng(p1[lat], p1[long]), new LatLng(p2[lat], p2[long]));
*/
    /*double distanceInMeters = await Geolocator()
        .distanceBetween(p1[lat], p1[long], p2[lat], p2[long]);
    
    */
    d = response.data['resourceSets'][0]['resources'][0]['results'][0]['travelDistance'].toString();

    print("distance in kilo=" + d);
    return d ;
    
  }

  void getLocation() async {
    Map<String, double> location = await _location.getLocation();
    print(location.toString());
  }

  @override
  Widget build(BuildContext context) {
    // print(stList);
    return ListView.builder(
      itemCount: stList.length,
      itemBuilder: (context, i) => new Column(
            children: <Widget>[
              new Divider(
                height: 10.0,
              ),
              new ListTile(
                leading: new CircleAvatar(
                  foregroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey,
                  backgroundImage: new NetworkImage(stList[i]["avatar"]),
                ),
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      stList[i]["S_Name"],
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      dummyData[i].time,
                      style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                  ],
                ),
                subtitle: new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    d.substring(0,4)+" km",
                    style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                  ),
                ),
              )
            ],
          ),
    );
  }
}

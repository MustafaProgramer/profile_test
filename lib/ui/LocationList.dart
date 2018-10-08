import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import './data/cities.dart';
import './data/Firebase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Locations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LocationState();
  }
}

class LocationState extends State<Locations> {
  Firestore firestore;
  var dex = 0;
  void initState() {
    _addCities();
    _initlize();

    // _createList();
  }
  _initlize()
  {
    var f; 
   f= FirebaseConfig1.initFire(firestore);
   print(f.toString());
   
  }
/*
  Future<void> _initialize() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'test',
      options: const FirebaseOptions(
        googleAppID: '1:282652140711:android:dbac553d9ed9b18c',
        apiKey: 'AIzaSyCgJPiep1ADLqvJXbfwDz_hj_Vh_Q_2vuE',
        projectID: 'senior-project-a1ec6',
      ),
    );
    firestore = Firestore(app: app);
  }
*/
  _addCities() {
    cities = [];
    Firestore.instance.collection('Bahrain Places').snapshots().listen((data) {
      print(data.documents[0].documentID);
      data.documents.forEach((doc) {
        cities.add({"ID":doc.documentID,"Detail":doc.data});
        //print(doc.data);
      });
      if (_Areas.isEmpty)
        for (int i = 0; i < cities.length; i++) {
          _Areas.add({"Name": cities[i]["ID"], "value": false});
        }
      _createList();
      setState(() {
        dex = 1;
      });
    });
  }

// ---------------- variable declerations --------------
  List _SearchRes = [];
  bool _notFound = false;
  var checkboxValue = [];
  var _Areas = [];
  var _list = <Widget>[new Padding(padding: EdgeInsets.only(top: 30.0))];
  TextEditingController _searchInput = new TextEditingController();
  var _sIndex;

// ---------------- Search bar ---------------------------

  Widget searchBar() => new Card(
          child: new TextField(
        onChanged: (v) {
          if (v.isNotEmpty) {
            _SearchRes = [];
            for (int i = 0; i < _Areas.length; i++) {
              if (_Areas[i]["Name"].toLowerCase().contains(v.toLowerCase())) {
                _SearchRes.add({
                  "Name": _Areas[i]["Name"],
                  "value": _Areas[i]["value"],
                  "Index": i
                });
              }
            }
            if (_SearchRes.isEmpty) {
              _notFound = true;
            }
            setState(() {
              _searchList();
            });
          } else
            setState(() {
              _SearchRes = [];
              _notFound = false;
              _createList();
            });
        },
        controller: _searchInput,
        decoration: InputDecoration(
          
          icon: Icon(Icons.search),
          hintText: "Search for area..",
          suffix:  IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchInput.clear();
                setState(() {
                   _SearchRes = [];
              _notFound = false;
              _createList();
                });
              }),
        ),
      ));

// ------------------- Creating the list of contries ------------------

  _createList() {
    _list = <Widget>[];

    for (int i = 0; i < _Areas.length; i++) {
      _list.add(InkWell(
          onTap: () {
            setState(() {
              _Areas[i]["value"] = !_Areas[i]["value"];
              print(_Areas[i]["value"]);
            });
          },
          child: new Row(
            children: <Widget>[
              new Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      _Areas[i]["value"] = value;
                    });
                  },
                  value: _Areas[i]["value"]),
              new Text(_Areas[i]["Name"]),
            ],
          )));

      _list.add(new Padding(
        padding: EdgeInsets.all(10.0),
      ));
    }
  }

  //---------------- Creating Search list -----------------------

  _searchList() {
    _list = [];
    for (int i = 0; i < _SearchRes.length; i++) {
      //print(_SearchRes);

      _list.add(InkWell(
          onTap: () {
            setState(() {
              _SearchRes[i]["value"] = !_SearchRes[i]["value"];
              var index = _SearchRes[i]["Index"];
              _Areas[index]["value"] = _SearchRes[i]["value"];

              //_createList();
            });
          },
          child: new Row(
            children: <Widget>[
              new Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      _SearchRes[i]["value"] = !_SearchRes[i]["value"];
                      var index = _SearchRes[i]["Index"];
                      _Areas[index]["value"] = !_SearchRes[i]["value"];
                      print(_SearchRes[i]["value"]);
                    });
                  },
                  value: _SearchRes[i]["value"]),
              new Text(_SearchRes[i]["Name"]),
            ],
          )));

      _list.add(new Padding(
        padding: EdgeInsets.all(20.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    _createList();
    if (_SearchRes.isNotEmpty || _notFound) {
      _searchList();
    }

    var temp = <Widget>[
      Container(
        margin: EdgeInsets.only(top: 250.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            new Text(" Loading the cities"),
            CircularProgressIndicator()
          ],
        ),
      ),
      Expanded(child: new ListView(children: _list))
    ];

    return Scaffold(
        appBar: new AppBar(
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Save",
                style: new TextStyle(color: Colors.white),
              ),
              onPressed: () => print(cities),
            )
          ],
          title: Text("Cities"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[searchBar(), temp[dex]],
        ));
  }
}

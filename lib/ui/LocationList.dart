import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class Locations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LocationState();
  }
}

class LocationState extends State<Locations> {
  void initState() {
    if (_Areas.isEmpty)
      for (int i = 0; i < 30; i++) {
        // print(_list);
        _Areas.add({"Name": "Area Number " + i.toString(), "value": false});
      }
    _createList();
  }

// ---------------- variable declerations --------------
  List _SearchRes = [];
  bool _notFound=false;
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
              _notFound=true;
              
              }
            setState(() {
              _searchList();
            });
          } else
            setState(() {
              _SearchRes = [];
              _notFound=false;
              _createList();
            });
        },
        controller: _searchInput,
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          hintText: "Search for area..",
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
        padding: EdgeInsets.all(20.0),
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
    if (_SearchRes.isNotEmpty||_notFound) {
      
      _searchList();
    }

    Widget data() => Expanded(child: new ListView(children: _list));

    return Scaffold(
        appBar: new AppBar(
          title: Text("Cites"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[searchBar(), data()],
        ));
  }
}

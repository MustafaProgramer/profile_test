import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class Locations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LocationState();
  }
}

class LocationState extends State<Locations> {
   var _list = <Widget>[new Padding(padding: EdgeInsets.only(top: 30.0))];
  List _SearchRes = null;
  var checkboxValue = [];
  var _Areas = [];
  TextEditingController _searchInput = new TextEditingController();
   _searchList() {
      
      for (int i = 0; i < _SearchRes.length; i++) {
        _list=[];
        _list.add(InkWell(
            onTap: () {
              setState(() {
                checkboxValue[i] = !checkboxValue[i];
                print(checkboxValue[i]);
              });
            },
            child: new Row(
              children: <Widget>[
                new Checkbox(
                    onChanged: (bool value) {
                      setState(() {
                        checkboxValue[i] = value;
                      });
                    },
                    value: checkboxValue[i]),
                new Text(_SearchRes[i]),
              ],
            )));

        _list.add(new Padding(
          padding: EdgeInsets.all(20.0),
        ));
      }
    }

Widget searchBar() => new Card(
            child: new TextField(
          onChanged: (value) {
            setState(() {
             
              if(value.isNotEmpty)
              {
               _SearchRes = _Areas.where((i) => i == value).toList();
               _searchList();
               print(_SearchRes);
              }
            });
          },
          controller: _searchInput,
          decoration: InputDecoration(
            icon: Icon(Icons.search),
            hintText: "Search for area..",
          ),
        ));

  @override
  Widget build(BuildContext context) {
    
   
    _createList() {
      _Areas=[];
      for (int i = 0; i < 30; i++) {
       // print(_list);
        checkboxValue.add(false);
        _Areas.add("Area Number " + i.toString());
        _list.add(InkWell(
            onTap: () {
              setState(() {
                checkboxValue[i] = !checkboxValue[i];
                print(checkboxValue[i]);
              });
            },
            child: new Row(
              children: <Widget>[
                new Checkbox(
                    onChanged: (bool value) {
                      setState(() {
                        checkboxValue[i] = value;
                      });
                    },
                    value: checkboxValue[i]),
                new Text(_Areas[i]),
              ],
            )));

        _list.add(new Padding(
          padding: EdgeInsets.all(20.0),
        ));
      }
    }

       
    _createList();
    Widget data() => Expanded(child: new ListView(children: _list));

    
/*new ListView.builder(
      itemCount: _list.length,
      itemBuilder: (_,i){
             return new Text("data");
      },*/
    

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

import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class Locations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LocationState();
  }
}

class LocationState extends State<Locations> {
  TextEditingController _searchInput = new TextEditingController();
  Widget searchBar() => new Card(
          child: new TextField(
        controller: _searchInput,
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          hintText: "Search for area..",
        ),
      ));
bool checkboxValueA = false;
  @override
  Widget build(BuildContext context) {
    
    var _list = <Widget>[new Padding(padding:EdgeInsets.only(top:30.0))];
    _createList() {
      for (int i = 0; i < 30; i++) {
        _list.add(new Checkbox(
          onChanged:(bool value) {
                  setState(() {
                    checkboxValueA = value;
                  });},
                  value: checkboxValueA   
        ));
        _list.add( new Text("this is the " + i.toString() + "  Loop"));
        _list.add(new Padding(
          padding: EdgeInsets.all(20.0),
        ));
      }
    }

    Widget data() => Expanded(child: new ListView(
      children: _list));

/*new ListView.builder(
      itemCount: _list.length,
      itemBuilder: (_,i){
             return new Text("data");
      },*/
    _createList();

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

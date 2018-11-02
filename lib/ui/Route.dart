import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './data/Firebase.dart';
import 'chat_model.dart';

class StRoute extends StatefulWidget {
  _StRouteState createState() => _StRouteState();
}

class _StRouteState extends State<StRoute> {
 
  DateTime time = DateTime.now();
  var stList = Students.getStudents();
  //var temp = Students.getStudents();
    
  @override
  Widget build(BuildContext context) {
   // stList.add(Students.getStudents());
    //stList.add(temp);
     Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      children: <Widget>[stuList(stList)],
    ),
    floatingActionButton: new RaisedButton(
        onPressed: ()=> print("outline pressed :) "),
        child: new Container(
          width: deviceSize.width - deviceSize.width/7 ,
          child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            
           Text("Start",style: TextStyle(color: Colors.white,fontSize: 23.0),textAlign: TextAlign.center),
           

          ],
        ),
        ),

         color: Colors.blue,
         shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        
         padding: EdgeInsets.all(10.0),
        
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
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
                            style: new TextStyle(
                                color: Colors.grey, fontSize: 15.0),
                          ),
                          new InkWell(
                            child: Icon(Icons.call),
                            onTap: () => launch("tel://${list[i]["S_Phone"]}"),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
        ),
      );
}

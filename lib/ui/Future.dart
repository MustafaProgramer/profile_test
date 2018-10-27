import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //for making request
import 'dart:async'; //for asynchronous features
import 'dart:convert';
class FutureTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FutureTestState();
  }
}

class FutureTestState extends State<FutureTest> {
  Firestore firestore;
  FirebaseUser user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController UserName = new TextEditingController();
  TextEditingController Password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    UserName.text = "admin@a.com";
    Password.text = "Admin123";
    return Scaffold(
        appBar: AppBar(
          title: new Text("Future test"),
        ),
        body:new Center(
             child: Container(
        
        width: 250.0,
        padding: const EdgeInsets.all(10.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text("Future Builder Demo"),
              futureWidget()
            ]))) /*new Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: new FutureBuilder(
                future: retrive(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  List<Widget> _getData(snapshot) {
                    List<Widget> a = [
                      new Text("data"),
                      new Text(snapshot.data.data.toString()),
                    ];
                    return a;
                  }

                  if (snapshot.hasData) {
                    if (snapshot.data.data != null) {
                      return new Column(
                        children: <Widget>[
                          new Expanded(
                              child: new ListView(
                            children: _getData(snapshot),
                          ))
                        ],
                      );
                    } else {
                      return new CircularProgressIndicator();
                    }
                  }
                }))*/);
  }

  Future<FirebaseUser> _handleSignIn() async {
    user = await _auth.signInWithEmailAndPassword(
        email: UserName.text = "admin@a.com",
        password: Password.text = "Admin123");
    return user;
  }
 Widget futureWidget() {
    return new FutureBuilder(
      future: retrive(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new Text(
            snapshot.data.data.toString(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(fontWeight: FontWeight.bold),
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }

        return new CircularProgressIndicator();
      },
    );
  }

  Future retrive() async {
    await  Future.delayed(Duration(seconds: 5));
    DocumentReference docRef = Firestore.instance
        .collection("Driver")
        .document("PurzGEW5lCXdHM6P2RbhEao1WVv1");
    var ref = await docRef.get().then((data) {
        
         return data;
         
    });
      print(ref);
    return ref;
  }
}









class MiddleSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MiddleSectionState();
  }
}

class MiddleSectionState extends State<MiddleSection> {
  String display;

  Widget futureWidget() {
    return new FutureBuilder<String>(
      future: getDataFB(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new Text(
            snapshot.data.toString(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(fontWeight: FontWeight.bold),
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }

        return new CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.yellowAccent,
        width: 250.0,
        padding: const EdgeInsets.all(10.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text("Future Builder Demo"),
              futureWidget()
            ]));
  }
}

Future<String> getDataFB() async {
  http.Response response = await http.get(
      Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
      headers: {"Accept": "application/json"});
  List data = json.decode(response.body);
  print(data[1]['title'].toString());
  return data[1]['title'].toString();
}
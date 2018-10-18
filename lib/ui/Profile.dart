import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:profile_test/ui/widgets/common_scaffold.dart';
import './LocationList.dart';
import './data/Firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './path.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:image_picker/image_picker.dart';

class ProfileTwoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileTwoState();
  }
}

class ProfileTwoState extends State<ProfileTwoPage> {
  Size deviceSize;
  FirebaseUser user;
  var cont;
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _conpany = new TextEditingController();
  TextEditingController _locations = new TextEditingController();
  TextEditingController _discription = new TextEditingController();

// --------------------------- profile Header (banner + name +profile pic, etc) ----------------------

  // ----------------- Info widget (Email, phone, company, Locations) -----------------------------------

// -------------------- building the scaffold -----------------------------
  Firestore firestore;
  var _dName = "unknown";
  var barIndex = 0;
  static bool enabled = false;
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    user = UserDetails.getUser();
    print("ABC");
/*
     Firestore.instance.collection('Driver').document("PurzGEW5lCXdHM6P2RbhEao1WVv1")
  .setData({ 'D_Company': 'Al sadiq', 'D_Email': 'AlSadiq@gmail.com',"D_Name":"Mansoor Abbas","D_Phone":"+97338477340","D_Locations":"Sitra,Sar" });
  */
    _getDetails();
  }

// ---------------- Geting user deatils --------------------

  Future _getDetails() async {
    await FirebaseConfig1.initFire(firestore).then((onValue) {
      Firestore.instance
          .collection('Driver')
          .document(user.uid)
          .snapshots()
          .listen((data) {
        print(data["D_Name"]);
        UserDetails.setDetails(data.data);
        print(data.data);
        _name.text = data["D_Name"];
        _email.text = data["D_Email"];
        _phone.text = data["D_Phone"];
        _conpany.text = data["D_Company"];
        _locations.text = data["D_Locations"];
        _discription.text = data['D_Discrip'];
        //print(_discription);
      }).onError((handleError) {
        print(handleError);
        print("errrrrrrrrrrrrrrrrrrrrrrrrrer");
        var _det = UserDetails.getDetails();
        _name.text = _det["D_Name"];
        _email.text = _det["D_Email"];
        _phone.text = _det["D_Phone"];
        _conpany.text = _det["D_Company"];
        _locations.text = _det["D_Locations"];
        _discription.text = _det['D_Discrip'];
      });
    });
  }

  _recoverDetails() {
    var _det = UserDetails.getDetails();
    _name.text = _det["D_Name"];
    _email.text = _det["D_Email"];
    _phone.text = _det["D_Phone"];
    _conpany.text = _det["D_Company"];
    _locations.text = _det["D_Locations"];
    _discription.text = _det['D_Discrip'];
  }

  Future<Null> _loading(text) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new Dialog(
          insetAnimationCurve: Curves.decelerate,
          child: new Row(
            children: [
              new Padding(
                padding: EdgeInsets.all(40.0),
              ),
              new CircularProgressIndicator(),
              new Padding(
                padding: EdgeInsets.only(left: 30.0),
              ),
              FadingText(text),
            ],
          )),
    );
  }

  Future<Null> _askedToLead(id, cxt) async {
    var mess;
    var tos;
    switch (id) {
      case (0):
        mess = " Are you sure you want to Save Changes ?";
        tos = "Edits Saved successfully";
        break;
    }
    _snackLoading() {
      //print("SnackKey =" + _scaffoldKey.toString());
      Scaffold.of(context).showSnackBar(new SnackBar(
        duration: new Duration(seconds: 5),
        content: new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
            ),
            new FadingText("Saving...")
          ],
        ),
      ));
    }

    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text(
              'Save Changes',
            ),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(mess),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _snackLoading();
                  _updateInfo().then((T) {
                    print(T);

                    if (T == true)
                      Scaffold.of(cxt)
                          .showSnackBar(new SnackBar(content: new Text(tos)));
                    else {
                      print(T.toString() + "..........");
                      Scaffold.of(cxt).showSnackBar(new SnackBar(
                          content: new Text(
                              "some thing went wrong please try again later")));
                      _getDetails();
                    }
                  });
                },
              ),
              new FlatButton(
                child: new Text('NO'),
                onPressed: () {
                  debugPrint("No");
                  setState(() {
                    // enabled = !enabled;
                    _getDetails();
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future _updateInfo() async {
    bool done = false;
    try {
      // _loading("Saving ...");

      // print( Firestore.toString());

      DocumentReference docRef =
          Firestore.instance.collection("Driver").document(user.uid);
      await docRef.updateData({
        'D_Email': _email.text,
        "D_Name": _name.text,
        "D_Phone": _phone.text,
        'D_Discrip': _discription.text
      }).whenComplete(() {
        done = true;
        print("completed");
        return done;
      }).catchError((onError) {
        Navigator.of(context).pop();
        print("error = " + onError);
        return done;
      }).timeout(Duration(seconds: 20), onTimeout: () {
        print("Timeout");
        _recoverDetails();
        setState(() {});

        //Navigator.of(context).pop();
      });
      return done;
      /*
          Firestore firestore = Firestore.instance;
      final DocumentReference docRef =
          Firestore.instance.collection("Driver").document(user.uid);
      print(docRef.toString());

      var transaction = Firestore.instance.runTransaction((t) {
        return t.get(docRef).then((doc) {
          // Add one person to the city population
         // t.update(docRef, {"D_Phone": "+973"});
        });
      }).then((result) {
        debugPrint('Transaction success!');
      }).catchError((err) {
        debugPrint('Transaction failure:' + err);
      });
      */
    } catch (err) {
      print(err);
      print("error..");
      return false;
    }

    //return true;
  }

  bool editing = false;
  @override
  Widget build(BuildContext context) {
    List appBar = <Widget>[
      new Padding(
        child: InkWell(
          child: Icon(Icons.edit),
          onTap: () {
            // print("edit pressed");
            enabled = !enabled;
            editing = !editing;
            //print(enabled);
            setState(() {
              barIndex = 1;
            });
          },
        ),
        padding: EdgeInsets.only(right: 25.0),
      ),
      new Padding(
        child: InkWell(
          child: Icon(Icons.done),
          onTap: () {
            _askedToLead(0, context);
            //  print("Done pressed");
            enabled = !enabled;
            editing = !editing;
            //print(enabled);
            setState(() {
              barIndex = 0;
            });
          },
        ),
        padding: EdgeInsets.only(right: 25.0),
      ),
    ];
    cont = context;
    _path() {
      MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => FlutterDemo(storage: CounterStorage()));
      Navigator.push(context, route);
    }

    _editLocations() {
      MaterialPageRoute route = MaterialPageRoute(builder: (context) => Loc());
      Navigator.push(context, route);
    }

    var _avaLink = null;
    //https://cdn.iconscout.com/icon/free/png-256/avatar-375-456327.png
    var _bannerLink;
    bool exist;

    Widget profileHeader() => Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
            image: new NetworkImage(
                "http://sc01.alicdn.com/kf/UT8ECKhXzJaXXagOFbXh/200043761/UT8ECKhXzJaXXagOFbXh.jpg"),
            fit: BoxFit.cover,
          )),
          height: deviceSize.height / 3.2,
          width: double.infinity,
          //color: Colors.black,
          child: Card(
            color: Colors.white10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                editing
                    ? Padding(
                        child: InkWell(
                          enableFeedback: editing ? true : false,
                          onTap: () {
                            (!editing) ? null : getImage();
                          },
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                        ),
                        padding: EdgeInsets.only(left: deviceSize.width / 1.1),
                      )
                    : Divider(),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(width: 2.0, color: Colors.white)),
                    child: InkWell(
                      enableFeedback: editing ? true : false,
                      onTap: () {
                        (!editing) ? null : getImage();
                      },
                      child: CircleAvatar(
                        child: editing ? Icon(Icons.add_a_photo) : null,
                        radius: 40.0,
                        backgroundImage: (_avaLink != null)
                            ? NetworkImage(_avaLink)
                            : new AssetImage('assets/default-avatar.png'),
                      ),
                    )),
                new Padding(
                    padding: EdgeInsets.only(left: deviceSize.width / 3.2),
                    child: TextField(
                      controller: _name,
                      enabled: enabled,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    )),
                new Expanded(
                  child: new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        controller: _discription,
                        enabled: enabled,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ),
        );

    Widget info() => Container(
        padding: EdgeInsets.all(65.0),
        child: Column(
          children: <Widget>[
            new TextField(
              enabled: enabled,
              controller: _email,
              decoration: new InputDecoration(
                  icon: Icon(
                Icons.email,
                color: Colors.blue,
              )),
            ),
            new TextField(
              enabled: enabled,
              controller: _phone,
              decoration: new InputDecoration(
                  icon: Icon(
                Icons.phone_android,
                color: Colors.blue,
              )),
            ),
            new InkWell(
              onTap: _path,
              child: new TextField(
                enabled: false,
                controller: _conpany,
                decoration: new InputDecoration(
                    icon: Icon(
                  Icons.group,
                  color: Colors.blue,
                )),
              ),
            ),
            new InkWell(
                onTap: () {
                  _editLocations();
                },
                child: new TextField(
                  enabled: false,
                   maxLines: 2,
                  controller: _locations,
                  decoration: new InputDecoration(
                      icon: Icon(
                    Icons.directions_bus,
                    color: Colors.blue,
                  )),
                ))
          ],
        ));

    Widget bodyData() => SingleChildScrollView(
          child: Column(
            children: <Widget>[
              profileHeader(),
              info(),
              //followColumn(deviceSize),
              // imagesCard(),
              //postCard(),
            ],
          ),
        );
// ------------------------- on click funcitons ---------------------------
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        actions: <Widget>[appBar[barIndex]],
        title: new Text("Profile"),
      ),
      body: bodyData(),
    );
  }
}
/*

*/

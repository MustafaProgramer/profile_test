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
import 'image_picker_handler.dart';

/*
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }
*/
class ProfileTwoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileTwoState();
  }
}

class ProfileTwoState extends State<ProfileTwoPage>
    with TickerProviderStateMixin, ImagePickerListener {
  // ----------------- variables decleration -------------------------------
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Size deviceSize;
  FirebaseUser user;
  Firestore firestore;
 
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _conpany = new TextEditingController();
  TextEditingController _locations = new TextEditingController();
  TextEditingController _discription = new TextEditingController();

  var cont;
  var details;
  var _dName = "unknown";
  var barIndex = 0;
  static bool enabled = false;

  File _image;
  File _banimage;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  AssetImage avaImage = AssetImage('assets/default-avatar.png');
  AssetImage bannerImage = AssetImage('assets/images/banner.jpg');
  bool banEdit = false;
    bool avatEdit = false;
// ----------------- Initial state function -------------------------
  @override
  void initState() {
  
    user = UserDetails.getUser();
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    FirebaseConfig1.initFire(firestore);
    //details = _getDetails();
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    _getDetails();
/*super.initState();
     Firestore.instance.collection('Driver').document("PurzGEW5lCXdHM6P2RbhEao1WVv1")
  .setData({ 'D_Company': 'Al sadiq', 'D_Email': 'AlSadiq@gmail.com',"D_Name":"Mansoor Abbas","D_Phone":"+97338477340","D_Locations":"Sitra,Sar" });
  */
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  userImage(File _image) {
    setState(() {
      if(avatEdit)
      this._image = _image;
      else if(banEdit)
      this._banimage = _image;
    });
  }

// ---------------- Geting user deatils --------------------
  Future _getDetails() async {
    DocumentReference docRef =
        Firestore.instance.collection("Driver").document(user.uid);
    var ref = await docRef.get();
    var data = ref.data;
      UserDetails.setDetails(data);
_name.text = data["D_Name"];
        _email.text = data["D_Email"];
        _phone.text = data["D_Phone"];
        _conpany.text = data["D_Company"];
        _locations.text = data["D_Locations"];
        _discription.text = data['D_Discrip'];
    //return ref;
  }

/*
UserDetails.setDetails(data.data);
_name.text = data["D_Name"];
        _email.text = data["D_Email"];
        _phone.text = data["D_Phone"];
        _conpany.text = data["D_Company"];
        _locations.text = data["D_Locations"];
        _discription.text = data['D_Discrip'];*/
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
    var _bannerLink=null;
    bool exist;
    

    Widget profileHeader() => Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
            image: (_bannerLink != null)
                          ? NetworkImage(_bannerLink)
                            : _banimage != null 
                                ? new ExactAssetImage(_banimage.path)
                                : bannerImage,
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
                           
                            (!editing) ? null :  banEdit = true;
                            avatEdit = false; imagePicker.showDialog(context);
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
                       
                        (!editing) ? null :  avatEdit = true;
                        banEdit = false; imagePicker.showDialog(context);
                      },
                      child: CircleAvatar(
                        child: editing ? Icon(Icons.add_a_photo) : null,
                        radius: 40.0,
                        backgroundImage: (_avaLink != null)
                          ? NetworkImage(_avaLink)
                            : _image != null 
                                ? new ExactAssetImage(_image.path)
                                : avaImage,
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
              onChanged: (t) {
                _phone.text = t;
              },
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

    Widget futureProfile() {
      return new FutureBuilder(
        future: details,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print(snapshot.data.data);
            var data = snapshot.data.data;
            UserDetails.setDetails(snapshot.data.data);
            _name.text = data["D_Name"];
            _email.text = data["D_Email"];
            _phone.text = data["D_Phone"];
            _conpany.text = data["D_Company"];
            _locations.text = data["D_Locations"];
            _discription.text = data['D_Discrip'];
            return bodyData();
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }

          return Center(child: new CircularProgressIndicator());
        },
      );
    }

// ------------------------- on click funcitons ---------------------------
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        actions: <Widget>[appBar[barIndex]],
        title: new Text("Profile"),
      ),
      body: Center(child: bodyData()),
      
    );
  }
}
/*

*/

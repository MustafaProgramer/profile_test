import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:profile_test/ui/widgets/common_scaffold.dart';
import './LocationList.dart';
import './data/Firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './path.dart';

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

// --------------------------- profile Header (banner + name +profile pic, etc) ----------------------

  // ----------------- Info widget (Email, phone, company, Locations) -----------------------------------

// -------------------- building the scaffold -----------------------------
  Firestore firestore;
  var _dName = "unknown";
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
     
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    cont = context;
    _path() {
      MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => FlutterDemo(storage: CounterStorage()));
      Navigator.push(context, route);
    }

    _editLocations() {
      MaterialPageRoute route =
          MaterialPageRoute(builder: (context) => Loc());
      Navigator.push(context, route);
    }

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
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Card(
              color: Colors.white12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(width: 2.0, color: Colors.white)),
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundImage: NetworkImage(
                          "http://www.cutestpaw.com/wp-content/uploads/2011/11/OIo.jpg"),
                    ),
                  ),
                  new Padding(
                      padding: EdgeInsets.only(left: deviceSize.width /3.2),
                      child: TextField(
                        controller: _name,
                        enabled: false,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      )),
                  Text(
                    "Amazon Driver",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        );

    Widget info() => Container(
        padding: EdgeInsets.all(65.0),
        child: Column(
          children: <Widget>[
            new TextField(
              enabled: false,
              controller: _email,
              decoration: new InputDecoration(
                  icon: Icon(
                Icons.email,
                color: Colors.blue,
              )),
            ),
            new TextField(
              enabled: false,
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
    return  bodyData();
      
 
  }
}
/*

*/

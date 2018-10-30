import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity/connectivity.dart';
import './data/Firebase.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:progress_indicators/progress_indicators.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  TextEditingController UserName = new TextEditingController();
  TextEditingController Password = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Future<Null> _loading() async {
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
                FadingText('Loading...'),
              ],
            )),
      );
    }

    _onTimeout() {
      print("time out ");
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
            "Something went wrong check your internet conneticon and try again"),
      ));
      //Navigator.pop(context);
    }

    Future<FirebaseUser> _handleSignIn(cont) async {
      _loading();
      try {
        var connectivityResult = await (new Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          {
            FirebaseUser user = await _auth
                .signInWithEmailAndPassword(
                  email: UserName.text,
                  password: Password.text,
                )
                .timeout(Duration(seconds: 15), onTimeout: () => _onTimeout());
            Navigator.pop(context);
            return user;
          }
        } else {
          Navigator.pop(context);
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text("No Internet connection "),
          ));
        }
      } catch (err) {
        print(err);
      }
    }

    var _avaLink = null;

    UserName.text = "admin@a.com";
    Password.text = "Admin123";
    var form =
        //------------------- Login form --------------------
        <Widget>[
      new Container(
          padding: EdgeInsets.only(top: 90.0),
          alignment: Alignment.center,
          child: new TextField(
              controller: UserName,
              decoration: InputDecoration(
                  hintText: "Username", icon: Icon(Icons.person)))),
      new Container(
          alignment: Alignment.center,
          child: new TextField(
              obscureText: true,
              controller: Password,
              decoration: InputDecoration(
                  hintText: "Passwrod", icon: Icon(Icons.vpn_key)))),
      new Container(
          padding: EdgeInsets.only(top: 20.0, left: 30.0),
          child: new FlatButton(
            child: new Text("Login"),
            onPressed: () {
              _handleSignIn(context).then((FirebaseUser user) {
                print(user);
                UserDetails.setUser(user);
                if (user.email != "null") {
                  Navigator.pushNamed(context, "Home");
                }
              }).catchError((e) => print(e));
            },
            color: Colors.lightBlue,
          )),
     
    ];

    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: new ListView(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            children: form));
  }
}

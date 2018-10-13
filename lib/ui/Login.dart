import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity/connectivity.dart';
import './data/Firebase.dart';
class Login extends StatelessWidget {
  TextEditingController UserName = new TextEditingController();
  TextEditingController Password = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
 
  Future<FirebaseUser> _handleSignIn(cont) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      {
        FirebaseUser user = await _auth.signInWithEmailAndPassword(
          email: UserName.text,
          password: Password.text,
        );
        return user;
      }
    } else
      Scaffold.of(cont).showSnackBar(new SnackBar(
        content: new Text("No Internet connection "),
      ));
  }

  @override
  Widget build(BuildContext context) {
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
        resizeToAvoidBottomPadding: false,
        body: new ListView(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            children: form));
  }
}

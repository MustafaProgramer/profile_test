import 'package:flutter/material.dart';
import 'package:profile_test/ui/widgets/common_scaffold.dart';

class ProfileTwoPage extends StatelessWidget {
  Size deviceSize;
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _conpany = new TextEditingController();
  TextEditingController _locations = new TextEditingController();

  Widget profileHeader() => Container(
        height: deviceSize.height / 4,
        width: double.infinity,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            color: Colors.black,
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
                        "https://png2.kisspng.com/20180219/rje/kisspng-avatar-icon-fashion-men-vector-avatar-5a8b58502f1ae5.101219951519081552193.png"),
                  ),
                ),
                Text(
                  "Pawan Kumar",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Text(
                  "Amazon Driver",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      );

  Widget info() => Container(
      padding: EdgeInsets.all(80.0),
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
          new TextField(
            enabled: false,
            controller: _conpany,
            decoration: new InputDecoration(
                icon: Icon(
              Icons.group,
              color: Colors.blue,
            )),
          ),
          new TextField(
            enabled: false,
            controller: _locations,
            decoration: new InputDecoration(
                icon: Icon(
              Icons.directions_bus,
              color: Colors.blue,
            )),
          )
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

  @override
  Widget build(BuildContext context) {
    _email.text = "D@m.com";
    _phone.text = "+97334356868";
    _conpany.text = "Al Marhoon";
    _locations.text = "Manama , Isa Town";
    deviceSize = MediaQuery.of(context).size;
    return CommonScaffold(
      appTitle: "Profile",
      bodyData: bodyData(),
      elevation: 0.0,
    );
  }
}

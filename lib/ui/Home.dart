import 'package:flutter/material.dart';
import 'package:profile_test/ui/widgets/common_scaffold.dart';
import './LocationList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './path.dart';
class ProfileTwoPage extends StatelessWidget {
  Size deviceSize;
  var cont;
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _conpany = new TextEditingController();
  TextEditingController _locations = new TextEditingController();

// --------------------------- profile Header (banner + name +profile pic, etc) ----------------------
  Widget profileHeader() => Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
          image: new NetworkImage(
              "http://sc01.alicdn.com/kf/UT8ECKhXzJaXXagOFbXh/200043761/UT8ECKhXzJaXXagOFbXh.jpg"),
          fit: BoxFit.cover,
        )),
        height: deviceSize.height / 3,
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
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjEPBnSuANA7WI9edlw0KrNjx892C-46LdnGZgtj9D8zLKduwm"),
                  ),
                ),
                Text(
                  "Ali Ahmed",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
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
  // ----------------- Info widget (Email, phone, company, Locations) -----------------------------------
  



// -------------------- building the scaffold -----------------------------
  @override
  Widget build(BuildContext context) {
    initState()
    {


    }
    _email.text = "ali@gmail.com";
    _phone.text = "+97334356868";
    _conpany.text = "Al Marhoon";
    _locations.text = "Manama , Isa Town";
    cont = context;
    _path()
    {
      MaterialPageRoute route = MaterialPageRoute(
    builder: (context)=>FlutterDemo(storage: CounterStorage())
  );
    Navigator.push(context, route);
      
    }
    
_editLocations()
{
  MaterialPageRoute route = MaterialPageRoute(
    builder: (context)=> Locations()
  );
  Navigator.push(context, route);
}
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
            child:new TextField(
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
    return CommonScaffold(
      appTitle: "Profile",
      bodyData: bodyData(),
      elevation: 0.0,
    );
  }
}
/*

*/

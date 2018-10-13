import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './Home.dart';
import './data/Firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GMaps extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GMapsState();
  }
}

class GMapsState extends State<GMaps> {
  Size deviceSize;
  var _stLoc = [];
  FirebaseUser user;
  Firestore firestore;
  void initState() {
    user = UserDetails.getUser();
    _getDetails().then((onValue) {
      //print("Loc = " + _stLoc.toString());
    });
  }

  /*
   void dispose() {
    mapController?.onMarkerTapped?.remove(_onMarkerTapped);
    super.dispose();
  }
  */
  Future _getDetails() async {
    _stLoc = [];
    await FirebaseConfig1.initFire(firestore).then((onValue) {
      /*
      Firestore.instance.collection("Students").document("S2").setData({
        "S_Home": {"Lat": "26.203140", "Long": "50.556839"},
        "S_Name": "Khalid isa",
        "S_Phone": "39747351"
      });
      Firestore.instance.collection("Assigned").document().setData({
        "C_ID": "223",
        "D_ID": "PurzGEW5lCXdHM6P2RbhEao1WVv1",
        "S_ID": "S2"
      });
      */
      Firestore.instance
          .collection('Assigned')
          .where("D_ID", isEqualTo: user.uid)
          .snapshots()
          .listen((data) {
        data.documents.forEach((doc) {
          print("S_ID =" + doc.data["S_ID"]);
          var _userID = doc.data["S_ID"];
          Firestore.instance
              .collection('Students')
              .document(_userID)
              .snapshots()
              .listen((data) {
            // print("Name:" + data.data["S_Home"]["P_Name"]);
            //_stLoc.add({"Lat":data.data["S_Home"]["Lat"],"Long":data.data["S_Home"]["Long"]});
            _stLoc.add(data.data);
            print(_stLoc);
            _stLoc.forEach((st) {
              _add(st["S_Home"]["Lat"], st["S_Home"]["Long"], st["S_Name"],
                  st["S_Phone"]);
            });
          });
        });
      });
      return true;
    });
  }

  GoogleMapController mapController;
  Marker _selectedMarker;
  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Map"),
        centerTitle: true,
      ),
      body:  Center(
        child: SizedBox(
            width: double.parse(deviceSize.width.toString()),
            height: double.parse(deviceSize.height.toString()),
            child: GoogleMap(
                onMapCreated: _onMapCreated,
                options: GoogleMapOptions(
                  showUserLocation: true,
                  compassEnabled: true,
                  tiltGesturesEnabled: true,
                  cameraPosition: const CameraPosition(
                    target: LatLng(26.2285, 50.5860),
                    zoom: 11.0,
                  ),
                ))))
    );
   
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.onInfoWindowTapped.add(_onInfoTapped);
    controller.onMarkerTapped.add(_onMarkerTapped);
    print(_stLoc);

    setState(() {
      mapController = controller;
    });
  }

  void _add(lat, long, name, phone) {
    mapController.addMarker(MarkerOptions(
      position: LatLng(
        double.parse(lat),
        double.parse(long),
      ),
      infoWindowText: InfoWindowText(name, 'Phone number:' + phone),
    ));
    setState(() {});
  }

  _onInfoTapped(Marker marker) {
    MaterialPageRoute P = new MaterialPageRoute(
      builder: (context) => PlaceholderWidget(Colors.yellow),
    );
    Navigator.push(context, P);
  }

  void _onMarkerTapped(Marker marker) {
    print(_selectedMarker);
    if (_selectedMarker != null) {
      _updateSelectedMarker(
        const MarkerOptions(icon: BitmapDescriptor.defaultMarker),
      );
    }
    setState(() {
      _selectedMarker = marker;
    });
    _updateSelectedMarker(
      MarkerOptions(
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
      ),
    );
  }

  void _updateSelectedMarker(MarkerOptions changes) {
    mapController.updateMarker(_selectedMarker, changes);
  }
}

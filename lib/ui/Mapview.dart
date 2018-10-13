import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import './widgets/common_scaffold.dart';
class Map extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
   return _Maps();
  }
 
  
}

class _Maps extends State<Map> {
  var mapProvider =
      new StaticMapProvider('AIzaSyBth-j1JK30_yCR8PtJgWHixcl020ILtNk');
     
  MapView mapView = new MapView();
 
  Uri staticMapUri;
  initState() {
    super.initState();
    var cameraPosition = new CameraPosition(Locations.centerOfUSA, 2.0);
    staticMapUri = mapProvider.getStaticUri(Locations.centerOfUSA, 12,
        width: 900, height: 400, mapType: StaticMapViewType.roadmap);
        
  }

  int _counter = 0;

  void _ShowMaps() {
    mapView.show(new MapOptions(
      mapViewType: MapViewType.normal,
      hideToolbar: false,
      showMyLocationButton: true,
      showUserLocation: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appTitle: "Map",
      
    );
  }
}

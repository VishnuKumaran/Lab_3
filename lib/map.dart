import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  String _currentAddress;

  //nak add marker
  List<Marker> allMarkers = [];
  addMarker(cordinate) {
    int id = Random().nextInt(100);

    setState(() {
      allMarkers.add(
        Marker(position: cordinate, markerId: MarkerId(id.toString())),
      );
      print(_currentAddress);
    });
  }

  @override
  void initState() {
    super.initState();
    //_getCurrentLocation();
    allMarkers.add(Marker(
      markerId: MarkerId('myMarker'),
      infoWindow: InfoWindow(title: 'Your are here now'),
      draggable: true,
      position: LatLng(6.4676929, 100.5067673),
    ));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * (2 / 3);
    return Scaffold(
      appBar: AppBar(
        
        title: Text(" GOOGLE MAP"),
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(6.4676929, 100.5067673), zoom: 17),
        mapType: MapType.normal,
        markers: Set.from(allMarkers),
        onTap: _untukMarker,
      ),
    );

  }
// untuk detect  current location yg user nak
  void _untukMarker(LatLng tappedPoint) {
    _getAddressFromLatLng(tappedPoint);
    print(tappedPoint);
    setState(() {
      allMarkers = [];
      allMarkers.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
    });
  }

  void _getAddressFromLatLng(tappedPoint) async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          tappedPoint.latitude, tappedPoint.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
        print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }
}

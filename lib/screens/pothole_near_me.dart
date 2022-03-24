import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:awaslubang/services/geolocator_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:awaslubang/screens/report_pothole.dart';

class PotholeNearMeScreen extends StatefulWidget {
  const PotholeNearMeScreen({Key? key}) : super(key: key);

  @override
  _PotholeNearMeState createState() => _PotholeNearMeState();
}

class _PotholeNearMeState extends State<PotholeNearMeScreen> {
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  final Set<Marker> markers = new Set();
  late GoogleMapController _controller;
  late Position location;

  void _onMapCreated(GoogleMapController _cntlr) async {
    location = await geolocatorService().determinePosition();
    _controller = _cntlr;
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(location.latitude, location.longitude), zoom: 25),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 47, 11, 131),
        systemNavigationBarColor: Color.fromARGB(255, 47, 11, 131)));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 47, 11, 131),
        title: Text(
          "Pothole Near Me",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w100),
        ),
      ),
      body: GoogleMap(
        // zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(target: _initialcameraposition),
        markers: getmarkers(),
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(ReportPotholeScreen(), arguments: [location]);
        },
        label: const Text('I Found a Hole!'),
        backgroundColor: Color.fromARGB(255, 47, 11, 131),
      ),
    );
  }

  Set<Marker> getmarkers() {
    //Latitude: 3.1096663, Longitude: 101.6693742

    setState(() {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId("custom_marker_1"),
        position: LatLng(3.1100000, 101.660000), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Marker Title First ',
          snippet: 'My Custom Subtitle',
        ),
        onTap: () {
          log("test");
        },
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });
    return markers;
  }
}

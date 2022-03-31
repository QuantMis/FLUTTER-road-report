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
import 'package:awaslubang/screens/take_picture.dart';

class ReportPotholeScreen extends StatefulWidget {
  const ReportPotholeScreen({Key? key}) : super(key: key);

  @override
  _ReportPotholeState createState() => _ReportPotholeState();
}

class _ReportPotholeState extends State<ReportPotholeScreen> {
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  final Set<Marker> markers = new Set();
  late GoogleMapController _controller;
  var location = Get.arguments[0];

  //report data
  late double _latitude;
  late double _longitude;

  void _onMapCreated(GoogleMapController _cntlr) async {
    var location = await geolocatorService().determinePosition();
    _latitude = location.latitude;
    _longitude = location.longitude;
    _controller = _cntlr;
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(location.latitude, location.longitude), zoom: 25),
      ),
    );
  }

  void _updatePosition(CameraPosition _position) {
    Position newMarkerPosition = Position(
        latitude: _position.target.latitude,
        longitude: _position.target.longitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0);

    var m =
        markers.firstWhere((p) => p.markerId == MarkerId('custom_marker_1'));
    markers.remove(m);
    markers.add(
      Marker(
        markerId: MarkerId('custom_marker_1'),
        position: LatLng(_position.target.latitude, _position.target.longitude),
        draggable: true,
      ),
    );
    setState(() {
      _latitude = _position.target.latitude;
      _longitude = _position.target.longitude;
    });
  }

  void _takePhoto() async {
    var address = await placemarkFromCoordinates(_latitude, _longitude);
    Get.to(TakePictureScreen(), arguments: [_latitude, _longitude, address]);
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
          "Pin Pothole Location",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w100),
        ),
      ),
      body: GoogleMap(
        // zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(location.latitude, location.longitude), zoom: 25),
        mapType: MapType.normal,
        markers: getmarkers(),
        // markers: Set<Marker>.of(
        //   <Marker>[
        //     Marker(
        //       draggable: true,
        //       markerId: MarkerId("1"),
        //       position: LatLng(location.latitude, location.longitude),
        //       icon: BitmapDescriptor.defaultMarker,
        //       infoWindow: const InfoWindow(
        //         title: 'Usted está aquí',
        //       ),
        //     )
        //   ],
        // ),
        onCameraMove: ((_position) => _updatePosition(_position)),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _takePhoto();
        },
        label: const Text('Take Photo'),
        backgroundColor: Color.fromARGB(255, 47, 11, 131),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          title: 'Is this the hole? ',
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

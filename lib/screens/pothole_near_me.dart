import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:awaslubang/services/geolocator_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:awaslubang/screens/report_pothole.dart';
import 'package:http/http.dart' as http;
import 'package:awaslubang/baseurl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

class PotholeNearMeScreen extends StatefulWidget {
  const PotholeNearMeScreen({Key? key}) : super(key: key);

  @override
  _PotholeNearMeState createState() => _PotholeNearMeState();
}

class _PotholeNearMeState extends State<PotholeNearMeScreen> {
  bool isLoading = true;
  bool isConnected = false;
  bool locationService = true;

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  Set<Marker> markers = new Set();
  late GoogleMapController _controller;
  late Position location;
  var aduans = [];

  late Uint8List customMarker;

  void _onMapCreated(GoogleMapController _cntlr) async {
    try {
      location = await geolocatorService().determinePosition();
      _controller = _cntlr;
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(location.latitude, location.longitude), zoom: 15),
        ),
      );
    } catch (e) {
      setState(() {
        locationService = false;
      });
    }
  }

  void _getPotholeNearMe() async {
    try {
      markers = new Set();
      var url = Uri.parse(Baseurl.staging + 'aduans/');
      var response = await http.get(url);

      setState(() {
        aduans = json.decode(response.body);
        log(aduans.toString());
        isLoading = false;
      });
    } on SocketException catch (_) {
      log('not connected');
    }
  }

  void _generateCustomMarker() async {
    customMarker = await getBytesFromAsset(
        path: 'assets/images/pothole.png', //paste the custom image path
        width: 80 // size of custom image as marker
        );
    setState(() {
      customMarker;
    });
  }

  void _checkLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        isLoading = true;
      });
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          isLoading = true;
        });
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        isLoading = true;
      });
    }
  }

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    _generateCustomMarker();
    _getPotholeNearMe();
    // _checkLocationService();

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
        leading: IconButton(
          icon: Icon(Icons.replay_outlined),
          onPressed: () {
            _getPotholeNearMe();
          },
        ),
        title: Text(
          "Pothole Near Me",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w100),
        ),
      ),
      body: isLoading
          ? Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 47, 11, 131)),
                height: 20.0,
                width: 20.0,
              ),
              SizedBox(width: 20),
              Text(
                "Please enable internet connection and \nlocation service",
              ),
            ]))
          : GoogleMap(
              // zoomGesturesEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: _initialcameraposition),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Set<Marker> getmarkers() {
    setState(() {
      for (int i = 0; i < aduans.length; i++)
        markers.add(Marker(
          markerId: MarkerId("custom_marker_${i}"),
          position: LatLng(double.parse(aduans[i]['latitude']),
              double.parse(aduans[i]['longitude'])), //position of marker
          infoWindow: InfoWindow(
            title: aduans[i]['alamat'],
            snippet: 'Tap again to view',
          ),
          onTap: () {
            log("http://admin.awaslubang.com/storage/${aduans[i]['gambar']}");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    content: Container(
                  padding: EdgeInsets.all(0),
                  width: 500,
                  height: 300,
                  child: Image.network(
                    "http://admin.awaslubang.com/storage/${aduans[i]['gambar']}",
                    width: 500,
                    height: 300,
                    fit: BoxFit.fill,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return const Center(child: Text(" "));
                    },
                  ),
                ));
              },
            );
          },
          icon: BitmapDescriptor.fromBytes(customMarker), //Icon for Marker
        ));
    });
    return markers;
  }
}

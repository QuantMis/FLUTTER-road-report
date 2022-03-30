import 'package:awaslubang/screens/pothole_near_me.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awaslubang/screens/base.dart';
import 'package:awaslubang/screens/pothole_near_me.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:awaslubang/screens/take_picture.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Awas Lubang',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backwardsCompatibility: false, // 1
            systemOverlayStyle: SystemUiOverlayStyle.light, // 2
          ),
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/",
        getPages: [GetPage(name: "/", page: () => PotholeNearMeScreen())]);
  }
}

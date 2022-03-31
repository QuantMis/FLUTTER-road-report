import 'package:awaslubang/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:awaslubang/screens/pothole_near_me.dart';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    Timer(
        Duration(seconds: 1),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PotholeNearMeScreen())));
  }

  bool? checkValue = true;

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 249, 249, 250)));
    return Scaffold(
        body: Container(
            child: Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 64),
            child: FxText.h6(
              "Your report have been submitted",
              color: theme.colorScheme.onBackground,
              letterSpacing: 0.3,
              fontWeight: 600,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 64, bottom: 64),
            child: Icon(
              MdiIcons.check,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ),
          FxText.sh2(
            "Thank You,\nThis report will be verified",
            color: theme.colorScheme.onBackground,
            letterSpacing: 0,
            fontWeight: 500,
            textAlign: TextAlign.center,
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[],
            ),
          ),
        ],
      ),
    )));
  }
}

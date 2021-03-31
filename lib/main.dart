import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:secure_messaging/view/ChatRoom.dart';
import 'package:secure_messaging/view/CreateRoom.dart';
import 'package:secure_messaging/view/JoinRoom.dart';
import 'package:secure_messaging/view/Loading.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:convert';

import 'controller/AppThemeController.dart';
import 'data/BackendServer.dart';

void main() {
  runApp(MyApp());
}

ThemeData _darkTheme = ThemeData(
  visualDensity: VisualDensity.standard,
  accentColor: Colors.purple,
  brightness: Brightness.dark,
  primaryColor: Colors.purple,
  backgroundColor: Colors.white,
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline6: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.red),
    bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'Hind', color: Colors.white),
  ),
);

ThemeData _lightTheme = ThemeData(
  visualDensity: VisualDensity.standard,
  accentColor: Colors.deepPurple,
  brightness: Brightness.light,
  primaryColor: Colors.deepPurple,
  backgroundColor: Colors.black38,
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black),
    headline6: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.red),
    bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'Hind', color: Colors.black),
  ),
);

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _appTheme = false;
  var currentRoute = 0;
  var possibleRoutes = [
    Loading(false, 'Please wait while the app loads'),
    CreateRoom(),
    JoinRoom(),
    ChatRoom(),
  ];

  @override
  void initState() {
    super.initState();
    _handleAppTheme();
    setState(() {
      possibleRoutes[1] = CreateRoom(
        changeCurrentScreen: (routeID) {
          _changeRoute(routeID);
        },
      );
      possibleRoutes[2] = JoinRoom(changeCurrentScreen: (routeID) {
        _changeRoute(routeID);
      });
      possibleRoutes[3] = ChatRoom(changeCurrentScreen: (routeID) {
        _changeRoute(routeID);
      });
      currentRoute = 1;
    });
  }

  void _changeRoute(int routeID) {
    setState(() {
      currentRoute = routeID;
    });
  }

  void _changeTheme(bool value) {
    setState(() {
      _appTheme = value;
    });
    AppThemeController.saveAppTheme(value);
  }

  void _handleAppTheme() async {
    bool appTheme = await AppThemeController.getSavedAppTheme();
    setState(() {
      _appTheme = appTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _appTheme ? _darkTheme : _lightTheme,
      debugShowCheckedModeBanner: false,
      title: "Secure Messaging",
      home: Scaffold(
        body: Stack(
          children: [
            possibleRoutes[currentRoute],
            Positioned(
              top: 20.0,
              right: 20.0,
              child: DayNightSwitcherIcon(
                isDarkModeEnabled: _appTheme,
                onStateChanged: (isDarkModeEnabled) {
                  setState(() {
                    _appTheme = isDarkModeEnabled;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

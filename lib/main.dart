import 'package:flutter/material.dart';
import 'package:secure_messaging/view/ChatRoom.dart';
import 'package:secure_messaging/view/CreateRoom.dart';
import 'package:secure_messaging/view/JoinRoom.dart';
import 'package:secure_messaging/view/Loading.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:convert';

import 'data/BackendServer.dart';

void main() {
  runApp(MyApp());

  client.activate();
}

StompClient client = StompClient(config: StompConfig.SockJS(url: 'https://securemessaging.codingshadows.com/gs-guide-websocket', onConnect: onConnectCallback));

void onConnectCallback(StompFrame connectFrame) {
  // client is connected and ready
  print("connect callback");
  client.subscribe(
      destination: '/topic/greetings/aaaaaa',
      headers: {},
      callback: (frame) {
        // Received a frame for this subscription
        print(frame.body);
      });
}

ThemeData _darkTheme = ThemeData(
  visualDensity: VisualDensity.standard,
  accentColor: Colors.red,
  brightness: Brightness.dark,
  primaryColor: Colors.amber,
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline6: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.red),
    bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'Hind', color: Colors.white),
  ),
);

ThemeData _lightTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  accentColor: Colors.red,
  brightness: Brightness.light,
  primaryColor: Colors.cyan,
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
    setState(() {
      possibleRoutes[1] = CreateRoom(changeCurrentScreen: (routeID) {
        _changeRoute(routeID);
      });
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _lightTheme,
      debugShowCheckedModeBanner: false,
      title: "Secure Messaging",
      home: possibleRoutes[currentRoute],
    );
  }
}

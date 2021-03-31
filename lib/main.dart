import 'package:flutter/material.dart';
import 'package:secure_messaging/view/CreateRoom.dart';
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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Secure Messaging",
      home: CreateRoom(),
    );
  }
}

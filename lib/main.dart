import 'package:flutter/material.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
// webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'}));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

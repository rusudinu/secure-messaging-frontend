import 'package:flutter/material.dart';
import 'package:secure_messaging/data/ConnectionData.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatRoom extends StatefulWidget {
  final Function changeCurrentScreen;

  const ChatRoom({Key key, this.changeCurrentScreen}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  StompClient client;
  var messages = [];

  @override
  void initState() {
    client = StompClient(config: StompConfig.SockJS(url: 'https://securemessaging.codingshadows.com/gs-guide-websocket', onConnect: onConnectCallback));
    client.activate();
    super.initState();
  }

  void onConnectCallback(StompFrame connectFrame) {
    // client is connected and ready
    print("connect callback");
    client.subscribe(
        destination: '/topic/greetings/' + ConnectionData.roomID,
        headers: {},
        callback: (frame) {
          // Received a frame for this subscription
          print(frame.body);
          //todo parse the body with the json trickery
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

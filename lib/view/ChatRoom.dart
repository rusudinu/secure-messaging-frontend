import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final Function changeCurrentScreen;

  const ChatRoom({Key key, this.changeCurrentScreen}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

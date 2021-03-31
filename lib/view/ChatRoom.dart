import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secure_messaging/behaviours/ScrollBehaviourNoOverflow.dart';
import 'package:secure_messaging/controller/GenerateStringHash.dart';
import 'package:secure_messaging/data/ConnectionData.dart';
import 'package:secure_messaging/model/Message.dart';
import 'package:secure_messaging/widget/MessageWidget.dart';
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
  FocusNode _messageFocusNode = FocusNode();
  final _messageController = TextEditingController();
  double screenWidth, screenHeight;
  StompClient client;
  List<Message> _messages = [];

  @override
  void initState() {
    ConnectionData.userID = GenerateRoomID.generateStringHash(20);
    client = StompClient(config: StompConfig.SockJS(url: 'https://securemessaging.codingshadows.com/gs-guide-websocket', onConnect: onConnectCallback));
    client.activate();
    super.initState();
  }

  void onConnectCallback(StompFrame connectFrame) {
    client.subscribe(
        destination: '/topic/greetings/' + ConnectionData.roomID,
        headers: {},
        callback: (frame) {
          final parsed = jsonDecode(frame.body).cast<String, dynamic>();
          Message message = Message.fromJson(parsed);
          _messages.add(message);
          setState(() {});
        });
  }

  void _sendMessage() {
    if (_messageController.text.trim().length > 0) {
      Message message = new Message(messageText: _messageController.text.trim(), seen: false, senderID: ConnectionData.userID);
      client.send(destination: '/app/hello/' + ConnectionData.roomID, body: jsonEncode(message.toJson()), headers: {});
      _messageController.clear();
      _messageFocusNode.requestFocus();
      setState(() {
        _messageController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                height: screenHeight - 80,
                width: double.infinity,
                child: ScrollConfiguration(
                  behavior: ScrollBehaviorNoOverflow(), //REMOVES THE SCROLL OVERFLOW
                  child: ListView.builder(
                    reverse: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      return MessageWidget(
                        key: UniqueKey(),
                        message: _messages[_messages.length - 1 - i],
                      );
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 60,
                    width: screenWidth - 60,
                    child: TextField(
                      focusNode: _messageFocusNode,
                      onSubmitted: (String data) {
                        _sendMessage();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        hintText: 'Type your message here',
                        hintStyle: TextStyle(color: Theme.of(context).accentColor),
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Theme.of(context).accentColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      controller: _messageController,
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    child: ElevatedButton(
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Icon(Icons.send_rounded),
                      ),
                      onPressed: _sendMessage,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey, // background
                        onPrimary: Colors.white, // fore
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(80.0),
                        ), // ground
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

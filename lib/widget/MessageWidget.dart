import 'package:flutter/material.dart';
import 'package:secure_messaging/data/ConnectionData.dart';
import 'package:secure_messaging/model/Message.dart';

class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 0, bottom: 5),
      child: Align(
        alignment: (message.senderID == ConnectionData.userID
            ? Alignment.topRight
            : message.senderID == "server"
                ? Alignment.center
                : Alignment.topLeft),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (message.senderID == ConnectionData.userID
                ? Theme.of(context).accentColor
                : message.senderID == "server"
                    ? Colors.transparent
                    : Theme.of(context).accentColor),
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            message.messageText,
            style: message.senderID == "server" ? TextStyle(fontSize: 12, color: Colors.blueGrey[200], fontWeight: FontWeight.bold) : TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

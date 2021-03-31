import 'package:flutter/material.dart';
import 'package:secure_messaging/model/Message.dart';

class MessageSent extends StatelessWidget {
  final Message message;

  const MessageSent({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(message.messageText),
    );
  }
}

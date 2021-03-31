import 'package:flutter/material.dart';
import 'package:secure_messaging/controller/GenerateRoomID.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CreateRoom extends StatefulWidget {
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final _usernameController = TextEditingController();
  final _roomIDController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateRoomID();
  }

  _generateRoomID() {
    _roomIDController.text = GenerateRoomID.generateRoomID(12);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // This makes the blue container full width.
                    Expanded(
                      child: Container(
                        height: 100.0,
                        child: Center(
                          child: Container(
                            width: 250.0,
                            child: Column(
                              children: [
                                TextField(
                                  enabled: false,
                                  decoration: InputDecoration(hintText: 'Room ID', labelText: 'Room ID', hintStyle: TextStyle(color: Theme.of(context).primaryColor), border: InputBorder.none),
                                  keyboardType: TextInputType.text,
                                  controller: _roomIDController,
                                ),
                                // TextField(
                                //   autofocus: true,
                                //   decoration: InputDecoration(hintText: 'This is your username', hintStyle: TextStyle(color: Theme.of(context).primaryColor), border: InputBorder.none),
                                //   keyboardType: TextInputType.text,
                                //   controller: _usernameController,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SlidingUpPanel(
            minHeight: 50,
            collapsed: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: Center(
                child: Text(
                  "Please Read (Pull Up)",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            panel: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                    "Please be careful how you handle the room code. If someone else gets access to the room code, while you are still talking in the room, they will be able to see what you type. You will be able to see the number of connected persons, shown as a number in the top right corner. For example: if there are two connected persons in the room, you will see a \"2\" in the top right corner of the app. If there are more persons connected, compared to the expected number (number of persons you invited), then your room was compromised.\n\nWhy is this app better compared to other messaging apps?\nThis chat app works on a different principle compared to the others. The messages are never stored, neither on the server, neither on your phone. Messages are sent as a broadcast trough an encrypted tunnel, to all the meeting participants. Similar to an encrypted radio signal."),
              ),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
        ],
      ),
    );
  }
}

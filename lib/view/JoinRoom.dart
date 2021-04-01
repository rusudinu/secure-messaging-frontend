import 'package:flutter/material.dart';
import 'package:secure_messaging/behaviours/ScrollBehaviourNoOverflow.dart';
import 'package:secure_messaging/data/ConnectionData.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class JoinRoom extends StatefulWidget {
  final Function changeCurrentScreen;

  const JoinRoom({Key key, this.changeCurrentScreen}) : super(key: key);

  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final _roomIDController = TextEditingController();

  _joinRoom() {
    ConnectionData.roomID = _roomIDController.text;
    widget.changeCurrentScreen(3);
  }

  _createRoom() {
    widget.changeCurrentScreen(1);
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 100.0,
                            child: Center(
                              child: Container(
                                width: 250.0,
                                child: Column(
                                  children: [
                                    TextField(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                child: Text("Join Room"),
                                onPressed: _joinRoom,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                              ),
                              ElevatedButton(
                                child: Text("Create Room"),
                                onPressed: _createRoom,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SlidingUpPanel(
            backdropEnabled: true,
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
            panelBuilder: (ScrollController sc) => _scrollingList(sc),
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

Widget _scrollingList(ScrollController sc) {
  return ListView(
    controller: sc,
    children: [
      Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
              "Please be careful how you handle the room code. If someone else gets access to the room code, while you are still talking in the room, they will be able to see what you type. You will be able to see the number of connected persons, shown as a number in the top center part of the chat room. For example: if there are two connected persons in the room, you will see a \"2\" in the top center of the app. If there are more persons connected, compared to the expected number (number of persons you invited), then your room was compromised. Please note that: this number will be decremented, as users disconnect.\n\nWhy is this app better compared to other messaging apps?\nThis chat app works on a different principle compared to the others. The messages are never stored, neither on the server, neither on your phone. Messages are sent as a broadcast trough an encrypted tunnel, to all the meeting participants. Similar to an encrypted radio signal. Hence, when you disconnect from the broadcast, you won't have any message history, nor will you be able to receive new messages until you reconnect.\n\nIf you want to join an existing room, you will be redirected to a new screen, where you will enter the room ID."),
        ),
      ),
    ],
  );
}

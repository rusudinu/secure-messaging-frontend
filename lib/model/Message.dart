class Message {
  String senderID;
  bool seen;
  String seenList;
  String messageText;

  Message({this.senderID, this.seen, this.seenList, this.messageText});

  Map<String, dynamic> toJson() => {
        'senderID': senderID,
        'seen': seen,
        'seenList': seenList,
        'messageText': messageText,
      };

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderID: json['senderID'],
      seen: json['seen'],
      seenList: json['seenList'],
      messageText: json['messageText'],
    );
  }
}

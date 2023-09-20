import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  String id;
  String lastMessage;
  String lastMessageID;
  String lastMessageBy;
  Timestamp timestamp;
  List<String> users;
  ChatRoom(this.id, this.lastMessage, this.lastMessageID, this.lastMessageBy,
      this.timestamp, this.users);
}

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String id;
  String sender;
  String content;
  String type;
  Timestamp timestamp;
  ChatMessage(this.id, this.sender, this.content, this.type, this.timestamp);
}

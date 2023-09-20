import 'package:cloud_firestore/cloud_firestore.dart';

class EventID {
  String docID;
  String eID;
  Timestamp timestamp;
  EventID(this.docID,this.eID,this.timestamp);
}

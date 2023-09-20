import 'package:app/models/swipe_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMatch {
  String matchID;
  String userID;
  NewMatch(this.matchID, this.userID);
}

class NewMatch1 {
  String matchID;
  String userID;
  SwipeModal sm;
  String status;
  NewMatch1(this.matchID, this.userID, this.sm, this.status);
}

class UserMatch {
  String matchID;
  String mainUser;
  String otherUser;
  Timestamp timestamp;
  String status;
  UserMatch(
    this.matchID,
    this.mainUser,
    this.otherUser,
    this.timestamp,
    this.status,
  );
}

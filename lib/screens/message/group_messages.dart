// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:app/constants.dart';
import 'package:app/models/chat_room.dart';
import 'package:app/screens/message/group_notifybubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupMessages extends StatefulWidget {
  const GroupMessages({Key? key}) : super(key: key);

  @override
  State<GroupMessages> createState() => _GroupMessagesState();
}

class _GroupMessagesState extends State<GroupMessages> {
  List<ChatRoom> getRooms(AsyncSnapshot snapshot) {
    List<ChatRoom> chatrooms = [];
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      chatrooms = snapshot.data.docs.map<ChatRoom>((doc) {
        List<String> users = [];
        List<dynamic> us = doc.data()['users'];
        us.forEach((element) {
          users.add(element.toString());
        });
        return ChatRoom(
          doc.id,
          doc.data()['lastMessage'] ?? "",
          doc.data()['lastMessageID'] ?? "",
          doc.data()['lastMessageBy'] ?? "",
          doc.data()['timestamp'] ?? Timestamp.now(),
          users,
        );
      }).toList();
    }
    return chatrooms;
  }

  List<Widget> getChildren(List<ChatRoom> rooms) {
    List<Widget> children = [];
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (int i = 0; i < rooms.length; i++) {
        DateTime dt = rooms[i].timestamp.toDate();
        String fTD = "${dt.hour}:${dt.minute}";
        children.add(
          GroupNotifyBubble(
            rooms[i].lastMessage,
            dt.toString(),
            rooms[i].id,
          ),
        );
      }
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final Stream<QuerySnapshot> chatRoomsStream = FirebaseFirestore.instance
        .collection("chatRooms")
        .where("users", arrayContains: user!.uid)
        .where("type", isEqualTo: 'event') 
        .snapshots();
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          List<ChatRoom> rooms = getRooms(snapshot);
          return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getChildren(rooms),
            );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: blackColor,
            ),
          );
        }
      },
    );
  }
}

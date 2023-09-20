// ignore_for_file: must_be_immutable, avoid_print, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:app/constants.dart';
import 'package:app/models/admin/create_groupevent.dart';
import 'package:app/screens/admin/group_details.dart';
import 'package:app/screens/video/video_call.dart';
import 'package:app/widgets/admin_custom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/chat_message.dart';


class GroupChat extends StatefulWidget {
  final CreateGroupEvent event;
  const GroupChat(this.event, {Key? key}) : super(key: key);
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  TextEditingController textController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  List<ChatMessage> getMessages(AsyncSnapshot snapshot) {
    List<ChatMessage> messages = [];
    messages = snapshot.data.docs.map<ChatMessage>((doc) {
      return ChatMessage(
        doc.id,
        doc.data()['sender'],
        doc.data()['content'],
        doc.data()['type'],
        doc.data()['timestamp'],
      );
    }).toList();
    return messages;
  }

  List<Widget> getChildren(List<ChatMessage> messages) {
    List<Widget> children = [];
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (int i = 0; i < messages.length; i++) {
        DateTime dt = messages[i].timestamp.toDate();
        String fTD = "${dt.year}/${dt.month}/${dt.day} ${dt.hour}:${dt.minute}";
        if (messages[i].sender == user.uid) {
          children.add(
            RightBubble(
              msg: messages[i].content,
              time: fTD,
            ),
          );
        } else {
          children.add(
            LeftBubble(
              msg: messages[i].content,
              time: fTD,
            ),
          );
        }
      }
    }
    return children;
  }

  void sendMessage() {
    if (textController.text.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !loading) {
        loading = true;
        WriteBatch batch = FirebaseFirestore.instance.batch();
        Timestamp timestamp = Timestamp.now();
        String messageID =
            FirebaseFirestore.instance.collection("chatMessages").doc().id;

        batch.update(
          FirebaseFirestore.instance
              .collection("chatRooms")
              .doc(widget.event.eventID),
          {
            'lastMessageBy': user.uid,
            'lastMessage': textController.text,
            'lastMessageID': messageID,
            'timestamp': timestamp,
          },
        );
        batch.set(
          FirebaseFirestore.instance
              .collection("chatMessages")
              .doc(widget.event.eventID)
              .collection("Messages")
              .doc(messageID),
          {
            'sender': user.uid,
            'content': textController.text,
            'type': 'text',
            'timestamp': timestamp,
          },
        );
        batch.commit().then((value) {
          textController.clear();
          loading = false;
        }).catchError(
          (onError) {
            log("Error");
          },
        );
      }
    }
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  Widget getBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: goBack,
      color: Colors.white,
    );
  }

  List<Widget> getActions() {
    List<Widget> actions = [];
    actions.add(
      IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_){
            return VideoCall(widget.event.eventID);
          }));
        },
        icon: const Icon(
          Icons.video_call,size: 30 ,
          color: Colors.white,
        ),
      ),
    );
    return actions;
  }

  void selectGroup(CreateGroupEvent group) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_){
      return GroupDetails(group);
    }));
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> messagesStream = FirebaseFirestore.instance
        .collection("chatMessages")
        .doc(widget.event.eventID)
        .collection("Messages")
        .orderBy('timestamp', descending: true)
        .snapshots();
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: PreferredSize(
          child: GestureDetector(
            onTap: () => selectGroup(widget.event),
            child: AdminCustomAppBar(
                getBackButton(), widget.event.eventName, getActions(), widget.event.iconURL),
          ),
          preferredSize: Size(MediaQuery.of(context).size.width, adminAppBarHeight),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: messagesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      List<ChatMessage> messages = getMessages(snapshot);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          reverse: true,
                          children: getChildren(messages),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black87,
                        ),
                      );
                    }
                  }),
            ),
            SizedBox(
              height: 56,
              child: ListTile(
                title: TextField(
                  controller: textController,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  cursorColor: Colors.black87,
                  decoration: InputDecoration(
                    hintText: "Say Something....",
                    hintStyle: const TextStyle(
                      color: Colors.black87,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xffD5DDE0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xffD5DDE0),
                      ),
                    ),
                  ),
                ),
                trailing: GestureDetector(
                  onTap: sendMessage,
                  child: const Icon(
                    Icons.send,
                    color: blackColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeftBubble extends StatefulWidget {
  var msg;
  var emoji;
  var time;

  LeftBubble({
    Key? key,
    this.msg,
    this.emoji,
    this.time,
  }) : super(key: key);

  @override
  _LeftBubbleState createState() => _LeftBubbleState();
}

class _LeftBubbleState extends State<LeftBubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration:  BoxDecoration(
              color: const Color(0xffF7F8F9),
              border: Border.all(color: blackColor, width: 0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Text(
              widget.msg,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xff3E4958),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.time,
            style: const TextStyle(
              color: Color(0xff97ADB6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class RightBubble extends StatefulWidget {
  var msg;
  var emoji;
  var time;

  RightBubble({
    Key? key,
    this.msg,
    this.emoji,
    this.time,
  }) : super(key: key);

  @override
  _RightBubbleState createState() => _RightBubbleState();
}

class _RightBubbleState extends State<RightBubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration: BoxDecoration(
                    border: Border.all(color: blackColor, width: 0.5),
              color: const Color(0xffF7F8F9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              widget.msg,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xff97ADB6),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.time,
            style: const TextStyle(
              color: Color(0xff97ADB6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class EmojiClass extends StatefulWidget {
  const EmojiClass({Key? key}) : super(key: key);

  @override
  _EmojiClassState createState() => _EmojiClassState();
}

class _EmojiClassState extends State<EmojiClass> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration: const BoxDecoration(
              color: Color(0xffF7F8F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: const Icon(
              Icons.emoji_emotions,
              color: Colors.amber,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "8:38 AM",
            style: TextStyle(
              color: Color(0xff97ADB6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

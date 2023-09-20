// ignore_for_file: must_be_immutable, avoid_print, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:app/constants.dart';
import 'package:app/screens/message/chat_bar.dart';
import 'package:app/widgets/join_call_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/chat_message.dart';


class Chat extends StatefulWidget {
  final String chatRoomID;
  final String matchId;
  const Chat(this.chatRoomID, this.matchId, {Key? key}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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
        //children.add(MessageBubble(messages[i], user.uid));
        
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
              .doc(widget.chatRoomID),
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
              .doc(widget.chatRoomID)
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

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> messagesStream = FirebaseFirestore.instance
        .collection("chatMessages")
        .doc(widget.chatRoomID)
        .collection("Messages")
        .orderBy('timestamp', descending: true)
        .snapshots();
    return Scaffold(
      backgroundColor: greenBackgroundColor,
      appBar: PreferredSize(
        child: ChatBar(widget.matchId, widget.chatRoomID),
        preferredSize: Size.fromHeight(Constants.appBarPreferredHeight),
      ),
      body: Column(
        children: [
          JoinCallWidget(widget.chatRoomID, widget.matchId),
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
                        color: lightGoldColor,
                      ),
                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: SizedBox(
              height: 56,
              child: ListTile(
                title: TextField(
                  controller: textController,
                  style:GoogleFonts.poppins(
                    fontSize: 13,
                    color: whiteColor,
                  ),
                  cursorColor: lightGoldColor,
                  decoration: InputDecoration(
                    hintText: "Say Something....",
                    hintStyle: GoogleFonts.poppins(
                      color: whiteColor,
                    ),
                    filled: true,
                    fillColor: lightGreenColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide( width: 0,),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide( width: 0,

                      ),
                    ),
                  ),
                ),
                trailing: GestureDetector(
                  onTap: sendMessage,
                  child: const Icon(
                    Icons.send,
                    color: Color(0xff97ADB6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatefulWidget {
  final ChatMessage cm;
  final myUserID;
  const MessageBubble(this.cm, this.myUserID, {Key? key}) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool isLeft = false;
  DateTime dt = DateTime.now();
  @override
  void initState() {
    super.initState();
    if (widget.myUserID != widget.cm.sender) {
      isLeft = true;
    }
    dt = widget.cm.timestamp.toDate();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Column(
        crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration:  BoxDecoration(
              border: Border.all(color: blackColor, width: 0.5),
              color: whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: isLeft ? const Radius.circular(0) : const Radius.circular(10),
                topRight: isLeft ? const Radius.circular(10) : const Radius.circular(0),
                bottomLeft: const Radius.circular(10),
                bottomRight: const Radius.circular(10),
              ),
            ),
            child: Text(
              widget.cm.content,
              style: TextStyle(
                fontSize: 15,
                color: isLeft ? const Color(0xff3E4958) : const Color(0xff97ADB6),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${dt.year}/${dt.month}/${dt.day} ${dt.hour}:${dt.minute}",
            style: TextStyle(
              color: isLeft ? const Color(0xff3E4958) : const Color(0xff97ADB6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class LeftBubble extends StatefulWidget {
  String? msg;
  var emoji;
  var time;

  LeftBubble({Key? key, 
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
              border: Border.all(color: blackColor, width: 0.5),
              color: whiteColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              widget.msg!,
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
  String? msg;
  var emoji;
  var time;

  RightBubble({Key? key, 
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
            decoration:  BoxDecoration(
                border: Border.all(color: blackColor, width: 0.5),
              color: whiteColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              widget.msg!,
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

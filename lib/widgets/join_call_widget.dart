import 'dart:developer';

import 'package:app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../screens/video/video_call.dart';

class JoinCallWidget extends StatefulWidget {
  final String chatRoomID;
  final String otherUser;
  const JoinCallWidget(this.chatRoomID, this.otherUser, {Key? key})
      : super(key: key);

  @override
  State<JoinCallWidget> createState() => _JoinCallWidgetState();
}

class _JoinCallWidgetState extends State<JoinCallWidget> {
  bool processSnap(AsyncSnapshot snapshot) {
    bool result = false;
    try {
      result = snapshot.data['isVideo'];
    } catch (e) {
      result = false;
    }
    return result;
  }

  void joinCall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return VideoCall(widget.chatRoomID);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> joinCallStream =
        FirebaseFirestore.instance
            .collection("chatRooms")
            .doc(widget.chatRoomID)
            .snapshots();
    return StreamBuilder(
      stream: joinCallStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          bool join = processSnap(snapshot);
          return join
              ? Container(
                  color: lightPurpleColor,
                  child: ListTile(
                    onTap: joinCall,
                    leading: const Icon(
                      Icons.video_call_rounded,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Join Call",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.black,
                    ),
                  ),
                )
              : Container();
        } else {
          return Container();
        }
      },
    );
  }
}

// ignore_for_file: file_names, avoid_print

import 'dart:developer';

import 'package:app/constants.dart';
import 'package:app/models/match_photo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../reports.dart';
import '../video/video_call.dart';

class ChatBar extends StatefulWidget {
  final String matchId;
  final String chatRoomID;
  const ChatBar(this.matchId, this.chatRoomID, {Key? key}) : super(key: key);

  @override
  _ChatBarState createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  Future<MatchPhotoModel> getMatch() async {
    MatchPhotoModel pm = MatchPhotoModel("", "", "");
    await FirebaseFirestore.instance
        .collection("profile")
        .doc(widget.matchId)
        .get()
        .then((doc) {
      pm = MatchPhotoModel(
        doc.id,
        doc.data()!['firstname'].toString(),
        doc.data()!['profileURL'].toString(),
      );
    }).catchError((onError) {
      log("Error");
    });
    return pm;
  }

  void startVideoCall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return VideoCall(widget.chatRoomID);
        },
      ),
    );
  }


  void goToReports(name) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Reports(name: name,);
    }));
  }


  void block() {
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMatch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            MatchPhotoModel pm = snapshot.data as MatchPhotoModel;
            return AppBar(
              //toolbarHeight: 60,
              backgroundColor: greenBackgroundColor,
              elevation: 2,
              centerTitle: true,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(pm.photoURL),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    pm.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: whiteColor),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: startVideoCall,
                  icon: const Icon(Icons.video_call_rounded),
                ),
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ),
                  onSelected: (result) {
                    Navigator.of(context).pop();
                  },
                  itemBuilder: (BuildContext ctx) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: "report",
                      child: ListTile(
                        onTap: () {
                          goToReports(pm.name);
                          // report();
                        },
                        dense: true,
                        leading: const Icon(
                          Icons.warning_amber_rounded,
                        ),
                        title: const Text('Report'),
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: "block",
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Block ${pm.name}"),
                              content: Text("Are you sure?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("Yes"),
                                ),
                              ],
                            ),
                          );
                        },
                        dense: true,
                        leading: const Icon(
                          Icons.block_rounded,
                        ),
                        title: const Text('Block'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            );
            // Row(
            //   children: [
            //     Image.network(pm.photoURL),
            //     const SizedBox(width: 10,),
            //     MyTitle(text: pm.name,)

            //   ],
            // )

          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class AddFriendDialog extends StatelessWidget {

  AddFriendDialog({
    Key? key,
    @required required this.name,

  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height / 4,
      width: MediaQuery
          .of(context)
          .size
          .height / 1.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Text(
                  name,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 23,
                    color: Colors.black,
                    letterSpacing: 0.5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                width: MediaQuery
                    .of(context)
                    .size
                    .height /
                    1.5,
              ),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Column(
            children: [
              Container(
                width: 76,
                height: 32,
                padding: EdgeInsets.symmetric(
                    vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey,
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      '+',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      'Block',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 12,
              ),

              Text(
                'Dismiss',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

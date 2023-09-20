// ignore_for_file: must_be_immutable, file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print

import 'dart:developer';

import 'package:app/constants.dart';
import 'package:app/models/match_photo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotifyBubble extends StatefulWidget {
  final String title;
  final String time;
  final String matchId;
  final bool isVideo;
  const NotifyBubble(this.title, this.time, this.matchId, this.isVideo, {Key? key})
      : super(key: key);

  @override
  _NotifyBubbleState createState() => _NotifyBubbleState();
}

class _NotifyBubbleState extends State<NotifyBubble> {
  late Future getMatchFuture;

  @override
  void initState() {
    super.initState();
    getMatchFuture = getMatch();
  }


  Future<MatchPhotoModel> getMatch() async {
    MatchPhotoModel pm = MatchPhotoModel("", "", "");
    if (widget.matchId.isNotEmpty) {
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
    }
    return pm;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMatchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            MatchPhotoModel pm = snapshot.data as MatchPhotoModel;
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: lightGreenColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 25,
                      child: CircleAvatar(
                          radius: 23, backgroundImage: NetworkImage(pm.photoURL)),
                    ),
                    title: Text(pm.name,
                    style: GoogleFonts.poppins(color: whiteColor,fontWeight: FontWeight.w500),),
                    subtitle:
                     Text(widget.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                       style: GoogleFonts.poppins(color: whiteColor.withOpacity(0.5),fontSize: 12),),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(timeago.format(DateTime.parse(widget.time)),
                          style: GoogleFonts.poppins(color: whiteColor,fontWeight: FontWeight.w500, fontSize: 10),),
                        // Container(
                        //   padding: EdgeInsets.all(3),
                        //   decoration: BoxDecoration(
                        //     gradient: gradient,
                        //     shape: BoxShape.circle,
                        //   ),
                        //   child:  Text("2",
                        //     style: GoogleFonts.poppins(color: whiteColor,fontWeight: FontWeight.w500, fontSize: 10),),
                        // ),
                        if (widget.isVideo)
                        const Icon(Icons.video_call_rounded, color: lightGoldColor,)
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

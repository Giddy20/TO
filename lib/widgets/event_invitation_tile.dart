// ignore_for_file: avoid_print, unused_local_variable, unnecessary_null_comparison

import 'dart:developer';

import 'package:app/models/event_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventInvitationTile extends StatefulWidget {
  final String eventID;
  final String timestamp;
  const EventInvitationTile(this.eventID, this.timestamp,{ Key? key }) : super(key: key);

  @override
  State<EventInvitationTile> createState() => _EventInvitationTileState();
}



class _EventInvitationTileState extends State<EventInvitationTile> {
  late Future getEventInfo;

  @override
  initState() {
    super.initState();
    getEvent();
    getEventInfo = getEvent();
  }

  Future<EventInfo> getEvent() async {
    EventInfo eI = EventInfo("", "");
    await FirebaseFirestore.instance
    .collection("adminEvent")
    .doc(widget.eventID)
    .get()
    .then((doc) {
      eI = EventInfo( 
        doc.data()!['eventName'].toString(),
        doc.data()!['iconURL'].toString());
    }).catchError((onError) {
      log(onError);
    });
    return eI;
  }
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return FutureBuilder(
      future: getEventInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          EventInfo? eID = snapshot.data as EventInfo;
          if (eID != null) {
            return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 27,
          child: CircleAvatar(
              radius: 25, 
              backgroundImage: NetworkImage(eID.profileURL),
              ),
        ),
        title: Text(eID.eventName),
        subtitle: const Text("You are invited by admin to join this group based on your interest."),
        trailing: Text(widget.timestamp
        ),);
          }  else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } 
        }  else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
      });
  }
}


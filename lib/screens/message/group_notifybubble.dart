// ignore_for_file: must_be_immutable, file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../models/admin/create_groupevent.dart';
import 'group_chat.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupNotifyBubble extends StatefulWidget {
  final String title;
  final String time;
  final eventID;
  const GroupNotifyBubble(this.title, this.time, this.eventID, {Key? key})
      : super(key: key);

  @override
  _GroupNotifyBubbleState createState() => _GroupNotifyBubbleState();
}

class _GroupNotifyBubbleState extends State<GroupNotifyBubble> {
  late Future getEventFuture;

  @override
  initState() {
    super.initState();
    getEventFuture = getEvent();
  }

  Future<CreateGroupEvent> getEvent() async {
    CreateGroupEvent event = CreateGroupEvent('', widget.eventID, '', '',
        DateTime.now(), DateTime.now(), '', '', '', '', '', '', '', []);
    await FirebaseFirestore.instance
        .collection("adminEvent")
        .doc(widget.eventID)
        .get()
        .then((doc) {
      if (doc.exists) {
        List<String> interests = [];
        List<dynamic> ints = doc.data()?['groupInterest'] ?? [];
        for (String interest in ints) {
          interests.add(interest);
        }
        DateTime startDate = (doc.data()!['startDate'] as Timestamp).toDate();
        DateTime endDate = (doc.data()!['endDate'] as Timestamp).toDate();
        String startsAt =
            (doc.data()!['startsAT'] as Timestamp).toDate().hour.toString();
        event.iconURL = doc.data()?['iconURL'] ?? "";
        event.groupName = doc.data()?['groupName'] ?? '';
        event.eventName = doc.data()?['eventName'] ?? '';
        event.startDate = startDate;
        event.endDate = endDate;
        event.startsAt = startsAt;
        event.eventLocation = doc.data()?['eventLocation'] ?? '';
        event.ticketPrice = doc.data()?['ticketPrice'] ?? '';
        event.minAge = doc.data()?['minAge'].toString() ?? '';
        event.maxAge = doc.data()?['maxAge'].toString() ?? '';
        event.country = doc.data()?['country'] ?? '';
        event.gender = doc.data()?['gender'] ?? '';
        event.interest = interests;
      }
    }).catchError((onError) {
      log(onError);
    });
    return event;
  }

  void tapped(CreateGroupEvent pm) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return GroupChat(pm);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getEventFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            CreateGroupEvent pm = snapshot.data as CreateGroupEvent;
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: lightGreenColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    onTap: () => tapped(pm),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(pm.iconURL),
                    ),
                    title: Text(
                      pm.eventName,
                      style: GoogleFonts.poppins(color: whiteColor,fontWeight: FontWeight.w500),),

                    subtitle: Text(widget.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(color: whiteColor.withOpacity(0.5),fontSize: 12),),
                    trailing:  Text(timeago.format(DateTime.parse(widget.time)),
                      style: GoogleFonts.poppins(color: whiteColor,fontWeight: FontWeight.w500, fontSize: 10),),
                  ),
                  // const Divider(
                  //   endIndent: 30,
                  //   indent: 30,
                  // )
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

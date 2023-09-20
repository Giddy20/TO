import 'package:app/constants.dart';
import 'package:app/models/admin/event_id.dart';
import 'package:app/widgets/event_invitation_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventInvitation extends StatefulWidget {
  const EventInvitation({Key? key}) : super(key: key);

  @override
  State<EventInvitation> createState() => _EventInvitationState();
}

class _EventInvitationState extends State<EventInvitation> {
  List<EventID> getEvents(AsyncSnapshot snapshot) {
    List<EventID> events = [];
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      events = snapshot.data.docs.map<EventID>((doc) {
        return EventID(
          doc.id,
          doc.data()['eventID'],
          doc.data()['timestamp'] ?? Timestamp.now(),
        );
      }).toList();
    }
    return events;
  }

  List<Widget> getEventsTile(List<EventID> eventID) {
    List<Widget> children = [];
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (int i = 0; i < eventID.length; i++) {
        DateTime dt = eventID[i].timestamp.toDate();
        String fTD = "${dt.hour}:${dt.minute}";
        String eventid = eventID[i].eID;
        String docID = eventID[i].docID;
        children.add(
          GestureDetector(
            onTap: () => showOptions(context, docID),
            child: EventInvitationTile(eventid, fTD),
          ),
        );
      }
    }
    return children;
  }

  Future<void> showOptions(BuildContext ctx, String id) async {
    return showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Column(
              children: const [
                Text(
                  'You are invited by admin to join this group based on your interests',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // content:
            //     const Text('Are you sure, you want to delete this ticker ?'),
            actions: [
              TextButton(
                child: const Text("Accept"),
                onPressed: () => acceptInvitation(ctx, id)
                ,
              ),
              TextButton(
                child: const Text('Decline'),
                onPressed: () => cancelDelete(ctx),
              )
            ],
          );
        });
  }

   void cancelDelete(BuildContext ctx) {
     Navigator.of(ctx).pop();
  }

  void acceptInvitation(BuildContext ctx, String id) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
      .collection("adminEventUsers")
      .doc(id)
      .set({"status": "accept"}, SetOptions(merge:true))
      .then((value) => {
        Navigator.of(ctx).pop(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final Stream<QuerySnapshot> eventChatRoom = FirebaseFirestore.instance
        .collection("adminEventUsers")
        .where("userID", isEqualTo: user!.uid)
        .where("status", isEqualTo: "added")
        .snapshots();
    return StreamBuilder(
        stream: eventChatRoom,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<EventID> events = getEvents(snapshot);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getEventsTile(events),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: whiteColor,
              ),
            );
          }
        });
  }
}

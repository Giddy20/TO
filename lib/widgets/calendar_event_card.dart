// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:app/models/admin/create_groupevent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CalendarEventCard extends StatelessWidget {
  final String eventID;
  const CalendarEventCard(this.eventID, {Key? key}) : super(key: key);

  Future<CreateGroupEvent> getEventDetails() async {
    CreateGroupEvent event = CreateGroupEvent("",eventID, '', '', DateTime.now(),
        DateTime.now(), '', '', '', '', '', '', '', []);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('adminEvent')
          .doc(eventID)
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
    }
    return event;
  }

  String getDates(CreateGroupEvent event) {
    String result = '';
    result =
        "${event.startDate.day} ${Constants.getMonthName(event.startDate.month)} ${event.startDate.year}";
    result += " - ";
    result +=
        "${event.endDate.day} ${Constants.getMonthName(event.endDate.month)} ${event.endDate.year}";
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getEventDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            CreateGroupEvent event = snapshot.data as CreateGroupEvent;
            return Card(
              child: ListTile(
                leading: const Icon(Icons.group_work_rounded),
                title: Text(
                  event.eventName,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getDates(event)),
                    Text(
                        "Starts ${Constants.getTimeText(int.parse(event.startsAt))}"),
                    Text(event.eventLocation),
                    Text(event.country),
                    Text("Ticket Price: ${event.ticketPrice}"),
                    const Text("Your Status: Unpaid"),
                    TextButton(
                      child: const Text(
                        "Pay Now",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
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

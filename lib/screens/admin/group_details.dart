// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:app/constants.dart';
import 'package:app/models/admin/create_groupevent.dart';
import 'package:app/screens/admin/group_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupDetails extends StatefulWidget {
  final CreateGroupEvent event;
  const GroupDetails(this.event, {Key? key}) : super(key: key);

  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  bool loading = false;
  List<String> users = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loading = true;
      });
      List<String> u = [];
      await FirebaseFirestore.instance
          .collection('adminEventUsers')
          .where('eventID', isEqualTo: widget.event.eventID)
          .get()
          .then((value) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          u.add(doc.data()['userID']);
        }
        setState(() {
          users = u;
          loading = false;
        });
      }).catchError((onError) {
        log(onError);
      });
    }
  }

  String convertDate(DateTime dt, String type) {
    String result = "";
    if (type == 'dateOnly') {
      result = dt.year.toString() + "/" + "0" + dt.month.toString() + "/" + dt.day.toString();
    }
    return result;
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  void removeUser(String userID) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loading = true;
      });
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('removeAdminEventUser');
      final results = await callable({'eventID': widget.event.eventID, 'userID': userID});
      if (results.data != 'error') {
        getUsers();
      } else {
        setState(() {
          loading = false;
        });
        Constants.showMessage(context, "Error, please try again later");
      }
    }
  }

  void deleteGroup() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loading = true;
      });
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteGroup');
      final results = await callable({'groupID': widget.event.eventID});
      if (results.data != 'error') {
        Navigator.of(context).pop();
      } else {
        setState(() {
          loading = false;
        });
        Constants.showMessage(context, "Error, please try again later");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: goldColor,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 60,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: goBack,
                    color: Colors.white,
                  ),
                  const Expanded(
                      child: Text(
                    "Group Details",
                    style: TextStyle(color: Colors.white),
                  )),
                ],
              ),
            ),
          ),
          preferredSize: Size(MediaQuery.of(context).size.width, 60),
        ),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       CircleAvatar(
                         radius: 40,
                        backgroundImage: NetworkImage(widget.event.iconURL),
                      ),
                      Text(
                        widget.event.eventName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: goldColor),
                      ),
                      GestureDetector(
                        onTap: deleteGroup,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.delete, color: goldColor,),
                              Text("Delete Group", style: TextStyle(color: goldColor),),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.edit, color: goldColor,),
                              Text("Edit Details", style: TextStyle(color: goldColor),),
                            ],
                          ),
                        ),
                      ),
                      Text(convertDate(widget.event.startDate, 'dateOnly'
                      ,) + " - " + convertDate(widget.event.endDate, 'dateOnly',)
                      , style: const TextStyle(
                        color: goldColor
                      ),),
                      Text('Starts at' + widget.event.startsAt, style: const TextStyle(color: goldColor),),
                      Text(widget.event.eventLocation, style: const TextStyle(color: goldColor),),
                       Text("Ticket Price: ${widget.event.ticketPrice}", style: const TextStyle(color: goldColor),),
                   ],
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${users.length} members",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: goldColor),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return GroupUser(users[index], removeUser);
                        }),
                  ),
                ],
              ),
      ),
    );
  }
}

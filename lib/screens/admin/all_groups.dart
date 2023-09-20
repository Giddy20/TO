// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:app/models/admin/create_groupevent.dart';
import 'package:app/screens/admin/createGroup/create_group.dart';
import 'package:app/screens/admin/group_details.dart';
import 'package:app/screens/admin/admin_side_nav.dart';
import 'package:app/screens/message/group_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AllGroups extends StatefulWidget {
  const AllGroups({Key? key}) : super(key: key);

  @override
  _AllGroupsState createState() => _AllGroupsState();
}

class _AllGroupsState extends State<AllGroups> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController groupNameController = TextEditingController();
  bool loading = false;
  List<CreateGroupEvent> events = [];

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  void selectGroup(CreateGroupEvent group) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_){
      return GroupDetails(group);
    }));
  }

    void goToCreateGroup() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const CreateGroup();
    }));
  }

  void getGroups() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loading = true;
      });
      List<CreateGroupEvent> evs = [];
      await FirebaseFirestore.instance
          .collection('adminEvent')
          .get()
          .then((value) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          List<String> interests = [];
          DateTime startDate = (doc.data()['startDate'] as Timestamp).toDate();
          DateTime endDate = (doc.data()['endDate'] as Timestamp).toDate();
          String startsAt =
              (doc.data()['startsAT'] as Timestamp).toDate().hour.toString();
          evs.add(
            CreateGroupEvent(
              doc.data()['iconURL'],
              doc.id,
              doc.data()['groupName'],
              doc.data()['eventName'],
              startDate,
              endDate,
              startsAt,
              doc.data()['eventLocation'],
              doc.data()['ticketPrice'],
              doc.data()['minAge'].toString(),
              doc.data()['maxAge'].toString(),
              doc.data()['country'],
              doc.data()['gender'],
              interests,
            ),
          );
        }
        setState(() {
          loading = false;
          events = evs;
        });
      }).catchError((onError) {
        log(onError);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AdminSideNav(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 16,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                        //   color: Colors.purple,
                        borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                              child: const Icon(Icons.menu,
                                  color: Colors.deepPurple),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'ALL GROUPS',
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        TextButton.icon(
                            onPressed: goToCreateGroup,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.deepPurple,
                            ),
                            label: const Text(
                              'Create Group',
                              style: TextStyle(color: Colors.deepPurple),
                            ))
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      ' Group For upcoming events:',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
                 const GroupMessages(),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: events.length,
                //     itemBuilder: (context, index) {
                //       return Card(
                //         child: ListTile(
                //           onTap: () => selectGroup(events[index]),
                //           leading: const Icon(Icons.group_work_rounded),
                //           title: Text(events[index].eventName),
                //           trailing: Text(events[index].startsAt),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                /*
                const ListTile(
                  leading: CircleAvatar(
                    backgroundImage: ExactAssetImage('assets/pic.jpg'),
                  ),
                  title: Text(
                    ' Premier League Final',
                    style: TextStyle(
                        color: pinkAccent, fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    ' Ken I dont like Arsenal lol!',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Text(
                    ' 08:00 PM ',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                const ListTile(
                  leading: CircleAvatar(
                    backgroundImage: ExactAssetImage('assets/pic.jpg'),
                  ),
                  title: Text(
                    ' Drake London Concert',
                    style: TextStyle(
                        color: pinkAccent, fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    ' Adam  I really love the idea',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Text(
                    ' 08:00 PM ',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                )
                */
              ],
            ),
    );
  }
}

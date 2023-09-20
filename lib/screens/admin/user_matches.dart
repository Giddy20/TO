// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:app/constants.dart';
import 'package:app/models/new_match.dart';
import 'package:app/screens/admin/match_card_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../widgets/custom_app_bar.dart';

class UserMatches extends StatefulWidget {
  final UserProfile selectedUser;
  const UserMatches(this.selectedUser, {Key? key}) : super(key: key);

  @override
  State<UserMatches> createState() => _UserMatchesState();
}

class _UserMatchesState extends State<UserMatches> {
  bool loading = false;
  List<UserMatch> matches = [];

  @override
  void initState() {
    super.initState();
    getMatches();
  }

  void getMatches() async {
    setState(() {
      loading = true;
    });
    List<UserMatch> ms = [];
    await FirebaseFirestore.instance
        .collection('Matches')
        .where('users', arrayContains: widget.selectedUser.userID)
        .orderBy("timestamp", descending: true)
        .get()
        .then((value) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
        List<dynamic> users = doc.data()['users'];
        for (int i = 0; i < users.length; i++) {
          if (users[i] != widget.selectedUser) {
            ms.add(
              UserMatch(
                doc.id,
                widget.selectedUser.userID,
                users[i],
                doc.data()['timestamp'],
                doc.data()['status'],
              ),
            );
          }
        }
      }
      setState(() {
        loading = false;
        matches = ms;
      });
    }).catchError((onError) {
      log(onError);
    });
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  Widget getBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: goBack,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: CustomAppBar(
              getBackButton(),
              "${widget.selectedUser.firstName} ${widget.selectedUser.lastName}'s matches",
              const []),
          preferredSize: Size(MediaQuery.of(context).size.width, appBarHeight),
        ),
        body: SafeArea(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    return MatchCardAdmin(matches[index]);
                  },
                ),
        ),
      ),
    );
  }
}

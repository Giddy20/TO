
import 'package:app/models/new_match.dart';
import 'package:app/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class MatchCardAdmin extends StatelessWidget {
  final UserMatch um;
  const MatchCardAdmin(this.um, {Key? key}) : super(key: key);

  Future<UserProfile> getProfile() async {
    UserProfile up = UserProfile(um.otherUser, '', '', '', '', Timestamp.now(), '', '', [],
    '','','','','','','','','','','','','','','','','','','','','','','', true);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      up = await Constants.getProfile(um.otherUser);
    }
    return up;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          UserProfile up = snapshot.data as UserProfile;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Matched on ${Constants.stringFromTimestamp(um.timestamp, 'justDate')}"),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: goldColor)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(up.profileURL),
                      backgroundColor: goldColor,
                    ),
                    title: Text("${up.firstName} ${up.lastName}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(up.locationText),
                        Text(Constants.stringFromTimestamp(up.dob, 'justDate'))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}

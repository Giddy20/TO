import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/user_profile.dart';

class UserForReview extends StatelessWidget {
  final String userID;
  final bool status;
  const UserForReview(this.userID, this.status, { Key? key }) : super(key: key);

  Future<UserProfile> getProfile() async {
    UserProfile up = UserProfile(userID, '', '', '', '', Timestamp.now(), '', '', [],
    '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
     '', '', true);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      up = await Constants.getProfile(userID);
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
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(up.profileURL),
                backgroundColor: goldColor,
              ),
              title: Text("${up.firstName} ${up.lastName}"),
              trailing: status ? const Icon(Icons.check) : const Icon(Icons.cancel),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
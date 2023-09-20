import 'package:app/constants.dart';
import 'package:app/screens/admin/review_about.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import 'about_.dart';

class AppUser extends StatelessWidget {
  final String userID;
  final bool status;
  final bool review;
  const AppUser(this.userID, this.status, this.review, {Key? key}) : super(key: key);

  Future<UserProfile> getProfile() async {
    UserProfile up =
        UserProfile(userID, '', '', '', '', Timestamp.now(), '', '', [],'','','','','','','','','','','','','','','','',
        '','','','','','','', true);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      up = await Constants.getProfile(userID);
    }
    return up;
  }

  void showProfile(BuildContext ctx, UserProfile up) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return About(up, status, true, );
    }));
  }

  void showReviewProfile(BuildContext ctx, UserProfile up) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return ReviewAbout(up, status, true, );
    }));
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
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: goldColor, width: 1.5),
                      borderRadius: BorderRadius.circular(12)),
                  child: 
                  review ?
                  ListTile(
                    onTap: () => showReviewProfile(context, up),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(up.profileURL),
                      backgroundColor: goldColor,
                    ),
                    title: Text("${up.firstName} ${up.lastName}", style: const TextStyle(color: goldColor),),
                    subtitle: Text(up.locationText, style: const TextStyle(color: goldColor),),
                    // Text("DOB:" + up.dob.toString())
                  ) :
                  ListTile(
                    onTap: () => showProfile(context, up),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(up.profileURL),
                      backgroundColor: goldColor,
                    ),
                    title: Text("${up.firstName} ${up.lastName}", style: const TextStyle(color: goldColor),),
                    subtitle: Text(up.locationText, style: const TextStyle(color: goldColor),),
                    // Text("DOB:" + up.dob.toString())
                  )
                ),
                const SizedBox(height: 10,),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

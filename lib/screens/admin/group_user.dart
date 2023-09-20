import 'package:app/constants.dart';
import 'package:app/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupUser extends StatelessWidget {
  final String userID;
  final Function removeUser;
  const GroupUser(this.userID, this.removeUser, {Key? key}) : super(key: key);

  Future<UserProfile> getProfile() async {
    UserProfile up = UserProfile(userID, '', '', '', '', Timestamp.now(), '', '', []
    ,"","","","","","","","","","","","","","","","","","","","","","","", true);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      up = await Constants.getProfile(userID);
    }
    return up;
  }

  void rUser() {
    removeUser(userID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            UserProfile up = snapshot.data as UserProfile;
            return Card(
              elevation: 0,
              child: ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(up.profileURL)),
                title: Text("${up.firstName} ${up.lastName}", style: 
                TextStyle(color: Colors.red[500], fontWeight: FontWeight.w500),),
                trailing: IconButton(icon: const Icon(Icons.remove_circle, color: goldColor,), onPressed: rUser,),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

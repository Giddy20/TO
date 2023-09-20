// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:developer';

import 'package:app/profile/user_personal_details.dart';
import 'package:app/screens/admin/createGroup/create_group.dart';
import 'package:app/screens/my_profile.dart';
import 'package:app/screens/sub_screen.dart';
import 'package:app/screens/views.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/constants.dart';

class CheckProfile extends StatefulWidget {
  const CheckProfile({Key? key}) : super(key: key);

  @override
  _CheckProfileState createState() => _CheckProfileState();
}

class _CheckProfileState extends State<CheckProfile> {
  String userID = "";
  @override
  void initState() {
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    bool result = false;
    User? user = FirebaseAuth.instance.currentUser;
    SharedPreferences prefs = await Constants.getPrefs();
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("profile")
          .doc(user.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          List<dynamic> interest = doc.data()?['myInterest'] ?? [];
          List<String> int = [];
          interest.forEach((element) {
            int.add(element);
          });
          result = true;
          userID = doc.id;
          prefs.setString("firstname", doc.data()!['firstname']);
          prefs.setString("lastname", doc.data()!['lastname'] ?? "");
          prefs.setString("gender", doc.data()!['gender'] ?? "");
          prefs.setString('locationText', doc.data()!['locationText'] ?? "");
          prefs.setString('profileURL', doc.data()!['profileURL'] ?? "");
          prefs.setBool("approved", doc.data()!['approved'] ?? false);
          prefs.setStringList("myInterest", int);
          Timestamp dob = doc.data()?['birthDay'] ?? Timestamp.now();
          Constants.usersDOB = dob.toDate();
          Map<String, dynamic> location =
              doc.data()?['location'] ?? {'lat': 0, 'lng': 0};
          prefs.setDouble('lat', location['lat']);
          prefs.setDouble('lng', location['lng']);
          prefs.setInt("minAge", doc.data()!['minAge'] ?? 18);
          prefs.setInt("maxAge", doc.data()!['maxAge'] ?? 100);
          prefs.setInt('distance', doc.data()!['distance'] ?? 100);
          prefs.setString('phoneNo', doc.data()!['phoneNo'] ?? "");
          prefs.setString('height', doc.data()!['height'] ?? "");
          prefs.setString('fatherName', doc.data()!['fatherName'] ?? "");
          prefs.setString('motherName', doc.data()!['motherName'] ?? "");
          prefs.setString('momsMaider', doc.data()!['momsMaider'] ?? "");
          prefs.setString(
              'parentsMarriage', doc.data()!['parentsMarriage'] ?? "");
          prefs.setString('siblings', doc.data()!['siblings'] ?? "");
          prefs.setString('rabbiShul', doc.data()!['rabbiShul'] ?? "");
          prefs.setString('address', doc.data()!['address'] ?? "");
          prefs.setString('openToMoving', doc.data()!['openToMoving'] ?? "");
          prefs.setString('religionLevel', doc.data()!['religionLevel'] ?? "");
          prefs.setString('school', doc.data()!['school'] ?? "");
          prefs.setString('work', doc.data()!['work'] ?? "");
          prefs.setString('hobbies', doc.data()!['hobbies'] ?? "");
          prefs.setString('firstRefName', doc.data()!['firstRefName'] ?? "");
          prefs.setString('firstRefPhone', doc.data()!['firstRefPhone'] ?? "");
          prefs.setString(
              'firstRefRelation', doc.data()!['firstRefRelation'] ?? "");
          prefs.setString('lastRefName', doc.data()!['lastRefName'] ?? "");
          prefs.setString('lastRefPhone', doc.data()!['lastRefPhone'] ?? "");
          prefs.setString(
              'lastRefRelation', doc.data()!['lastRefRelation'] ?? "");
          prefs.setString('about', doc.data()!['about'] ?? "");
          prefs.setString('lookingFor', doc.data()!['lookingFor'] ?? "");
          prefs.setString('lottery', doc.data()!['lottery'] ?? "");
          prefs.setString('martialStatus', doc.data()!['martialStatus'] ?? "");
          prefs.setBool('cohen', doc.data()!['cohen'] ?? false);
        } else {
          result = false;
        }
      }).catchError(
        (onError) {
          log(
            onError.toString(),
          );
        },
      );
    }
    if (result == true) {
      if (userID == "UEa9c4WwuLf9193lcfExfjdXCqF2") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) {
          return const CreateGroup();
        }), (route) => false);
      } else {
        /*
        bool sub = await checkForSub();
        if (sub) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
            return const MyProfile();
          }));
        } else {
          await Constants.showUpgradeDialog(context);
          checkProfile();
        }
        */

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return const Views();
        }));
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) {
        //   return const UserPersonalDetails();
        // }), (route) => false);
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (_) {
        //   return const SubScreen();
        // }), (route) => false);
      }
    } else {

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) {
        return const UserPersonalDetails();
      }), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(color: lightGoldColor),
            SizedBox(height: 20),
            Text(
              "Loading Profile ...",
              style: TextStyle(color: whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}

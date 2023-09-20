// ignore_for_file: unused_local_variable, avoid_print

import 'dart:developer';

import 'package:app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Functions {
  void checkProfile() async {
    //await updateProfile();
    bool result = false;
    User? user = FirebaseAuth.instance.currentUser;
    var prefs = await Constants.getPrefs();
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("profile")
          .doc(user.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          result = true;
          Timestamp dob = doc.data()?['birthDay'] ?? Timestamp.now();
          Constants.usersDOB = dob.toDate();

          List<dynamic> interest = doc.data()?['myInterest'] ?? [];
          List<String> int = [];
          interest.forEach((element) {
            int.add(element);
          });
          Map<String, dynamic> location = doc.data()?['location'] ?? {'lat': 0, 'lng': 0};
          prefs.setString("firstname", doc.data()!['firstname']);
          prefs.setString("lastname", doc.data()!['lastname'] ?? "");
          prefs.setString("gender", doc.data()!['gender'] ?? "");
          prefs.setString('locationText', doc.data()!['locationText'] ?? "");
          prefs.setString('profileURL', doc.data()!['profileURL'] ?? "");
          prefs.setBool("approved", doc.data()!['approved'] ?? false);
          prefs.setStringList("myInterest", int);
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
          prefs.setString(
              'religiousLevel', doc.data()!['religiousLevel'] ?? "");
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
          prefs.setBool('hobbies', doc.data()!['cohen'] ?? false);
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
  }
}

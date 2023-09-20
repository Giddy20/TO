import 'dart:developer';
import 'package:app/constants.dart';
import 'package:app/screens/admin/app_user.dart';
import 'package:app/screens/admin/review_profile_details.dart';
import 'package:app/screens/admin/user_for_revew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';

class ReviewNewProfile extends StatefulWidget {
  const ReviewNewProfile({Key? key}) : super(key: key);

  @override
  _ReviewNewProfileState createState() => _ReviewNewProfileState();
}

class _ReviewNewProfileState extends State<ReviewNewProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  List<String> users = [];
  List<bool> reviews = [];
  List<bool> status = [];
  bool show = false;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  void getUsers() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loading = true;
      });
      List<String> u = [];
      List<bool> r = [];
      await FirebaseFirestore.instance
          .collection('userReview')
          .get()
          .then((value) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          u.add(doc.id);
          r.add(doc.data()['approved']);
        }
        setState(() {
          loading = false;
          users = u;
          reviews = r;
        });
      }).catchError((onError) {
        log(onError);
      });
    }
  }

  goToReviewProfileDetails() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const ReviewProfileDetails();
    }));
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

  void userTapped(String userID, bool status) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
        setState(() {
          loading = true;
        });
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateUserReview');
      final results = await callable({'userID': userID, 'status': !status});
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

  void getProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loading = true;
      });
      List<String> u = [];
      List<bool> s = [];
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getUsersForAdmin');
      final results = await callable();
      print(results.data);
      if (results.data != 'error') {
        List<dynamic> data = results.data;
        print("dffff");
        for (var element in data) {
          print("wjjwkdjd");
          if (element['uid'] != user.uid) {
            u.add(element['uid'].toString());
            s.add(element['disabled']);
          }
        }
        setState(() {
          users = u;
          status = s;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        Constants.showMessage(context, "Error, please try again later");
      }
    }
  }

  void showButton() {
setState(() {
  show = true;
});
  }

  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            child:
                CustomAppBar(getBackButton(), "Review New Profiles", const [],),
            preferredSize:
                Size(MediaQuery.of(context).size.width, appBarHeight),
          ),
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : 
              ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return AppUser(users[index], status[index],true);
                },
              )
              // ListView.builder(
              //     itemCount: users.length,
              //     itemBuilder: (context, index) {
              //       return GestureDetector(
              //         onTap: (() => userTapped(users[index], reviews[index])),
              //         child: UserForReview(users[index], reviews[index]),
              //       );
              //     },
              //   )
          ),
    );
  }
}

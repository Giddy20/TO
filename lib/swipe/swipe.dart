// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print
/*
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ding_dong/providers/main_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Swipe extends StatefulWidget {
  const Swipe({Key? key}) : super(key: key);

  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    int cIndex =
        Provider.of<MainProvider>(context, listen: false).currentProfileIndex;
    if (cIndex <= 0) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          loading = true;
        });
        await FirebaseFirestore.instance
            .collection('Matches')
            .where('users', arrayContains: user.uid)
            .where('status', isEqualTo: 'initiated')
            .orderBy("timestamp", descending: true)
            .get()
            .then((value) {
          List<NewMatch> sm = [];
          value.docs.forEach((element) {
            List<dynamic> users = element.data()['users'];
            users.forEach((u) {
              if (u != user.uid) {
                sm.add(NewMatch(element.id, u));
              }
            });
          });
          setState(() {
            loading = false;
          });
          Provider.of<MainProvider>(context, listen: false).myMatches = sm;
          Provider.of<MainProvider>(context, listen: false)
              .currentProfileIndex = 0;
        }).catchError((onError) {
          print(onError);
        });
      }
    }
  }

  List<NewMatch> getSwipes(AsyncSnapshot snapshot, String uid) {
    List<NewMatch> swipeMatch = [];
    if (snapshot.data != null) {
      var docs = snapshot.data.docs;
      docs.forEach((doc) {
        List<dynamic> user = doc.data()['users'];
        user.forEach((element) {
          if (element != uid) {
            swipeMatch.add(NewMatch(doc.id, element));
          }
        });
      });
    }
    return swipeMatch;
  }

  List<Widget> getChildren(List<NewMatch> swipesMatch) {
    List<Widget> matches = [];
    swipesMatch.forEach((element) {
      matches.add(SwipePhoto(element));
    });
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = Provider.of<MainProvider>(context).currentProfileIndex;
    List<NewMatch> swipesMatch = Provider.of<MainProvider>(context).myMatches;
    return Scaffold(
      body: loading == true && swipesMatch.isNotEmpty
          ? Center(
              child: Image.asset(
              'assets/loading.gif',
              height: 50,
            ))
          : swipesMatch.isEmpty
              ? const Center(
                  child: Text(
                  "No Matches In your area",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ))
              : currentIndex == -1
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: TextButton(
                            child: const Text(
                              "Review Again",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            onPressed: getData,
                          ),
                        ),
                        //   Button(
                        //       "Review Again",
                        //       pinkColorshade200,
                        //       redAccentColorshade700,
                        //       whiteColor,
                        //       20,
                        //       getData,
                        //       Icons.refresh,
                        //       whiteColor,
                        //       false,
                        //       50),
                        // ) //NewGradientButton("Review Again", getData),
                      ],
                    )
                  : IndexedStack(
                      index: currentIndex,
                      children: getChildren(swipesMatch),
                    ),
    );
  }
}
*/
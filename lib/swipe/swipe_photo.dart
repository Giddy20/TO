/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mysapio/Models/newMatch.dart';
import 'package:mysapio/Models/swipeModal.dart';
import 'package:mysapio/screens/swipeScreen.dart';
import 'package:mysapio/screens/swipe/viewProfile.dart';

class SwipePhoto extends StatefulWidget {
  final NewMatch swipe;
  const SwipePhoto(this.swipe, {Key? key}) : super(key: key);

  @override
  _SwipePhotoState createState() => _SwipePhotoState();
}

class _SwipePhotoState extends State<SwipePhoto> {
  final myDuration = 1;
  bool loading = false;
  int index = 0;
  bool fav = false;
  bool click = false;
  bool _first = true;

  Future<SwipeModal> getSwipe() async {
    SwipeModal sm = SwipeModal(
        "", "", [""], "", "", "", "", "", "", "", "", "", "", "", "","","",[],"", "");
    await FirebaseFirestore.instance
        .collection("profile")
        .doc(widget.swipe.userID)
        .get()
        .then((doc) {
          List<dynamic> hobbies = doc.data()?['hobby'] ??[];
          List<String> hbs = [];
          hobbies.forEach((element) {
            hbs.add(element);
          });
      sm = SwipeModal(
        doc.id,
        doc.data()!['userName'].toString(),
        [doc.data()!['profileURL'].toString()],
        doc.data()!['school'].toString(),
        doc.data()!['belief'].toString(),
        doc.data()!['birthDay'].toString(),
        doc.data()!['difference'].toString(),        
        doc.data()!['orientation'].toString(),
        doc.data()!['passion'].toString(),
        doc.data()!['risk'].toString(),
        doc.data()!['travelled'].toString(),
        doc.data()!['location'].toString(),
        doc.data()!['enterpreneurship'].toString(),
        doc.data()!['difference'].toString(),
        doc.data()!['about'].toString(),
        doc.data()!['company'].toString(),
        doc.data()!['jobTitle'].toString(),
        hbs,
        doc.data()!['locationText'].toString(),
        doc.data()!['zodiac'].toString(),
      );
    }).catchError((onError) {
      print("Error");
    });
    return sm;
  }

  void changeStatus() {
    setState(() {
      _first = !_first;
      index = index + 1;
    });
  }

  void cancel() {
    setState(() {
      _first = !_first;
      index = index -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
        FutureBuilder(
            future: getSwipe(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                SwipeModal sm = snapshot.data as SwipeModal;
                return IndexedStack(
                  index:  index,
                  children: [
                    SwipeScreen(widget.swipe, sm.name,sm.photoURL[0],
                      sm.education, sm.birthday, changeStatus),
                     _first == false ?
                      ViewProfile(
                    widget.swipe,
                      sm.name,
                      sm.birthday,
                      sm.education,
                      sm.location,
                      sm.passion,
                      sm.travelled,
                      sm.existing,
                      sm.enterpre,
                      sm.risk,
                      sm.belief,
                      sm.photoURL,
                      sm.about, 
                      sm.company, 
                      sm.jobTitle,
                      sm.hobby,
                      sm.locationText,
                      cancel,
                      sm.zodiac)
                      :
                      Container()
                  ],
                );                          
                     // AnimatedCrossFade(
                //   duration: const Duration(seconds: 6),
                //   firstChild:
                //    SwipeScreen(widget.swipe, sm.name,sm.photoURL[0],
                //       sm.education, sm.birthday, changeStatus),
                //   secondChild: ViewProfile(
                //     widget.swipe,
                //       sm.name,
                //       sm.birthday,
                //       sm.education,
                //       sm.location,
                //       sm.passion,
                //       sm.travelled,
                //       sm.existing,
                //       sm.enterpre,
                //       sm.risk,
                //       sm.belief,
                //       sm.photoURL,
                //       sm.about, 
                //       sm.company, 
                //       sm.jobTitle,
                //       sm.hobby,
                //       sm.locationText),
                //   crossFadeState: _first
                //       ? CrossFadeState.showFirst
                //       : CrossFadeState.showSecond,
                // );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
  }
}
*/
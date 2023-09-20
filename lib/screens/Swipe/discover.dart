// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:app/models/new_match.dart';
import 'package:app/models/swipe_modal.dart';
import 'package:app/screens/side_nav.dart';
import 'package:app/widgets/icons/custom_we_swipe_icons_icons.dart';
import 'package:app/widgets/swipe/swipe_fav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/screens/my_profile.dart';
import 'package:app/screens/settings/preferences.dart';
import 'package:app/screens/view_profile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcard/tcard.dart';

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  goToPreferences() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Preferences();
    }));
  }

  goToMyProfile() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const MyProfile();
    }));
  }

  List<NewMatch> parse(AsyncSnapshot snapshot) {
    List<NewMatch> nms = [];
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && snapshot.data != null) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.data.docs) {
        nms.add(NewMatch(doc.id, doc.data()['otherUser']));
      }
    }
    return nms;
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final Stream<QuerySnapshot> matchStream = FirebaseFirestore.instance
        .collection('myMatches')
        .doc(user!.uid)
        .collection('matches')
        .where('status', isEqualTo: 'initiated')
        .orderBy("timestamp", descending: true)
        .snapshots();

/*
    final Stream<QuerySnapshot> matchStream = FirebaseFirestore.instance
        .collection('Matches')
        .where('users', arrayContains: user!.uid)
        .where('status', isEqualTo: 'initiated')
        .orderBy("timestamp", descending: true)
        .snapshots();
*/

    return Scaffold(
      key: _scaffoldKey,
      drawer:  SideNav(),
      backgroundColor:  greenBackgroundColor,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: greenBackgroundColor,
      //   title: Text("Your Matches",
      //   style: GoogleFonts.poppins(fontWeight: FontWeight.w600),),
      //   centerTitle: true,
      //   leading: GestureDetector(
      //     onTap: () {
      //       _scaffoldKey.currentState!.openDrawer();
      //     },
      //     child: Padding(
      //       padding:  EdgeInsets.symmetric(horizontal: 13.0),
      //       child: SvgPicture.asset("assets/menu.svg"),
      //     ),
      //   ),
      //   // actions: const [
      //   //   Icon(Icons.message_outlined, color: blackColor),
      //   //   SizedBox(width: 10),
      //   // ],
      // ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        color: greenBackgroundColor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    const Positioned(
                      left: 22,
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: whiteColor,
                        child: Text(
                          'We',
                          style: TextStyle(
                              color: blackColor,
                              fontFamily: 'Aliqa',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: matchStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        List<NewMatch> results = parse(snapshot);
                        return results.isNotEmpty
                            ? TCards(results)
                            :  Center(
                                child: Image.asset("assets/noMatches.png", scale: 4,),
                              );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class TCards extends StatelessWidget {
  final List<NewMatch> matches;
  TCards(this.matches, {Key? key}) : super(key: key);
  final TCardController controller = TCardController();
  List<NewMatch1> newMatches = [];
  Future<List<NewMatch1>> getProfiles() async {
    List<NewMatch1> nm = [];
    for (int i = 0; i < matches.length; i++) {
      SwipeModal swipeModal = await getSwipe(matches[i].userID);
      if (swipeModal.uid.isNotEmpty) {
        nm.add(NewMatch1(
            matches[i].matchID, matches[i].userID, swipeModal, 'initiated'));
      }
    }
    newMatches = nm;
    return nm;
  }

  void likeProfile(int index) async {
    if (index > 0 && index < newMatches.length + 1) {
      NewMatch1 nm = newMatches.elementAt(index - 1);
      markFav(nm);
    } else {
      controller.reset();
    }
  }

  void likeProfile1(int index) async {
    NewMatch1 nm = newMatches.elementAt(index);
    markFav(nm);
  }

  void goTohome(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Discover();
    }));
  }

  void nextProfile() {
    int fIndex = controller.state?.frontCardIndex ?? -1;
    if (fIndex == newMatches.length) {
      controller.reset();
    } else {
      controller.forward(direction: SwipDirection.Left);
    }
  }

  void tapped(BuildContext context, NewMatch1 nm) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return ViewProfile(
              nm.sm.name,
              nm.sm.lastName,
              nm.sm.birthday,
              nm.sm.photoURL[0],
              nm.sm.birthday,
              nm.sm.jobTitle,
              nm.sm.about,
              nm.sm.height,
              nm.sm.religion);
        },
      ),
    );
  }

  void markFav(NewMatch1 otherUser) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await Constants.updateMatch(otherUser.matchID, otherUser.userID);
    }
  }

  Future<SwipeModal> getSwipe(String userID) async {
    SwipeModal sm = SwipeModal("", "", "", [], "", "", "", 0, 0, "", "");
    await FirebaseFirestore.instance
        .collection("profile")
        .doc(userID)
        .get()
        .then((doc) {
      Map<String, dynamic> location =
          doc.data()?['location'] ?? {'lat': 0, 'lng': 0};
      double lat = location['lat'];
      double lng = location['lng'];
      try {
        sm = SwipeModal(
          doc.id,
          doc.data()!['firstname'].toString(),
          doc.data()!['lastname'].toString(),
          [doc.data()!['profileURL'].toString()],
          getDob(doc.data()!['birthDay']),
          doc.data()?['about'] ?? '',
          doc.data()?['degrees'] ?? '',
          lat,
          lng,
          doc.data()?['height'] ?? "",
          doc.data()?['religionLevel'] ?? "",
        );
      } catch (e) {
        log(e.toString());
      }
    }).catchError((onError) {
      log("Error");
    });
    return sm;
  }

  String getDob(Timestamp bDay) {
    String currentAge = "";
    //  List<String> dateSplits = bDay.split("-");
    Duration dur = DateTime.now().difference(bDay.toDate());
    currentAge = (dur.inDays / 365).floor().toString();
    return currentAge;
  }

  void blockOption(BuildContext context, NewMatch1 nm) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Block ${nm.sm.name}"),
          content: const Text("Are you sure you want to block ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            )
          ],
        );
      },
    );
  }

  List<Widget> getCards(BuildContext context, List<NewMatch1> newMatches) {
    List<Widget> cards = List.generate(
      newMatches.length,
      (int index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
                width: 2, color: const Color.fromARGB(15, 50, 50, 50)),
          ),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => tapped(context, newMatches[index]),
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: MediaQuery.of(context).size.height / 1.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                            image: NetworkImage(
                              newMatches[index].sm.photoURL[0],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 20,
                        child: Text(
                          newMatches[index].sm.name,
                          style: const TextStyle(
                              fontFamily: 'Aliqa',
                              color: whiteColor,
                              fontSize: 70),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(150, 255, 255, 255),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, bottom: 8, right: 12.0, top: 12.0),
                            child: GestureDetector(
                              onTap: () =>
                                  blockOption(context, newMatches[index]),
                              child: const Icon(
                                Icons.block_rounded,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: nextProfile,
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: whiteColor, width: 6),
                                  shape: BoxShape.circle),
                              child: GestureDetector(
                                //       onTap: goToMatch,
                                child: const CircleAvatar(
                                  radius: 30,
                                  backgroundColor: whiteColor,
                                  foregroundColor: whiteColor,
                                  child: Icon(
                                    Icons.cancel,
                                    color: blackColor,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            likeProfile1(index);
                          },
                          child: SwipeFav(
                            newMatches[index].sm.uid,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    cards.add(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border:
              Border.all(width: 2, color: const Color.fromARGB(15, 50, 50, 50)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  controller.reset();
                },
                child: const Text("Review Again"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getProfiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<NewMatch1> nms = snapshot.data as List<NewMatch1>;
            return TCard(
              lockYAxis: true,
              controller: controller,
              size: Size(size.width, size.height),
              cards: getCards(context, nms),
              onEnd: () {
                controller.reset();
              },
              onForward: (index, info) {
                if (info.direction == SwipDirection.Right) {
                  likeProfile(index);
                }
                if (index == newMatches.length + 1) {
                  controller.reset();
                }
              },
              onBack: (index, info) {},
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

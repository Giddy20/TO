// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/providers/iap_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:geolocator_web/geolocator_web.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/user_profile.dart';

const whitColor = Color(0xFFFFFFFF);
const blackColor = Color(0xFF000000);
const lightGreenColor = Color(0xFF1A3320);
const pinkColor = blackColor;
Color redColor = Colors.red.shade500;
Color darkredColor = Colors.red.shade800;
const whiteColorShade = Color(0xFFFFFFFF);
const greenBackgroundColor = Color(0xFF142E1A);
const whiteColor = Color(0xFFFFFFFF);
const goldColor = Color(0xFF9F7632);
const lightGoldColor = Color(0xFFBB9D66);
const lightPurpleColor = Colors.red;
const double appBarHeight = 60;
const double adminAppBarHeight = 80;


smallHSpace() => const SizedBox(width: 20);
tinyHSpace() => const SizedBox(width: 10);
smallSpace() => const SizedBox(height: 20);
tinySpace() => const SizedBox(height: 10);
tiny15Space() => const SizedBox(height: 15);
tiny5Space() => const SizedBox(height: 5);
tinyH5Space() => const SizedBox(width: 5);
mediumSpace() => const SizedBox(height: 30);
mediumHSpace() => const SizedBox(width: 30);




Widget kSpacing =  const SizedBox(height: 10,);
Widget kLargeSpacing =  const SizedBox(height: 30,);

verticalSpace(factor) => SizedBox(height: 700.0 * factor);

Widget subText(title) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: GoogleFonts.poppins(color: whiteColor.withOpacity(0.5), fontWeight: FontWeight.w500, fontSize: 15),
    ),
  );
}

TextStyle textStyle(fontSize){
  return GoogleFonts.poppins(
      color: whiteColor,
      fontSize: double.parse(fontSize.toString())
  );
}

LinearGradient gradient = LinearGradient(
    colors: [
      Color(0xFFD7C299), Color(0xFF9F7632)
    ],
    stops: [0.0, 1.0],
    begin: FractionalOffset.centerLeft,
    end: FractionalOffset.centerRight,
    tileMode: TileMode.repeated
);

class Constants {
  static const String AdminID = "bmei9skFAGhZcNgt6HplD31OI983";
  static const String AdminID2 = "idlcwSzUNcfxb9CIvJJn0zg3IsV2";
  static const String AdminID3 = "6notK95DKAPWj6Sb7C99zMJpC8U2";
  static const String AdminID4 = "0fqtUBYfFSVyExFKvRroqGMjHij1";
  static const String AdminID5 = "MEmRz67TTzYOOyTgeuZMOXehrfJ3";
  static SharedPreferences? prefs;
  static double appBarPreferredHeight = 70;
  static Size imageSize = const Size(300, 300);
  static int imageQuality = 50;
  static String noImage =
      "https://firebasestorage.googleapis.com/v0/b/swirl-10996.appspot.com/o/public%2Fno-image.png?alt=media&token=a276ea04-ceaa-447e-8b01-0a6da824c074";
  static DateTime usersDOB = DateTime.now();
  static bool isAdmin() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.uid == AdminID || user != null && user.uid == AdminID2
        || user != null && user.uid == AdminID3 || user != null && user.uid == AdminID4
        || user != null && user.uid == AdminID5) {

      return true;
    }
    return false;
  }

  static getPrefs() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs;
  }

  static adminPrefs() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs;
  }

  static String getID(String id1, String id2) {
    return id1.compareTo(id2) < 0 ? (id1 + id2) : (id2 + id1);
  }

  static Future<bool> updateMatch(String matchID, String otherUserID) async {
    bool result = false;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference matchRef =
          FirebaseFirestore.instance.collection('Matches').doc(matchID);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(matchRef);
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          if (data['status'] == 'initiated') {
            transaction.update(matchRef, {'status': 'pending'});
          } else if (data['status'] == 'pending') {
            transaction.update(matchRef, {'status': 'confirmed'});
          }
        } else {
          result = false;
        }
      }).then((value) {
        updateMyMatch(matchID);
        markFav(matchID, otherUserID);
        result = true;
      }).catchError((onError) {
        result = false;
      });
    }
    return result;
  }

  static void updateMyMatch(String matchID) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('myMatches')
          .doc(user.uid)
          .collection('matches')
          .doc(matchID)
          .set({
            'status': 'confirmed',
            'timestamp': FieldValue.serverTimestamp()
          }, SetOptions(merge: true))
          .then((value) {})
          .catchError((onError) {});
    }
  }

  static Future<bool> markFav(String matchID, String otherUserID) async {
    bool result = false;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String favID = getID(user.uid, matchID);
      await FirebaseFirestore.instance.collection('Likes').doc(favID).set({
        'matchID': matchID,
        'likedUser': otherUserID,
        'likedBy': user.uid,
        'timestamp': FieldValue.serverTimestamp()
      }).then((value) {
        result = true;
      }).catchError((onError) {
        result = false;
      });
    }
    return result;
  }

  static Future<String> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('0-0');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('0-0');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('0-0');
    }
    Position position = await Geolocator.getCurrentPosition();
    return "${position.latitude}:${position.longitude}";
  }

  static Future<List<Marker>> createMarkers(
      List<Marker> mapMarkers, String city, String country) async {
    List<Marker> markers = [];
    for (int i = 0; i < mapMarkers.length; i++) {
      if (mapMarkers[i] != null) {
        var bitMap = await createMarker(
          300,
          150,
          city,
          country,
        );
        var bitMapDescriptor = BitmapDescriptor.fromBytes(bitMap);
        markers.add(
          Marker(
            markerId: mapMarkers[i].markerId,
            position: mapMarkers[i].position,
            icon: bitMapDescriptor,
            infoWindow: mapMarkers[i].infoWindow,
          ),
        );
      }
    }
    return markers;
  }

  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static Future<Uint8List> createMarker(
      double width, double height, String city, String country,
      {Color color = Colors.amber}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    Paint paint_0 = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(0, height * 0.0909091);
    path_0.quadraticBezierTo(
        width * 0.0000500, height * 0.0076364, width * 0.0500000, 0);
    path_0.lineTo(width * 0.9500000, 0);
    path_0.quadraticBezierTo(
        width * 1.0010000, height * 0.0059091, width, height * 0.0909091);
    path_0.cubicTo(width, height * 0.2500000, width, height * 0.5681818, width,
        height * 0.7272727);
    path_0.quadraticBezierTo(width * 1.0001000, height * 0.8156364,
        width * 0.9500000, height * 0.8181818);
    path_0.lineTo(width * 0.6000000, height * 0.8181818);
    path_0.lineTo(width * 0.5000000, height);
    path_0.lineTo(width * 0.4000000, height * 0.8181818);
    path_0.lineTo(width * 0.0500000, height * 0.8181818);
    path_0.quadraticBezierTo(
        width * -0.0001000, height * 0.8122727, 0, height * 0.7272727);
    path_0.cubicTo(
        0, height * 0.5681818, 0, height * 0.5681818, 0, height * 0.0909091);
    path_0.close();

    canvas.drawPath(path_0, paint_0);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: city,
      style: const TextStyle(
        fontSize: 32,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset((width * 0.5) - painter.width * 0.5,
          (height * 0.1) - painter.height * 0.1),
    );

    TextPainter painter1 = TextPainter(textDirection: TextDirection.ltr);
    painter1.text = TextSpan(
      text: country,
      style: const TextStyle(
        fontSize: 40,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
    painter1.layout();
    painter1.paint(
      canvas,
      Offset((width * 0.5) - painter1.width * 0.5,
          (height * 0.4) - painter1.height * 0.4),
    );

    int w = 300;
    int h = 200;

    final img = await pictureRecorder.endRecording().toImage(w, h);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  static String stringFromTimestamp(Timestamp ts, String type) {
    String result = "";
    DateTime dt = ts.toDate();
    String month = dt.month < 10 ? "0${dt.month}" : "${dt.month}";
    String day = dt.day < 10 ? "0${dt.day}" : "${dt.day}";
    if (type == 'justDate') {
      result = "$day/$month/${dt.year}";
    }
    return result;
  }

  static Future<UserProfile> getProfile(String userID) async {
    UserProfile up = UserProfile(
        userID,
        '',
        '',
        '',
        '',
        Timestamp.now(),
        '',
        '',
        [],
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        true);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('profile')
          .doc(userID)
          .get()
          .then((doc) {
        if (doc.exists) {
          List<String> interests = [];
          List<dynamic> intrsts = doc.data()!['myInterest'] ?? [];
          for (String element in intrsts) {
            interests.add(element);
          }
          up.lastName = doc.data()!['lastName'] ?? '';
          up.firstName = doc.data()!['firstname'] ?? '';
          up.profileURL = doc.data()!['profileURL'] ?? '';
          up.locationText = doc.data()!['locationText'] ?? '';
          up.dob = doc.data()!['birthDay'] ?? Timestamp.now();
          up.gender = doc.data()!['gender'] ?? '';
          up.about = doc.data()!['about'] ?? '';
          up.interests = interests;
          up.phoneNo = doc.data()!['phoneNo'] ?? '';
          up.height = doc.data()!['height'] ?? '';
          up.fatherName = doc.data()!['fatherName'] ?? '';
          up.motherName = doc.data()!['motherName'] ?? '';
          up.momsMaiden = doc.data()!['momsMaiden'] ?? '';
          up.parentsMarriage = doc.data()!['parentsMarriage'] ?? '';
          up.siblings = doc.data()!['siblings'] ?? '';
          up.rabbiShul = doc.data()!['rabbiShul'] ?? '';
          up.address = doc.data()!['address'] ?? '';
          up.openToMoving = doc.data()!['openToMoving'] ?? '';
          up.religiousLevel = doc.data()!['religionLevel'] ?? '';
          up.school = doc.data()!['school'] ?? '';
          up.work = doc.data()!['work'] ?? '';
          up.hobbies = doc.data()!['hobbies'] ?? '';
          up.firstRefName = doc.data()!['firstRefName'] ?? '';
          up.firstRefPhone = doc.data()!['firstRefPhone'] ?? '';
          up.firstRefRelation = doc.data()!['FirstRefRelation'] ?? '';
          up.lastRefName = doc.data()!['lastRefName'] ?? '';
          up.lastRefPhone = doc.data()!['lastRefPhone'] ?? '';
          up.lastRefRelation = doc.data()!['lastRefRelation'] ?? '';

          up.lookingFor = doc.data()!['lookingFor'] ?? '';
          up.lottery = doc.data()!['lottery'] ?? '';
          up.maritialStatus = doc.data()!['martialStatus'] ?? '';
          up.cohen = doc.data()!['cohen'] ?? false;
        }
      }).catchError((onError) {
        log(onError);
      });
    }
    return up;
  }

  static String listToString(List<String> list) {
    String result = '';
    for (String l in list) {
      if (result.isNotEmpty) {
        result += ', ';
      }
      result += l;
    }
    return result;
  }

  static String getMonthName(int month) {
    if (month == 1) {
      return 'Jan';
    } else if (month == 2) {
      return 'Feb';
    } else if (month == 3) {
      return 'Mar';
    } else if (month == 4) {
      return 'Apr';
    } else if (month == 5) {
      return 'May';
    } else if (month == 6) {
      return 'Jun';
    } else if (month == 7) {
      return 'Jul';
    } else if (month == 8) {
      return 'Aug';
    } else if (month == 9) {
      return 'Sep';
    } else if (month == 10) {
      return 'Oct';
    } else if (month == 11) {
      return 'Nov';
    } else if (month == 12) {
      return 'Dec';
    }
    return '';
  }

  static String getTimeText(int hour) {
    String result = '';
    if (hour >= 0 && hour < 12) {
      result = "$hour AM";
    } else {
      result = "${hour - 12} PM";
    }
    return result;
  }

  static String getDayName(int weekday) {
    if (weekday == 1) {
      return 'Mon';
    } else if (weekday == 2) {
      return 'Tue';
    } else if (weekday == 3) {
      return 'Wed';
    } else if (weekday == 4) {
      return 'Thu';
    } else if (weekday == 5) {
      return 'Fri';
    } else if (weekday == 6) {
      return 'Sat';
    } else if (weekday == 7) {
      return 'Sun';
    }
    return '';
  }

  static Future<bool> checkLocationPermission(BuildContext context) async {
    bool result = true;
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      result = false;
      await showLocationAlert(context, "Location services are disabled.");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        result = false;
        await showLocationAlert(context, "Location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      result = false;
      await showLocationAlert(context,
          "Location permissions are permanently denied, we cannot request permissions.");
    }
    return result;
  }

  static Future<void> showLocationAlert(
      BuildContext ctx, String message) async {
    await showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Alert!'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: const Text('Open app Settings'),
              onPressed: () {
                Navigator.of(ctx).pop();
                openAppSettings();
              },
            )
          ],
        );
      },
    );
  }

  static void openURL(BuildContext ctx) {
    Navigator.of(ctx).pop();
    launchUrl(Uri.parse('sycevents.com'));
  }

  // static Future<void> showUpgradeDialog(BuildContext context) async {
  //   await showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text(
  //         "GET PREMIUM FEATURES",
  //         textAlign: TextAlign.center,
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: const [
  //           ListTile(
  //             leading: Icon(
  //               Icons.chat_rounded,
  //               color: pinkColorshade200,
  //             ),
  //             title: Text("Get personalized matches"),
  //           ),
  //           ListTile(
  //             leading: Icon(
  //               Icons.person_add,
  //               color: pinkColorshade200,
  //             ),
  //             title: Text("Complete profile of users"),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         Center(
  //           child: ElevatedButton(
  //             onPressed: () => buySub(ctx, context),
  //             style: ElevatedButton.styleFrom(
  //               padding:
  //                   const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
  //               primary: pinkColorshade200,
  //             ),
  //             child: Column(
  //               children: const [
  //                 Text(
  //                   "\$17.99 for 6 months ",
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 SizedBox(height: 5),
  //                 Text(
  //                   "SUBSCRIBE",
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Center(
  //           child: TextButton(
  //             child: const Text(
  //               "Restore Purchases",
  //               style: TextStyle(
  //                 color: pinkColorshade200,
  //               ),
  //             ),
  //             onPressed: () => restorePurchase(ctx, context),
  //           ),
  //         ),
  //         TextButton(
  //           child: const Text(
  //             "Terms of Service",
  //             style: TextStyle(
  //               color: pinkColorshade200,
  //             ),
  //           ),
  //           onPressed: () => openURL(ctx),
  //         ),
  //         TextButton(
  //           child: const Text(
  //             "Privacy Policy",
  //             style: TextStyle(
  //               color: pinkColorshade200,
  //             ),
  //           ),
  //           onPressed: () => openURL(ctx),
  //         ),
  //         TextButton(
  //           child: const Text(
  //             "Refund Policy",
  //             style: TextStyle(
  //               color: pinkColorshade200,
  //             ),
  //           ),
  //           onPressed: () => openURL(ctx),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // static void buySub(
  //     BuildContext dialogContext, BuildContext mainContext) async {
  //   List<ProductDetails> products =
  //       Provider.of<IAPProvider>(mainContext, listen: false).products;
  //   if (products.isNotEmpty) {
  //     bool result = await Provider.of<IAPProvider>(mainContext, listen: false)
  //         .buySub(mainContext, products[0]);
  //     if (result) {
  //       await updateDBForSub(products[0]);
  //       Navigator.pop(dialogContext);
  //       ScaffoldMessenger.of(mainContext).showSnackBar(const SnackBar(
  //         content: Text('Subscribed successfully'),
  //       ));
  //     } else {
  //       Navigator.pop(dialogContext);
  //       ScaffoldMessenger.of(mainContext).showSnackBar(const SnackBar(
  //         content: Text('Please try again later'),
  //       ));
  //     }
  //   } else {
  //     Navigator.pop(dialogContext);
  //     ScaffoldMessenger.of(mainContext).showSnackBar(const SnackBar(
  //       content: Text('Please try again later'),
  //     ));
  //   }
  // }

  // static void restorePurchase(
  //     BuildContext dialogContext, BuildContext mainContext) async {
  //   Navigator.pop(dialogContext);
  //   ScaffoldMessenger.of(mainContext).showSnackBar(const SnackBar(
  //     content: Text('Restoring your previous purchases if any'),
  //   ));
  //   await Provider.of<IAPProvider>(mainContext, listen: false)
  //       .restorePurchase();
  // }

  // static Future updateDBForSub(ProductDetails product) async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     await FirebaseFirestore.instance
  //         .collection("subscribed")
  //         .doc(user.uid)
  //         .set({
  //           'subID': product.id,
  //           'timestamp': FieldValue.serverTimestamp(),
  //         })
  //         .then((value) {})
  //         .catchError((onError) {
  //           print(onError);
  //         });
  //   }
  // }
}

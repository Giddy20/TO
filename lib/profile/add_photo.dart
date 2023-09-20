// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:developer';
import 'dart:io';

import 'package:app/models/image_model.dart';
import 'package:app/widgets/grid_screen.dart';
import 'package:app/widgets/image_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/profile/location.dart';
import 'package:app/widgets/add_photo_grid_screen.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPhoto extends StatefulWidget {
  const AddPhoto({Key? key}) : super(key: key);

  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  bool loading = false;
  File? pickedMedia;
  List<String> mediaFiles = [];
  final picker = ImagePicker();
  final myDuration = 1;
  String name = "";
  ImageModel profileURL = ImageModel("", "", "profile");
  List<ImageModel> userFiles = [
    ImageModel('', '', 'album'),
    ImageModel('', '', 'album'),
    ImageModel('', '', 'album'),
    ImageModel('', '', 'album'),
    ImageModel('', '', 'album'),
    ImageModel('', '', 'album'),
  ];

  @override
  void initState() {
    super.initState();
    getUserMediaFiles();
  }

  void addMedia() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Align(
          alignment: Alignment.center,
          child: Text("UPLOAD FROM ",
              style: TextStyle(color: blackColor, fontWeight: FontWeight.bold)),
        ),
        children: [
          GestureDetector(
            onTap: () => pickMedia("Camera"),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera, color: blackColor),
                  SizedBox(width: 10),
                  Text("CAMERA",
                      style: TextStyle(
                          color: blackColor, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const Divider(
            endIndent: 12,
            indent: 12,
          ),
          GestureDetector(
            onTap: () => pickMedia("Gallery"),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.picture_in_picture_alt_outlined,
                      color: blackColor),
                  SizedBox(width: 10),
                  Text("GALLERY",
                      style: TextStyle(
                          color: blackColor, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void pickMedia(String from) async {
    Navigator.of(context).pop();
    final XFile? photo = await picker.pickImage(
        source: from == "Camera" ? ImageSource.camera : ImageSource.gallery,
        maxWidth: Constants.imageSize.width,
        maxHeight: Constants.imageSize.height);
    if (photo != null) {
      pickedMedia = File(photo.path);

      uploadMedia(pickedMedia!);
    }
  }

  void uploadMedia(File file) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loading = true;
      });
      int now = Timestamp.now().microsecondsSinceEpoch;
      String id = "${user.uid}$now";
      final ref = FirebaseStorage.instance.ref().child('mediaFiles').child(id);
      UploadTask uploadTask = ref.putFile(file);
      String url = await (await uploadTask).ref.getDownloadURL();
      saveImageLink(url);
    }
  }

  void updateProfile(String url) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updatePhotoURL(url);
    }
  }

  void saveImageLink(String url) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("UserMediaFiles")
          .add({'userID': user.uid, 'url': url}).then((value) {
        setState(() {
          mediaFiles.add(url);
          loading = false;
        });
        //getUserMediaFiles();
      }).catchError(
        (onError) {
          log(onError.toString());
        },
      );
    }
  }

  Future<void> setProfileImage(String url) async {
    User? user = FirebaseAuth.instance.currentUser;
    SharedPreferences prefs = await Constants.getPrefs();
    if (user != null) {
      await FirebaseFirestore.instance.collection("profile").doc(user.uid).set(
        {'profileURL': url},
        SetOptions(merge: true),
      ).then((value) {
        setState(() {
          //   mediaFiles.add(url);
        });
        prefs.setString("profileURL", url);
      }).catchError(
        (onError) {
          log(onError.toString());
        },
      );
    }
  }

  List<String> mFiles = [];
  void getUserMediaFiles() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loading = true;
      });
      List<String> mFiles = [];
      await FirebaseFirestore.instance
          .collection("UserMediaFiles")
          .where("userID", isEqualTo: user.uid)
          .limit(4)
          .get()
          .then((value) {
        value.docs.forEach((doc) {
          mFiles.add(doc.data()["url"]);
        });
        if (mFiles.length < 4) {
          for (int i = mFiles.length; i < 4; i++) {
            mFiles.add("");
          }
        }
        setState(() {
          mediaFiles = mFiles;
          loading = false;
        });
      }).catchError((onError) {
        log(onError.toString());
      });
    }
  }

  next() {
    if (mediaFiles.length < 2) {
      Constants.showMessage(context, "Please add atleast 2 photos");
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) {
          return const Location();
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      // appBar: AppBar(
      //   backgroundColor: greenBackgroundColor,
      //   iconTheme: const IconThemeData(color: whiteColor),
      //   centerTitle: true,
      //   elevation: 0,
      //   title: Text('Upload Photos', style: GoogleFonts.poppins(color: whiteColor, fontWeight: FontWeight.w600)),
      // ),
      backgroundColor: greenBackgroundColor,
      body: loading
          ?  Center(
              child: Text(
                "Loading....",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: whiteColor),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(15.0),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: lightGreenColor
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 75,
                          width: 110,
                          child: Image.asset('assets/logo.png'),
                        ),

                        Expanded(
                          child: Text(
                            'Your are beautiful add your photos',
                            style: TextStyle(color: whiteColor.withOpacity(0.5), fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  const SizedBox(height: 10),
                  GridScreen(
                    userFiles,
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  ButtonIconLess('CONTINUE', whiteColor, whiteColor, whiteColor,
                      1.3, 18, 17, next),
                ],
              ),
            ),
    );
  }
}

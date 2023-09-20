// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'package:app/models/image_model.dart';
import 'package:app/widgets/grid_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_functions/cloud_functions.dart';

class EditProfileAddPhoto extends StatefulWidget {
  const EditProfileAddPhoto({Key? key}) : super(key: key);

  @override
  _EditProfileAddPhotoState createState() => _EditProfileAddPhotoState();
}

class _EditProfileAddPhotoState extends State<EditProfileAddPhoto> {
  bool loading = false;
  File? pickedMedia;
  List<String> mediaFiles = [];
  final picker = ImagePicker();
  final myDuration = 1;
  String name = "";
  String profileURL = '';
  List<ImageModel> userFiles = [
    ImageModel('', '', 'album'),
    ImageModel('', '', 'album'),
    ImageModel('', '', 'album'),
    ImageModel('', '', 'album'),
  ];
  @override
  void initState() {
    super.initState();
    getImage();
  }

  Future<void> getImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loading = true;
      });
      List<ImageModel> userImage = [];
      await FirebaseFirestore.instance
          .collection('UserMediaFiles')
          .where('userID', isEqualTo: user.uid)
          .get()
          .then((value) => {
                value.docs.forEach((doc) {
                  userImage.add(
                    ImageModel(
                      doc.id,
                      doc.data()['url'] ?? "",
                      doc.data()['status'] ?? ""
                    ),
                  );
                }),
                setState(() {
                  loading = false;
                  userFiles = userImage;
                })
              })
          .catchError((onError) {
        log(onError);
      });
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


  Future<void> showOptions(BuildContext ctx, ImageModel photo) async {
    return showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Delete ?'),
            content:
                const Text('Are you sure, you want to delete this ticker ?'),
            actions: [
              TextButton(
                child: const Text("No"),
                onPressed: () => cancelDelete(ctx),
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () => deleteImage(ctx, photo),
              )
            ],
          );
        });
  }

  Future<void> deleteImage(BuildContext ctx, ImageModel image) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(ctx).pop();
      setState(() {
        loading = true;
      });
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteImage');
      final results = await callable({'ref': image.id});
      if (results.data != 'error') {
        //  getBooks();
      } else {
        setState(() {
          loading = false;
        });
        //  showMessage("Error deleting book, please try again later");
      }
    }
  }

  void cancelDelete(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

  next() {
    if (mediaFiles.length < 2) {
      Constants.showMessage(context, "Please add atleast 2 photos");
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 50, left: 10, right: 10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: redColor)
                ),
                child: Column(
                  children: [
                    SizedBox(height: 120, child: Image.asset('assets/logo.png')),
                    const SizedBox(height: 5),
                    const Text('YOU ARE BEAUTIFUL - ADD YOUR PHOTOS',
                        style: TextStyle(color: whiteColor, fontSize: 16)),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 450,
                      child:
                      GridScreen(
                        userFiles,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // ButtonIconLess('Save', pinkAccent, pinkAccent, whiteColor,
                    //     1.3, 18, 17, next),
                  ],
                ),
              ),
            ),
    );

  }

  myAppBarWithRoundedBackButton(String s, BuildContext context) {}
}

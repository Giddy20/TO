// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:app/models/image_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/profile/location.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
            onTap: () => pickMedia("Camera", context),
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
            onTap: () => pickMedia("Gallery", context),
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

  void pickMedia(String from, BuildContext ctx) async {
    Navigator.of(ctx).pop();
    final pickedFile = await picker.getImage(
      source: from == "Camera" ? ImageSource.camera : ImageSource.gallery,
      maxHeight: Constants.imageSize.height,
      maxWidth: Constants.imageSize.width,
      imageQuality: Constants.imageQuality,
    );
    if (pickedFile != null) {
      pickedMedia = File(pickedFile.path);
      setState(() {
        loading = true;
      });
      uploadMedia(pickedMedia!);
    }
  }

  void uploadMedia(File file) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String id =
          FirebaseFirestore.instance.collection('UserMediaFiles').doc().id;
      final ref = FirebaseStorage.instance.ref().child('mediaFiles').child(id);
      UploadTask uploadTask = ref.putFile(file);
      String url = await (await uploadTask).ref.getDownloadURL();
      if (profileURL.isEmpty) {
        await setProfileImage(url);
      }
      saveImageLink(url, id);
    }
  }

  void saveImageLink(String url, String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("UserMediaFiles")
          .doc(id)
          .set({'userID': user.uid, 'url': url}).then((value) {
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
          // mediaFiles.add(url);
          profileURL = url;
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
          .get()
          .then((value) {
        value.docs.forEach((doc) {
          mFiles.add(doc.data()["url"]);
        });
        setState(() {
          mediaFiles = mFiles;
          loading = false;
        });
      }).catchError((onError) {
        log(onError.toString());
      });
    }
  }

  List<ImageModel> getPhoto(AsyncSnapshot snapshot) {
    List<ImageModel> photos = [];
    if (snapshot.data != null) {
      var docs = snapshot.data.docs;
      docs.forEach((doc) {
        photos.add(
          ImageModel(
            doc.id,
            doc.data()['url'],
            doc.data()['status'] ?? '',
          ),
        );
      });
    }
    return photos;
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
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return const Location();
      }));
    }
  }

  abc() {}
  goToLocation() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Location();
    }));
  }

  @override
  Widget build(BuildContext context) {
    final double itemHeight =
        (MediaQuery.of(context).size.height - kToolbarHeight - 24) / 2.95;
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    User? user = FirebaseAuth.instance.currentUser;
    final Stream<QuerySnapshot> photoStream = FirebaseFirestore.instance
        .collection("UserMediaFiles")
        .where('userID', isEqualTo: user!.uid)
        .snapshots();
    return Scaffold(
      backgroundColor: greenBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 78,
        title: const Text(
          'We Swipe',
          style:
              TextStyle(fontFamily: 'Aliqa', color: whiteColor, fontSize: 78),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: whiteColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Column(
                  children: [
                    SizedBox(
                      // height: MediaQuery.of(context).size.height / 1.3,
                      // width: MediaQuery.of(context).size.width,
                      child: StreamBuilder(
                        stream: photoStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            List<ImageModel> photos = getPhoto(snapshot);
                            if (photos.isEmpty) {
                              return const Center(
                                child: Text("No Photos"),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GridView.count(
                                mainAxisSpacing: 12,
                                childAspectRatio: (itemWidth / itemHeight),
                                crossAxisSpacing: 12,
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                children: List.generate(
                                  photos.length,
                                  (index) {
                                    return Stack(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.7),
                                              borderRadius:
                                                  BorderRadius.circular(32)),
                                          child: Image.network(
                                            photos[index].url,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          right: 10,
                                          child: GestureDetector(
                                            onTap: addMedia,
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: const Icon(
                                                Icons
                                                    .add_circle_outline_outlined,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          left: 10,
                                          child: GestureDetector(
                                            onTap: () => showOptions(
                                                context, photos[index]),
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text("No Photos"),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                ButtonIconLess('Add Photo', whiteColor, whiteColor, whiteColor,
                    1.3, 18, 17, addMedia),
              ],
            ),
    );

    // Scaffold(
    //   backgroundColor: pinkColorshade100,
    //   appBar: AppBar(
    //     toolbarHeight: 78,
    //     title: const Text(
    //       'We Swipe',
    //       style:
    //           TextStyle(fontFamily: 'Aliqa', color: pinkAccent, fontSize: 78),
    //     ),
    //     centerTitle: true,
    //     iconTheme: const IconThemeData(color: pinkAccent),
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //   ),
    //   body: loading
    //       ? const Center(
    //           child: Text(
    //             "Loading....",
    //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    //           ),
    //         )
    //       : SizedBox(
    //           height: MediaQuery.of(context).size.height,
    //           width: MediaQuery.of(context).size.width,
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 16.0),
    //             child: Column(
    //               children: [
    //                 const Text('YOU ARE BEAUTIFUL - ADD YOUR PHOTOS',
    //                     style: TextStyle(color: pinkAccent, fontSize: 16)),
    //                 SizedBox(
    //                     height: 500,
    //                     child: AddPhotoGridScreen(
    //                       mediaFiles,
    //                       addMedia,
    //                     )),
    //                 const SizedBox(
    //                   height: 20,
    //                 ),
    //                 const SizedBox(
    //                   height: 23,
    //                 ),
    //                 ButtonIconLess('CONTINUE', pinkAccent, pinkAccent,
    //                     whiteColor, 1.3, 18, 17, next),
    //               ],
    //             ),
    //           ),
    //         ),
    // );
  }

  myAppBarWithRoundedBackButton(String s, BuildContext context) {}
}

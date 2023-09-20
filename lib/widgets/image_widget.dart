// ignore_for_file: avoid_print, await_only_futures

import 'dart:developer';
import 'dart:io';
import 'package:app/constants.dart';
import 'package:app/models/image_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageWidget extends StatefulWidget {
  final ImageModel im;
  final double? width;
  final double? height;
  const ImageWidget(this.im, {Key? key, this.width, this.height})
      : super(key: key);

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool loading = false;
  final picker = ImagePicker();
  File? pickedMedia;
  late ImageModel iModel;
  Color? iconBgColor;

  @override
  void initState() {
    super.initState();
    iModel = widget.im;
  }

  void addMedia() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: lightGreenColor,
        title: const Text("Image options",
            style: TextStyle(color: lightGoldColor, fontWeight: FontWeight.bold)),
        children: [
          ListTile(
            onTap: () => pickMedia("Camera"),
            leading: const Icon(Icons.camera, color: lightGoldColor),
            title: const Text(
              "CAMERA",
              style: TextStyle(
                color: lightGoldColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: lightGoldColor,),
          ),
          ListTile(
            onTap: () => pickMedia("Gallery"),
            leading: const Icon(
              Icons.picture_in_picture_alt_outlined,
              color: lightGoldColor,
            ),
            title: const Text(
              "GALLERY",
              style: TextStyle(
                color: lightGoldColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: lightGoldColor,),
          ),
          // if (iModel.url.isNotEmpty)
          //   ListTile(
          //     onTap: deleteImage,
          //     leading: const Icon(Icons.delete, color: Colors.red),
          //     title: const Text(
          //       "Delete",
          //       style: TextStyle(
          //         color: Colors.red,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     trailing: const Icon(Icons.delete),
          //   ),
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
      String u = 'mediaFiles/$id';
      String uploadedURL = "";
      try {
        SettableMetadata metadata = SettableMetadata(
          customMetadata: <String, String>{
            'imageFor': widget.im.type,
            'userID': user.uid,
            'docID': id,
          },
        );

        await FirebaseStorage.instance
            .ref()
            .child(u)
            .putFile(pickedMedia!, metadata)
            .then((task) async {
          uploadedURL = await (await task).ref.getDownloadURL();
          log('done');
        });
        if (uploadedURL.isNotEmpty) {
          saveImageLink(uploadedURL, id, widget.im.type);
        }
      } on FirebaseException catch (e) {
        log(e.toString());
      }
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

  Future<void> saveImageLink(String url, String id, String imageFor) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("UserMediaFiles")
          .doc(id)
          .set({
        'userID': user.uid,
        'url': url,
        'type': imageFor,
      }).then((value) async {
        if (widget.im.type == "profile") {
          await setProfileImage(url);
        }
        setState(() {
          iModel.url = url;
          loading = false;
        });
      }).catchError(
        (onError) {
          log(onError.toString());
        },
      );
    }
  }

  void deleteImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pop();
      setState(() {
        loading = true;
      });
      print("here");
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteImage');
      print("here1");
      final results = await callable.call({'ref': widget.im.id});
      print("here");
      print(results.data.toString());
      if (results.data != 'error') {
        setState(() {
          loading = false;
          iModel.url = "";
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GestureDetector(
            onTap: addMedia,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  height: MediaQuery.of(context).size.height/ 4,
                  decoration: BoxDecoration(
                    color: greenBackgroundColor,
                    border: Border.all(color: lightGoldColor, width: 1.3,),
                    borderRadius: BorderRadius.circular(32),
                  ),
                    child: CachedNetworkImage(
                      errorWidget: ((context, url, error) {
                        if (url.isEmpty) {
                          return Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32),
                            color: greenBackgroundColor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/upload.svg",
                                  color: lightGoldColor,
                                  width: 50,),
                                Text("Choose a file",
                                style: GoogleFonts.poppins(fontSize: 18, color: lightGoldColor),)
                              ],
                            ),
                          );
                        }
                        return const Icon(Icons.error_rounded);
                      }),
                      placeholder: (context, url) => const Icon(Icons.image_rounded),
                      imageUrl: iModel.url,
                      fit: BoxFit.scaleDown,
                      height: widget.height,
                      width: widget.width,
                    ),
                  ),
                // if (iModel.url.isNotEmpty)
                // const  Positioned(
                //     top: 0,
                //     right: 0,
                //     child: Icon(Icons.delete, color: goldColor,size: 30),
                //   )
              ],
            ),
          );
  }
}

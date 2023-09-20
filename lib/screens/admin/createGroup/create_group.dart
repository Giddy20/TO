import 'dart:developer';
import 'dart:io';

import 'package:app/constants.dart';
import 'package:app/screens/admin/createGroup/group_filter.dart';
import 'package:app/screens/admin/admin_side_nav.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:app/widgets/new_entry_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController groupNameController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var cont = false;
  var formattedDate;
  var formattedDateTo;
  TimeOfDay time = TimeOfDay.now();
  String groupName = "";
  String eventName = "";
  DateTime currentDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool loading = false;
  int index = 0;
  File? pickedMedia;
  List<String> mediaFiles = [];
  final picker = ImagePicker();
  String iconURL = "";

  @override
  void initState() {
    super.initState();
    formattedDate = 'From';
    formattedDateTo = "To";
  }

  abc() {}
  DateTime? pickedDate;
  Future<void> _startSelectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(DateTime.now().day - 1),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        //pickTime(context);
      });
    }
  }

  Future<void> _endSelectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(DateTime.now().day - 1),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        endDate = pickedDate;
        //  pickTime(context);
      });
    }
  }

  Future pickTime(BuildContext context) async {
    final newTime = await showTimePicker(context: context, initialTime: time);
    if (newTime == null) return;
    setState(() {
      time = newTime;
    });
  }

  void nextPage() {
    if (groupNameController.text.isNotEmpty &&
        eventNameController.text.isNotEmpty &&
        eventLocationController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        iconURL.isNotEmpty) {
      setState(() {
        index += 1;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill the empty fields"),
      ));
    }
  }

  void addMedia() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Align(
          alignment: Alignment.center,
          child: Text("UPLOAD FROM ",
              style:
                  TextStyle(color: goldColor, fontWeight: FontWeight.bold)),
        ),
        children: [
          GestureDetector(
            onTap: () => pickMedia("Camera"),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("CAMERA",
                      style: TextStyle(
                          color: goldColor, fontWeight: FontWeight.bold)),
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
                      color: Colors.purple),
                  SizedBox(width: 10),
                  Text("GALLERY",
                      style: TextStyle(
                          color: goldColor, fontWeight: FontWeight.bold)),
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
      String id =
          FirebaseFirestore.instance.collection('UserMediaFiles').doc().id;
      final ref = FirebaseStorage.instance.ref().child('mediaFiles').child(id);
      UploadTask uploadTask = ref.putFile(file);
      String url = await (await uploadTask).ref.getDownloadURL();
      saveImageLink(url, id);
    }
  }

  void saveImageLink(String url, String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      SharedPreferences prefs = await Constants.getPrefs();
      WriteBatch batch = FirebaseFirestore.instance.batch();
      DocumentReference document =
          FirebaseFirestore.instance.collection("iconUserMedia").doc(id);
      batch.set(document, {'userID': user.uid, 'url': url});
      // updateProfile(url);
      await batch.commit().then((value) {
        prefs.setString("profileURL", url);
        //  getPrefs();
        setState(() {
          loading = false;
          iconURL = url;
        });
      }).catchError(
        (onError) {
          log(onError.toString());
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AdminSideNav(),
      body: IndexedStack(
        index: index,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 16,
                            width: MediaQuery.of(context).size.width / 1.1,
                            decoration: BoxDecoration(
                                color: goldColor,
                                borderRadius: BorderRadius.circular(14)),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    _scaffoldKey.currentState!.openDrawer();
                                  },
                                  child:
                                      const Icon(Icons.menu, color: whiteColor),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Create a group for an upcoming event',
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (iconURL.isEmpty)
                        GestureDetector(
                          onTap: addMedia,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 87,
                            child: CircleAvatar(
                              backgroundColor: whiteColor,
                              radius: 85,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.add,
                                    size: 105,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    'ADD GROUP ICON',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (iconURL.isNotEmpty)
                        CircleAvatar(
                          backgroundImage: NetworkImage(iconURL),
                          radius: 85,
                        //,
                        ),
                      const SizedBox(height: 30),
                      // NewEntryField(
                      //     'Group name',
                      //     goldColor,
                      //     TextInputType.name,
                      //     groupNameController,
                      //     false,
                      //     Icons.mail,
                      //     Colors.transparent,
                      //     goldColor,
                      //     false,
                      //     1,
                      //     1.1),
                      // const SizedBox(height: 10),
                      // NewEntryField(
                      //     'Event name',
                      //     goldColor,
                      //     TextInputType.text,
                      //     eventNameController,
                      //     false,
                      //     Icons.mail,
                      //     Colors.transparent,
                      //     goldColor,
                      //     false,
                      //     1,
                      //     1.1),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => _startSelectDate(context),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: goldColor),
                                ),
                                child: ListTile(
                                  leading: Column(
                                    children: [
                                      const Text(
                                        "FROM :",
                                        style: TextStyle(
                                            color: goldColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        currentDate.year.toString() +
                                            " -" +
                                            currentDate.month.toString() +
                                            " -" +
                                            currentDate.day.toString(),
                                        style:
                                            const TextStyle(color: goldColor),
                                      ),
                                    ],
                                  ),
                                  //subtitle: const Text("FROM"),
                                  trailing: const Icon(Icons.calendar_today,
                                      color: goldColor),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            GestureDetector(
                              onTap: () => _endSelectDate(context),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: goldColor),
                                ),
                                child: ListTile(
                                  leading: Column(
                                    children: [
                                      const Text(
                                        "TO :",
                                        style: TextStyle(
                                            color: goldColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        endDate.year.toString() +
                                            " -" +
                                            endDate.month.toString() +
                                            " -" +
                                            endDate.day.toString(),
                                        style:
                                            const TextStyle(color: goldColor),
                                      ),
                                    ],
                                  ),
                                  trailing: const Icon(Icons.calendar_today,
                                      color: goldColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Starts At :      ',
                            style: TextStyle(
                                color: goldColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          GestureDetector(
                            onTap: () => pickTime(context),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: goldColor)),
                              child: ListTile(
                                leading: Text(
                                  time.hour.toString() +
                                      " : " +
                                      time.minute.toString(),
                                  style: const TextStyle(color: goldColor),
                                ),
                                trailing: Text(
                                  time.period.name,
                                  style: const TextStyle(color: goldColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // NewEntryField(
                      //     'Event location',
                      //     goldColor,
                      //     TextInputType.emailAddress,
                      //     eventLocationController,
                      //     false,
                      //     Icons.mail,
                      //     Colors.transparent,
                      //     goldColor,
                      //     false,
                      //     1,
                      //     1.1),
                      // const SizedBox(height: 10),
                      // NewEntryField(
                      //     'Ticket Price',
                      //     goldColor,
                      //     TextInputType.text,
                      //     priceController,
                      //     false,
                      //     Icons.mail,
                      //     Colors.transparent,
                      //     goldColor,
                      //     false,
                      //     1,
                      //     1.1),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ButtonIconLess('CONTINUE', goldColor, goldColor,
                        whiteColor, 1.2, 14, 16, nextPage),
                  ),
                ],
              ),
            ),
          ),
          GroupFilters(
              groupNameController.text,
              eventNameController.text,
              currentDate,
              endDate,
              time,
              eventLocationController.text,
              priceController.text,
              iconURL),
        ],
      ),
    );
  }
}

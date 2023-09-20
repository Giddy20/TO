// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'package:app/models/chat_room.dart';
import 'package:app/screens/message/chat.dart';
import 'package:app/screens/message/group_messages.dart';
import 'package:app/screens/message/notify_bubble.dart';
import 'package:app/screens/side_nav.dart';
import 'package:app/widgets/event_invitation.dart';
import 'package:app/widgets/icons/custom_we_swipe_icons_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/screens/premier_league.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool loading = false;
  List<String> eventsID = [];

  var cont = false;
  var currentIndex;
  var selectedTab = "";
  List tab = [
    'Chat',
    'Groups',
  ];

  PageController pageController = PageController();


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ChatRoom> getRooms(AsyncSnapshot snapshot) {
    List<ChatRoom> chatrooms = [];
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      chatrooms = snapshot.data.docs.map<ChatRoom>((doc) {
        List<String> users = [];
        List<dynamic> us = doc.data()['users'];
        us.forEach((element) {
          users.add(element.toString());
        });
        return ChatRoom(
          doc.id,
          doc.data()['lastMessage'] ?? "",
          doc.data()['lastMessageID'] ?? "",
          doc.data()['lastMessageBy'] ?? "",
          doc.data()['timestamp'] ?? Timestamp.now(),
          users,
        );
      }).toList();
    }
    return chatrooms;
  }

  void tapped(String otherUser, String chatRoomID) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Chat(
            chatRoomID,
            otherUser,
          );
        },
      ),
    );
  }

  List<Widget> getChildren(List<ChatRoom> rooms) {
    List<Widget> children = [];
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (int i = 0; i < rooms.length; i++) {
        DateTime dt = rooms[i].timestamp.toDate();
        String fTD = "${dt.hour}:${dt.minute}";
        String otherUser = "";
        for (int j = 0; j < rooms[i].users.length; j++) {
          if (rooms[i].users[j] != user.uid) {
            otherUser = rooms[i].users[j];
          }
        }
        bool isVideo = rooms[i].lastMessage.endsWith('started a video call') ? true : false;
        children.add(
          GestureDetector(
            onTap: () => tapped(otherUser, rooms[i].id),
            child: NotifyBubble(
              rooms[i].lastMessage,
              dt.toString(),
              otherUser,
              isVideo,
            ),
          ),
        );
      }
    }
    return children;
  }

  goToPremierLeague() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const PremierLeague();
    }));
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final Stream<QuerySnapshot> chatRoomsStream = FirebaseFirestore.instance
        .collection("chatRooms")
        .where("users", arrayContains: user!.uid)
        .where("type", isEqualTo: 'oneTOone')
        .snapshots();
    return Scaffold(
      key: _scaffoldKey,
      drawer:  SideNav(),
      backgroundColor: greenBackgroundColor,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   leading: GestureDetector(
      //     onTap: () {
      //       _scaffoldKey.currentState!.openDrawer();
      //     },
      //     child: Padding(
      //       padding:  EdgeInsets.symmetric(horizontal: 13.0),
      //       child: SvgPicture.asset("assets/menu.svg"),
      //     ),
      //   ),
      //   title: Text(
      //     'Message',
      //     style: GoogleFonts.poppins(color: whiteColor, fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tabs(tab[0], 0),
                    tabs(tab[1], 1),
                  ],
                ),

                verticalSpace(0.05),

                Expanded(
                  child: PageView(
                    controller: pageController,
                    children: [
                      Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Chat',
                              style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          kSpacing,
                          kSpacing,
                          StreamBuilder(
                            stream: chatRoomsStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.active) {
                                List<ChatRoom> rooms = getRooms(snapshot);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: getChildren(rooms),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: whiteColor,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),

                      ListView(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Groups for upcoming events :',
                              style: TextStyle(
                                  color: whiteColor, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          kSpacing,
                          kSpacing,
                          // GestureDetector(
                          //   onTap: goToPremierLeague,
                          //   child: const MessagesListTile('Premier League Final',
                          //       "Ken:I don't like Arsenal Loll ", 'assets/pic.jpg'),
                          // ),
                          const GroupMessages(),
                          const EventInvitation(),
                        ],
                      )
                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tabs(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentIndex = index;
            selectedTab = tab[currentIndex];
            //  print(selectedGender);
            if(pageController.page != 0.0){
              pageController.previousPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn);
            }
            else{
              pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn);
            }
            currentIndex == index ? cont = true : cont = false;
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 22,
          width: MediaQuery.of(context).size.width / 3.8,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: currentIndex == index
              ? BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(34),

          )
              : BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: lightGoldColor, width: 2),
          ),
          // ignore: deprecated_member_use
          child: Center(
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: currentIndex == index ? FontWeight.bold : FontWeight.w600,
                color: currentIndex == index ? whiteColor : lightGoldColor,
                //  letterSpacing: 0.10,
              ),
            ),
          ),
        ),
      ),
    );
  }

}

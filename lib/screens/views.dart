
import 'package:app/constants.dart';
import 'package:app/profile/add_photo.dart';
import 'package:app/screens/Swipe/discover.dart';
import 'package:app/screens/my_profile.dart';
import 'package:app/screens/side_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart';

import 'message/messages.dart';

class Views extends StatefulWidget {
  const Views({Key? key}) : super(key: key);

  @override
  State<Views> createState() => _HomeState();
}

class _HomeState extends State<Views> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  TabController? _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _tabController!.index = _selectedIndex = index;
    });
  }

  List titles = [
    "Your Matches",
    "Upload Photos",
    "Message",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer:  SideNav(),
      backgroundColor: greenBackgroundColor,
      appBar: AppBar(
        backgroundColor: greenBackgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 13.0),
            child: SvgPicture.asset("assets/menu.svg"),
          ),
        ),
        title:  Text(titles[_selectedIndex],
          style: GoogleFonts.poppins(color: whiteColor, fontWeight: FontWeight.bold),)
        ,
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        // swipe navigation handling is not supported
        controller: _tabController,
        children: [
         Discover(),
          AddPhoto(),
          Messages(),
          MyProfile(),
        ],
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.only(top: 7),
          decoration: BoxDecoration(
            color: lightGreenColor,
          ),
          child: BottomNav()
      ),
    );
  }

  Widget BottomNav(){
    return  Container(
      height: 82,
      decoration: BoxDecoration(
        color: lightGreenColor,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(25, 00, 25, 23),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => _onItemTapped(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset("assets/home.svg",
                      color:  _selectedIndex == 0 ? lightGoldColor : whiteColor.withOpacity(0.5),
                      width: 25,)
                  ),
                  Text("Home",
                    style: GoogleFonts.poppins(color:  _selectedIndex == 0 ? lightGoldColor : whiteColor.withOpacity(0.5)),)

                ],
              ),
            ),
            // InkWell(
            //   // onTap: () => _onItemTapped(1),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(5.0),
            //         child:  SvgPicture.asset("assets/search.svg",
            //           color:  _selectedIndex == 1 ? lightGoldColor : whiteColor.withOpacity(0.5),
            //           width: 25,)
            //       ),
            //       Text("Search",
            //         style: GoogleFonts.poppins(color:  _selectedIndex == 1 ? lightGoldColor : whiteColor.withOpacity(0.5)),)
            //
            //     ],
            //   ),
            // ),
            InkWell(
              onTap: () => _onItemTapped(1),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -35,
                    right: -12,
                    child:  InkWell(
                      onTap: () => _onItemTapped(1),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: lightGoldColor,
                          gradient: gradient,
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SvgPicture.asset("assets/photo.svg",
                              color:  _selectedIndex == 1 ? whiteColor : whiteColor,
                              width: 25,)
                        ),
                      ),
                    ),),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Text("Photo",
                        style: GoogleFonts.poppins(color:  _selectedIndex == 1 ? lightGoldColor : whiteColor.withOpacity(0.5)),),


                    ],
                  ),

                ],
              ),
            ),
            InkWell(
              onTap: () => _onItemTapped(2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset("assets/chat.svg",
                      color:  _selectedIndex == 2 ? lightGoldColor : whiteColor.withOpacity(0.5),
                      width: 25,)
                  ),
                  Text("Chat",
                    style: GoogleFonts.poppins(color:  _selectedIndex == 2 ? lightGoldColor : whiteColor.withOpacity(0.5)),)

                ],
              ),
            ),

            InkWell(
              onTap: () => _onItemTapped(3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset("assets/profile.svg",
                      color:  _selectedIndex == 3 ? lightGoldColor : whiteColor.withOpacity(0.5),
                      width: 25,)
                  ),
                  Text("Profile",
                  style: GoogleFonts.poppins(color:  _selectedIndex == 3 ? lightGoldColor : whiteColor.withOpacity(0.5)),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


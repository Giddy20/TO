// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../constants.dart';
//
//
// Widget BottomNav(_selectedIndex, onTap){
//   return  Container(
//     height: 82,
//     decoration: BoxDecoration(
//       color: lightGreenColor,
//     ),
//     child: Padding(
//       padding: EdgeInsets.fromLTRB(25, 00, 25, 23),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           InkWell(
//             onTap: () => _onItemTapped(0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: SvgPicture.asset("assets/home.svg",
//                       color:  _selectedIndex == 0 ? lightGoldColor : whiteColor.withOpacity(0.5),
//                       width: 25,)
//                 ),
//                 Text("Home",
//                   style: GoogleFonts.poppins(color:  _selectedIndex == 0 ? lightGoldColor : whiteColor.withOpacity(0.5)),)
//
//               ],
//             ),
//           ),
//           InkWell(
//             // onTap: () => _onItemTapped(1),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child:  SvgPicture.asset("assets/search.svg",
//                       color:  _selectedIndex == 1 ? lightGoldColor : whiteColor.withOpacity(0.5),
//                       width: 25,)
//                 ),
//                 Text("Search",
//                   style: GoogleFonts.poppins(color:  _selectedIndex == 1 ? lightGoldColor : whiteColor.withOpacity(0.5)),)
//
//               ],
//             ),
//           ),
//           InkWell(
//             onTap: () => _onItemTapped(2),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 Positioned(
//                   top: -35,
//                   right: -12,
//                   child:  InkWell(
//                     onTap: () => _onItemTapped(2),
//                     child: Container(
//                       padding: EdgeInsets.all(15),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: lightGoldColor,
//                         gradient: gradient,
//                       ),
//                       child: Padding(
//                           padding: const EdgeInsets.all(5.0),
//                           child: SvgPicture.asset("assets/photo.svg",
//                             color:  _selectedIndex == 2 ? whiteColor : whiteColor,
//                             width: 25,)
//                       ),
//                     ),
//                   ),),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//
//                     Text("Photo",
//                       style: GoogleFonts.poppins(color:  _selectedIndex == 2 ? lightGoldColor : whiteColor.withOpacity(0.5)),),
//
//
//                   ],
//                 ),
//
//               ],
//             ),
//           ),
//           InkWell(
//             onTap: () => _onItemTapped(3),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: SvgPicture.asset("assets/chat.svg",
//                       color:  _selectedIndex == 3 ? lightGoldColor : whiteColor.withOpacity(0.5),
//                       width: 25,)
//                 ),
//                 Text("Chat",
//                   style: GoogleFonts.poppins(color:  _selectedIndex == 3 ? lightGoldColor : whiteColor.withOpacity(0.5)),)
//
//               ],
//             ),
//           ),
//
//           InkWell(
//             onTap: () => _onItemTapped(4),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: SvgPicture.asset("assets/profile.svg",
//                       color:  _selectedIndex == 4 ? lightGoldColor : whiteColor.withOpacity(0.5),
//                       width: 25,)
//                 ),
//                 Text("Profile",
//                   style: GoogleFonts.poppins(color:  _selectedIndex == 4 ? lightGoldColor : whiteColor.withOpacity(0.5)),)
//               ],
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }
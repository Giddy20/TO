import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';


class ViewProfile extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String age;
  final String profileUrl;
  final String distance;
  final String jobTitle;
  final String about;
  final String height;
  final String religion;
  const ViewProfile(this.firstName, this.lastName, this.age, this.profileUrl, this.distance,
  this.jobTitle, this.about, this.height, this.religion, {Key? key}) : super(key: key);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.firstName +  " " +
          widget.lastName +
           ", " +  widget.age,
          style: const TextStyle(color: blackColor, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: blackColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.08,
                  height: MediaQuery.of(context).size.height / 1.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image:  DecorationImage(
                          image: NetworkImage(widget.profileUrl),
                          fit: BoxFit.cover)),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:10.0),
                child: Row(children: [
                  const Icon(Icons.pin_drop),
                 const SizedBox(width: 5,), 
                  Text( widget.distance  + ' miles away',style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18),)
                ],),
              ),
             if (widget.jobTitle.isNotEmpty)  
                Padding(
                padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10),
                child: 
                Row(children: [
                  const Icon(CupertinoIcons.briefcase),
                  const SizedBox(width: 5,),
                  Text(widget.jobTitle ,style: const  TextStyle(fontWeight: FontWeight.w500,fontSize: 18),)
                ],),
              ),
              const SizedBox(height: 10,),
              const Padding(
                 padding:  EdgeInsets.only(left:12.0),
                 child:  Text("About :", style: 
                 TextStyle(fontWeight: FontWeight.w600,
                 fontSize: 16),),
               ),
               const SizedBox(height: 10,),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal:12.0),
                child: Text(widget.about,style: const TextStyle(fontSize: 16),textAlign: TextAlign.justify,),
              ),
              const SizedBox(height: 5,),
               if (widget.height.isNotEmpty)
               const Padding(
                 padding:  EdgeInsets.only(left:12.0),
                 child:  Text("Height :", style: 
                 TextStyle(fontWeight: FontWeight.w600,
                 fontSize: 16),),
               ),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10),
                child: 
                Row(children: [
                  const Icon(Icons.leaderboard, color: goldColor,),
                  const SizedBox(width: 5,),
                  Text(widget.height ,style: const  
                  TextStyle(fontWeight: FontWeight.w500,fontSize: 14),)
                ],),
              ),  
              const SizedBox(height: 5,),
              if (widget.religion.isNotEmpty)
              const Padding(
                 padding:  EdgeInsets.only(left:12.0),
                 child:  Text("Religion :", style: 
                 TextStyle(fontWeight: FontWeight.w600,
                 fontSize: 16),),
               ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10),
                child: 
                Row(children: [
                  const Icon(Icons.clean_hands, color: goldColor,),
                  const SizedBox(width: 5,),
                  Text(widget.religion ,style: const  
                  TextStyle(fontWeight: FontWeight.w500,fontSize: 14),)
                ],),
              ), 
              // const SizedBox(height: 5,),
              // Row(

              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Card(
              //       elevation: 12,
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(50)),
              //       child: Container(
              //         height: 40,
              //         width: 40,
              //         decoration: BoxDecoration(
              //             border: Border.all(color: whiteColor, width: 6),
              //             shape: BoxShape.circle),
              //         child: GestureDetector(
              //           //       onTap: goToMatch,
              //           child: const CircleAvatar(
              //             radius: 30,
              //             backgroundColor: whiteColor,
              //             foregroundColor: whiteColor,
              //             child: Icon(
              //               Icons.cancel_outlined,
              //               color: blackColor,
              //               size: 20,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     Card(
              //       elevation: 12,
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(50)),
              //       child: Container(
              //         height: 40,
              //         width: 40,
              //         decoration: BoxDecoration(
              //             border: Border.all(color: whiteColor, width: 6),
              //             shape: BoxShape.circle),
              //         child: GestureDetector(
              //           //       onTap: goToMatch,
              //           child: const CircleAvatar(
              //             radius: 30,
              //             backgroundColor: whiteColor,
              //             foregroundColor: whiteColor,
              //             child: Icon(
              //               Icons.favorite,
              //               color: pinkAccent,
              //               size: 20,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Card(
              //         elevation: 4,
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(40)),
              //         child: Container(
              //           height: 35,
              //           width: 35,
              //           decoration: BoxDecoration(
              //               border: Border.all(color: whiteColor, width: 6),
              //               shape: BoxShape.circle),
              //           child: GestureDetector(
              //             //       onTap: goToMatch,
              //             child: const CircleAvatar(
              //               radius: 30,
              //               backgroundColor: whiteColor,
              //               foregroundColor: whiteColor,
              //               child: Icon(
              //                 Icons.pin_drop_outlined,
              //                 color: Colors.purple,
              //                 size: 25,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Card(
              //         elevation: 4,
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(40)),
              //         child: Container(
              //           height: 35,
              //           width: 35,
              //           decoration: BoxDecoration(
              //               border: Border.all(color: whiteColor, width: 6),
              //               shape: BoxShape.circle),
              //           child: GestureDetector(
              //             //       onTap: goToMatch,
              //             child: const CircleAvatar(
              //               radius: 30,
              //               backgroundColor: whiteColor,
              //               foregroundColor: whiteColor,
              //               child: Icon(
              //                 Icons.message,
              //                 color: Colors.purple,
              //                 size: 25,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );

  }
}

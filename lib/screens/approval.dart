import 'package:app/screens/message/messages.dart';
import 'package:app/screens/views.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Approval extends StatefulWidget {
  const   Approval({Key? key}) : super(key: key);

  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  goToHome() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) {
      return const Views();
    }),  (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: greenBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: whiteColor),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   SizedBox(
                        width: 200,
                        child: Image.asset('assets/logo.png'),
                  ),
                    Column(
                      children: [
                        SvgPicture.asset('assets/hourglass.svg', color: lightGoldColor,),
                       const SizedBox(
                          height: 20,
                        ),
                       const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                                "YOU WILL BE ABLE TO USE THE APPLICATION AFTER ADMIN'S APPROVAL",
                                style: TextStyle(
                                    color: lightGoldColor, fontSize: 18),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                    ButtonIconLess('COME BACK LATER', whiteColor, whiteColor,
                        whiteColor, 1.3, 14, 17, goToHome),
                  ]),
            )));
  }
}

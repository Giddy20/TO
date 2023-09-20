import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Agreement extends StatelessWidget {
  const Agreement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenBackgroundColor,
      appBar: AppBar(
        title: Text("Terms & Conditions",
        style: GoogleFonts.poppins(color: whiteColor, fontWeight: FontWeight.bold),),
        backgroundColor: greenBackgroundColor,
      ),
      body: const WebView(
        initialUrl: "https://sycevents.com/pages/privacy",
      ),
    );
  }
}

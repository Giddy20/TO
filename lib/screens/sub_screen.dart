// import 'dart:developer';
//
// import 'package:app/constants.dart';
// import 'package:app/providers/iap_provider.dart';
// import 'package:app/screens/my_profile.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// // import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:provider/provider.dart';
//
// class SubScreen extends StatefulWidget {
//   const SubScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SubScreen> createState() => _SubScreenState();
// }
//
// class _SubScreenState extends State<SubScreen> {
//   bool loading = false;
//   bool subscribed = false;
//
//   @override
//   void initState() {
//     Provider.of<IAPProvider>(context, listen: false).startiap();
//     super.initState();
//     checkForSub();
//   }
//
//   checkForSub() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         loading = true;
//       });
//       await FirebaseFirestore.instance
//           .collection("subscribed")
//           .doc(user.uid)
//           .get()
//           .then((doc) {
//         if (doc.exists) {
//           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
//             return const MyProfile();
//           }));
//         } else {
//           setState(() {
//             loading = false;
//           });
//         }
//       }).catchError((onError) {
//         log(onError);
//       });
//     }
//   }
//
//   void restorePurchase() async {
//     Constants.showMessage(context, 'Restoring your previous purchases if any');
//     await Provider.of<IAPProvider>(context, listen: false).restorePurchase();
//   }
//
//   void buySub() async {
//     List<ProductDetails> products =
//         Provider.of<IAPProvider>(context, listen: false).products;
//     if (products.isNotEmpty) {
//       bool result = await Provider.of<IAPProvider>(context, listen: false)
//           .buySub(context, products[0]);
//       if (result) {
//         await updateDBForSub(products[0]);
//         Constants.showMessage(context, 'Subscribed successfully');
//         checkForSub();
//       } else {
//         Constants.showMessage(context, 'Please try again later');
//       }
//     } else {
//       Constants.showMessage(context, 'Please try again later');
//     }
//   }
//
//   Future updateDBForSub(ProductDetails product) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await FirebaseFirestore.instance
//           .collection("subscribed")
//           .doc(user.uid)
//           .set({
//             'subID': product.id,
//             'timestamp': FieldValue.serverTimestamp(),
//           })
//           .then((value) {})
//           .catchError((onError) {
//             log(onError);
//           });
//     }
//   }
//
//   void startTrial() async {
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: loading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Image.asset("assets/sub.png"),
//                   ),
//                   const Text("Get personalized matches"),
//                   const SizedBox(height: 5),
//                   const Text("Complete profile of users"),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: buySub,
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 50),
//                       primary: pinkColorshade200,
//                     ),
//                     child: Column(
//                       children: const [
//                         Text(
//                           "\$17.99 for 6 months ",
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           "SUBSCRIBE",
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Center(
//                     child: TextButton(
//                       child: const Text(
//                         "Restore Purchases",
//                         style: TextStyle(
//                           color: pinkColorshade200,
//                         ),
//                       ),
//                       onPressed: restorePurchase,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   /*
//                   Center(
//                     child: TextButton(
//                       child: const Text(
//                         "Start 3-day trial",
//                         style: TextStyle(
//                           color: pinkColorshade200,
//                         ),
//                       ),
//                       onPressed: startTrial,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   */
//                 ],
//               ),
//             ),
//     );
//   }
// }

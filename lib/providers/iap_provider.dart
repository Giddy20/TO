// import 'dart:async';
// import 'dart:io';
// import 'package:app/providers/consumable_store.dart';
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
//
// const bool _kAutoConsume = true;
//
// const String _kConsumableId = 'consumable';
// const String _kUpgradeId = 'upgrade';
// const String _kSilverSubscriptionId = 'sub_6a';
// //const String _kGoldSubscriptionId = 'sub_12';
// const List<String> _kProductIds = <String>[
//   _kSilverSubscriptionId,
//   //_kGoldSubscriptionId,
// ];
//
// class IAPProvider with ChangeNotifier {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<String> notFoundIds = [];
//   List<ProductDetails> products = [];
//   List<PurchaseDetails> _purchases = [];
//   List<String> consumables = [];
//   bool isAvailable = false;
//   bool purchasePending = false;
//   bool loading = true;
//   String? queryProductError;
//   String selectedSub = "";
//
//   void startiap() {
//     final Stream<List<PurchaseDetails>> purchaseUpdated =
//         _inAppPurchase.purchaseStream;
//     _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription.cancel();
//     }, onError: (error) {
//       // handle error here.
//     });
//     initStoreInfo();
//   }
//
//   @override
//   void dispose() {
//     if (Platform.isIOS) {
//       var iosPlatformAddition = _inAppPurchase
//           .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       iosPlatformAddition.setDelegate(null);
//     }
//     _subscription.cancel();
//     super.dispose();
//   }
//
//   Future<void> initStoreInfo() async {
//     isAvailable = await _inAppPurchase.isAvailable();
//     if (!isAvailable) {
//       products = [];
//       _purchases = [];
//       notFoundIds = [];
//       consumables = [];
//       purchasePending = false;
//       loading = false;
//       notifyListeners();
//     }
//
//     if (Platform.isIOS) {
//       var iosPlatformAddition = _inAppPurchase
//           .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
//     }
//
//     ProductDetailsResponse productDetailResponse =
//         await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       queryProductError = productDetailResponse.error!.message;
//       products = productDetailResponse.productDetails;
//       _purchases = [];
//       notFoundIds = productDetailResponse.notFoundIDs;
//       consumables = [];
//       purchasePending = false;
//       loading = false;
//       notifyListeners();
//     }
//
//     if (productDetailResponse.productDetails.isEmpty) {
//       queryProductError = null;
//       products = productDetailResponse.productDetails;
//       _purchases = [];
//       notFoundIds = productDetailResponse.notFoundIDs;
//       consumables = [];
//       purchasePending = false;
//       loading = false;
//       notifyListeners();
//     }
//
//     consumables = await ConsumableStore.load();
//     products = productDetailResponse.productDetails;
//     notFoundIds = productDetailResponse.notFoundIDs;
//     purchasePending = false;
//     loading = false;
//     notifyListeners();
//   }
//
//   Future<void> consume(String id) async {
//     await ConsumableStore.consume(id);
//     consumables = await ConsumableStore.load();
//     notifyListeners();
//   }
//
//   void deliverProduct(PurchaseDetails purchaseDetails) async {
//     if (purchaseDetails.productID == _kConsumableId) {
//       await ConsumableStore.save(purchaseDetails.purchaseID!);
//       consumables = await ConsumableStore.load();
//       purchasePending = false;
//     } else {
//       _purchases.add(purchaseDetails);
//       //selectedSub = purchaseDetails.productID;
//       selectedSub = "1";
//       purchasePending = false;
//     }
//     notifyListeners();
//   }
//
//   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//     return Future<bool>.value(true);
//   }
//
//   void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {}
//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//     purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         purchasePending = true;
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           purchasePending = false;
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           bool valid = await _verifyPurchase(purchaseDetails);
//           if (valid) {
//             deliverProduct(purchaseDetails);
//           } else {
//             _handleInvalidPurchase(purchaseDetails);
//             return;
//           }
//         }
//         if (Platform.isAndroid) {
//           if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
//             final InAppPurchaseAndroidPlatformAddition androidAddition =
//                 _inAppPurchase.getPlatformAddition<
//                     InAppPurchaseAndroidPlatformAddition>();
//             await androidAddition.consumePurchase(purchaseDetails);
//           }
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           await _inAppPurchase.completePurchase(purchaseDetails);
//         }
//       }
//     });
//   }
//
//   Future<bool> confirmPriceChange(BuildContext context, String sku) async {
//     bool result = false;
//     if (Platform.isAndroid) {
//       final InAppPurchaseAndroidPlatformAddition androidAddition =
//           _inAppPurchase
//               .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
//       var priceChangeConfirmationResult =
//           await androidAddition.launchPriceChangeConfirmationFlow(
//         sku: sku,
//       );
//       if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
//         result = true;
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Price change accepted'),
//         ));
//       } else {
//         result = false;
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(
//             priceChangeConfirmationResult.debugMessage ??
//                 "Price change failed with code ${priceChangeConfirmationResult.responseCode}",
//           ),
//         ));
//       }
//     }
//     if (Platform.isIOS) {
//       var iapStoreKitPlatformAddition = _inAppPurchase
//           .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
//       result = true;
//     }
//     return result;
//   }
//
//   GooglePlayPurchaseDetails? _getOldSubscription(
//       ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
//     GooglePlayPurchaseDetails? oldSubscription;
//     if (productDetails.id == _kSilverSubscriptionId &&
//         purchases[_kSilverSubscriptionId] != null) {
//       oldSubscription =
//           purchases[_kSilverSubscriptionId] as GooglePlayPurchaseDetails;
//     } else if (productDetails.id == _kSilverSubscriptionId &&
//         purchases[_kSilverSubscriptionId] != null) {
//       oldSubscription =
//           purchases[_kSilverSubscriptionId] as GooglePlayPurchaseDetails;
//     }
//     return oldSubscription;
//   }
//
//   Future<bool> buySub(
//       BuildContext context, ProductDetails productDetails) async {
//     bool result = false;
//
//     Map<String, PurchaseDetails> purchases =
//         Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
//       if (purchase.pendingCompletePurchase) {
//         _inAppPurchase.completePurchase(purchase);
//       }
//       return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
//     }));
//     PurchaseDetails? previousPurchase = purchases[productDetails.id];
//     if (previousPurchase != null) {
//       result = await confirmPriceChange(context, productDetails.id);
//     } else {
//       late PurchaseParam purchaseParam;
//
//       if (Platform.isAndroid) {
//         final oldSubscription = _getOldSubscription(productDetails, purchases);
//
//         purchaseParam = GooglePlayPurchaseParam(
//             productDetails: productDetails,
//             applicationUserName: null,
//             changeSubscriptionParam: (oldSubscription != null)
//                 ? ChangeSubscriptionParam(
//                     oldPurchaseDetails: oldSubscription,
//                     prorationMode: ProrationMode.immediateWithTimeProration,
//                   )
//                 : null);
//       } else {
//         purchaseParam = PurchaseParam(
//           productDetails: productDetails,
//           applicationUserName: null,
//         );
//       }
//       if (productDetails.id == _kConsumableId) {
//         result = await _inAppPurchase.buyConsumable(
//             purchaseParam: purchaseParam,
//             autoConsume: _kAutoConsume || Platform.isIOS);
//       } else {
//         result =
//             await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//       }
//     }
//     return result;
//   }
//
//   Future<void> restorePurchase() async {
//     await _inAppPurchase.restorePurchases();
//   }
// }
//
// class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//   @override
//   bool shouldContinueTransaction(
//       SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
//     return true;
//   }
//
//   @override
//   bool shouldShowPriceConsent() {
//     return false;
//   }
// }

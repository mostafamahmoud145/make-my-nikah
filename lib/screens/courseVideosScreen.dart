
// import 'dart:convert';
// import 'dart:io';


// import 'package:basic_utils/basic_utils.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:grocery_store/config/app_fonts.dart';
// import 'package:grocery_store/models/courses.dart';
// import 'package:grocery_store/widget/resopnsive.dart';
// //import 'package:paginate_firestore/bloc/pagination_listeners.dart';
// import '../FireStorePagnation/bloc/pagination_listeners.dart';
// import '../FireStorePagnation/paginate_firestore.dart';import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:uuid/uuid.dart';
// import '../config/app_values.dart';
// import '../config/assets_manager.dart';
// import '../config/colorsFile.dart';
// import '../config/paths.dart';
// import '../localization/localization_methods.dart';
// import '../models/courseVideo.dart';
// import '../models/user.dart';
// import '../widget/IconButton.dart';
// import '../widget/TextButton.dart';
// import '../widget/videoItem.dart';

// class CourseVideosScreen extends StatefulWidget {
//   final Courses course;
//   final String? loggedUserId;
//   const CourseVideosScreen({Key? key,  required this.course,  this.loggedUserId}) : super(key: key);
//   @override
//   _CourseVideosScreenState createState() => _CourseVideosScreenState();
// }

// class _CourseVideosScreenState extends State<CourseVideosScreen> with SingleTickerProviderStateMixin {
//   PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
//   bool buy=false,sharing=false;
//   @override
//   void initState() {
//     updateViewCount();
//     super.initState();

//   }
//   updateViewCount() async {
//     await  FirebaseFirestore.instance.collection("Courses").doc(widget.course.courseId).update(
//       {
//         "views":FieldValue.increment(1),
//       },
//     );
//   }


//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery .of(context).size;
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body:SafeArea(
//           child: Stack(children: [
//             Column(
//               children: <Widget>[
//                 // Container(
//                 //     width: size.width,
//                 //     height: AppSize.h386_6.h,
//                 //     color: Color.fromRGBO(48, 48, 48,1),
//                 //      padding: EdgeInsets.symmetric(horizontal: AppPadding.p32.w,),
//                 //     child: Stack(fit:StackFit.expand,children: [
//                 //       Align(
//                 //         alignment: Alignment.bottomCenter,
//                 //         child:CachedNetworkImage(
//                 //             memCacheHeight: 500,memCacheWidth: 500,
//                 //             imageUrl: widget.course.image,
//                 //             fit: BoxFit.fill,
//                 //             height: AppSize.h356.h,
//                 //             width:  AppSize.w454_6.w,
//                 //             placeholder: (context, url) => Center(
//                 //               child: Container(height: 100,
//                 //                 child: Center(
//                 //                   child: Image.asset(
//                 //                       'assets/icons/icon/load2.gif',
//                 //                       width: 40,
//                 //                       height: 40,
//                 //                       //fit: BoxFit.fill
//                 //                   ),
//                 //                 ),
//                 //               ),
//                 //             ),
//                 //             errorWidget: (context, url, error) => Center(
//                 //               child: Image.asset(
//                 //                 'assets/icons/icon/Mask Group 47.png',
//                 //                 width: 70,
//                 //                 height: 70,
//                 //               ),
//                 //             ),
//                 //           ),
//                 //       ),
//                 //       Positioned(
//                 //         top: AppPadding.p42_6.h,
//                 //         right: 0,
//                 //         child: sharing?CircularProgressIndicator():IconButton1(onPress:() {
//                 //           share(context);
//                 //         }, Width: AppSize.w53_3.r, Height: AppSize.h53_3.r,ButtonBackground: Colors.transparent,BoxShape1: BoxShape.circle,Icon: AssetsManager.blackShareIconPath.toString(),IconWidth: 32.r,IconHeight: 32.r,IconColor: AppColors.white,BorderColor: AppColors.white,),
//                 //       ),
//                 //       Positioned(
//                 //         top: AppPadding.p42_6.h,
//                 //         child: IconButton1(onPress:() {
//                 //           Navigator.pop(context);
//                 //         }, Width: AppSize.w53_3.r, Height: AppSize.h53_3.r,ButtonBackground: Colors.transparent,BoxShape1: BoxShape.circle,Icon: AssetsManager.blackIosArrowLeftIconPath.toString(),IconWidth: AppSize.w28_4.r,IconHeight: AppSize.h28_4.r,IconColor: AppColors.white,BorderColor: AppColors.white,),
//                 //       )
//                 //       ,
//                 //     ])
//                 // ),
            
//                 // Padding(
//                 //   padding:EdgeInsets.only(
//                 //   left: AppPadding.p32.w,
//                 //   right: AppPadding.p32.w,
//                 //   top: AppPadding.p98_6.h),
//                 //   child: Column(
//                 //     mainAxisAlignment: MainAxisAlignment.start,
//                 //     children: [
//                 //       Row(
//                 //       mainAxisAlignment :MainAxisAlignment.spaceBetween,
//                 //       crossAxisAlignment:CrossAxisAlignment.center,
//                 //       children: [
//                 //         Expanded(
//                 //           child: Text(
//                 //             StringUtils.capitalize( widget.course.title),
//                 //             maxLines:1,
//                 //             overflow: TextOverflow.ellipsis,
//                 //             style: TextStyle(
//                 //               fontWeight: FontWeight.w600,
//                 //                 color: Color.fromRGBO(32,32,32,1),
//                 //                 fontSize: AppFontsSizeManager.s24.sp,
//                 //                 fontFamily: getTranslated(context, "academyFontFamily")
//                 //             ),),

//                 //         ),
//                 //           SizedBox(width: AppSize.w48.w,),
//                 //           if(widget.course.price!="0")
//                 //            buy
//                 //                ? Center(child: CircularProgressIndicator())
//                 //                : Center(
//                 //              child: TextButton1(onPress: () async {
//                 //                if(widget.loggedUserId==null)
//                 //                  Navigator.pushNamed(context, '/Register_Type');
//                 //                else {
//                 //                  setState(() {
//                 //                    buy = true;
//                 //                  });
//                 //                 //  stripePayment(widget.loggedUserId! + "@gmail.com",
//                 //                 //      double.parse( widget.course.price),context); //300
//                 //                }

//                 //              },Width: AppSize.w206_6.w,Height: AppSize.h50_6.h, 
//                 //              Title:  getTranslated(context, "buy")+ widget.course.price+"\$", 
//                 //              ButtonRadius: AppRadius.r10_6.r,
//                 //               TextSize: AppFontsSizeManager.s18_6.sp,
//                 //               GradientColor: Color.fromRGBO(207 ,0 ,54, 1),
//                 //               GradientColor2:Color.fromRGBO( 224, 16, 70, 1) ,
//                 //               GradientColor3:  Color.fromRGBO(255 ,47 ,101, 1),
//                 //                TextFont: getTranslated(context, "academyFontFamily")
//                 //              ,TextColor: AppColors.white),
//                 //            ),

//                 //       ],),
//                 //       Row(crossAxisAlignment: CrossAxisAlignment.start,
//                 //         children: [
//                 //           Row(
//                 //             mainAxisAlignment: MainAxisAlignment.start,
//                 //             crossAxisAlignment: CrossAxisAlignment.center,
//                 //             children: [
//                 //               SvgPicture.asset(
//                 //                 AssetsManager.outlineLayersIconPath,
//                 //                 height: AppSize.h24_6.h,
//                 //                 width: AppSize.w24_6.w,
//                 //               ),
//                 //               SizedBox(
//                 //                 width: AppSize.w14_6.w,
//                 //               ),
//                 //               Text(
//                 //                 widget.course.videoNum.toString()+" Videos",
//                 //                 textAlign: TextAlign.start,
//                 //                 style: GoogleFonts.poppins(
//                 //                   color: AppColors.darkGrey,
//                 //                   fontSize: AppFontsSizeManager.s21_3.sp,
//                 //                 ),
//                 //               ),
//                 //             ],
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
                
//                 // Expanded(
//                 //   child: PaginateFirestore(
//                 //     itemBuilderType: PaginateBuilderType.gridView,
//                 //     padding: EdgeInsets.only(left: AppPadding.p32.w,right: AppPadding.p32.w,top: AppPadding.p32.h),
//                 //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 //         crossAxisCount: 2,
//                 //         crossAxisSpacing: 20,
//                 //         mainAxisSpacing: 20,
//                 //         mainAxisExtent: 150,
//                 //         childAspectRatio: 1.8 //(AppSize.w242_6.w/AppSize.h245_3.h)
//                 //      ),
//                 //     itemBuilder: (context, documentSnapshot, index) {
//                 //       return  VideoItem(
//                 //           video:  CourseVideo.fromMap(documentSnapshot[index].data() as Map),
//                 //           course: widget.course,
//                 //           loggedUserId:widget.loggedUserId==null?null:widget.loggedUserId

//                 //       );

//                 //     },
//                 //     query: FirebaseFirestore.instance.collection("CourseVideo")
//                 //         .where('courseId', isEqualTo: widget.course.courseId)
//                 //         .where('active', isEqualTo: true)
//                 //         .orderBy('order', descending: false),
//                 //     isLive: true,
//                 //   ),
//                 // )

//               ],
//             ),
//             // Positioned(
//             //   top: AppSize.h315.h,
//             //   left: AppSize.w32.w,
//             //   right: AppSize.w32.w,
//             //   child: Container(
//             //     width: AppSize.w506_6.w,
//             //     height: AppSize.h137_3.h,
//             //     padding: EdgeInsets.all(AppPadding.p21_3.r),
//             //     decoration: BoxDecoration(
//             //       boxShadow: [
//             //         BoxShadow(
//             //           color: Color.fromRGBO(48, 48, 48, 0.08),
//             //           blurRadius: AppSize.h29_3.r,
//             //           offset: Offset(0.0, 4.0),
//             //         ),
//             //       ],
//             //       borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
//             //       color: AppColors.white,
//             //     ),child: Column(children: [
//             //       Row(mainAxisAlignment: MainAxisAlignment.start,
//             //         children: [
//             //           SvgPicture.asset(
//             //             AssetsManager.goldFlower3IconPath,
//             //             height: AppSize.h18_7.r,
//             //             width: AppSize.w18_7.r,
//             //           ),
//             //           SizedBox(
//             //             width: AppSize.w8.w,
//             //           ),
//             //           Text(
//             //             widget.course.name,
//             //             textAlign: TextAlign.start,
//             //             maxLines: 1,
//             //             overflow:TextOverflow.ellipsis,
//             //             style: TextStyle(
//             //                 fontFamily: getTranslated(context, "academyFontFamily"),
//             //                 color:AppColors.balck2,
//             //                 fontSize: AppFontsSizeManager.s24.sp,
//             //                 fontWeight: FontWeight.w600
//             //             ),
//             //           ),
//             //           SizedBox(
//             //             width: AppSize.w8.w,
//             //           ),
//             //           SvgPicture.asset(
//             //             AssetsManager.goldFlower4IconPath,
//             //             height: AppSize.h18_7.r,
//             //             width: AppSize.w18_7.r,
//             //           ),
//             //           //pb
//             //          Spacer(),
//             //           Row(
//             //             mainAxisAlignment: MainAxisAlignment.end,
//             //             crossAxisAlignment: CrossAxisAlignment.center,
//             //             children: [
//             //               Text(
//             //                 widget.course.rate.toString(),
//             //                 textAlign: TextAlign.start,
//             //                 style: TextStyle(
//             //                   fontFamily: getTranslated(context, "academyFontFamily"),
//             //                   fontWeight: FontWeight.w500,
//             //                   color:AppColors.balck2,
//             //                   fontSize: AppFontsSizeManager.s18_6.sp,
//             //                 ),
//             //               ),
//             //               SizedBox(width: AppSize.w5_3.w,),
//             //               Icon(
//             //                 Icons.star,
//             //                 color: Color.fromRGBO(255, 188, 0,1),
//             //                 size: 16,
//             //               ),
//             //             ],
//             //           ),
//             //         ],
//             //       ),
//             //       SizedBox(height:AppSize.h12.h ,),
//             //       Row(mainAxisAlignment: MainAxisAlignment.start,
//             //         children: [
//             //           Expanded(
//             //             child: Text(
//             //               widget.course.desc,
//             //               textAlign: TextAlign.start,
//             //               maxLines: 2,
//             //               overflow:TextOverflow.ellipsis,
//             //               style: TextStyle(
//             //                   fontFamily: getTranslated(context, "academyFontFamily"),
//             //                   color:AppColors.darkGrey,
//             //                   fontSize: AppFontsSizeManager.s18_6.sp,
//             //                   fontWeight: FontWeight.w400
//             //               ),
//             //             ),
//             //           ),
//             //         ],
//             //       ),
//             //     ],),
//             //   ),
//             // ),

//           ]),
//         )

//     );
//   }
//   String capitalizeAllWord(String value) {
//     var result = value[0].toUpperCase();
//     for (int i = 1; i < value.length; i++) {
//       if (value[i - 1] == " ") {
//         result = result + value[i].toUpperCase();
//       } else {
//         result = result + value[i];
//       }
//     }
//     return result;
//   }
  
//   share(BuildContext context) async {
//     setState(() {
//       sharing = true;
//     });
//     String uid=widget.course.courseId;
//     // Create DynamicLink
//     print("share1");
//     print("https://makemynikahapp\.page\.link/.*course_id="+uid);
//     final dynamicLinkParams = DynamicLinkParameters(
//       link: Uri.parse("https://makemynikahapp\.page\.link/course_id="+uid),
//       uriPrefix:"https://makemynikahapp\.page\.link",
//       androidParameters: const AndroidParameters(packageName: "com.app.MakeMyNikah"),
//       iosParameters: const IOSParameters(bundleId: "com.app.MakeMyNikahApp",appStoreId:"1668556326"),
//     );
//     ShortDynamicLink dynamicLink =
//     await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

//     File file;
//     final directory = await getTemporaryDirectory();
//     final path = directory.path;
//     final response = await http.get(Uri.parse(widget.course.image));
//     file = await File('$path/image_${DateTime.now().millisecondsSinceEpoch}.png').writeAsBytes(response.bodyBytes);
//     String text="${widget.course.name} \n I think that it will be a good course for you \n ${dynamicLink.shortUrl.toString()}";
//     Share.shareFiles(["${file.path}"],
//         text:text);
//     setState(() {
//       sharing = false;
//     });
//   }
  
//   Future<void> stripePayment( String email,  double amount,  BuildContext context) async {
//     try {
//       setState(() {
//         buy=true;
//       });
//       print("stripePayment0");
//       DocumentReference docRef = FirebaseFirestore.instance.collection(Paths.usersPath).doc(widget.loggedUserId);
//       final DocumentSnapshot documentSnapshot = await docRef.get();
//       String payWith="balance";
//       print("stripePayment1");
//       var user= GroceryUser.fromMap(documentSnapshot.data() as Map);
//       if(user.balance>=1){
//         print("stripePayment2");
//         var newBalance=user.balance-amount;
//         if(newBalance<0)newBalance=0;
//         await FirebaseFirestore.instance.collection(Paths.usersPath).doc(user.uid).set({
//           'balance': newBalance,
//         }, SetOptions(merge: true));
//         Fluttertoast.showToast(
//             msg: "thanks for your support",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.lightGreen,
//             textColor: Colors.white,
//             fontSize: 16.0);
//         print("stripePayment3");
//       }
//       else{
//         print("stripePayment4");
//         email=email.trim().replaceAll(' ', '');
//         final response = await http.post(
//             Uri.parse(
//                 'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/stripePaymentIntentRequest'),
//             body: {
//               'email': email,
//               'amount': (amount*100).toString(),
//             });
//         final jsonResponse = jsonDecode(response.body);
//         print("stripePayment5");
//         await Stripe.instance.initPaymentSheet(
//             paymentSheetParameters: SetupPaymentSheetParameters(
//               paymentIntentClientSecret: jsonResponse['paymentIntent'],
//               customerId: jsonResponse['customer'],
//               customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
//               testEnv: false,
//               applePay: true,
//               googlePay: true,
//               merchantDisplayName: "Make My Nikah",
//               merchantCountryCode: "AE",
//               style:ThemeMode.dark,
//               appearance:PaymentSheetAppearance(
//                 /*   colors: PaymentSheetAppearanceColors(
//                 background: Colors.white,
//                 primary: Colors.white,
//                 componentBorder: Colors.black,
//               ),
//               shapes: PaymentSheetShape(
//                 borderWidth: 4,
//                 shadow: PaymentSheetShadowParams(color: Colors.white),
//               ),*/
//                 primaryButton: PaymentSheetPrimaryButtonAppearance(
//                   shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
//                   colors: PaymentSheetPrimaryButtonTheme(
//                     dark: PaymentSheetPrimaryButtonThemeColors(
//                       background: AppColors.reddark2,
//                       text: AppColors.white,
//                       border: Colors.white,
//                     ),
//                     light: PaymentSheetPrimaryButtonThemeColors(
//                       background: AppColors.reddark2,
//                       text: AppColors.white,
//                       border: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               //=====
//             ));
//         await Stripe.instance.presentPaymentSheet();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Payment is successful'),
//           ),
//         );
//         print("stripePayment6");
//         payWith="stripe";
//       }
//       print("stripePayment7");
//       updateDatabaseAfterBuying(user,payWith);

//     } catch (error) {
//       print("stripeerror");
//       print(error.toString());
//       if (error is StripeException) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('An error occured ${error.error.localizedMessage}'),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('An error occured $error'),
//           ),
//         );
//       }
//       setState(() {
//         buy=false;
//       });
//     }
//   }
//   updateDatabaseAfterBuying(GroceryUser user,String payWith) async {
//     //createOrder
//     String orderId = Uuid().v4();
//     DateTime dateValue = DateTime.now();
//     await FirebaseFirestore.instance
//         .collection(Paths.ordersPath)
//         .doc(orderId)
//         .set({
//       'orderStatus': 'closed',
//       'orderId': orderId,
//       'date': {
//         'day': dateValue.day,
//         'month': dateValue.month,
//         'year': dateValue.year,
//       },
//       "consultType": "course",
//       'orderTimestamp': Timestamp.now(),
//       'utcTime': DateTime.now().toUtc().toString(),
//       'orderTimeValue':DateTime(dateValue.year, dateValue.month, dateValue.day).millisecondsSinceEpoch,
//       'packageId': "",
//       'promoCodeId': "",
//       'remainingCallNum': 0,
//       'packageCallNum': 0,
//       'answeredCallNum': 0,
//       'callPrice': double.parse(widget.course.price),
//       "payWith": payWith,
//       "platform": Platform.isIOS ? "iOS" : "Android",
//       'price': widget.course.price.toString(),
//       'consult': {
//         'uid': widget.course.courseId,
//         'name': widget.course.name,
//         'image': widget.course.image,
//         'phone': " ",
//         'countryCode': " ",
//         'countryISOCode': " ",
//       },
//       'user': {
//         'uid': user.uid,
//         'name': user.name,
//         'image': user.photoUrl,
//         'phone': user.phoneNumber,
//         'countryCode': user.countryCode,
//         'countryISOCode': user.countryISOCode,
//       },
//     });

//     print("af_purchase event");
//     String eventName = "af_purchase";
//     Map eventValues = {
//       "af_revenue": widget.course.price,
//       "af_price": widget.course.price,
//       "af_content_id": widget.course.courseId,
//       "af_order_id": orderId,
//       "af_currency": "USD",
//     };

//     await FirebaseAnalytics.instance.logPurchase(
//         currency: "USD",
//         value: double.parse(widget.course.price),
//         affiliation: widget.course.courseId,
//         transactionId: orderId);
//     if(widget.course.paidUsers==null)
//       widget.course.paidUsers=[user.uid];
//     else
//     widget.course.paidUsers!.add(user.uid!);
//     await FirebaseFirestore.instance.collection("Courses").doc(widget.course.courseId).set({
//       'paidUsers': widget.course.paidUsers,
//     }, SetOptions(merge: true));
//     setState(() {
//       buy=false;
//     });
//   }

// }
// import 'dart:convert';
// import 'dart:io';
// import 'package:animate_icons/animate_icons.dart';
// import 'package:animated_widgets/widgets/opacity_animated.dart';
// import 'package:animated_widgets/widgets/translation_animated.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:another_flushbar/flushbar.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// // import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:grocery_store/Utils/extensions/printing_extension.dart';
// import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
// import 'package:grocery_store/blocs/notification_bloc/notification_bloc.dart';
// import 'package:grocery_store/config/app_fonts.dart';
// import 'package:grocery_store/config/colorsFile.dart';
// import 'package:grocery_store/config/paths.dart';
// import 'package:grocery_store/localization/localization_methods.dart';
// import 'package:grocery_store/models/order.dart';
// import 'package:flutter/material.dart';
// import 'package:grocery_store/screens/userAccountScreen.dart';
// import 'package:grocery_store/widget/IconButton.dart';
// import 'package:grocery_store/widget/TextButton.dart';
// import 'package:grocery_store/widget/addAppointmentDialog.dart';
// import 'package:grocery_store/widget/app_bar_widget.dart';
// import 'package:grocery_store/widget/nikah_dialog.dart';
// import 'package:grocery_store/widget/reportBottomSheetWidget.dart';
// import 'package:grocery_store/widget/resopnsive.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:uuid/uuid.dart';
// import '../config/app_values.dart';
// import '../config/assets_manager.dart';
// import '../models/user.dart';
// import '../models/userDetails.dart';
// import '../models/user_notification.dart';
// import '../widget/read_more_button.dart';
// import 'DevelopTechSupport/allDevelopSupport.dart';
// import 'account_screen.dart';
// import 'bioDetailsScreen.dart';
// import 'package:http/http.dart' as http;
// import 'notification_screen.dart';

// class ConsultantDetailsScreen extends StatefulWidget {
//   final GroceryUser consultant;
//   final GroceryUser? loggedUser;
//   final bool? appleReview;

//   const ConsultantDetailsScreen(
//       {Key? key, required this.consultant, this.appleReview, this.loggedUser})
//       : super(key: key);

//   @override
//   _ConsultantDetailsScreenState createState() =>
//       _ConsultantDetailsScreenState();
// }

// class _ConsultantDetailsScreenState extends State<ConsultantDetailsScreen> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   String from = "", to = "";
//   List<String> dayList = [], dayListValue = [];
//   final TextEditingController controller = TextEditingController();
//   final TextEditingController searchController = new TextEditingController();
//   GroceryUser? user;
//   late AccountBloc accountBloc;
//   Orders? order;
//   int currentNumber = 0;
//   late int localFrom, localTo;
//   bool first = true,
//       showPayView = false,
//       load = false,
//       fromBalance = false,
//       sharing = false;
//   String? userImage, userName = "nikahUser", type;
//   bool validPartner = false;
//   AnimateIconController? animatecontroller;

//   dynamic price = 30.0;
//   late Size size;
//   late NotificationBloc notificationBloc;
//   late UserNotification userNotification;

//   late UserDetail userDetails;
//   bool loadData = false;
//   String lang = "";

//   void getuserDetails(String userID) async {
//     try {
//       setState(() {
//         loadData = true;
//         validPartner = false;
//       });
//       DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
//           .instance
//           .collection(Paths.userDetail)
//           .doc(userID)
//           .get();
//       var details = UserDetail.fromMap(snapshot.data() as Map);
//       bool check = false;
//       if (widget.loggedUser != null) {
//         check = widget.loggedUser != null &&
//             details.partnerOrigin != null &&
//             (details.partnerOrigin == "notinterest" ||
//                 details.partnerOrigin == widget.loggedUser!.origin) &&
//             details.partnerDoctrine != null &&
//             (details.partnerDoctrine == "notinterest" ||
//                 details.partnerDoctrine == widget.loggedUser!.doctrine) &&
//             details.partnerEducationalLevel != null &&
//             (details.partnerEducationalLevel == "notinterest" ||
//                 details.partnerEducationalLevel ==
//                     widget.loggedUser!.education) &&
//             details.partnerEmploymentStatus != null &&
//             (details.partnerEmploymentStatus == "notinterest" ||
//                 details.partnerEmploymentStatus ==
//                     widget.loggedUser!.employment) &&
//             details.partnerLivingStander != null &&
//             (details.partnerLivingStander == "notinterest" ||
//                 details.partnerLivingStander == widget.loggedUser!.living) &&
//             details.partnerMaritalState != null &&
//             (details.partnerMaritalState == "notinterest" ||
//                 details.partnerMaritalState ==
//                     widget.loggedUser!.maritalStatus) &&
//             details.partnerSpecialization != null &&
//             (details.partnerSpecialization == "notinterest" ||
//                 details.partnerSpecialization ==
//                     widget.loggedUser!.specialization) &&
//             details.partnerSmoking != null &&
//             (details.partnerSmoking == "notinterest" ||
//                 details.partnerSmoking == widget.loggedUser!.smooking) &&
//             details.partnerMinAge != null &&
//             details.partnerMaxAge != null &&
//             widget.loggedUser!.age >= details.partnerMinAge &&
//             widget.loggedUser!.age <= details.partnerMaxAge &&
//             details.partnerMinHeight != null &&
//             details.partnerMaxHeight != null &&
//             widget.loggedUser!.length >= details.partnerMinHeight &&
//             widget.loggedUser!.length <= details.partnerMaxHeight &&
//             details.partnerMinWeight != null &&
//             details.partnerMaxWeight != null &&
//             widget.loggedUser!.weight >= details.partnerMinWeight &&
//             widget.loggedUser!.weight <= details.partnerMaxWeight;
//       }
//       setState(() {
//         this.userDetails = details;
//         loadData = false;
//         validPartner = check;
//       });
//     } catch (e) {
//       print("jjjjjjjj");
//       print(e.toString());
//       setState(() {
//         loadData = false;
//         validPartner = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     animatecontroller = AnimateIconController();
//     cleanConsultDays();
//     getuserDetails(widget.consultant.uid!);

//     accountBloc = BlocProvider.of<AccountBloc>(context);
//     notificationBloc = BlocProvider.of<NotificationBloc>(context);
//     if (widget.loggedUser != null) {
//       user = widget.loggedUser!;
//       getNumber();
//       accountBloc.add(GetLoggedUserEvent());
//       notificationBloc.add(GetAllNotificationsEvent(user!.uid!));
//     }
//     localFrom = DateTime.parse(widget.consultant.fromUtc!).toLocal().hour;
//     localTo = DateTime.parse(widget.consultant.toUtc!).toLocal().hour;
//     if (localTo == 0) localTo = 24;

//     if (widget.consultant.workTimes!.length > 0) {
//       if (localFrom == 12)
//         from = "12 PM";
//       else if (localFrom == 0)
//         from = "12 AM";
//       else if (localFrom > 12)
//         from = ((localFrom) - 12).toString() + " PM";
//       else
//         from = (localFrom).toString() + " AM";
//     }
//     if (widget.consultant.workTimes!.length > 0) {
//       if (localTo == 12)
//         to = "12 PM";
//       else if (localTo == 0 || localTo == 24)
//         to = "12 AM";
//       else if (localTo > 12)
//         to = ((localTo) - 12).toString() + " PM";
//       else
//         to = (localTo).toString() + " AM";
//     }
//     accountBloc.stream.listen((state) {
//       if (state is GetLoggedUserCompletedState) {
//         user = state.user;
//       }
//     });

//     print("content_view event started ");
//     String eventName = "af_content_view";
//     Map eventValues = {
//       "af_price": "30",
//       "af_content_id": widget.consultant.uid,
//     };
//   }

//   errorLog(String function, String error) async {
//     String id = Uuid().v4();
//     await FirebaseFirestore.instance
//         .collection(Paths.errorLogPath)
//         .doc(id)
//         .set({
//       'timestamp': Timestamp.now(),
//       'id': id,
//       'seen': false,
//       'desc': error,
//       'phone': widget.loggedUser == null ? " " : widget.loggedUser!.phoneNumber,
//       'screen': "ConsultantDetailsScreen",
//       'function': function,
//     });
//   }

//   void showSnakbar(String s, bool status) {
//     Fluttertoast.showToast(
//         msg: s,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }

//   void didChangeDependencies() {
//     if (user != null && user!.photoUrl != null && user!.photoUrl != "")
//       setState(() {
//         userImage = user!.photoUrl!;
//       });
//     if (first && widget.consultant.workDays!.length > 0) {
//       dayList = [];
//       if (widget.consultant.workDays!.contains("1"))
//         dayList.add(getTranslated(context, "monday"));
//       if (widget.consultant.workDays!.contains("2"))
//         dayList.add(getTranslated(context, "tuesday"));
//       if (widget.consultant.workDays!.contains("3"))
//         dayList.add(getTranslated(context, "wednesday"));
//       if (widget.consultant.workDays!.contains("4"))
//         dayList.add(getTranslated(context, "thursday"));
//       if (widget.consultant.workDays!.contains("5"))
//         dayList.add(getTranslated(context, "friday"));
//       if (widget.consultant.workDays!.contains("6"))
//         dayList.add(getTranslated(context, "saturday"));
//       if (widget.consultant.workDays!.contains("7"))
//         dayList.add(getTranslated(context, "sunday"));
//       setState(() {
//         dayListValue = dayList;
//         first = false;
//       });
//     }
//     size = MediaQuery.of(context).size;
//     super.didChangeDependencies();
//   }

//   BoxShadow shadow() {
//     return BoxShadow(
//       color: AppColors.chat,
//       blurRadius: 2,
//       spreadRadius: 2,
//       offset: Offset(0.0, 1.0), // shadow direction: bottom right
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//            /* headerWidget()*/
//            AppBarWidget2(text: widget.consultant.name!),
//            SizedBox(height:AppSize.h21_3.h,),
//            Container(width: size.width,color: AppColors.lightGray,height: AppSize.h1.h,),
           
            
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.only(
//                     top: AppPadding.p32.h,
//                     left: AppPadding.p32.w,
//                     right: AppPadding.p32.w),
//                 child: ListView(
//                   physics: AlwaysScrollableScrollPhysics(),
//                   children: [
//                     Center(
//                       child: Container(
//                         width: size.width,
//                         //  height: 252.h,
//                         padding: EdgeInsets.only(
//                             top: AppPadding.p21_3.h,
//                             right: AppPadding.p32.w,
//                             left: AppPadding.p32.w,
//                             bottom: AppPadding.p29_3.h),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(AppRadius.r32.r),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color.fromRGBO(32, 32, 32, 0.06),
//                               blurRadius: 18.r,
//                               spreadRadius: 0.0,
//                               offset: Offset(
//                                   0, 9), // shadow direction: bottom right
//                             )
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                               lang=="ar"? SvgPicture.asset(
//                                   AssetsManager.goldHeader2IconPath,
//                                   height: AppSize.h21_3.h,
//                                   width: AppSize.w8_3.w,
//                                 )
//                               :  SvgPicture.asset(
//                                   AssetsManager.goldHeader1IconPath,
//                                   height: AppSize.h21_3.h,
//                                   width: AppSize.w8_3.w,
//                                 ),
//                                 SizedBox(
//                                   width: AppSize.w16.w,
//                                 ),
//                                 Text(
//                                   getTranslated(context, "bio2"),
//                                   style: TextStyle(
//                                     fontFamily: getTranslated(
//                                         context, "Montserratsemibold"),
//                                     color: AppColors.blackColor,
//                                     fontSize: AppFontsSizeManager.s21_3.sp,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: AppSize.w16.w,
//                                 ),
//                             lang=="ar"?
//                              SvgPicture.asset(
//                                   AssetsManager.goldHeader1IconPath,
//                                   height: AppSize.h21_3.h,
//                                   width: AppSize.w8_3.w,
//                                 )
//                             :    SvgPicture.asset(
//                                   AssetsManager.goldHeader2IconPath,
//                                   height: AppSize.h21_3.h,
//                                   width: AppSize.w8_3.w,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: AppSize.h26_6.h,
//                             ),
//                             Text(
//                               widget.consultant.bio!.length > 165
//                                   ? widget.consultant.bio!.substring(0, 165)
//                                   : widget.consultant.bio!,
//                               maxLines: 3,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontFamily:
//                                     getTranslated(context, "Montserratmedium"),
//                                 color: AppColors.darkGrey,
//                                 fontSize: AppFontsSizeManager.s18_6.sp,
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                             SizedBox(
//                               height: AppSize.h26_6.h,
//                             ),
//                             ReadMoreButton(
//                               onPress: () {
//                                 if (loadData) {
//                                 } else
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => BioDetailsScreen(
//                                         consult: widget.consultant,
//                                         consultDetails: userDetails,
//                                         loggedUser: widget.loggedUser,
//                                         screen: 1,
//                                       ),
//                                     ),
//                                   );
//                               },
//                             ),
//                             // TextButton1(
//                             //   onPress: () {
//                             //   if (loadData) {
//                             //   } else
//                             //     Navigator.push(
//                             //       context,
//                             //       MaterialPageRoute(
//                             //         builder: (context) => BioDetailsScreen(
//                             //           consult: widget.consultant,
//                             //           consultDetails: userDetails,
//                             //           loggedUser: widget.loggedUser,
//                             //           screen: 1,
//                             //         ),
//                             //       ),
//                             //     );
//                             // },
//                             //   Width: AppSize.w138_6.w,
//                             // Height: AppSize.h42_6.h,
//                             // Title: getTranslated(context, "readMore"),
//                             //  ButtonRadius: AppRadius.r5_3.r,
//                             //   ButtonBackground: AppColors.pink2,
//                             //   TextSize: AppFontsSizeManager.s16.sp,
//                             //    TextFont:  getTranslated(context, "Montserratsemibold"),
//                             //     TextColor: AppColors.white,
//                             //     IconSpace:AppSize.w5_3.w,
//                             //     Icon: AssetsManager.backIcon.toString(),
//                             //     IconColor: AppColors.white,
//                             //     IconWidth: AppSize.w21_3.r,
//                             //     IconHeight: AppSize.h21_3.r,
//                             //     Direction: TextDirection.ltr,),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: AppSize.h32.h,
//                     ),
//                     Center(
//                       child: Container(
//                         width: size.width,
//                         //height: AppSize.h252.h,
//                         padding: EdgeInsets.only(
//                             top: AppPadding.p21_3.h,
//                             right: AppPadding.p32.w,
//                             left: AppPadding.p32.w,
//                             bottom: AppPadding.p29_3.h),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(AppRadius.r32.r),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color.fromRGBO(32, 32, 32, 0.06),
//                               blurRadius: AppRadius.r18.r,
//                               spreadRadius: 0.0,
//                               offset: Offset(
//                                   0, 9.0), // shadow direction: bottom right
//                             )
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                               lang=="ar"?

//                               SvgPicture.asset(
//                                   AssetsManager.goldHeader2IconPath,
//                                   height: AppSize.h21_3.h,
//                                   width: AppSize.w8_3.w,
//                                 )
//                               :  SvgPicture.asset(
//                                   AssetsManager.goldHeader1IconPath,
//                                   height: AppSize.h21_3.h,
//                                   width: AppSize.w8_3.w,
//                                 ),
//                                 SizedBox(
//                                   width: AppSize.w16.w,
//                                 ),
//                                 Text(
//                                   getTranslated(context, "aboutLife"),
//                                   style: TextStyle(
//                                     fontFamily:
//                                     getTranslated(context, "Montserratsemibold"),
//                                     color: AppColors.blackColor,
                                   
//                                     fontSize: AppFontsSizeManager.s21_3.sp,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: AppSize.w16.w,
//                                 ),
//                               lang=="ar"?SvgPicture.asset(
//                                   AssetsManager.goldHeader1IconPath,
//                                   height: AppSize.h21_3.h,
//                                   width: AppSize.w8_3.w,
//                                 ):
//                                   SvgPicture.asset(
//                                   AssetsManager.goldHeader2IconPath,
//                                   height: AppSize.h21_3.h,
//                                   width: AppSize.w8_3.w,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: AppSize.h26_6.h,
//                             ),
//                             Text(
//                               widget.consultant.partnerSpecifications!.length >
//                                       165
//                                   ? widget.consultant.partnerSpecifications!
//                                       .substring(0, 165)
//                                   : widget.consultant.partnerSpecifications!,
//                               textAlign: TextAlign.center,
//                               maxLines: 3,
//                               style: TextStyle(
//                                 fontFamily: getTranslated(context, "Montserratmedium"),
//                                 color: AppColors.darkGrey,
//                                 fontSize: AppFontsSizeManager.s18_6.sp,
                                
//                               ),
//                             ),
//                             SizedBox(
//                               height: AppSize.h26_6.h,
//                             ),
//                             ReadMoreButton(
//                               onPress: () {
//                                 if (loadData) {
//                                 } else
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => BioDetailsScreen(
//                                         consult: widget.consultant,
//                                         consultDetails: userDetails,
//                                         loggedUser: widget.loggedUser,
//                                         screen: 2,
//                                       ),
//                                     ),
//                                   );
//                               },
//                             ),
//                             // TextButton1(
//                             //   onPress: () {
//                             //   if (loadData) {
//                             //   } else
//                             //     Navigator.push(
//                             //       context,
//                             //       MaterialPageRoute(
//                             //         builder: (context) => BioDetailsScreen(
//                             //           consult: widget.consultant,
//                             //           consultDetails: userDetails,
//                             //           loggedUser: widget.loggedUser,
//                             //           screen: 2,
//                             //         ),
//                             //       ),
//                             //     );
//                             // }, Width: AppSize.w138_6.w,
//                             // Height: AppSize.h42_6.h,
//                             // Title: getTranslated(context, "readMore"),
//                             //  ButtonRadius: AppRadius.r5_3.r,
//                             //   ButtonBackground: AppColors.pink2,
//                             //   TextSize: AppFontsSizeManager.s16.sp,
//                             //    TextFont:  getTranslated(context, "Montserratsemibold"),
//                             //     TextColor: AppColors.white,
//                             //     IconSpace:AppSize.w5_3.w,
//                             //     Icon: AssetsManager.backIcon.toString(),
//                             //     IconColor: AppColors.white,
//                             //     IconWidth: AppSize.w21_3.r,
//                             //     IconHeight: AppSize.h21_3.r,
//                             //     Direction: TextDirection.ltr,),
        
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: AppSize.h32.h,
//                     ),
//                     Center(
//                       child: Container(
//                         width: size.width,
//                         padding: EdgeInsets.only(
//                             top: AppPadding.p21_3.h,
//                             right: AppPadding.p32.w,
//                             left: AppPadding.p32.w,
//                             bottom: AppPadding.p32.h),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(28.0),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color.fromRGBO(32, 32, 32, 0.06),
//                               blurRadius: 18.r,
//                               spreadRadius: 0.0,
//                               offset: Offset(
//                                   0, 9.0), // shadow direction: bottom right
//                             )
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                               lang=="ar"?
//                               SvgPicture.asset(
//                                   AssetsManager.goldHeader2IconPath,
//                                   height: AppSize.h21_3.h,
//                                   width: AppSize.w8_3.w,
//                                 ):

//                                 SvgPicture.asset(
//                                   AssetsManager.goldHeader1IconPath,
//                                   height: AppSize.h21_3.h,
//                                   width: AppSize.w8_3.w,
//                                 ),
//                                 SizedBox(
//                                   width: AppSize.w16.w,
//                                 ),
//                                 Text(
//                                   getTranslated(context, "Reviews"),
//                                   style: TextStyle(
//                                     fontFamily: getTranslated(
//                                         context, "Montserratsemibold"),
//                                     color: AppColors.blackColor,
//                                     fontSize: AppFontsSizeManager.s21_3.sp,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: AppSize.w16.w,
//                                 ),
//                               lang=="ar"?
//                                SvgPicture.asset(
//                                   AssetsManager.goldHeader1IconPath,
//                                   height: AppSize.h21_3.h,
//                                   width: AppSize.w8_3.w,
//                                 ):  SvgPicture.asset(
//                                   AssetsManager.goldHeader2IconPath,
//                                   height: AppSize.h21_3.h,
//                                   width: AppSize.w8_3.w,
//                                 ),
//                               ],
//                             ),
        
        
//                             SizedBox(
//                               height: AppSize.h32.h,
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 rateWidget(getTranslated(context, "Serious"),
//                                     widget.consultant.serious),
//                                 SizedBox(
//                                   height: AppSize.h16.h,
//                                 ),
//                                 rateWidget(getTranslated(context, "polite"),
//                                     widget.consultant.polite),
//                                 SizedBox(
//                                   height: AppSize.h16.h,
//                                 ),
//                                 rateWidget(getTranslated(context, "exceptional"),
//                                     widget.consultant.exceptional),
//                                 SizedBox(
//                                   height: AppSize.h16.h,
//                                 ),
//                                 rateWidget(getTranslated(context, "appropriate"),
//                                     widget.consultant.appropriate),
//                               ],
//                             ),
                            
//                           ],
//                         ),
//                       ),
//                     ),
        
//                     SizedBox(
//                       height: AppSize.h53_3.h,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                       lang=="ar"?
//                       SvgPicture.asset(
//                           AssetsManager.goldHeader2IconPath,
//                           height: AppSize.h21_3.h,
//                           width: AppSize.w8_3.w,
//                         )
//                       :  SvgPicture.asset(
//                           AssetsManager.goldHeader1IconPath,
//                           height: AppSize.h21_3.h,
//                           width: AppSize.w8_3.w,
//                         ),
//                         SizedBox(
//                           width: AppSize.w16.w,
//                         ),
//                         Text(
//                           getTranslated(context, "workTime"),
//                           style: TextStyle(
//                             fontFamily:
//                             getTranslated(context, "Montserratsemibold"),
//                             color: AppColors.blackColor,
//                             fontSize: AppFontsSizeManager.s21_3.sp,
//                           ),
//                         ),
//                         SizedBox(
//                           width: AppSize.w16.w,
//                         ),
//                       lang=="ar"?
//                        SvgPicture.asset(
//                           AssetsManager.goldHeader1IconPath,
//                           height: AppSize.h21_3.h,
//                           width: AppSize.w8_3.w,
//                         )
//                       :
//                        SvgPicture.asset(
//                           AssetsManager.goldHeader2IconPath,
//                           height: AppSize.h21_3.h,
//                           width: AppSize.w8_3.w,
//                         ),
//                       ],
//                     ),
//                     //days
//                     Padding(
//                       padding: EdgeInsets.only(
//                           left:AppPadding.p32.w, right:AppPadding.p32.w , top: AppPadding.p32.h,),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset(AssetsManager.calenderIcon,
//                             width: AppSize.w26_6.w,
//                             height: AppSize.h26_6.h,
//                           ),
//                           SizedBox(
//                             width: AppSize.w21_3.w,
//                           ),
//                           Expanded(
//                             child: Wrap(
//                               alignment: WrapAlignment.center, // This aligns children within a run in the center
//                               crossAxisAlignment: WrapCrossAlignment.center,
//                                 runSpacing: AppSize.w16.w,
//                                 spacing: AppSize.w16.w,
//                                 direction: Axis.horizontal,
//                                 children: [
//                                   for (int x = 0; x < dayListValue.length; x++)
//                                     daysWidget(dayListValue[x]),
//                                 ]),
//                           ),
//                         ],
//                       ),
//                     ),
//                     //times
//                     Padding(
//                       padding: EdgeInsets.only(top: AppPadding.p16.h,left:AppPadding.p32.w, right:lang=="ar"? AppPadding.p32.w:AppPadding.p24.w),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset(
//                            AssetsManager.clockIcon,
//                             width: AppSize.w26_6.r,
//                             height: AppSize.h26_6.r,
//                           ),
//                           SizedBox(width: AppSize.w24.w,),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     getTranslated(context, "From"),
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontFamily:
//                                         getTranslated(context, "Montserratsemibold"),
//                                         color: AppColors.black,
//                                         fontSize: AppFontsSizeManager.s21_3.sp,
//                                         ),
//                                   ),
//                                   SizedBox(width: AppSize.w10_6.w,),
        
//                                   Container(
//                                     height: AppSize.h45_3.h,
//                                     width: AppSize.w138_6.w,
                                    
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         image: AssetImage(
//                                           AssetsManager.borderIcon,
//                                         ),
//                                         fit: BoxFit.fill,
//                                       ),),
//                                     child: Center(
//                                       child: Text(
//                                         from,
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontFamily:
//                                                 getTranslated(context, "Montserratsemibold"),
//                                             color: AppColors.black,
//                                             fontSize: AppFontsSizeManager.s18_6.sp,),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 width: AppSize.w24.w,
//                               ),
        
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     getTranslated(context, "to"),
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontFamily:
//                                         getTranslated(context, "Montserratsemibold"),
//                                         color: AppColors.black,
//                                         fontSize: AppFontsSizeManager.s21_3.sp,
//                                         ),
//                                   ),
//                                   SizedBox(width: AppSize.w10_6.w,),
//                                   Container(
//                                      height: AppSize.h45_3.h,
//                                     width: AppSize.w138_6.w,
                                    
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         image: AssetImage(
//                                           AssetsManager.borderIcon,
//                                         ),
//                                         fit: BoxFit.fill,
//                                       ),                              ),
//                                     child: Center(
//                                       child: Text(
//                                         to,
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontFamily:
//                                             getTranslated(context, "Montserratsemibold"),
//                                             color: AppColors.black,
//                                             fontSize: AppFontsSizeManager.s18_6.sp,),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
                          
//                         ],
//                       ),
//                     ),
//                     //call
//                     SizedBox(
//                       height: AppSize.h32.h,
//                     ),
//                     Center(
//                       child: Container(
//                         width: size.width,
//                         padding: EdgeInsets.only(
//                         top: AppPadding.p32.h,
//                         bottom: AppPadding.p34_6.h,
//                         right: AppPadding.p53_3.w,
//                         left: AppPadding.p53_3.h,),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(AppRadius.r32.r),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color.fromRGBO(48, 48, 48, 0.06),
//                               blurRadius: 18.r,
//                               spreadRadius: 0.0,
//                               offset: Offset(
//                                   0, 9.0), // shadow direction: bottom right
//                             )
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   height: 25,
//                                   width: size.width * .30,
//                                   decoration: BoxDecoration(
//                                     color: AppColors.white,
//                                     borderRadius: BorderRadius.circular(5.0),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       getTranslated(context, "callMe"),
//                                       style: TextStyle(
//                                           fontFamily: getTranslated(
//                                               context, "Montserratsemibold"),
//                                           color: AppColors.black,
//                                           fontSize: AppFontsSizeManager.s21_3.sp,
//                                           ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               color: AppColors.pink2,
//                               width: AppSize.w76.w,
//                               height: AppSize.h2_6.h,
        
//                             ),
//                             SizedBox(
//                               height: AppSize.h24.h,
//                             ),
//                             //ig
//                             Image.asset(
//                               AssetsManager.sendIcon,
//                               height: AppSize.h130_6.h,
//                               width: AppSize.w156.w,
//                               fit: BoxFit.fill,
//                             ),
//                             //voice&video button
//                             Padding(
//                               padding: EdgeInsets.only(
//                                   left: AppPadding.p53_3.w,
//                                   right: AppPadding.p53_3.w,
//                                   top: AppPadding.p32.h,
//                                   bottom: AppPadding.p32.h),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       IconButton1(onPress: () {
//                                         setState(() {
//                                           type = "audio";
//                                         });
//                                       }, Width: AppSize.w60.r,
//                                        Height: AppSize.h60.r,
//                                        ButtonRadius: AppRadius.r10_6.r,
//                                        ButtonBackground: AppColors.pink2,
//                                        Icon: AssetsManager.whiteCallIconPath.toString(),
//                                        IconWidth: AppSize.w37_3.w
//                                        ,IconHeight: AppSize.h37_3.h,),

//                                       SizedBox(
//                                         height: AppSize.h16.h,
//                                       ),
//                                       Text(
//                                         getTranslated(context, "voiceCall"),
//                                         style: TextStyle(
//                                             fontFamily: getTranslated(
//                                                 context, "Montserratmedium"),
//                                             color: AppColors.black,
//                                             fontSize: AppFontsSizeManager.s18_6.sp),
//                                       ),
//                                       SizedBox(
//                                         height: AppSize.h16.h,
//                                       ),
//                                       Row(
//                                         children: [
//                                           Text(
//                                             "30\$",
//                                             style: TextStyle(
//                                                 fontFamily: getTranslated(
//                                                     context, "Montserratsemibold"),
//                                                 color: AppColors.darkGrey,

//                                                 fontSize: AppFontsSizeManager.s21_3.sp),
//                                           ),

//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       IconButton1(onPress: () {
//                                         setState(() {
//                                           type = "video";
//                                         });
//                                       }, Width: AppSize.w60.w, Height: AppSize.h60.h,ButtonRadius: AppRadius.r10_6.r,ButtonBackground: AppColors.whitered,Icon: AssetsManager.whiteVideoIconPath.toString(),IconWidth: AppSize.w32.w,IconHeight: AppSize.h20_4.h,IconColor: AppColors.pink2,),
//                                       SizedBox(
//                                         height: AppSize.h16.h,
//                                       ),
//                                       Text(
//                                         getTranslated(context, "videoCall"),
//                                         style: TextStyle(
//                                             fontFamily: getTranslated(
//                                                 context, "Montserratmedium"),
//                                             color: AppColors.black,

//                                             fontSize: AppFontsSizeManager.s18_6.sp),
//                                       ),
//                                       SizedBox(
//                                         height: AppSize.h16.h,
//                                       ),
//                                       Row(
//                                         children: [
//                                           Text(
//                                             "30\$",
//                                             style: TextStyle(
//                                                 fontFamily: getTranslated(
//                                                     context, "Montserratsemibold"),
//                                                 color: AppColors.darkGrey,
//                                                 fontWeight: FontWeight.w300,
//                                                 fontSize: AppFontsSizeManager.s21_3.sp),
//                                           ),

//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
        
//                             Text.rich(
//                               TextSpan(
//                                 text: getTranslated(context, "itIs"),
//                                 style: TextStyle(
//                                     fontFamily:
//                                         getTranslated(context, "Montserratmedium"),
//                                     color: AppColors.grey3,
//                                     fontSize: AppFontsSizeManager.s18_6.sp,
//                                     fontWeight: FontWeight.normal),
//                                 children: <TextSpan>[
//                                   TextSpan(
//                                     text:
//                                         getTranslated(context, "notAllowedVideo"),
//                                     style: TextStyle(
//                                       fontFamily:
//                                           getTranslated(context, "Montserratmedium"),
//                                       decorationThickness: 1,
//                                       color: AppColors.pink2,
//                                       fontSize: AppFontsSizeManager.s18_6.sp,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: " ",
//                                     style: TextStyle(
//                                       fontFamily:
//                                           getTranslated(context, "Montserratmedium"),
//                                       decorationThickness: 1,
//                                       color: AppColors.pink2,
//                                       fontSize: AppFontsSizeManager.s18_6.sp,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: getTranslated(context, "typeText"),
//                                     style: TextStyle(
//                                       fontFamily:
//                                           getTranslated(context, "Montserratmedium"),
//                                       decorationThickness: 1,
//                                       color: AppColors.grey3,
//                                       fontSize: AppFontsSizeManager.s18_6.sp,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               softWrap: true,
//                               maxLines: 10,
//                               textAlign: TextAlign.center,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
        
//                     SizedBox(
//                       height: AppSize.h64.h,
//                     ),
//                     load
//                         ? Center(child: CircularProgressIndicator())
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SvgPicture.asset(
//                                 AssetsManager.goldFlower3IconPath,
//                                 width: AppSize.w30_1.r,
//                                 height: AppSize.h30_1.r,
//                               ),
//                               //pb
//                               SizedBox(
//                                 width: AppSize.w5_3.w,
//                               ),
//                               TextButton1(onPress: () async {
//                                 if (user == null)
//                                   Navigator.pushNamed(
//                                       context, '/Register_Type');
//                                 if (user!.userType == "COACH" ||
//                                     user!.userType == "CLIENT")
//                                   changeTypeDialog(size);
//                                 else if (type == null)
//                                   Fluttertoast.showToast(
//                                       msg: getTranslated(
//                                           context, "selectCallType"),
//                                       toastLength: Toast.LENGTH_SHORT,
//                                       gravity: ToastGravity.BOTTOM,
//                                       backgroundColor: Colors.red,
//                                       textColor: Colors.white,
//                                       fontSize: 16.0);
//                                 else if (type == "video" &&
//                                     user!.userConsultIds == null) {
//                                   Fluttertoast.showToast(
//                                       msg: getTranslated(context, "audioFirst"),
//                                       toastLength: Toast.LENGTH_SHORT,
//                                       gravity: ToastGravity.BOTTOM,
//                                       backgroundColor: Colors.red,
//                                       textColor: Colors.white,
//                                       fontSize: 16.0);
//                                 } else if (type == "video" &&
//                                     user!.userConsultIds != null &&
//                                     (!(user!.userConsultIds!
//                                         .contains(widget.consultant.uid!)))) {
//                                   videoDialog(size);
//                                 } else if (user != null &&
//                                     currentNumber == 0 &&
//                                     validPartner == false) {
//                                   print("ddddddd");
//                                   confirmDialog(size);
//                                 } else if (user != null &&
//                                     currentNumber == 0 &&
//                                     validPartner) {
                                      
//                                   orderPay();
//                                 } else {
//                                   showAddAppointmentDialog(
//                                       order!.orderId, order!.callPrice);
//                                 }
//                               }, Title:  getTranslated(context, "confirm"),
//                               Width: AppSize.w432.w,
//                               Height: AppSize.h66_6.h,
//                               ButtonBackground: AppColors.pink2,
//                               ButtonRadius: AppRadius.r10_6.r,
//                               TextSize: AppFontsSizeManager.s21_3.sp,
//                                TextFont: getTranslated(context, "Montserratsemibold"),
//                                TextColor: AppColors.white),
//                               /*SizedBox(
//                                 width: AppSize.w5_3.w,
//                               ),*/

//                               SizedBox(
//                                 width: AppSize.w5_3.w,
//                               ),
//                               SvgPicture.asset(
//                                 AssetsManager.goldFlower4IconPath,
//                                 width: AppSize.w30_1.r,
//                                 height: AppSize.h30_1.r,
//                               ),
//                             ],
//                           ),
        
//                     SizedBox(
//                       height: AppSize.h89_3.h,
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   orderPay() async {
//     setState(() {
//       load = true;
//     });
//     if (double.parse(user!.balance.toString()) >= price) {
//       var newBalance = double.parse(user!.balance.toString()) - price;
//       await FirebaseFirestore.instance
//           .collection(Paths.usersPath)
//           .doc(user!.uid)
//           .set({
//         'balance': newBalance,
//       }, SetOptions(merge: true));
//       setState(() {
//         fromBalance = true;
//         user!.balance = newBalance;
//       });
//       updateDatabaseAfterAddingOrder("userBalance");
//     } else {
//       setState(() {
//         fromBalance = false;
//       });
//       stripePayment(
//           email: widget.loggedUser!.phoneNumber! + "@gmail.com",
//           amount: 3000,
//           context: context); //3000

//     }
//   }

//   Widget headerWidget() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Container(
//           width: size.width,
//           padding:
//               const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//           ),
//           child: Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 IconButton(
//                   iconSize: 30,
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: Image.asset(
//                     getTranslated(context, 'back'),
//                     width: 30,
//                     height: 30,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     /* widget.loggedUser == null?SizedBox():ReportBottomSheetWidget(
//                       loggedUser: widget.loggedUser!,
//                       consult: widget.consultant,
//                     ),*/
//                     IconButton(
//                       iconSize: 30,
//                       onPressed: () {
//                         share(context);
//                       },
//                       icon: Image.asset(
//                         'assets/icons/icon/Group 3655.png',
//                         width: 30,
//                         height: 30,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Container(color: AppColors.white3, height: 1, width: size.width)
//       ],
//     );
//   }

//   changeTypeDialog(Size size) {
//     return showDialog(
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(15.0),
//           ),
//         ),
//         elevation: 5.0,
//         contentPadding: const EdgeInsets.only(
//             left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
//         content: StatefulBuilder(
//           builder: (context, setState) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 Center(
//                   child: Text(
//                     getTranslated(context, "attention"),
//                     style: TextStyle(
//                       fontFamily: getTranslated(context, "fontFamily"),
//                       fontSize: 14.0,
//                       fontWeight: FontWeight.w300,
//                       color: AppColors.reddark2,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 Text(
//                   getTranslated(context, "confirmChangeType"),
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: getTranslated(context, "fontFamily"),
//                     fontSize: 11.0,
//                     fontWeight: FontWeight.w300,
//                     color: AppColors.balck2,
//                   ),
//                 ),
//                 Text(
//                   getTranslated(context, "confirmPay2"),
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: getTranslated(context, "fontFamily"),
//                     fontSize: 11.0,
//                     fontWeight: FontWeight.w300,
//                     color: AppColors.balck2,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: <Widget>[
//                       InkWell(
//                         onTap: () async {
//                           Navigator.pop(context);
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                           height: 35,
//                           width: 50,
//                           padding: const EdgeInsets.all(2),
//                           decoration: BoxDecoration(
//                             color: AppColors.lightPink,
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           child: Center(
//                             child: Text(
//                               getTranslated(context, "no"),
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontFamily:
//                                       getTranslated(context, "fontFamily"),
//                                   color: AppColors.reddark2,
//                                   fontSize: 11.0,
//                                   fontWeight: FontWeight.w300),
//                             ),
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () async {
//                           Navigator.pop(context);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => UserAccountScreen(
//                                   user: user!, firstLogged: false),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           height: 35,
//                           width: 50,
//                           padding: const EdgeInsets.all(2),
//                           decoration: BoxDecoration(
//                             color: AppColors.reddark2,
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           child: Center(
//                             child: Text(
//                               getTranslated(context, "yes"),
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontFamily:
//                                     getTranslated(context, "fontFamily"),
//                                 color: Colors.white,
//                                 fontSize: 11.0,
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//       barrierDismissible: false,
//       context: context,
//     );
//   }

//   confirmDialog(Size size) {
//     return showDialog(
//       builder: (context) =>  NikahDialogWidget(
//         padButtom: AppPadding.p48.h,
//         padLeft: AppPadding.p10.w,
//         padReight: AppPadding.p10.w,
//         padTop:AppPadding.p42_6.h,
//         radius: AppRadius.r21_3.r,
//         dialogContent: Container(
//           color: AppColors.white,
//         width:AppSize.w458_6.w,
//           child: StatefulBuilder(
//             builder: (context, setState) {
//               return Container(

//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Center(
//                       child: Text(
//                         getTranslated(context, "attention"),
//                         style: TextStyle(
//                           fontFamily: getTranslated(context, "Montserratsemibold"),
//                           fontSize: AppFontsSizeManager.s24.sp,
//                           color: AppColors.reddark2,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: AppSize.h19_3.h,
//                     ),
//                     Text(
//                       getTranslated(context, "confirmPay1"),
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontFamily: getTranslated(context, "Montserrat"),
//                         fontSize: AppFontsSizeManager.s21_3.sp,
//                         fontWeight:
//                         lang=="ar"?
//                         AppFontsWeightManager.semiBold
//                         :null,
//                         color: AppColors.balck2,
//                       ),
//                     ),
//                     Text(
//                       getTranslated(context, "confirmPay2"),
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontFamily: getTranslated(context, "Montserrat"),
//                         fontSize: AppFontsSizeManager.s21_3.sp,
//                         fontWeight:
//                         lang=="ar"?
//                         AppFontsWeightManager.semiBold
//                         :null,
//                         color: AppColors.reddark2,
//                       ),
//                     ),
//                     SizedBox(
//                       height: AppSize.h24_6.h,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: AppPadding.p33_3.w
//                       ),
//                       child: Row(

//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisSize: MainAxisSize.max,
//                         children: <Widget>[
//                           InkWell(
//                             onTap: () async {
//                               Navigator.pop(context);
//                               orderPay();
//                             },
//                             child: Container(
//                               width: AppSize.w160.w,
//                               height:AppSize.h52.h ,
//                               decoration: BoxDecoration(
//                                 color: AppColors.reddark2,
//                                 borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
//                               ),
//                               padding: const EdgeInsets.all(2),
//                               child: Center(
//                                 child: Text(
//                                   getTranslated(context, "continue"),
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontFamily:
//                                         getTranslated(context, "Montserratsemibold"),
//                                     color: Colors.white,
//                                     fontSize: AppFontsSizeManager.s21_3.sp,
//                                     fontWeight: FontWeight.w300,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),

//                           SizedBox(width: AppSize.w53_3.w,),
//                           InkWell(
//                             onTap: () async {
//                               Navigator.pop(context);
//                               Navigator.pop(context);
//                             },
//                             child: Container(
//                               width: AppSize.w160.w,
//                               height:AppSize.h52.h ,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
//                                 border: Border.all(
//                                     color: AppColors.reddark2
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   getTranslated(context, "cancel"),
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontFamily:
//                                       getTranslated(context, "Montserratsemibold"),
//                                       color: AppColors.reddark2,
//                                       fontSize: AppFontsSizeManager.s21_3.sp,
//                                       fontWeight: FontWeight.w300),
//                                 ),
//                               ),
//                             ),
//                           ),

//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//       barrierDismissible: false,
//       context: context,
//     );
//   }
//   videoDialog(Size size) {
//     return showDialog(
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(15.0),
//           ),
//         ),
//         elevation: 5.0,
//         contentPadding: const EdgeInsets.only(
//             left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
//         content: StatefulBuilder(
//           builder: (context, setState) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 Center(
//                   child: Text(
//                     getTranslated(context, "attention"),
//                     style: TextStyle(
//                       fontFamily: getTranslated(context, "fontFamily"),
//                       fontSize: 14.0,
//                       fontWeight: FontWeight.w300,
//                       color: AppColors.reddark2,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: getTranslated(context, "itIs"),
//                     style: TextStyle(
//                         fontFamily:
//                         getTranslated(context, "fontFamily"),
//                         color: AppColors.grey3,
//                         fontSize: 12.0,
//                         fontWeight: FontWeight.normal),
//                     children: <TextSpan>[
//                       TextSpan(
//                         text:
//                         getTranslated(context, "notAllowedVideo"),
//                         style: TextStyle(
//                           fontFamily:
//                           getTranslated(context, "fontFamily"),
//                           decorationThickness: 1,
//                           color: AppColors.reddark,
//                           fontSize: 12.0,
//                         ),
//                       ),
//                       TextSpan(
//                         text: " ",
//                         style: TextStyle(
//                           fontFamily:
//                           getTranslated(context, "fontFamily"),
//                           decorationThickness: 1,
//                           color: AppColors.reddark,
//                           fontSize: 12.0,
//                         ),
//                       ),
//                       TextSpan(
//                         text: getTranslated(context, "typeText"),
//                         style: TextStyle(
//                           fontFamily:
//                           getTranslated(context, "fontFamily"),
//                           decorationThickness: 1,
//                           color: AppColors.grey3,
//                           fontSize: 12.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                   softWrap: true,
//                   maxLines: 10,
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 Center(
//                   child: InkWell(
//                     onTap: () async {
//                       Navigator.pop(context);

//                     },
//                     child: Container(
//                       height: 35,
//                       width: 50,
//                       padding: const EdgeInsets.all(2),
//                       decoration: BoxDecoration(
//                         color: AppColors.lightPink,
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Center(
//                         child: Text(
//                           getTranslated(context, "Ok"),
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontFamily:
//                               getTranslated(context, "fontFamily"),
//                               color: AppColors.reddark2,
//                               fontSize: 11.0,
//                               fontWeight: FontWeight.w300),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//       barrierDismissible: false,
//       context: context,
//     );
//   }
//   BoxDecoration decoration() {
//     return BoxDecoration(
//       color: AppColors.white,
//       borderRadius: BorderRadius.circular(8.0),
//       boxShadow: [
//         BoxShadow(
//           color: AppColors.grey,
//           blurRadius: 2.0,
//           spreadRadius: 0.0,
//           offset: Offset(0.0, 1.0), // shadow direction: bottom right
//         )
//       ],
//     );
//   }

//   void showNoNotifSnack(String text) {
//     Flushbar(
//       margin: const EdgeInsets.all(8.0),
//       borderRadius: BorderRadius.circular(7),
//       backgroundColor: Colors.green.shade500,
//       animationDuration: Duration(milliseconds: 300),
//       isDismissible: true,
//       boxShadows: [
//         BoxShadow(
//           color: Colors.black12,
//           spreadRadius: 1.0,
//           blurRadius: 5.0,
//           offset: Offset(0.0, 2.0),
//         )
//       ],
//       shouldIconPulse: false,
//       duration: Duration(milliseconds: 1500),
//       icon: Icon(
//         Icons.notification_important,
//         color: Colors.white,
//       ),
//       messageText: Text(
//         '$text',
//         style: TextStyle(
//           fontFamily: getTranslated(context, "fontFamily"),
//           fontSize: 14.0,
//           fontWeight: FontWeight.w500,
//           letterSpacing: 0.3,
//           color: Colors.white,
//         ),
//       ),
//     )..show(context);
//   }

//   // Stripe google and apple pay test
//   Future<void> stripePayment(
//       {required String email,
//       required double amount,
//       required BuildContext context}) async {
//     try {
//       print("stripePayment1");
//       email = email.trim().replaceAll(' ', '');
//       print(email);
//       // 1. Create a payment intent on the server
//       final response = await http.post(
//           Uri.parse(
//               'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/stripePaymentIntentRequest'),
//           body: {
//             'email': email,
//             'amount': amount.toString(),
//           });
//       print("stripePayment2");
//       final jsonResponse = jsonDecode(response.body);
//       print(jsonResponse);
//       // 2. Initialize the payment sheet
//       // await Stripe.instance.initPaymentSheet(
//       //     paymentSheetParameters: SetupPaymentSheetParameters(
//       //   paymentIntentClientSecret: jsonResponse['paymentIntent'],
//       //   customerId: jsonResponse['customer'],
//       //   customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
//       //   testEnv: false,
//       //   applePay: true,
//       //   googlePay: true,
//       //   merchantDisplayName: "Make My Nikah",
//       //   merchantCountryCode: "AE",
//       //   style: ThemeMode.dark,
//       //   appearance: PaymentSheetAppearance(
//       //     /*   colors: PaymentSheetAppearanceColors(
//       //           background: Colors.white,
//       //           primary: Colors.white,
//       //           componentBorder: Colors.black,
//       //         ),
//       //         shapes: PaymentSheetShape(
//       //           borderWidth: 4,
//       //           shadow: PaymentSheetShadowParams(color: Colors.white),
//       //         ),*/
//       //     primaryButton: PaymentSheetPrimaryButtonAppearance(
//       //       shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
//       //       colors: PaymentSheetPrimaryButtonTheme(
//       //         dark: PaymentSheetPrimaryButtonThemeColors(
//       //           background: AppColors.reddark2,
//       //           text: AppColors.white,
//       //           border: Colors.white,
//       //         ),
//       //         light: PaymentSheetPrimaryButtonThemeColors(
//       //           background: AppColors.reddark2,
//       //           text: AppColors.white,
//       //           border: Colors.white,
//       //         ),
//       //       ),
//       //     ),
//       //   ),
//       // ));
//       print("stripePayment3");
//       // await Stripe.instance.presentPaymentSheet();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Payment is successful'),
//         ),
//       );
//       print("stripePayment4");
//       updateDatabaseAfterAddingOrder("userBalance");
//       // print("good");

//       print("add_payment_info event");
//       String eventName = "af_add_payment_info";
//       Map eventValues = {
//         "af_success": true,
//         "af_achievement_id": "success",
//       };
//       await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
//         "success": true,
//         "reason": "success",
//         "userUid": widget.loggedUser!.uid
//       });
//     } catch (error) {
//       print("stripeerror");
//       String eventName = "af_add_payment_info";
//       Map eventValues = {
//         "af_success": false,
//         "af_achievement_id": error.toString(),
//       };

//       await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
//         "success": false,
//         "reason": error.toString(),
//         "userUid": widget.loggedUser!.uid
//       });
//       print(error.toString());
//       // if (error is StripeException) {
//       //   ScaffoldMessenger.of(context).showSnackBar(
//       //     SnackBar(
//       //       content: Text('An error occured ${error.error.localizedMessage}'),
//       //     ),
//       //   );
//       // } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('An error occured $error'),
//         ),
//       );
//       // }
//       setState(() {
//         load = false;
//       });
//     }
//   }

//   updateDatabaseAfterAddingOrder(String? payWith) async {
//     try {
//       //createOrder
//       String orderId = Uuid().v4();
//       DateTime dateValue = DateTime.now();
//       await FirebaseFirestore.instance
//           .collection(Paths.ordersPath)
//           .doc(orderId)
//           .set({
//         'orderStatus': 'open',
//         'orderId': orderId,
//         'date': {
//           'day': dateValue.day,
//           'month': dateValue.month,
//           'year': dateValue.year,
//         },
//         "consultType": type,
//         'orderTimestamp': Timestamp.now(),
//         'utcTime': DateTime.now().toUtc().toString(),
//         'orderTimeValue':
//             DateTime(dateValue.year, dateValue.month, dateValue.day)
//                 .millisecondsSinceEpoch,
//         'packageId': "",
//         'promoCodeId': "",
//         'remainingCallNum': 1,
//         'packageCallNum': 1,
//         'answeredCallNum': 0,
//         'callPrice': 30,
//         "payWith": payWith,
//         "platform": Platform.isIOS ? "iOS" : "Android",
//         'price': "30",
//         'consult': {
//           'uid': widget.consultant.uid,
//           'name': widget.consultant.name,
//           'image': widget.consultant.photoUrl,
//           'phone': widget.consultant.phoneNumber,
//           'countryCode': widget.consultant.countryCode,
//           'countryISOCode': widget.consultant.countryISOCode,
//         },
//         'user': {
//           'uid': user!.uid,
//           'name': user!.name,
//           'image': user!.photoUrl,
//           'phone': user!.phoneNumber,
//           'countryCode': user!.countryCode,
//           'countryISOCode': user!.countryISOCode,
//         },
//       });
//       currentNumber = 1;

//       print("af_purchase event");
//       String eventName = "af_purchase";
//       Map eventValues = {
//         "af_revenue": "30",
//         "af_price": "30",
//         "af_content_id": widget.consultant.uid,
//         "af_order_id": orderId,
//         "af_currency": "USD",
//       };

//       await FirebaseAnalytics.instance.logPurchase(
//           currency: "USD",
//           value: 30.0,
//           affiliation: widget.consultant.uid,
//           transactionId: orderId);
//       //update user order numbers
//       int userOrdersNumbers = 1;
//       dynamic payedBalance = double.parse(price.toString());
//       if (user!.ordersNumbers != null)
//         userOrdersNumbers = user!.ordersNumbers! + 1;
//       if (user!.payedBalance != null)
//         payedBalance = user!.payedBalance + payedBalance;

//       await FirebaseFirestore.instance
//           .collection(Paths.usersPath)
//           .doc(user!.uid)
//           .set({
//         'ordersNumbers': userOrdersNumbers,
//         'payedBalance': payedBalance,
//         'customerId': " ",
//         "userConsultIds": user!.userConsultIds! + "," + widget.consultant.uid!,
//         'preferredPaymentMethod': "tapCompany"
//       }, SetOptions(merge: true));
//       accountBloc.add(GetLoggedUserEvent());

//       showAddAppointmentDialog(orderId, price);
//     } catch (e) {
//       errorLog("updateDatabaseAfterAddingOrder", e.toString());
//     }
//   }

//   Future<void> getNumber() async {
//     try {
//       setState(() {
//         load = true;
//       });
//       await FirebaseFirestore.instance
//           .collection(Paths.ordersPath)
//           .where(
//             'user.uid',
//             isEqualTo: user!.uid,
//           )
//           .where(
//             'consult.uid',
//             isEqualTo: widget.consultant.uid,
//           )
//           .where('orderStatus', isEqualTo: 'open')
//           .get()
//           .then((value) async {
//         if (value != null && value.docs != null && value.docs.length > 0) {
//           var order2 = Orders.fromMap(value.docs[0].data() as Map);
//           setState(() {
//             order = order2;
//           });
//           await FirebaseFirestore.instance
//               .collection(Paths.appAppointments)
//               .where(
//                 'orderId',
//                 isEqualTo: order!.orderId,
//               )
//               .get()
//               .then((value) async {
//             if (value.docs.length > 0) {
//               setState(() {
//                 currentNumber = order!.packageCallNum - value.docs.length;
//               });
//             } else {
//               setState(() {
//                 currentNumber = order!.packageCallNum;
//               });
//             }
//           }).catchError((err) {
//             errorLog("getNumber1", err.toString());
//             setState(() {
//               load = false;
//             });
//           });
//         } else {
//           setState(() {
//             currentNumber = 0;
//             order = null;
//           });
//         }
//         setState(() {
//           load = false;
//         });
//       }).catchError((err) {
//         errorLog("getNumber", err.toString());
//         setState(() {
//           load = false;
//         });
//       });
//     } catch (e) {
//       errorLog("getNumber", e.toString());
//       setState(() {
//         load = false;
//         currentNumber = 0;
//         order = null;
//       });
//     }
//   }

//   showAddAppointmentDialog(String _orderId, dynamic callPrice) async {
//     bool isProceeded = await showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return AddAppointmentDialog(
//             loggedUser: user!,
//             consultant: widget.consultant,
//             localFrom: localFrom,
//             localTo: localTo,
//             type: type!,
//             orderId: _orderId,
//           callPrice: callPrice,
//         );
//       },
//     );

//     if (isProceeded != null) {
//       if (isProceeded) {
//         print("allah");
//         setState(() {
//           load = false;
//         });
//       }
//     }
//   }

//   cleanConsultDays() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection(Paths.consultDaysPath)
//           .where('date',
//               isLessThan: DateTime(DateTime.now().year, DateTime.now().month,
//                       DateTime.now().day)
//                   .millisecondsSinceEpoch)
//           .where('consultUid', isEqualTo: widget.consultant.uid)
//           .get();
//       for (var doc in querySnapshot.docs) {
//         await FirebaseFirestore.instance
//             .collection(Paths.consultDaysPath)
//             .doc(doc.id)
//             .delete();
//       }
//     } catch (e) {
//       print("hhhhhh" + e.toString());
//     }
//   }

//   Widget rateWidget(String name, dynamic rate) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           name,
//           textAlign: TextAlign.start,
//           overflow: TextOverflow.ellipsis,
//           maxLines: 1,
//           style: TextStyle(
//               fontFamily: getTranslated(context, "Montserratsemibold"),
//               color: AppColors.black,
//               fontSize: AppFontsSizeManager.s18_6.sp,
//              ),
//         ),
//         Expanded(child: SizedBox()),
//         RatingBar(
//           initialRating: rate,
//           direction: Axis.horizontal,
//           allowHalfRating: true,
//           itemCount: 5,
//           itemSize: AppSize.w16.r,
//           itemPadding: EdgeInsets.symmetric(horizontal: AppPadding.p2.w),
//           ratingWidget: RatingWidget(

//             full: Image.asset(
//               "assets/icons/icon/baseline-favorite-24px.png",
//               width: AppSize.w16.h,
//               height: AppSize.h16.r,
//             ),
//             half: Image.asset(
//               "assets/icons/icon/baseline-favorite-2.png",
//               width:AppSize.w16.r,
//               height:AppSize.h16.r,
//             ),
//             empty: Image.asset("assets/icons/icon/baseline-favorite-1.png",
//                 width: AppSize.w16.r, height: AppSize.h16.r,),
//           ),
//           onRatingUpdate: (double value) {},
//         ),
//       ],
//     );
//   }

//   Widget daysWidget(String day) {
//     return Container(
//       width: AppSize.w60.w,
//       height: AppSize.h73_3.h,
      
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(
//             AssetsManager.circleIcon,
//           ),
//           fit: BoxFit.fill,
//         ),
//       ),
//       child: Center(
//         child: Text(
//           day,
//           textAlign: TextAlign.center,
//           overflow: TextOverflow.ellipsis,
//           maxLines: 1,
//           style: TextStyle(
//             fontFamily: getTranslated(context, "Montserratsemibold"),
//             color: AppColors.blackColor,
            
//             fontSize: AppFontsSizeManager.s16.sp,
//           ),
//         ),
//       ),
//     );
//   }

//   share(BuildContext context) async {
//     setState(() {
//       sharing = true;
//     });
//     String uid = widget.consultant.uid!;
//     // Create DynamicLink
//     print("share1");
//     print("https://makemynikahapp\.page\.link/.*consultant_id=" + uid);
//     final dynamicLinkParams = DynamicLinkParameters(
//       link: Uri.parse("https://makemynikahapp\.page\.link/consultant_id=" + uid),
//       uriPrefix: "https://makemynikahapp\.page\.link",
//       androidParameters:
//           const AndroidParameters(packageName: "com.app.MakeMyNikah"),
//       iosParameters: const IOSParameters(
//           bundleId: "com.app.MakeMyNikah", appStoreId: "1665532757"),
//     );
//     ShortDynamicLink dynamicLink =
//         await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

//     File file;

//     final bytes = await rootBundle.load('assets/icons/icon/Mask Group 47.png');
//     final list = bytes.buffer.asUint8List();
//     final tempDir = await getTemporaryDirectory();
//     file = await File('${tempDir.path}/image.jpg').create();
//     file.writeAsBytesSync(list);
//     String text =
//         "${widget.consultant.name} \n I think that she will be a good wife for you \n ${dynamicLink.shortUrl.toString()}";

//     Share.shareFiles(["${file.path}"], text: text);
//     setState(() {
//       sharing = false;
//     });
//   }
// }

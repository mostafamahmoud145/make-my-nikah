// import 'dart:convert';
// import 'dart:io';
// import 'package:animate_icons/animate_icons.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
// import 'package:grocery_store/config/app_fonts.dart';
// import 'package:grocery_store/config/app_constat.dart';
// import 'package:grocery_store/config/app_fonts.dart';
// import 'package:grocery_store/config/assets_manager.dart';
// import 'package:grocery_store/config/colorsFile.dart';
// import 'package:grocery_store/config/paths.dart';
// import 'package:grocery_store/localization/localization_methods.dart';
// import 'package:grocery_store/methodes/pt_to_px.dart';
// import 'package:grocery_store/models/order.dart';
// import 'package:flutter/material.dart';
// import 'package:grocery_store/widget/addAppointmentDialog.dart';
// import 'package:grocery_store/widget/resopnsive.dart';
// import 'package:grocery_store/widget/reviewWidget.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:uuid/uuid.dart';
// import '../config/app_values.dart';
// import '../config/assets_manager.dart';
// import '../config/app_values.dart';
// import '../models/user.dart';

// import 'package:http/http.dart' as http;
// import '../widget/TextButton.dart';
// import '../widget/about_me_widget.dart';
// import '../widget/app_bar_widget.dart';
// import 'coachBioDetailsScreen.dart';

// class CoachDetailScreen extends StatefulWidget {
//   final GroceryUser consultant;
//   final GroceryUser? loggedUser;

//   const CoachDetailScreen({Key? key, required this.consultant, this.loggedUser})
//       : super(key: key);

//   @override
//   _CoachDetailScreenState createState() => _CoachDetailScreenState();
// }

// class _CoachDetailScreenState extends State<CoachDetailScreen> {
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
//   bool first = true, showPayView = false, load = false, fromBalance = false;
//   String? userImage, userName = "beautUser", type = "coach";
//   bool validPartner = false;
//   AnimateIconController? animatecontroller;

//   double price = 0.0;
//   late Size size;

//   bool loadData = false;

//   bool sharing = false;
//   String lang = "";

//   @override
//   void initState() {
//     super.initState();
//     price = double.parse(widget.consultant.price.toString());
//     animatecontroller = AnimateIconController();
//     cleanConsultDays();

//     accountBloc = BlocProvider.of<AccountBloc>(context);
//     if (widget.loggedUser != null) {
//       user = widget.loggedUser!;
//       getNumber();
//       accountBloc.add(GetLoggedUserEvent());
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

  //   print("content_view event started ");
  //   String eventName = "af_content_view";
  //   Map eventValues = {
  //     "af_price": widget.consultant.price.toString(),
  //     "af_content_id": widget.consultant.uid,
  //   };
  // }

  // errorLog(String function, String error) async {
  //   String id = Uuid().v4();
  //   await FirebaseFirestore.instance
  //       .collection(Paths.errorLogPath)
  //       .doc(id)
  //       .set({
  //     'timestamp': Timestamp.now(),
  //     'id': id,
  //     'seen': false,
  //     'desc': error,
  //     'phone': widget.loggedUser == null ? " " : widget.loggedUser!.phoneNumber,
  //     'screen': "CoachDetailScreen",
  //     'function': function,
  //   });
  // }

  // void showSnakbar(String s, bool status) {
  //   Fluttertoast.showToast(
  //       msg: s,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }

  // void didChangeDependencies() {
  //   if (user != null && user!.photoUrl != null && user!.photoUrl != "")
  //     setState(() {
  //       userImage = user!.photoUrl!;
  //     });
  //   if (first && widget.consultant.workDays!.length > 0) {
  //     dayList = [];
  //     if (widget.consultant.workDays!.contains("1"))
  //       dayList.add(getTranslated(context, "monday"));
  //     if (widget.consultant.workDays!.contains("2"))
  //       dayList.add(getTranslated(context, "tuesday"));
  //     if (widget.consultant.workDays!.contains("3"))
  //       dayList.add(getTranslated(context, "wednesday"));
  //     if (widget.consultant.workDays!.contains("4"))
  //       dayList.add(getTranslated(context, "thursday"));
  //     if (widget.consultant.workDays!.contains("5"))
  //       dayList.add(getTranslated(context, "friday"));
  //     if (widget.consultant.workDays!.contains("6"))
  //       dayList.add(getTranslated(context, "saturday"));
  //     if (widget.consultant.workDays!.contains("7"))
  //       dayList.add(getTranslated(context, "sunday"));
  //     setState(() {
  //       dayListValue = dayList;
  //       first = false;
  //     });
  //   }
  //   size = MediaQuery.of(context).size;
  //   super.didChangeDependencies();
  // }

  // BoxShadow shadow() {
  //   return BoxShadow(
  //     color: AppColors.chat,
  //     blurRadius: 2,
  //     spreadRadius: 2,
  //     offset: Offset(0.0, 1.0), // shadow direction: bottom right
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   lang = getTranslated(context, "lang");
  //   return Scaffold(
  //     key: _scaffoldKey,
  //     backgroundColor: Colors.white,
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: <Widget>[
  //         SizedBox(
  //           height: AppSize.h42_6.h,
  //         ),
  //         AppBarWidget4(onPress: () {
  //           share(context);
  //         }),
  //         SizedBox(
  //           height: AppSize.h8.h,
  //         ),
  //         Container(
  //             color: AppColors.lightGrey,
  //             height: AppSize.h1,
  //             width: double.infinity),
  //         Expanded(
  //           child: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 SizedBox(
  //                   height: AppSize.h45_3.h,
  //                 ),
  //                 Center(
  //                   child: Container(
  //                     height: convertPtToPx(AppSize.h70).h,
  //                     width: convertPtToPx(AppSize.w70).w,
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       color: AppColors.white,
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Color.fromRGBO(32, 32, 32, 0.05),
  //                           blurRadius: 17.0,
  //                           spreadRadius: 0.0,
  //                           offset: Offset(
  //                               0, 5.0), // shadow direction: bottom right
  //                         )
  //                       ],
  //                     ),
  //                     child: widget.consultant.photoUrl!.isEmpty
  //                         ? Image.asset(
  //                             AssetsManager.loadGIF,
  //                             height: convertPtToPx(AppSize.h70).h,
  //                             width: convertPtToPx(AppSize.w70).w,
  //                             fit: BoxFit.cover,
  //                           )
  //                         : ClipRRect(
  //                             borderRadius: BorderRadius.circular(100.0),
  //                             child: FadeInImage.assetNetwork(
  //                               placeholder: AssetsManager.loadGIF,
  //                               placeholderScale: 0.5,
  //                               imageErrorBuilder:
  //                                   (context, error, stackTrace) => Image.asset(
  //                                 AssetsManager.loadGIF,
  //                                 height: convertPtToPx(AppSize.h70).h,
  //                                 width: convertPtToPx(AppSize.w70).w,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                               image: widget.consultant.photoUrl!,
  //                               fit: BoxFit.cover,
  //                               fadeInDuration: Duration(
  //                                   milliseconds: AppConstants.milliseconds250),
  //                               fadeInCurve: Curves.easeInOut,
  //                               fadeOutDuration: Duration(
  //                                   milliseconds: AppConstants.milliseconds150),
  //                               fadeOutCurve: Curves.easeInOut,
  //                             ),
  //                           ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: AppSize.h10_6.h,
  //                 ),
  //                 Text(
  //                   widget.consultant.name!,
  //                   textAlign: TextAlign.center,
  //                   overflow: TextOverflow.ellipsis,
  //                   maxLines: 1,
  //                   style: TextStyle(
  //                       fontFamily:
  //                           getTranslated(context, "Montserratsemibold"),
  //                       color: AppColors.black,
  //                       fontSize: AppFontsSizeManager.s21_3.sp,
  //                       fontWeight: FontWeight.w400),
  //                 ),
  //                 SizedBox(
  //                   height: AppSize.h21_3.h,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Directionality(
  //                       textDirection: TextDirection.rtl,
  //                       child: Container(
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               widget.consultant.rating.toString(),
  //                               textAlign: TextAlign.start,
  //                               style: TextStyle(
  //                                 color: AppColors.black,
  //                                 fontSize: AppFontsSizeManager.s18_6.sp,
  //                                 fontFamily: getTranslated(
  //                                     context, "Montserratmedium"),
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               width: AppSize.w5_3.w,
  //                             ),
  //                             Icon(
  //                               Icons.star,
  //                               color: Color.fromRGBO(255, 213, 8, 1),
  //                               size: AppSize.w16.w,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: AppSize.w21_3.w,
  //                     ),
  //                     // Directionality(
  //                     //   textDirection: TextDirection.rtl,
  //                     //   child: Container(
  //                     //     child: Row(
  //                     //       mainAxisAlignment: MainAxisAlignment.center,
  //                     //       crossAxisAlignment: CrossAxisAlignment.center,
  //                     //       children: [
  //                     //         Text(
  //                     //           widget.consultant.ordersNumbers.toString() +
  //                     //               " ",
  //                     //           textAlign: TextAlign.start,
  //                     //           style: TextStyle(
  //                     //             color: AppColors.black,
  //                     //             fontSize: AppFontsSizeManager.s18_6.sp,
  //                     //             fontFamily: getTranslated(
  //                     //                 context, "Montserratmedium"),
  //                     //           ),
  //                     //         ),
  //                     //         SizedBox(
  //                     //           width: AppSize.w5_3.w,
  //                     //         ),
  //                     //         SvgPicture.asset(
  //                     //           AssetsManager.whiteSmallCallIconPath,
  //                     //           width: AppSize.w16.w,
  //                     //           height: AppSize.h16.h,
  //                     //           color: AppColors.pink2,
  //                     //           //fit: BoxFit.fill,
  //                     //         ),
  //                     //       ],
  //                     //     ),
  //                     //   ),
  //                     // ),
  //                     // SizedBox(
  //                     //   width: AppSize.w21_3.w,
  //                     // ),
  //                     // Container(
  //                     //   child: Row(
  //                     //     mainAxisAlignment: MainAxisAlignment.center,
  //                     //     crossAxisAlignment: CrossAxisAlignment.center,
  //                     //     children: [
  //                     //       Text(
  //                     //         widget.consultant.price.toString(),
  //                     //         textAlign: TextAlign.start,
  //                     //         style: TextStyle(
  //                     //           color: AppColors.black,
  //                     //           fontSize: AppFontsSizeManager.s18_6.sp,
  //                     //           fontFamily:
  //                     //               getTranslated(context, "Montserratmedium"),
  //                     //         ),
  //                     //       ),
  //                     //       Padding(
  //                     //         padding: EdgeInsets.only(
  //                     //             bottom: lang == "ar" ? AppPadding.p4.h : 0),
  //                     //         child: Text(
  //                     //           "\$",
  //                     //           textAlign: TextAlign.start,
  //                     //           style: GoogleFonts.poppins(
  //                     //             color: AppColors.black,
  //                     //             fontSize: AppFontsSizeManager.s18_6.sp,
  //                     //           ),
  //                     //         ),
  //                     //       ),
  //                     //     ],
  //                     //   ),
  //                     // )
                  
  //                   ],
  //                 ),
  //                 /*Icon(
  //                   Icons.mic_none,
  //                   color: Color.fromRGBO( 205 ,61, 99,1),
  //                   size: 18.0,
  //                 ),
  //                 SizedBox(height: 2,),
  //                 widget.consultant.languages!.length > 1
  //                     ? Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     langWidget(widget.consultant.languages![0]),
  //                     SizedBox(
  //                       width: 20,
  //                     ),
  //                     langWidget(widget.consultant.languages![1])
  //                   ],
  //                 )
  //                     : langWidget(widget.consultant.languages![0]),*/
  //                 SizedBox(
  //                   height: AppSize.h42_6.h,
  //                 ),
  //                 ///ABOUT_ME_WIDGET///
  //                 // AboutMeWidget(
  //                 //   consultant: widget.consultant,
  //                 // ),
  //                 SizedBox(
  //                   height: AppSize.h32.h,
  //                 ),

  //                 // ReviewWidget(consultant: widget.consultant),
  //                 SizedBox(
  //                   height: AppSize.h32.h,
  //                 ),

  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     SvgPicture.asset(
  //                       AssetsManager.goldHeader1IconPath,
  //                       height: AppSize.h21_3.h,
  //                       width: AppSize.w8_3.w,
  //                     ),
  //                     SizedBox(
  //                       width: AppSize.w16.w,
  //                     ),
  //                     Text(
  //                       getTranslated(context, "workTime"),
  //                       style: TextStyle(
  //                         fontFamily:
  //                             getTranslated(context, "Montserratsemibold"),
  //                         color: AppColors.blackColor,
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: AppFontsSizeManager.s21_3.sp,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: AppSize.w16.w,
  //                     ),
  //                     SvgPicture.asset(
  //                       AssetsManager.goldHeader2IconPath,
  //                       height: AppSize.h21_3.h,
  //                       width: AppSize.w8_3.w,
  //                     ),
  //                   ],
  //                 ),
  //                 //days
  //                 Padding(
  //                   padding: EdgeInsets.only(
  //                       left: AppPadding.p56_6.w,
  //                       right: AppPadding.p56_6.w,
  //                       top: AppPadding.p32.h,
  //                       bottom: AppPadding.p50.h),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       SvgPicture.asset(
  //                         AssetsManager.redCalenderIconPath,
  //                         width: convertPtToPx(AppSize.w20.w),
  //                         height: convertPtToPx(AppSize.h20.h),
  //                       ),
  //                       SizedBox(
  //                         width: convertPtToPx(AppSize.w20.w),
  //                       ),
  //                       Expanded(
  //                         child: Wrap(
  //                             alignment: WrapAlignment.start,
  //                             runSpacing: AppSize.w16.w,
  //                             spacing: AppSize.w16.w,
  //                             direction: Axis.horizontal,
  //                             children: [
  //                               for (int x = 0; x < dayListValue.length; x++)
  //                                 daysWidget(dayListValue[x]),
  //                             ]),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 //times
  //                 Padding(
  //                   padding: EdgeInsets.only(
  //                     left: AppPadding.p56_6.w,
  //                     right: AppPadding.p56_6.w,
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       SvgPicture.asset(
  //                         AssetsManager.clockIcon,
  //                         width: AppSize.w26_6.w,
  //                         height: AppSize.h26_6.h,
  //                       ),
  //                       SizedBox(
  //                         width: AppSize.w24.w,
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Text(
  //                                 getTranslated(context, "From"),
  //                                 textAlign: TextAlign.center,
  //                                 style: TextStyle(
  //                                     fontFamily: getTranslated(
  //                                         context, "Montserratsemibold"),
  //                                     color: AppColors.black,
  //                                     fontSize: AppFontsSizeManager.s21_3.sp,
  //                                     fontWeight: FontWeight.w300),
  //                               ),
  //                               SizedBox(
  //                                 width: AppSize.w10_6.w,
  //                               ),
  //                               Container(
  //                                 height: AppSize.h45_3.h,
  //                                 width: AppSize.w138_6.w,
  //                                 decoration: BoxDecoration(
  //                                   image: DecorationImage(
  //                                     image: AssetImage(
  //                                       AssetsManager.timeBody,
  //                                     ),
  //                                     fit: BoxFit.fill,
  //                                   ),
  //                                 ),
  //                                 child: Center(
  //                                   child: Text(
  //                                     from,
  //                                     textAlign: TextAlign.center,
  //                                     style: TextStyle(
  //                                         fontFamily: getTranslated(
  //                                             context, "Montserratsemibold"),
  //                                         color: AppColors.black,
  //                                         fontSize:
  //                                             AppFontsSizeManager.s18_6.sp,
  //                                         fontWeight: FontWeight.w300),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             width: AppSize.w24.w,
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Text(
  //                                 getTranslated(context, "to"),
  //                                 textAlign: TextAlign.center,
  //                                 style: TextStyle(
  //                                     fontFamily: getTranslated(
  //                                         context, "Montserratsemibold"),
  //                                     color: AppColors.black,
  //                                     fontSize: AppFontsSizeManager.s21_3.sp,
  //                                     fontWeight: FontWeight.w300),
  //                               ),
  //                               SizedBox(
  //                                 width: AppSize.w10_6.w,
  //                               ),
  //                               Container(
  //                                 height: AppSize.h45_3.h,
  //                                 width: AppSize.w138_6.w,
  //                                 decoration: BoxDecoration(
  //                                   image: DecorationImage(
  //                                     image: AssetImage(
  //                                       AssetsManager.timeBody,
  //                                     ),
  //                                     fit: BoxFit.fill,
  //                                   ),
  //                                 ),
  //                                 child: Center(
  //                                   child: Text(
  //                                     to,
  //                                     textAlign: TextAlign.center,
  //                                     style: TextStyle(
  //                                         fontFamily: getTranslated(
  //                                             context, "Montserratsemibold"),
  //                                         color: AppColors.black,
  //                                         fontSize:
  //                                             AppFontsSizeManager.s18_6.sp,
  //                                         fontWeight: FontWeight.w300),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(),
  //                     ],
  //                   ),
  //                 ),
  //                 //call
  //                 SizedBox(
  //                   height: AppSize.w42_6.w,
  //                 ),

  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Center(
  //                       child: Image.asset(
  //                         AssetsManager.visaImage,
  //                         width: AppSize.w199_7.w,
  //                         height: AppSize.h147_8.h,
  //                         //fit: BoxFit.fill
  //                       ),
  //                     ),
  //                     Text(
  //                       widget.consultant.price.toString() + "\$",
  //                       style: TextStyle(
  //                           fontFamily:
  //                               getTranslated(context, "Montserratsemibold"),
  //                           color: AppColors.black,
  //                           fontWeight: FontWeight.w500,
  //                           fontSize: AppFontsSizeManager.s29_3.sp),
  //                     ),
  //                     SizedBox(
  //                       height: AppSize.h21_3.h,
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 20, right: 20),
  //                       child: Text(
  //                         getTranslated(context, "bookText"),
  //                         maxLines: 2,
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             fontFamily:
  //                                 getTranslated(context, "Montserratmedium"),
  //                             color: AppColors.darkGrey,
  //                             //fontWeight: FontWeight.w400,
  //                             fontSize: AppFontsSizeManager.s21_3.sp),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: AppSize.h58_8.h,
  //                     ),
  //                   ],
  //                 ),

  //                 load
  //                     ? Center(child: CircularProgressIndicator())
  //                     : Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           SvgPicture.asset(
  //                             AssetsManager.goldFlower3IconPath,
  //                             width: AppSize.w30_1.w,
  //                             height: AppSize.h30_1.h,
  //                           ),
  //                           //pb
  //                           /*SizedBox(
  //                             width: AppSize.w5_3.w,
  //                           ),*/
  //                           TextButton1(
  //                               onPress: () async {
  //                                 if (user == null)
  //                                   Navigator.pushNamed(
  //                                       context, '/Register_Type');
  //                                 else if (user != null && currentNumber == 0)
  //                                   orderPay();
  //                                 else
  //                                   showAddAppointmentDialog(order!.orderId);
  //                               },
  //                               Title: getTranslated(context, "confirm"),
  //                               Width: AppSize.w446_6.w,
  //                               Height: AppSize.h66_6.h,
  //                               ButtonBackground: AppColors.pink2,
  //                               ButtonRadius: AppRadius.r10_6.r,
  //                               TextSize: AppFontsSizeManager.s21_3.sp,
  //                               TextFont: getTranslated(
  //                                   context, "Montserratsemibold"),
  //                               TextColor: AppColors.white),
  //                           /*SizedBox(
  //                             width: AppSize.w5_3.w,
  //                           ),*/
  //                           SvgPicture.asset(
  //                             AssetsManager.goldFlower4IconPath,
  //                             width: AppSize.w30_1.w,
  //                             height: AppSize.h30_1.h,
  //                           ),
  //                         ],
  //                       ),

  //                 SizedBox(
  //                   height: AppSize.h49_3.h,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // orderPay() async {
  //   setState(() {
  //     load = true;
  //   });
  //   if (double.parse(user!.balance.toString()) >= price) {
  //     var newBalance = double.parse(user!.balance.toString()) - price;
  //     await FirebaseFirestore.instance
  //         .collection(Paths.usersPath)
  //         .doc(user!.uid)
  //         .set({
  //       'balance': newBalance,
  //     }, SetOptions(merge: true));
  //     setState(() {
  //       fromBalance = true;
  //       user!.balance = newBalance;
  //     });
  //     updateDatabaseAfterAddingOrder("userBalance");
  //   } else {
  //     setState(() {
  //       fromBalance = false;
  //     });
  //     stripePayment(
  //         email: widget.loggedUser!.phoneNumber! + "@gmail.com",
  //         amount: price * 100,
  //         context: context); //3000
  //   }
  // }

  // Widget headerWidget() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       Container(
  //         width: size.width,
  //         padding:
  //             const EdgeInsets.only(left: 16, right: 16, top: 35, bottom: 5),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //         ),
  //         child: Center(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.max,
  //             children: <Widget>[
  //               IconButton(
  //                 iconSize: 30,
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 icon: Image.asset(
  //                   getTranslated(context, 'back'),
  //                   width: 30,
  //                   height: 30,
  //                 ),
  //               ),
  //               IconButton(
  //                 onPressed: () {
  //                   share(context);
  //                 },
  //                 icon: sharing
  //                     ? Center(child: CircularProgressIndicator())
  //                     : Image.asset(
  //                         'assets/icons/icon/Icon feather-share-3.png',
  //                         width: 20,
  //                         height: 20,
  //                       ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       Container(color: AppColors.white3, height: 1, width: size.width)
  //     ],
  //   );
  // }

  // BoxDecoration decoration() {
  //   return BoxDecoration(
  //     color: AppColors.white,
  //     borderRadius: BorderRadius.circular(8.0),
  //     boxShadow: [
  //       BoxShadow(
  //         color: AppColors.grey,
  //         blurRadius: 2.0,
  //         spreadRadius: 0.0,
  //         offset: Offset(0.0, 1.0), // shadow direction: bottom right
  //       )
  //     ],
  //   );
  // }

  // // Stripe google and apple pay test
  // Future<void> stripePayment(
  //     {required String email,
  //     required double amount,
  //     required BuildContext context}) async {
  //   try {
  //     print("stripePayment1");
  //     email = email.trim().replaceAll(' ', '');
  //     print(email);
  //     // 1. Create a payment intent on the server
  //     final response = await http.post(
  //         Uri.parse(
  //             'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/stripePaymentIntentRequest'),
  //         body: {
  //           'email': email,
  //           'amount': amount.toString(), //"100"
  //         });
  //     print("stripePayment2");
  //     final jsonResponse = jsonDecode(response.body);
  //     print(jsonResponse);
  //     // 2. Initialize the payment sheet
  //     await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //       paymentIntentClientSecret: jsonResponse['paymentIntent'],
  //       customerId: jsonResponse['customer'],
  //       customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
  //       testEnv: false,
  //       applePay: true,
  //       googlePay: true,
  //       merchantDisplayName: "Make My Nikah",
  //       merchantCountryCode: "AE",
  //       style: ThemeMode.dark,
  //       appearance: PaymentSheetAppearance(
  //         /*   colors: PaymentSheetAppearanceColors(
  //               background: Colors.white,
  //               primary: Colors.white,
  //               componentBorder: Colors.black,
  //             ),
  //             shapes: PaymentSheetShape(
  //               borderWidth: 4,
  //               shadow: PaymentSheetShadowParams(color: Colors.white),
  //             ),*/
  //         primaryButton: PaymentSheetPrimaryButtonAppearance(
  //           shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
  //           colors: PaymentSheetPrimaryButtonTheme(
  //             dark: PaymentSheetPrimaryButtonThemeColors(
  //               background: AppColors.reddark2,
  //               text: AppColors.white,
  //               border: Colors.white,
  //             ),
  //             light: PaymentSheetPrimaryButtonThemeColors(
  //               background: AppColors.reddark2,
  //               text: AppColors.white,
  //               border: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ));
  //     print("stripePayment3");
  //     await Stripe.instance.presentPaymentSheet();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Payment is successful'),
  //       ),
  //     );
  //     print("stripePayment4");
  //     updateDatabaseAfterAddingOrder("userBalance");
  //     // print("good");

  //     print("add_payment_info event");
  //     String eventName = "af_add_payment_info";
  //     Map eventValues = {
  //       "af_success": true,
  //       "af_achievement_id": "success",
  //     };
  //     await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
  //       "success": true,
  //       "reason": "success",
  //       "userUid": widget.loggedUser!.uid
  //     });
  //   } catch (error) {
  //     print("stripeerror");
  //     String eventName = "af_add_payment_info";
  //     Map eventValues = {
  //       "af_success": false,
  //       "af_achievement_id": error.toString(),
  //     };
  //     await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
  //       "success": false,
  //       "reason": error.toString(),
  //       "userUid": widget.loggedUser!.uid
  //     });
  //     print(error.toString());
  //     if (error is StripeException) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('An error occured ${error.error.localizedMessage}'),
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('An error occured $error'),
  //         ),
  //       );
  //     }
  //     setState(() {
  //       load = false;
  //     });
  //   }
  // }

  // updateDatabaseAfterAddingOrder(String? payWith) async {
  //   try {
  //     //createOrder
  //     String orderId = Uuid().v4();
  //     DateTime dateValue = DateTime.now();
  //     await FirebaseFirestore.instance
  //         .collection(Paths.ordersPath)
  //         .doc(orderId)
  //         .set({
  //       'orderStatus': 'open',
  //       'orderId': orderId,
  //       'date': {
  //         'day': dateValue.day,
  //         'month': dateValue.month,
  //         'year': dateValue.year,
  //       },
  //       "consultType": type,
  //       'orderTimestamp': Timestamp.now(),
  //       'utcTime': DateTime.now().toUtc().toString(),
  //       'orderTimeValue':
  //           DateTime(dateValue.year, dateValue.month, dateValue.day)
  //               .millisecondsSinceEpoch,
  //       'packageId': "",
  //       'promoCodeId': "",
  //       'remainingCallNum': 1,
  //       'packageCallNum': 1,
  //       'answeredCallNum': 0,
  //       'callPrice': price,
  //       "payWith": payWith,
  //       "platform": Platform.isIOS ? "iOS" : "Android",
  //       'price': price.toString(),
  //       'consult': {
  //         'uid': widget.consultant.uid,
  //         'name': widget.consultant.name,
  //         'image': widget.consultant.photoUrl,
  //         'phone': widget.consultant.phoneNumber,
  //         'countryCode': widget.consultant.countryCode,
  //         'countryISOCode': widget.consultant.countryISOCode,
  //       },
  //       'user': {
  //         'uid': user!.uid,
  //         'name': user!.name,
  //         'image': user!.photoUrl,
  //         'phone': user!.phoneNumber,
  //         'countryCode': user!.countryCode,
  //         'countryISOCode': user!.countryISOCode,
  //       },
  //     });
  //     currentNumber = 1;

  //     print("af_purchase event");
  //     String eventName = "af_purchase";
  //     Map eventValues = {
  //       "af_revenue": price.toString(),
  //       "af_price": price.toString(),
  //       "af_content_id": widget.consultant.uid,
  //       "af_order_id": orderId,
  //       "af_currency": "USD",
  //     };

  //     await FirebaseAnalytics.instance.logPurchase(
  //         currency: "USD",
  //         value: price,
  //         affiliation: widget.consultant.uid,
  //         transactionId: orderId);
  //     //update user order numbers
  //     int userOrdersNumbers = 1;
  //     dynamic payedBalance = double.parse(price.toString());
  //     if (user!.ordersNumbers != null)
  //       userOrdersNumbers = user!.ordersNumbers! + 1;
  //     if (user!.payedBalance != null)
  //       payedBalance = user!.payedBalance + payedBalance;

  //     await FirebaseFirestore.instance
  //         .collection(Paths.usersPath)
  //         .doc(user!.uid)
  //         .set({
  //       'ordersNumbers': userOrdersNumbers,
  //       'payedBalance': payedBalance,
  //       'customerId': " ",
  //       "userConsultIds": user!.userConsultIds! + "," + widget.consultant.uid!,
  //       'preferredPaymentMethod': "stripe"
  //     }, SetOptions(merge: true));
  //     accountBloc.add(GetLoggedUserEvent());
  //     print("callPrice0000111");
  //     print(price);
  //     showAddAppointmentDialog(orderId);
  //   } catch (e) {
  //     errorLog("updateDatabaseAfterAddingOrder", e.toString());
  //   }
  // }

  // Future<void> getNumber() async {
  //   try {
  //     setState(() {
  //       load = true;
  //     });
  //     await FirebaseFirestore.instance
  //         .collection(Paths.ordersPath)
  //         .where(
  //           'user.uid',
  //           isEqualTo: user!.uid,
  //         )
  //         .where(
  //           'consult.uid',
  //           isEqualTo: widget.consultant.uid,
  //         )
  //         .where('orderStatus', isEqualTo: 'open')
  //         .get()
  //         .then((value) async {
  //       if (value.docs.length > 0) {
  //         var order2 = Orders.fromMap(value.docs[0].data() as Map);
  //         setState(() {
  //           order = order2;
  //         });
  //         await FirebaseFirestore.instance
  //             .collection(Paths.appAppointments)
  //             .where(
  //               'orderId',
  //               isEqualTo: order!.orderId,
  //             )
  //             .get()
  //             .then((value) async {
  //           if (value.docs.length > 0) {
  //             setState(() {
  //               currentNumber = order!.packageCallNum - value.docs.length;
  //             });
  //           } else {
  //             setState(() {
  //               currentNumber = order!.packageCallNum;
  //             });
  //           }
  //         }).catchError((err) {
  //           errorLog("getNumber1", err.toString());
  //           setState(() {
  //             load = false;
  //           });
  //         });
  //       } else {
  //         setState(() {
  //           currentNumber = 0;
  //           order = null;
  //         });
  //       }
  //       setState(() {
  //         load = false;
  //       });
  //     }).catchError((err) {
  //       errorLog("getNumber", err.toString());
  //       setState(() {
  //         load = false;
  //       });
  //     });
  //   } catch (e) {
  //     errorLog("getNumber", e.toString());
  //     setState(() {
  //       load = false;
  //       currentNumber = 0;
  //       order = null;
  //     });
  //   }
  // }

  // showAddAppointmentDialog(String _orderId) async {
  //   bool isProceeded = await showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return AddAppointmentDialog(
  //           loggedUser: user!,
  //           consultant: widget.consultant,
  //           localFrom: localFrom,
  //           localTo: localTo,
  //           type: type!,
  //           orderId: _orderId,
  //           callPrice: price);
  //     },
  //   );

  //   if (isProceeded != null) {
  //     if (isProceeded) {
  //       print("allah");
  //       setState(() {
  //         load = false;
  //       });
  //     }
  //   }
  // }

  // cleanConsultDays() async {
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection(Paths.consultDaysPath)
  //         .where('date',
  //             isLessThan: DateTime(DateTime.now().year, DateTime.now().month,
  //                     DateTime.now().day)
  //                 .millisecondsSinceEpoch)
  //         .where('consultUid', isEqualTo: widget.consultant.uid)
  //         .get();
  //     for (var doc in querySnapshot.docs) {
  //       await FirebaseFirestore.instance
  //           .collection(Paths.consultDaysPath)
  //           .doc(doc.id)
  //           .delete();
  //     }
  //   } catch (e) {
  //     print("hhhhhh" + e.toString());
  //   }
  // }

  // share(BuildContext context) async {
  //   setState(() {
  //     sharing = true;
  //   });
  //   String uid = widget.consultant.uid!;
  //   // Create DynamicLink
  //   print("share1");
  //   print("https://makemynikahapp\.page\.link/.*coach_id=" + uid);
  //   final dynamicLinkParams = DynamicLinkParameters(
  //     link: Uri.parse("https://makemynikahapp\.page\.link/coach_id=" + uid),
  //     uriPrefix: "https://makemynikahapp\.page\.link",
  //     androidParameters:
  //         const AndroidParameters(packageName: "com.app.MakeMyNikah"),
  //     iosParameters: const IOSParameters(
  //         bundleId: "com.app.MakeMyNikahApp", appStoreId: "1668556326"),
  //   );
  //   ShortDynamicLink dynamicLink =
  //       await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

  //   File file;
  //   if (widget.consultant.photoUrl!.isEmpty) {
  //     print("share5");
  //     final bytes =
  //         await rootBundle.load('assets/icons/icon/Mask Group 47.png');
  //     final list = bytes.buffer.asUint8List();
  //     final tempDir = await getTemporaryDirectory();
  //     file = await File('${tempDir.path}/image.jpg').create();
  //     file.writeAsBytesSync(list);
  //     print("share6");
  //   } else {
  //     final directory = await getTemporaryDirectory();
  //     final path = directory.path;
  //     final response = await http.get(Uri.parse(widget.consultant.photoUrl!));
  //     file =
  //         await File('$path/image_${DateTime.now().millisecondsSinceEpoch}.png')
  //             .writeAsBytes(response.bodyBytes);
  //   }
  //   String text =
  //       "${widget.consultant.name} \n I think that he is a good coach \n ${dynamicLink.shortUrl.toString()}";
  //   Share.shareFiles(["${file.path}"], text: text);
  //   setState(() {
  //     sharing = false;
  //   });
  // }

  // Widget daysWidget(String day) {
  //   return Container(
  //     width: 58.0.w,
  //     height: 60.h,
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         image: AssetImage(
  //           AssetsManager.roundHeader1IconPath,
  //         ),
  //         fit: BoxFit.fill,
  //       ),
  //     ),
  //     child: Center(
  //       child: Text(
  //         day,
  //         textAlign: TextAlign.center,
  //         overflow: TextOverflow.ellipsis,
  //         maxLines: 1,
  //         style: TextStyle(
  //           fontFamily: getTranslated(context, "Montserratmedium"),
  //           color: AppColors.black,
  //           fontWeight: FontWeight.w300,
  //           fontSize: convertPtToPx(AppFontsSizeManager.s12.sp),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget langWidget(String langText) {
  //   return Text(
  //     getTranslated(context, langText),
  //     textAlign: TextAlign.center,
  //     style: TextStyle(
  //       fontFamily: getTranslated(context, "fontFamily"),
  //       color: Color.fromRGBO(158, 158, 158, 1),
  //       fontSize: 11.0,
  //     ),
  //   );
  // }
// }

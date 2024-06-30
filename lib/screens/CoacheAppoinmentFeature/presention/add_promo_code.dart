// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:grocery_store/widget/custom_back_button.dart';

// import 'package:uuid/uuid.dart';
// import 'package:grocery_store/config/app_values.dart';
// import 'package:grocery_store/config/colorsFile.dart';
// import 'package:grocery_store/config/paths.dart';
// import 'package:grocery_store/models/user.dart';
// import 'package:grocery_store/widget/resopnsive.dart';
// import '../../../config/app_constat.dart';
// import '../../../config/app_fonts.dart';
// import '../../../localization/localization_methods.dart';

// class AddPromoCodeScreen extends StatefulWidget {
//   const AddPromoCodeScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _AddPromoCodeScreenState createState() => _AddPromoCodeScreenState();
// }

// class _AddPromoCodeScreenState extends State<AddPromoCodeScreen> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String? owner, code, discount, usedNumber, id, theme = "light";
//   late bool isAdding, activeCode = false;
//   String? dropdownLangValue;
//   List<KeyValueModel> _langArray = [
//     KeyValueModel(key: "primary", value: "primary"),
//     KeyValueModel(key: "default", value: "default"),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     isAdding = false;
//   }

//   addCategory() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       setState(() {
//         isAdding = true;
//       });
//       String id = Uuid().v4();
//       await FirebaseFirestore.instance.collection(Paths.promoPath).doc(id).set({
//         'discount': int.parse(discount!),
//         'code': code,
//         'ownerName': owner,
//         'usedNumber': 0,
//         'promoCodeId': id,
//         'promoCodeStatus': activeCode,
//         'promoCodeTimestamp': Timestamp.now(),
//         'type': dropdownLangValue == null ? "default" : dropdownLangValue
//       }, SetOptions(merge: true));
//       if (activeCode) {
//         if (activeCode == true)
//           await FirebaseFirestore.instance
//               .collection(Paths.appAnalysisPath)
//               .doc("TgWCp3B22sbkl0Nm3wLx")
//               .set({
//             'activePromoCodes': FieldValue.increment(1),
//           }, SetOptions(merge: true));
//         else
//           await FirebaseFirestore.instance
//               .collection(Paths.appAnalysisPath)
//               .doc("TgWCp3B22sbkl0Nm3wLx")
//               .set({
//             'notActivePromoCodes': FieldValue.increment(1),
//           }, SetOptions(merge: true));
//       }

//       setState(() {
//         isAdding = false;
//       });
//       Navigator.pop(context);
//     } else {
//       showSnack('Please fill all the details!', context);
//     }
//   }

//   void showSnack(String text, BuildContext context) {
//     Fluttertoast.showToast(
//         msg: text,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.TOP,
//         backgroundColor: AppColors.red,
//         textColor: AppColors.white,
//         fontSize: AppFontsSizeManager.s16);
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     const _chars =
//         'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
//     Random _rnd = Random();

//     String getRandomString(int length) =>
//         String.fromCharCodes(Iterable.generate(
//             length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
//     return Scaffold(
//       key: _scaffoldKey,
//       body: Column(
//         children: <Widget>[
//           Container(
//               width: size.width,
//               child: SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: AppPadding.p20,
//                       right: AppPadding.p20,
//                       top: AppPadding.p10,
//                       bottom: AppPadding.p10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       CustomBackButton(),
//                       const SizedBox(width: AppSize.w10),
//                       Text(
//                         "addPromo",
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                           fontWeight:AppFontsWeightManager.bold300,
//                           fontFamily: getTranslated(context, "Ithra"),
//                           fontStyle: FontStyle.normal,
//                           fontSize:
//                               false ? AppFontsSizeManager.s31.sp : AppFontsSizeManager.s15.sp,
//                           color: AppColors.black2,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.only(
//                   left: false ? size.width * AppPadding.p0_3 : AppPadding.p16,
//                   right: false ? size.width * AppPadding.p0_3 : AppPadding.p16,
//                   bottom: AppPadding.p16,
//                   top: AppPadding.p16),
//               children: <Widget>[
//                 SizedBox(
//                   height: AppSize.h20,
//                 ),
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       TextFormField(
//                         textAlignVertical: TextAlignVertical.center,
//                         initialValue: getRandomString(5),
//                         /* validator: (String val) {
//                           if (val.trim().isEmpty) {
//                             return getTranslated(context, "required");
//                           }
//                           return null;
//                         },*/
//                         onSaved: (val) {
//                           code = val!;
//                         },
//                         enableInteractiveSelection: true,
//                         style: GoogleFonts.poppins(
//                           color: AppColors.black,
//                           fontSize: AppFontsSizeManager.s14_5,
//                           fontWeight: AppFontsWeightManager.bold500,
//                           letterSpacing: AppConstants.letterSpacing0_5,
//                         ),
//                         readOnly: true,
//                         textInputAction: TextInputAction.done,
//                         keyboardType: TextInputType.text,
//                         textCapitalization: TextCapitalization.words,
//                         decoration: InputDecoration(
//                           contentPadding:
//                               EdgeInsets.symmetric(horizontal: AppPadding.p15),
//                           helperStyle: GoogleFonts.poppins(
//                              color: AppColors.black.withOpacity(0.65),
//                              fontWeight: AppFontsWeightManager.bold500,
//                             letterSpacing: AppConstants.letterSpacing0_5,
//                           ),
//                           errorStyle: GoogleFonts.poppins(
//                             fontSize: AppFontsSizeManager.s13,
//                              fontWeight: AppFontsWeightManager.bold500,
//                             letterSpacing: AppConstants.letterSpacing0_5,
//                           ),
//                           hintStyle: GoogleFonts.poppins(
//                            color: AppColors.black4,
//                             fontSize: AppFontsSizeManager.s14_5,
//                              fontWeight: AppFontsWeightManager.bold500,
//                             letterSpacing: AppConstants.letterSpacing0_5,
//                           ),
//                           labelText: "promoCodes",
//                           labelStyle: GoogleFonts.poppins(
//                             fontSize: AppFontsSizeManager.s14_5,
//                              fontWeight: AppFontsWeightManager.bold500,
//                             letterSpacing: AppConstants.letterSpacing0_5,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(AppRadius.r12),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: AppSize.h15,
//                       ),
//                       TextFormField(
//                         textAlignVertical: TextAlignVertical.center,
//                         initialValue: owner,
//                         validator: (String? val) {
//                           if (val!.trim().isEmpty) {
//                             return getTranslated(context, "required");
//                           }
//                           return null;
//                         },
//                         onSaved: (val) {
//                           owner = val!;
//                         },
//                         enableInteractiveSelection: true,
//                         style: GoogleFonts.poppins(
//                            color: AppColors.black,
//                           fontSize: AppFontsSizeManager.s14_5,
//                            fontWeight: AppFontsWeightManager.bold500,
//                           letterSpacing: AppConstants.letterSpacing0_5,
//                         ),
//                         textInputAction: TextInputAction.done,
//                         keyboardType: TextInputType.text,
//                         textCapitalization: TextCapitalization.words,
//                         decoration: InputDecoration(
//                           contentPadding:
//                               EdgeInsets.symmetric(horizontal: AppPadding.p15),
//                           helperStyle: GoogleFonts.poppins(
//                              color: AppColors.black.withOpacity(0.65),
//                              fontWeight: AppFontsWeightManager.bold500,
//                             letterSpacing: AppConstants.letterSpacing0_5,
//                           ),
//                           errorStyle: GoogleFonts.poppins(
//                             fontSize: AppFontsSizeManager.s13,
//                              fontWeight: AppFontsWeightManager.bold500,
//                             letterSpacing: AppConstants.letterSpacing0_5,
//                           ),
//                           hintStyle: GoogleFonts.poppins(
//                            color: AppColors.black4,
//                             fontSize: AppFontsSizeManager.s14_5,
//                              fontWeight: AppFontsWeightManager.bold500,
//                             letterSpacing: AppConstants.letterSpacing0_5,
//                           ),
//                           labelText: getTranslated(context, "owner"),
//                           labelStyle: GoogleFonts.poppins(
//                             fontSize: AppFontsSizeManager.s14_5,
//                              fontWeight: AppFontsWeightManager.bold500,
//                             letterSpacing: AppConstants.letterSpacing0_5,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(AppRadius.r12),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: AppSize.h15,
//                       ),
//                       TextFormField(
//                         textAlignVertical: TextAlignVertical.center,
//                         initialValue: discount,
//                         validator: (String? val) {
//                           if (val!.trim().isEmpty) {
//                             return getTranslated(context, "required");
//                           }
//                           return null;
//                         },
//                         onSaved: (val) {
//                           discount = val!;
//                         },
//                         enableInteractiveSelection: true,
//                         style: GoogleFonts.poppins(
//                            color: AppColors.black,
//                           fontSize: AppFontsSizeManager.s14_5,
//                            fontWeight: AppFontsWeightManager.bold500,
//                           letterSpacing: AppConstants.letterSpacing0_5,
//                         ),
//                         textInputAction: TextInputAction.done,
//                         keyboardType: TextInputType.number,
//                         textCapitalization: TextCapitalization.words,
//                         decoration: InputDecoration(
//                           contentPadding:
//                               EdgeInsets.symmetric(horizontal: AppPadding.p15),
//                           helperStyle: GoogleFonts.poppins(
//                              color: AppColors.black.withOpacity(0.65),
//                              fontWeight: AppFontsWeightManager.bold500,
//                             letterSpacing: AppConstants.letterSpacing0_5,
//                           ),
//                           errorStyle: GoogleFonts.poppins(
//                             fontSize: AppFontsSizeManager.s13,
//                              fontWeight: AppFontsWeightManager.bold500,
//                             letterSpacing: AppConstants.letterSpacing0_5,
//                           ),
//                           hintStyle: GoogleFonts.poppins(
//                            color: AppColors.black4,
//                             fontSize: AppFontsSizeManager.s14_5,
//                              fontWeight: AppFontsWeightManager.bold500,
//                             letterSpacing: AppConstants.letterSpacing0_5,
//                           ),
//                           labelText: "discount",
//                           labelStyle: GoogleFonts.poppins(
//                             fontSize: AppFontsSizeManager.s14_5,
//                              fontWeight: AppFontsWeightManager.bold500,
//                             letterSpacing: AppConstants.letterSpacing0_5,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(AppRadius.r12),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: AppSize.h15,
//                       ),
//                       Container(
//                           height: AppSize.h50,
//                           decoration: BoxDecoration(
//                               color: theme == "light"
//                                   ? AppColors.white
//                                   : Colors.transparent,
//                               border: Border.all(
//                                 color: AppColors.grey,
//                               ),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(AppRadius.r10))),
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: AppPadding.p10, right: AppPadding.p10),
//                             child: DropdownButton<String>(
//                               hint: Text(
//                                 "type",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontFamily: getTranslated(context, "Ithra"),
//                                   // color: AppColors.black,
//                                   fontSize: AppFontsSizeManager.s15,
//                                   letterSpacing: AppConstants.letterSpacing0_5,
//                                 ),
//                               ),
//                               underline: Container(),
//                               isExpanded: true,
//                               value: dropdownLangValue,
//                               icon: Icon(Icons.keyboard_arrow_down,
//                                    color: AppColors.black),
//                               iconSize: AppSize.w24,
//                               elevation: 16,
//                               style: TextStyle(
//                                 fontFamily: getTranslated(context, "Ithra"),
//                                 color: AppColors.blue,
//                                 fontSize: AppFontsSizeManager.s13,
//                                 letterSpacing: AppConstants.letterSpacing0_5,
//                               ),
//                               items: _langArray
//                                   .map((data) => DropdownMenuItem<String>(
//                                       child: Text(
//                                         data.value.toString(),
//                                         style: TextStyle(
//                                           fontFamily:
//                                               getTranslated(context, "Ithra"),
//                                            color: AppColors.black,
//                                           fontSize: AppFontsSizeManager.s15,
//                                           letterSpacing: AppConstants.letterSpacing0_5,
//                                         ),
//                                       ),
//                                       value: data.key.toString() //data.key,
//                                       ))
//                                   .toList(),
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   dropdownLangValue = value!;
//                                 });
//                               },
//                             ),
//                           )),
//                       SizedBox(
//                         height: AppSize.h15,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: AppPadding.p10, right: AppPadding.p10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               getTranslated(context, "active"),
//                               style: TextStyle(
//                                 fontFamily: getTranslated(context, "Ithra"),
//                                 color: Theme.of(context).primaryColor,
//                                 fontSize: AppFontsSizeManager.s15,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing:AppConstants.letterSpacing0_3,
//                               ),
//                             ),
//                             Switch(
//                               value: activeCode,
//                               onChanged: (value) {
//                                 setState(() {
//                                   activeCode = value;
//                                 });
//                               },
//                               activeTrackColor: AppColors.green,
//                               activeColor: AppColors.red,
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: AppSize.h15,
//                       ),
//                       isAdding
//                           ? Center(child: CircularProgressIndicator())
//                           : Center(
//                               child: Container(
//                                 height: AppSize.h45,
//                                 width: false
//                                     ? size.width * AppSize.w0_15
//                                     : double.infinity,
//                                 child: MaterialButton(
//                                   onPressed: () {
//                                     addCategory();
//                                   },
//                                   color: Theme.of(context).primaryColor,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(AppRadius.r15.r),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       FaIcon(
//                                         FontAwesomeIcons.atom,
//                                         color: theme == "light"
//                                             ?AppColors.white
//                                             : Colors.black,
//                                         size: AppSize.w20,
//                                       ),
//                                       SizedBox(
//                                         width: AppSize.w10,
//                                       ),
//                                       Text(
//                                         getTranslated(context, "save"),
//                                         style: GoogleFonts.poppins(
//                                           color: theme == "light"
//                                               ? Colors.white
//                                               : Colors.black,
//                                           fontSize: AppFontsSizeManager.s15,
//                                           fontWeight: AppFontsWeightManager.semiBold,
//                                           letterSpacing: AppConstants.letterSpacing0_3,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                       SizedBox(
//                         height: AppSize.h15,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

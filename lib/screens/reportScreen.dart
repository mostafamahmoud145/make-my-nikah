

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/app_bar_widget.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/text_form_field_widget.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:uuid/uuid.dart';

import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';

class ReportScreen extends StatefulWidget {
  final GroceryUser user;
  final String appointmentId;
  final GroceryUser consult;

  const ReportScreen({Key? key,required this.user, required this.consult,required this.appointmentId}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

   int? groupval;
  bool showTextform = false;
  late String reportReason;
  bool other=false;
  final TextEditingController description = TextEditingController();
  String lang = "";
appointmentDialog(Size size) {
    return showDialog(
      builder: (context) => NikahDialogWidget(
        padButtom: AppPadding.p45_3.h,
        padLeft: AppPadding.p18_6.w,
        padReight: AppPadding.p18_6.w,
        padTop:AppPadding.p44_6.h,
        radius: AppRadius.r21_3.r,
        dialogContent: Container(
          width:AppSize.w416.w,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                getTranslated(context, "reportSend2"),
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: getTranslated(context,"Montserratmedium"),
                  fontSize: AppFontsSizeManager.s26_6.sp,
                  fontWeight:lang=="ar"? AppFontsWeightManager.semiBold:null,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: AppSize.h32.h,
              ),
          
              Center(
                child: Container(
                  width: AppSize.w261_3.w,
                  height: AppSize.h61_3.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
                     color: AppColors.pink2
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      getTranslated(context, 'continue'),
                      style: TextStyle(fontFamily:
                       getTranslated(context,"Montserratsemibold"),
                        color: Colors.white,
                        fontSize: AppFontsSizeManager.s21_3.sp,
                        fontWeight:lang=="ar"? AppFontsWeightManager.semiBold:null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ), barrierDismissible: false,
      context: context,
    );
  }

  // appointmentDialog(Size size) {
  //   return showDialog(
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(15.0),
  //         ),
  //       ),
  //       elevation: 5.0,
  //       contentPadding: const EdgeInsets.only(
  //           left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
  //       content: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           Center(
  //               child: Container(height: 70,width: 70,
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     // color: Colors.white,
  //                   ),
  //                   child: Image.asset('assets/icons/icon/Union.png', fit:BoxFit.contain,height: 70,width: 90)

  //               )
  //           ),
  //           SizedBox(
  //             height: 15.0,
  //           ),
  //           Text(
  //             getTranslated(context, "reportSend"),
  //             textAlign: TextAlign.center,
  //             style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
  //               fontSize: 11.0,
  //               fontWeight: FontWeight.w300,
  //               color: AppColors.black,
  //             ),
  //           ),
  //           SizedBox(
  //             height: 5.0,
  //           ),

  //           Center(
  //             child: Container(
  //               width: size.width*.4,height: 45,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(5.0),
  //                   gradient: LinearGradient(
  //                     begin: Alignment.centerLeft,
  //                     end: Alignment.centerRight,
  //                     colors: [
  //                       AppColors.reddark2,
  //                       AppColors.brown
  //                     ],
  //                   )
  //               ),
  //               child: MaterialButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text(
  //                   getTranslated(context, 'Ok'),
  //                   style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
  //                     color: Colors.white,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 10.0,
  //           ),
  //         ],
  //       ),
  //     ), barrierDismissible: false,
  //     context: context,
  //   );
  // }
   Future<void> addReport()async {
     String reportId = widget.appointmentId;//Uuid().v4();
     await FirebaseFirestore.instance.collection(Paths.complaintsPath).doc(reportId).set({
       'appointmentId': widget.appointmentId,
       'complaintTime': Timestamp.now(),
       'complaints': reportReason,
       "other":other,
       'consultName': widget.consult.name,
       'consultPhone': widget.consult.phoneNumber,
       'consultUid': widget.consult.uid,
       'id': reportId,
       'name': widget.user.name,
       'openingStatus':widget.appointmentId,
       'phone':widget.user.phoneNumber,
       'status': "new",
       'uid': widget.user.uid,
     }, SetOptions(merge: true)
     ).then((value)
     {
       appointmentDialog(MediaQuery.of(context).size);
     });
   }


  @override
  Widget build(BuildContext context) {
print("kkkkk1111111111");
    Size size = MediaQuery.of(context).size;
    lang= getTranslated(context, "lang");

    return Scaffold(
      backgroundColor: Colors.white,
      body:  Column(
          children: [
               Container(
                width: size.width,
                child: SafeArea(
                    child: Padding( padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                      child: AppBarWidget2(
                        text: getTranslated(context, "report"),
                      ),
                    ))),
               Container( color: AppColors.white3, height: convertPtToPx(AppSize.h1.h), width: size.width),
               SizedBox(height: AppSize.h42_6.h,),
               Expanded(
                 child: ListView(padding: EdgeInsets.symmetric(horizontal:AppSize.w32.w),
                     children: [
                    /*showTextform==false ?
                         Padding(padding: EdgeInsets.symmetric(horizontal: 40),child:
                         Column(
                          children: [
                            Row(
                              children: [
                                Text(getTranslated(context,"reportreason"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: getTranslated(context, "fontFamily"),
                                    fontSize: 12,
                                    color: AppColors.grey2,
                                  ),),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RadioButton(description: "", value: 1, activeColor: AppColors.reddark2,groupValue: groupval, onChanged: (value){
                                  setState(() {
                                    groupval = value!;
                                    reportReason = "reason1";
                                    other=false;
                                  });
                                }),
                                Flexible(
                                  child: Text(getTranslated(context, "reason1"),
                                      maxLines:3,
                                      softWrap: true,style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 11,
                                      fontFamily: getTranslated(context, "fontFamily")
                                  )),
                                ),

                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RadioButton(description: "", value: 2, activeColor: AppColors.reddark2, groupValue: groupval, onChanged: (value){
                                  setState(() {
                                    groupval = value!;
                                    reportReason = "reason2";
                                    other=false;
                                  });
                                }),
                                Flexible(
                                  child: Text(getTranslated(context, "reason2"),
                                      maxLines:3,
                                      softWrap: true,style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 11,
                                    fontFamily: getTranslated(context, "fontFamily")
                                ))),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RadioButton(
                                    description: "", value: 3, groupValue: groupval,
                                    activeColor: AppColors.reddark2,onChanged: (value){
                                  setState(() {
                                    groupval = value!;
                                    reportReason = "reason3";
                                    other=false;
                                  });
                                }),
                                Flexible(
                                    child: Text(getTranslated(context, "reason3"),
                                        maxLines:3,
                                        softWrap: true,style: TextStyle(
                                            color: AppColors.black,
                                            fontSize: 11,
                                            fontFamily: getTranslated(context, "fontFamily")
                                        ))),


                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RadioButton(description: "", value: 4, activeColor: AppColors.reddark2, groupValue: groupval, onChanged: (value){
                                  setState(() {
                                    groupval = value!;
                                    reportReason = "reason4";
                                    other=false;

                                  });
                                }),
                                Flexible(
                                    child: Text(getTranslated(context, "reason4"),
                                        maxLines:3,
                                        softWrap: true,style: TextStyle(
                                            color: AppColors.black,
                                            fontSize: 11,
                                            fontFamily: getTranslated(context, "fontFamily")
                                        ))),


                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated(context, "other"),style: TextStyle(color: AppColors.black,fontFamily: getTranslated(context, "fontFamily"),fontSize: 13),),
                                InkWell(
                                  child: Image.asset("assets/icons/icon/Group2890.png",width: 20,height: 20,),
                                  onTap: ()
                                  {
                                      setState(() {
                                        showTextform = true;
                                      });
                                  },
                                ),

                              ],
                            ),
                          ],
                        ),
                         ):*/
                       Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(getTranslated(context, "reportdescription"),
                               textAlign:TextAlign.start,style: TextStyle(
                               fontFamily: getTranslated(context, "Montserrat-SemiBold"),
                               fontSize: AppFontsSizeManager.s21_3.sp,fontWeight: FontWeight.w500,
                               color: AppColors.balck2
                             ),),
                             SizedBox(height: AppSize.h32.h,),
                             Container(
                               height: AppSize.h360.h,
                               decoration: BoxDecoration(
                                 border: Border.all(
                                   color: AppColors.lightGrey6
                                 ),
                                 borderRadius: BorderRadius.circular(convertPtToPx(AppRadius.r8.r))
                               ),
                               padding: EdgeInsets.all(AppPadding.p21_3.r),
                               child: TextFormFieldWidget(

                                 maxLine: 15,
                                 maxLength: 350,
                                 controller: description,
                                 onchange: (value)
                                 {
                                   setState(() {
                                     reportReason = value;
                                     other=true;
                                   });
                                 },
                                 hintStyle: TextStyle(fontSize: AppFontsSizeManager.s18_6.sp,
                                 fontFamily: getTranslated(context,"Montserrat-Regular"),
                                   color: AppColors.grey3,
                                   fontWeight: FontWeight.w400,
                                 ),
                                 hint: getTranslated(context,'reporthint'),
                                 borderColor: AppColors.white,
                                 style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),fontSize: AppFontsSizeManager.s18_6.sp,
                                   color:AppColors.grey,
                                 ),
                                 cursorColor: Colors.black,
                                 textInputType: TextInputType.multiline,
                               ),
                             ),
                           ],
                         ),
                       SizedBox(height: AppSize.h64.h,),
                       Center(
                         child: Text(getTranslated(context, "applicationtext"),
                           textAlign: TextAlign.start,
                           style: TextStyle(
                               color: AppColors.lightGrey7,
                               fontSize: AppFontsSizeManager.s16.sp,
                               fontFamily: 'Inter-Medium'
                           ),),
                       ),
                       SizedBox(height: AppSize.h64.h,),
                       Container(
                         width: AppSize.w446_6.w,
                         height: AppSize.h66_6.h,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                           color: AppColors.reddark2
                         ),
                         child: MaterialButton(
                           onPressed: ()async{
                            await addReport();
                           },
                           child: Text(getTranslated(context, "senD"),style: TextStyle(
                               color: AppColors.white,
                               fontSize: AppFontsSizeManager.s21_3.sp,
                               fontFamily: getTranslated(context, "Montserrat-SemiBold")
                           )),
                         ),
                       )
                     ],
                   ),
               )
          ],
        ),
    );
  }
}

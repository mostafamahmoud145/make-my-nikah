import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:uuid/uuid.dart';
import '../../../config/app_constat.dart';
import '../../../config/assets_manager.dart';
import '../../../config/colorsFile.dart';
import '../../../config/paths.dart';
import '../../../localization/localization_methods.dart';
import '../../../models/user.dart';

class ReviewEndCallDialog extends StatefulWidget {
  final GroceryUser user;

  ReviewEndCallDialog({
    required this.user,
  });

  @override
  _ReviewEndCallDialogState createState() => _ReviewEndCallDialogState();
}

class _ReviewEndCallDialogState extends State<ReviewEndCallDialog> {
  bool endingCall = false, done = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 5.0,
      surfaceTintColor: AppColors.white,
      contentPadding: EdgeInsets.all(0),
      content: StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w,vertical: 26.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(

                    onTap: () {

                      Navigator.pop(context);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (route) => false);

                    }, child: Icon(
                  Icons.close,

                  size: 28.r,
                )),
              ),
              Container(


                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                //borderRadius: BorderRadius.circular(80.0),
                child: SvgPicture.asset(
                  AssetsManager.mask_groupImagePath,
                  color: AppColors.pink2,
                  width: 63.r,
                  height: 63.r,
                ),
              ),

              Padding(
                padding:  EdgeInsets.symmetric(vertical: 12.h,horizontal: 7.w),
                child: Text(
                  getTranslated(context, "doesCallEndWithClient"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: getTranslated(context, "NotoKufiArabic-SemiBold"),
                    fontSize: 20.0,

                    fontWeight: FontWeight.w600,
                    color: AppColors.black1,
                  ),
                ),
              ),

            ],
          ),
        );
      }),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[ endingCall
              ? Center(child: CircularProgressIndicator())
              : Container(
            width: 120.w,height: 42.h,
            decoration: BoxDecoration(
              color: AppColors.cherry,
              borderRadius: BorderRadius.all(
                  Radius.circular(8.r)
              ),

            ),
            child: MaterialButton(
              padding: const EdgeInsets.all(0.0),
              onPressed: () {
                setState(() {
                  endingCall = true;
                });
                callDone(context);

                /* Navigator.pop(context);
                                  confirmEndCallDialog(size, context);*/
              },
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 9.h,horizontal: 16.w),
                child: Text(
                  getTranslated(context, 'yes'),
                  style: TextStyle(

                    fontFamily: getTranslated(context, "NotoKufiArabic-SemiBold"),
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
            Container(
              width: 120.w,height: 42.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(8.r)
                ),
                border: Border.all(
                    color: AppColors.cherry,
                    width: 1
                ),),
              child: MaterialButton(
                padding: const EdgeInsets.all(0.0),

                onPressed: ()  {


                  Navigator.pop(context);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home', (route) => false);

                },
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 9.h,horizontal: 16.w),
                  child: Text(
                    getTranslated(context, 'no'),
                    style: TextStyle(
                      fontFamily: getTranslated(context, "NotoKufiArabic-SemiBold"),
                      color: AppColors.black1,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),

      ],
    );
  }

  //-----------
  // confirmEndCallDialog(Size size, BuildContext context) {
  //   return showDialog(
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(15.0),
  //         ),
  //       ),
  //       elevation: 5.0,
  //       contentPadding: const EdgeInsets.only(
  //           left: AppPadding.p16, right: AppPadding.p16, top: 20.0, bottom: 10.0),
  //       content: StatefulBuilder(
  //         builder: (context, setState) {
  //           return Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               SizedBox(
  //                 height: 15.0,
  //               ),
  //               Text(
  //                 getTranslated(context, "areYouSureCloseAppointment"),
  //                 style: TextStyle(
  //                   fontFamily: getTranslated(context, "Ithra"),
  //                   fontSize: 14.0,
  //                   fontWeight: FontWeight.bold,
  //                   color: AppColors.pink,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10.0,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisSize: MainAxisSize.max,
  //                 children: <Widget>[
  //                   InkWell(
  //                     onTap: () async {
  //                       await FirebaseFirestore.instance
  //                           .collection(Paths.appAppointments)
  //                           .doc(widget.appointment.appointmentId)
  //                           .set({
  //                         'allowCall': false,
  //                       }, SetOptions(merge: true));
  //                       Navigator.pop(context);
  //                       //Navigator.pop(context);
  //                       Navigator.pushNamedAndRemoveUntil(
  //                         context,
  //                         '/home',
  //                         (route) => false,
  //                       );
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
  //                           getTranslated(context, "no"),
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               fontFamily:
  //                                   getTranslated(context, "Ithra"),
  //                               color: AppColors.pink,
  //                               fontSize: 11.0,
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   endingCall
  //                       ? Center(child: CircularProgressIndicator())
  //                       : InkWell(
  //                           onTap: () async {
  //                             setState(() {
  //                               endingCall = true;
  //                             });
  //                             callDone(context);
  //                           },
  //                           child: Container(
  //                             height: 35,
  //                             width: 50,
  //                             padding: const EdgeInsets.all(2),
  //                             decoration: BoxDecoration(
  //                               color: AppColors.pink,
  //                               borderRadius: BorderRadius.circular(10.0),
  //                             ),
  //                             child: Center(
  //                               child: Text(
  //                                 getTranslated(context, "yes"),
  //                                 textAlign: TextAlign.center,
  //                                 style: TextStyle(
  //                                   fontFamily:
  //                                       getTranslated(context, "Ithra"),
  //                                   color: AppColors.white,
  //                                   fontSize: 11.0,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                 ],
  //               ),
  //             ],
  //           );
  //         },
  //       ),
  //     ),
  //     barrierDismissible: false,
  //     context: context,
  //   );
  // }

  Future<void> callDone(BuildContext context) async {
    try {
      //update appointment
      var answeredCallNum = 0, packageCallNum = 0, remainingCall = 0;
      var dateNow = DateTime.now();
      if (done &&
          widget.user != null &&
          widget.user.userType == AppConstants.consultant) {
        await FirebaseFirestore.instance
            .collection(Paths.usersPath)
            .doc(widget.user.uid)
            .set({
          'accountStatus': 'Active',
        }, SetOptions(merge: true));
      }
      setState(() {
        done = false;
      });
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      errorLog("callDone", e.toString());
    }
  }

  errorLog(String function, String error) async {
    String id = Uuid().v4();
    await FirebaseFirestore.instance
        .collection(Paths.errorLogPath)
        .doc(id)
        .set({
      'timestamp': Timestamp.now(),
      'id': id,
      'seen': false,
      'desc': error,
      'phone': widget.user == null ? " " : widget.user.phoneNumber,
      'screen': "videoScreen",
      'function': function,
    });
  }
}

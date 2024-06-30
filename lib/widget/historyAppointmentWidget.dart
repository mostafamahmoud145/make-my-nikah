import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/TextButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:intl/intl.dart';

import '../config/app_fonts.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../methodes/pt_to_px.dart';
import '../screens/AppointmentChatScreen.dart';

class HistoryAppointmentWiget extends StatelessWidget {
  final GroceryUser loggedUser;
  final AppAppointments appointment;

  HistoryAppointmentWiget(
      {required this.appointment, required this.loggedUser});

  @override
  Widget build(BuildContext context) {
    String lang = getTranslated(context, "lang");
    Size size = MediaQuery.of(context).size;
    String time;
    DateFormat dateFormat = DateFormat('yyyy MMM dd');
    DateTime localDate =
        DateTime.parse(appointment.appointmentTimestamp.toDate().toString())
            .toLocal();
    if (localDate.hour == 12)
      time = "12 Pm";
    else if (localDate.hour == 0)
      time = "12 Am";
    else if (localDate.hour > 12)
      time = (localDate.hour - 12).toString() +
          ":" +
          localDate.minute.toString() +
          "Pm";
    else
      time = (localDate.hour).toString() +
          ":" +
          localDate.minute.toString() +
          "Am";

    return Container(
      width: convertPtToPx(AppSize.w182.w),
      height: convertPtToPx(AppSize.h154_5.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(convertPtToPx(AppRadius.r16.r)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(32, 32, 32, 0.05),
            blurRadius: 12.0,
            spreadRadius: 0.0,
            offset: Offset(0, 3.0), // shadow direction: bottom right
          )
        ],
      ),
      child: InkWell(
        splashColor: Colors.green.withOpacity(0.6),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentChatScreen(
                  appointment: appointment, user: loggedUser),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(convertPtToPx(AppPadding.p16.r)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            AssetsManager.greyCalenderIconPath,
                            width: convertPtToPx(AppSize.w12.w),
                            height: convertPtToPx(AppSize.h12.h),
                          ),
                          SizedBox(
                            width: AppSize.w10_6.w,
                          ),
                          Text(
                            '${dateFormat.format(localDate)}',
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratmedium"),
                              color: AppColors.grey3,
                              fontSize:
                                  convertPtToPx(AppFontsSizeManager.s10.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppSize.h10_6.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            AssetsManager.greyClock2IconPath,
                            width: convertPtToPx(AppSize.w12.w),
                            height: convertPtToPx(AppSize.h12.h),
                          ),
                          SizedBox(
                            width: AppSize.w10_6.w,
                          ),
                          Text(
                            time,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratmedium"),
                              color: AppColors.grey3,
                              fontSize:
                                  convertPtToPx(AppFontsSizeManager.s10.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppSize.h25.h,
                      ),
                    ],
                  ),
                  Container(
                    height: AppSize.h33_3.h,
                    width: AppSize.w65.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius:
                          BorderRadius.circular(convertPtToPx(AppRadius.r4.r)),
                      border: Border.all(
                        color: AppColors.pink2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            double.parse(appointment.callPrice.toString())
                                .toStringAsFixed(0),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserrat-SemiBold"),
                              color: AppColors.pink2,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  convertPtToPx(AppFontsSizeManager.s14.sp),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "\$",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              color: AppColors.pink2,
                              fontSize: AppFontsSizeManager.s18_6.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                  StringUtils.capitalize(appointment.user.name),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: getTranslated(context, "Montserrat-SemiBold"),
                    color: AppColors.balck2,
                    fontWeight: FontWeight.bold,
                    fontSize: convertPtToPx(AppFontsSizeManager.s16.sp),
                  ),
                ),
              SizedBox(
                height: lang == "ar" ? AppSize.h18_6.h : AppSize.h22.h,
              ),
              Container(
                width: double.infinity,
                height: convertPtToPx(AppSize.h30.h),
                decoration: BoxDecoration(
                  color: AppColors.lightPink2,
                  borderRadius:
                      BorderRadius.circular(convertPtToPx(AppRadius.r4.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getTranslated(context, "message"),
                      style: TextStyle(
                          color: AppColors.pink2,
                          fontFamily:
                              getTranslated(context, "Montserratsemibold"),
                          fontWeight: FontWeight.bold,
                          fontSize: AppFontsSizeManager.s13_5.sp),
                    ),
                    SizedBox(
                      width: convertPtToPx(AppSize.w8.w),
                    ),
                    Center(
                      child: SvgPicture.asset(
                        AssetsManager.chat2IconPath,
                        width: convertPtToPx(AppSize.w16.w),
                        height: convertPtToPx(AppSize.h16.h),
                      ),
                    ),
                  ],
                ),
              ),

              /* Image.asset(
                  'assets/icons/icon/Group2823.png',
                  width: 12,
                  height: 12,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  time,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                    color: AppColors.grey2,
                    fontSize: 10.0,
                  ),
                ),
                Container(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/icons/icon/Group2823.png',
                            width: 12,
                            height: 12,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            time,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                              color: AppColors.grey2,
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white1,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      shadow(),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only( left: 10, right: 10, top: 10, bottom: 10),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width * 0.4,
                              child: Text(
                                appointment.user.name != null
                                    ? appointment.user.name
                                    : appointment.user.phone,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                  color: AppColors.reddark2,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),

                            Container(
                              height: 17,
                              width: size.width * .17,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  shadow(),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  double.parse(appointment.callPrice.toString())
                                      .toStringAsFixed(2) +
                                      "\$",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                    color: AppColors.black2,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(width: 85,
                          padding: EdgeInsets.only(left: 10, right: 10, top: 5,bottom: 5),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              shadow(),
                            ],

                          ),
                          child: InkWell(
                              splashColor: Colors.green.withOpacity(0.6),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppointmentChatScreen(
                                        appointment: appointment, user: loggedUser),
                                  ),
                                );
                              },
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Image.asset("assets/icons/icon/Group2822.png",width: 10,height: 10,),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    getTranslated(context, "message"),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                      color: AppColors.greendark,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
*/
            ],
          ),
        ),
      ),
    );
  }

  BoxShadow shadow() {
    return BoxShadow(
      color: AppColors.lightGrey,
      blurRadius: 3.0,
      spreadRadius: 0.0,
      offset: Offset(0.0, 0.0),
    );
  }
}

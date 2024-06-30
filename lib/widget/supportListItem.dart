
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/SupportList.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/screens/supportMessagesScreen.dart';
import 'package:grocery_store/widget/IconButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:intl/intl.dart';

import '../config/assets_manager.dart';
import '../config/colorsFile.dart';

class SupportListItem extends StatelessWidget {
  final Size size;
  final SupportList item;
  final GroceryUser user;
  const SupportListItem({
    required this.size,
    required this.item,
    required this.user,
  });
  void showSnack(String text, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(7),
      backgroundColor: AppColors.greendark2,
      animationDuration: Duration(milliseconds: 300),
      isDismissible: true,
      boxShadows: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 1.0,
          blurRadius: 5.0,
          offset: Offset(0.0, 2.0),
        )
      ],
      shouldIconPulse: false,
      duration: Duration(milliseconds: 2000),
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      messageText: Text(
        '$text',
        style: GoogleFonts.poppins(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd/MM/yy');
    return Column(
      children: [
        InkWell(onTap: (){
          (item.openingStatus && user.userType == "SUPPORT")
                            ? showSnack(getTranslated(context, "otherSupport"), context)
                            : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SupportMessageScreen(
                              item: item,
                              user: user,
                            ),
                          ),
                        );
        },
          child: Container(
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: AppPadding.p32.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AssetsManager.headphoneIconPath,
                  width: AppSize.w53_3.r,
                  height: AppSize.h53_3.r,
                ),
                SizedBox(width: AppSize.w10_6.w,),
                Expanded(flex:2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        user.userType == "SUPPORT"
                            ? item.userName == null
                            ? item.owner
                            : item.userName!
                            : '${getTranslated(context, "supportTeam")}',
                        style: TextStyle(fontFamily: getTranslated(context,"Montserratmedium"),
                          fontSize: AppFontsSizeManager.s21_3.sp,
                          color: AppColors.black7,
                          fontWeight: FontWeight.w500,
          
                        ),
                      ),
                      SizedBox(height: AppSize.h1_3.h,),
                      item.lastMessage == null
                          ? SizedBox()
                          : (item.lastMessage != "imageFile" &&
                          item.lastMessage != "voiceFile")
                          ? Text(
                        item.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: getTranslated(context,"Montserrat"),
                          fontSize: AppFontsSizeManager.s18_6.sp,
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                          : Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: AppSize.w6_6.w,),
                          Icon(
                            Icons.file_copy_outlined,
                            size: 10,
                            color: Color.fromRGBO(167, 165, 165,1.0),
                          ),
                          Text(
                            getTranslated(
                                context, "attatchment"),
                            style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                              fontSize: AppFontsSizeManager.s18_6.sp,
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        IconButton1(onPress:() {
                         
                        }, Width: AppSize.w46_6.r,
                          Height: AppSize.h46_6.r,
                          ButtonBackground: AppColors.lightPink2,
                          BoxShape1: BoxShape.circle,
                          Icon: AssetsManager.chat1IconPath.toString(),
                          IconWidth: AppSize.w19_3.r,
                          IconHeight: AppSize.h19_3.r,
                          IconColor: AppColors.pink2,)
                        ,
                        /*Container(
                          height: 23,
                          width: 23,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white,
                              border: Border.all(width: 0.50, color: AppColors.lightGrey),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(102 ,90 ,95, 0.13),
                                  blurRadius: 1,
                                  spreadRadius: 0.0,
                                  offset: Offset(0.0, 1.0),
                                ),
                              ]
                          ),
                          child: Center(
                            child:Image.asset(
                              'assets/icons/icon/Group 3653.png',
                              width: 10,
                              height: 10,
                            ),
          
                          ),
                        ),*/
                       ((user.userType == "SUPPORT" && item.supportMessageNum > 0)||(user.userType != "SUPPORT" && item.userMessageNum > 0))
                            ? Positioned(
                          left: 1.0,
                          top: 1.0,
                          child: Container(
                            height: 5,
                            width: 5,
                            alignment:
                            Alignment.center,
                            decoration:
                            BoxDecoration(
                              shape:
                              BoxShape.circle,
                              color: Colors.amber,
                            ),
                          ),
                        )
                            : SizedBox()
                      ],
                    ),
                    SizedBox(
                      height: AppSize.h10_6.h,
                    ),
                    Text(
                      item.messageTime != null
                          ? '${dateFormat.format(item.messageTime.toDate())}'
                          : '..',
                      style: TextStyle(fontFamily: "Montserrat",
                        fontSize: AppFontsSizeManager.s16.sp,
                        color: AppColors.black4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          width: AppSize.w506_6.w,
          height: 0.5,
          color: Colors.grey[100],
        ),
      ],
    );
  }
}



import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/localization/localization_methods.dart';

import 'package:flutter/material.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/colorsFile.dart';
import '../widget/TextButton.dart';


class ForceUpdateScreen extends StatefulWidget {

  const ForceUpdateScreen({Key? key}) : super(key: key);
  @override
  _ForceUpdateScreenState createState() => _ForceUpdateScreenState();
}

class _ForceUpdateScreenState extends State<ForceUpdateScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  late String lang;
  @override
  void initState() {
    super.initState();
  }

  void showFailedSnakbar(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    lang=getTranslated(context, "lang");
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body:  Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
            Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
              SizedBox(height: AppSize.h341_3.h,),
              Center(
                  child:  Image.asset(AssetsManager.heartLogo,
                  width: AppSize.w166_1.w,
                  height: AppSize.h158.h,)
              ),
              SizedBox(height: AppSize.h32.h,),

            ],)),
            Center(
              child: SvgPicture.asset(AssetsManager.group1ImagePath,
              width: AppSize.w321_8.w,
              height: AppSize.h86_6.h,
              ),
            ),

            SizedBox(height: AppSize.h126.h,),

            Padding(
              padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p45_3.w),
              child: Text(
                getTranslated(context, "lastVersion"),
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: getTranslated(context,"Montserratsemibold"),
                    color: AppColors.grey6,
                    fontSize: AppFontsSizeManager.s26_6.sp,
                   
                ),
              ),
            ),
            SizedBox(height: AppSize.h64.h,),
            TextButton1(onPress: () async {
    String url = Platform.isIOS ?"https://apps.apple.com/us/app/1668556326":
     "https://play.google.com/store/apps/details?id=com.app.MakeMyNikah";
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }

    },Width: AppSize.w446_6.w,Height: AppSize.h66_6.h,
     Title:  getTranslated(context, "install") ,
      ButtonRadius: AppRadius.r10_6.r,
       TextSize: AppFontsSizeManager.s21_3.sp,
       ButtonBackground: AppColors.pink2,
        TextFont: getTranslated(context, "Montserratsemibold"),
         TextColor: AppColors.white),
            SizedBox(height: 40,),

          ],),
      ),
    );
  }
 
}

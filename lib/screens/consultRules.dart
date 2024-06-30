
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/localization/localization_methods.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/models/UnorderedList.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../config/colorsFile.dart';
import 'account_screen.dart';

class consultRuleScreen extends StatefulWidget {
  final GroceryUser user;

  const consultRuleScreen({Key? key, required this.user}) : super(key: key);

  @override
  _consultRuleScreenState createState() => _consultRuleScreenState();
}

class _consultRuleScreenState extends State<consultRuleScreen>with SingleTickerProviderStateMixin {
  bool isLoading=true,accept=false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
              width: size.width,
              // height: 80,
              // color: Colors.white,
              child: SafeArea(
                  child: Padding( padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset(
                            getTranslated(context, "back"),
                            width: 30,
                            height: 30,
                          ),
                        ),
                        Text(
                          getTranslated(context, "terms"),
                          textAlign:TextAlign.left,
                          style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),fontSize: 16.0,color:Colors.black.withOpacity(0.8)),
                        ),



                      ],
                    ),
                  ))),
          Center(
              child: Container(
                  color: AppColors.white3, height: 1, width: size.width)),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(children: [
                UnorderedList([
                  getTranslated(context, "rule1"),
                  getTranslated(context, "rule2"),
                  getTranslated(context, "rule3"),
                  getTranslated(context, "rule4"),
                  getTranslated(context, "rule5"),
                  getTranslated(context, "rule6")
                ]),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Checkbox(
                      value: accept,
                      onChanged: (value) {
                        setState(() {
                          accept = !accept;
                        });
                      },
                    ),
                    Text(
                      getTranslated(context, "agree"),
                      style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                accept==true?Center(
                  child: InkWell(onTap: (){
                    confirmDialog(size);

                    },
                    child: Container(
                      width: size.width*.6,
                      height: 45.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              AppColors.pink2,
                              AppColors.red1,
                            ],
                          )
                      ),
                      child: Center(
                        child: Text(
                          getTranslated(context, "saveAndContinue"),
                          style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ):SizedBox(),

              ],),
            ),
          ),
        ],
      ),
    );
  }
   confirmDialog(Size size) {
    return showDialog(
      builder: (context) => NikahDialogWidget(
        padButtom: AppPadding.p32.h,
        padLeft: AppPadding.p12.w,
        padReight:AppPadding.p12.w,
        padTop:AppPadding.p32.h,
        radius: AppRadius.r21_3.r,
        
        dialogContent:   Container(
          color: AppColors.white,
          width:AppSize.w446_6.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      getTranslated(context, "guarantee"),
                      style: TextStyle(
                        fontFamily: getTranslated(context,"Montserratsemibold"),
                        fontSize: AppFontsSizeManager.s32.sp,
                        

                        color: AppColors.pink2,
                      ),
                    ),
                    SizedBox(width: AppSize.w16.w,),
                    SvgPicture.asset(
                      AssetsManager.rightGreenIcon,
                      height: AppSize.h46.h,
                      width: AppSize.w41_3.w,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: AppSize.h32_6.w,
              ),
              Text(
                getTranslated(context, "guaranteeText"),
                textAlign: TextAlign.center,
                maxLines: 6,
                style: TextStyle(fontFamily: getTranslated(context,"Montserratmedium"),
                  fontSize: AppFontsSizeManager.s21_3.sp,
                  height: AppSize.h2.h,
                 // fontWeight: FontWeight.w500,
                 // letterSpacing: 0.3,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: AppSize.h32.h,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                     Navigator.push(
                    context,
                       MaterialPageRoute(
                         builder: (context) => AccountScreen(user: widget.user, firstLogged: true),),);
                  },
                  child: Container(
                      height: AppSize.h52.h,
                      decoration: BoxDecoration(
                        color: AppColors.pink2,
                        borderRadius: BorderRadius.circular(
                          AppRadius.r5_3.r
                        )
                      ),
                width: AppSize.w160.w,
                
                    child: Center(
                      child: Text(
                        getTranslated(context, 'accept1'),
                        style: TextStyle(fontFamily:
                         getTranslated(context,"Montserratsemibold"),
                          color: Colors.white,
                          fontSize: AppFontsSizeManager.s21_3.sp,
                          fontWeight: FontWeight.w500,
                        ),
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
    );}
}

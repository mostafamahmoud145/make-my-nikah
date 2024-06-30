import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/IconButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/app_bar_widget.dart';
import 'package:http/http.dart';
import '../FireStorePagnation/paginate_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../config/assets_manager.dart';
import '../widget/consultantListItem.dart';

class FavoritesScreen extends StatefulWidget {
  final GroceryUser? loggedUser;

  const FavoritesScreen({Key? key, this.loggedUser}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String lang = getTranslated(context, "lang");
    return Scaffold(
        backgroundColor: AppColors.white1,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                bottom: AppPadding.p21_3.w
                ),
                child: AppBarWidget2(
                    text: getTranslated(context, "favorite"),
                  ),
              ),
              Center(
                  child: Container(
                      color: AppColors.white3,
                      height: AppSize.h1.h,
                      width: size.width)),
              
              Padding(
                padding:  EdgeInsets.only(
                  bottom: AppPadding.p64.h,
                    right: AppPadding.p32.w,
                    left: AppPadding.p32.w,
                    top: AppPadding.p32.h,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
          
                    Text(
                      getTranslated(context, "yourFavorites"),
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      style: TextStyle(
                          fontFamily: getTranslated(context, "Montserratmedium"),
                          fontSize: AppFontsSizeManager.s26_6.sp,
                          color: AppColors.darkGrey)
                    ),
                  ],
                ),
              ),
              widget.loggedUser!.wishlist?.length == 0
                  ? Center(
                      child: Text(
                        getTranslated(context, "noData"),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            fontSize: 15.0,
                            color: Color.fromRGBO(158, 158, 158, 1.0)),
                      ),
                    )
                  : Padding(
                    padding: EdgeInsets.only(
                    
                     left: AppPadding.p22.w ,
                            right: AppPadding.p22.w,
                    ),
                    child: Container(
                      height: AppSize.h750.h,
                      padding:  EdgeInsets.only(
                        top: AppPadding.p10_6.h,
                                         
                                             bottom: AppPadding.p10_6.h,
                                         ),
                                  decoration: BoxDecoration(
                       
                                    boxShadow: [
                                       BoxShadow(
                                     color: AppColors.white2,
                                         blurRadius: 10,
                                        spreadRadius: 0,
                                       offset: Offset(0, 1),
                                 // shadow direction: bottom right
                            )
                            ],
                      ),
                     
                        
                        child: PaginateFirestore(
                    
                          separator: Container(
                            width: AppSize.w24.w,
                          ),
                          itemBuilderType: PaginateBuilderType.listView,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                              left: AppPadding.p10.w ,
                              right: AppPadding.p10.w,
                             ),
                          itemBuilder: (context, documentSnapshot, index) {
                            return ConsultantListItem(
                              consult: GroceryUser.fromMap(
                                  documentSnapshot[index].data() as Map),
                              loggedUser: widget.loggedUser,
                              size: size,
                              inAppleReview: false,
                            );
                          },
                          query: FirebaseFirestore.instance
                              .collection('Users')
                              .where('userType', isEqualTo: 'CONSULTANT')
                              .where('accountStatus', isEqualTo: "Active")
                              .where('uid',
                                  whereIn: widget.loggedUser!.wishlist?.toList()),
                          //.orderBy('order', descending: true),
                          isLive: true,
                        ),
                      ),
                  ),
            
            SizedBox(height: AppSize.h29_3.h,)
            ],
          ),
        ));
  }
}

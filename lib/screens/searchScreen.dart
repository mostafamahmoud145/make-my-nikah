
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/blocs/notification_bloc/notification_bloc.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/models/user_notification.dart';
import 'package:grocery_store/screens/userAccountScreen.dart';
import 'package:grocery_store/widget/app_bar_widget.dart';
import 'package:grocery_store/widget/consultantListItem.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../FireStorePagnation/paginate_firestore.dart';import '../config/colorsFile.dart';
import '../models/setting.dart';
import '../models/userSearch.dart';
import 'account_screen.dart';
import 'notification_screen.dart';

class SearchScreen extends StatefulWidget {
  final GroceryUser loggedUser;
  final UserSearch usersearch;
  const SearchScreen({Key? key, required this.loggedUser, required this.usersearch}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = new TextEditingController();
  List<GroceryUser>allConsults=[];
  bool load=false;
  late String name ="",lang;
  //Query filterQuery;
  bool inAppleReview=true,loadSetting=true;
  @override
  void initState() {
    super.initState();
    initiateSearch("search");
  }


  @override
  Widget build(BuildContext context) {
  lang=getTranslated((context), "lang");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key:_scaffoldKey,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: size.width,
                child: Padding( padding:  EdgeInsets.only(
                     bottom: AppPadding.p21_3.h
                      ),
                  child: AppBarWidget2(text: getTranslated(context, "results"),)
                )),
            Center( child: Container(  
              color: AppColors.white3,
             height: AppSize.h1.h,
              width: size.width )),
            Expanded(
              child: ListView(physics:  AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding:  EdgeInsets.only(
                    left: AppPadding.p32.w,
                    right: AppPadding.p32.w,
                    top: AppPadding.p42_6.w,
                    bottom: AppPadding.p74_6.w,
                    ),
                  child: Row(
                    children: [
                      Text(
                        getTranslated(context, "searchText"),
                        textAlign:TextAlign.center,maxLines: 1,
                        style: TextStyle(
                          fontFamily: getTranslated(context,"Montserratmedium"),
                            fontSize: AppFontsSizeManager.s32.sp ,
                            color:AppColors.black),
                      ),
                    ],
                  ),
                ),
                load?Center(child:CircularProgressIndicator() ):
                 allConsults.length==0?Center(child: Text(
                   getTranslated(context, "noData"),
                   textAlign:TextAlign.center,maxLines: 3,
                   style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                       fontSize: 15.0,color:Color.fromRGBO(158, 158, 158,1.0)),
                 ),):
                Container(height: AppSize.h750.h,width: size.width,
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
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    padding:  EdgeInsets.only( left: lang=="en"?2:20, right: lang=="en"?20:5, bottom: 16.0, top: 1.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: allConsults.length,
                    itemBuilder: (context, index) {
                      return
                        ConsultantListItem(
                            consult: allConsults[index],
                            loggedUser: widget.loggedUser,
                            size:size,
                            inAppleReview: false,
                        );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 10.0,
                      );
                    },
                  ),
                ),
              ])),
          ],
        ),
      ),
    );
  }
  Future<void> initiateSearch(String val) async {
    setState(() {
      loadSetting=false;
    });
    List<GroceryUser> consultantList;
    List<GroceryUser> filterList=[];
    Query querySearch = FirebaseFirestore.instance.collection(Paths.usersPath)
        .where('userType', isEqualTo: "CONSULTANT")
        .where('accountStatus', isEqualTo: "Active");
    if(widget.usersearch.country != "")
      querySearch = querySearch.where('country', isEqualTo:widget.usersearch.country!);

    //querySearch = querySearch.where('countryCode', isEqualTo: "+"+widget.usersearch.countryCode!);

    if(widget.usersearch.nationality != "")
      querySearch = querySearch.where('nationalityCode', isEqualTo: widget.usersearch.nationalityCode);

     if(widget.usersearch.skinColor!.length > 0)
       querySearch = querySearch.where('color', whereIn: widget.usersearch.skinColor);

    if(widget.usersearch.maritalState != "")
      querySearch = querySearch.where('maritalStatus', isEqualTo: widget.usersearch.maritalState);

    if(widget.usersearch.marriageType != "")
      querySearch = querySearch.where('marriage', isEqualTo: widget.usersearch.marriageType);

    if(widget.usersearch.hijab != "")
      querySearch = querySearch.where('hijab', isEqualTo: widget.usersearch.hijab);

    if(widget.usersearch.education != "")
      querySearch = querySearch.where('education', isEqualTo: widget.usersearch.education);

    if(widget.usersearch.employment != "")
      querySearch = querySearch.where('employment', isEqualTo: widget.usersearch.employment);

    if(widget.usersearch.smoke != "")
      querySearch = querySearch.where('smooking', isEqualTo: widget.usersearch.smoke);

    if(widget.usersearch.tribal != "")
      querySearch = querySearch.where('tribal', isEqualTo: widget.usersearch.tribal);

    QuerySnapshot filter = await  querySearch.get();
    consultantList = List<GroceryUser>.from(
      filter.docs.map( (snapshot) => GroceryUser.fromMap(snapshot.data() as Map),
    ),);
    for (var i = 0; i < consultantList.length; i++) {
       if(consultantList[i].age!>=widget.usersearch.minAge!&&consultantList[i].age!<=widget.usersearch.maxAge!&&
           consultantList[i].weight!>=widget.usersearch.minWeight!&&consultantList[i].weight!<=widget.usersearch.maxWeight!&&
           consultantList[i].length!>=widget.usersearch.minHeight!&&consultantList[i].length!<=widget.usersearch.maxHeight!)
           filterList.add(consultantList[i]);
    }
     
    setState(() {
    allConsults=filterList;
    load=false;
    });
    print("llllll");
    print(allConsults.length);
    print(allConsults);
    print(widget.usersearch.tribal);
  }
}

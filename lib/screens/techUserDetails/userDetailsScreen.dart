
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/SupportList.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/techUserDetails/userAppointmentScreen.dart';
import 'package:grocery_store/widget/processing_dialog.dart';
import '../../models/userDetails.dart';
import '../bioDetailsScreen.dart';
import '../interviewsScreen.dart';
import '../myOrderScreen.dart';
import '../supportMessagesScreen.dart';
class UserDetailsScreen extends StatefulWidget {
  final GroceryUser user;
  final GroceryUser loggedUser;

  const UserDetailsScreen({Key? key, required this.user, required this.loggedUser}) : super(key: key);
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Size? size;
  String from="",to="", days = "";
  int localFrom=0,localTo=23;
  List<String>dayList=[], dayListValue=[];


  DateTime _now=DateTime.now();
  final TextEditingController searchController = new TextEditingController();
  bool first=true,saving=false,load=false,activeValue=false,activeUser=false;
  UserDetail? userDetails;
  bool loadData=false,loadingChat=false,chating=false;

  @override
  void initState() {
    if(widget.user.userType=="CONSULTANT") {
      getuserDetails(widget.user.uid.toString());
      localFrom = DateTime .parse(widget.user.fromUtc.toString())
          .toLocal()
          .hour;
      localTo = DateTime
          .parse(widget.user.toUtc.toString())
          .toLocal()
          .hour;
      if (localTo == 0)
        localTo = 24;
      if (widget.user.workTimes!.length > 0) {
        if (localFrom == 12)
          from = "12 PM";
        else if (localFrom == 0)
          from = "12 AM";
        else if (localFrom > 12)
          from = ((localFrom) - 12).toString() + " PM";
        else
          from = (localFrom).toString() + " AM";
      }
      if (widget.user.workTimes!.length > 0) {
        if (localTo == 12)
          to = "12 PM";
        else if (localTo == 0 || localTo == 24)
          to = "12 AM";
        else if (localTo > 12)
          to = ((localTo) - 12).toString() + " PM";
        else
          to = (localTo).toString() + " AM";
      }
    }


    super.initState();
  }
  @override
  void didChangeDependencies() {

    if(first&&widget.user.workDays!.length>0) {
      dayList=[];
      if(widget.user.workDays!.contains("1"))
        dayList.add(getTranslated(context,"monday"));
      if(widget.user.workDays!.contains("2"))
        dayList.add(getTranslated(context,"tuesday"));
      if(widget.user.workDays!.contains("3"))
        dayList.add(getTranslated(context,"wednesday"));
      if(widget.user.workDays!.contains("4"))
        dayList.add(getTranslated(context,"thursday"));
      if(widget.user.workDays!.contains("5"))
        dayList.add(getTranslated(context,"friday"));
      if(widget.user.workDays!.contains("6"))
        dayList.add(getTranslated(context,"saturday"));
      if(widget.user.workDays!.contains("7"))
        dayList.add(getTranslated(context,"sunday"));

      setState(() {
        dayListValue=dayList;
      });
      for(int x=0;x<dayListValue.length;x++)
      {
        days = days + dayListValue[x] + " - ";

      }
    }


    super.didChangeDependencies();
  }
  void getuserDetails(String userID) async {
    setState(() {
      loadData=true;
    });
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection(Paths.userDetail).doc(userID)
        .get();
    setState(() {
      this.userDetails = UserDetail.fromMap(snapshot.data() as Map);
      loadData=false;
    });

  }
  @override
  void dispose() {
    super.dispose();

  }

  void showSnakbar(String s,bool status) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  BoxShadow shadow(){return
    BoxShadow(
      color: AppColors.lightGrey,
      blurRadius: 2.0,
      spreadRadius: 0.0,
      offset: Offset(
          0.0, 1.0), // shadow direction: bottom right
    );}
  Widget daysWidget(String day){
    return Container( width: 40.0,
      height: 45.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage( 'assets/plan/Group2849.png',),
          fit: BoxFit.fill,
        ),
      )
      ,child: Center(child:Text( day,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
          color:  AppColors.black,fontWeight: FontWeight.w300,
          fontSize: 9.0,
        ),
      ),),);

  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width: size!.width,
              child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 35,
                          width: 35,

                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Image.asset(
                              getTranslated(context, "back"),
                              width: 20,
                              height: 15,
                            ),
                          ),
                        ),
                        Text(
                          widget.user.name!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),fontSize: 17.0,color:AppColors.balck2,fontWeight: FontWeight.w300),

                        ),
                        loadingChat?CircularProgressIndicator(): Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: AppColors.white,

                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: IconButton(
                            onPressed: () {
                              startChat();
                            },
                            icon: Icon(
                              Icons.message,
                              color: AppColors.pink,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))),
          Center( child: Container(  color: AppColors.white3, height: 1, width: size!.width )),
          loadData?CircularProgressIndicator():
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // padding: EdgeInsets.all(20),
                  children: [

                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "name")),
                    getText(widget.user.name == null ? "" : widget.user.name!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "phoneNumber")),
                    getText(widget.user.phoneNumber == null ? "" : widget.user.phoneNumber!),
                    SizedBox(height: size!.height * 0.06,),


                    getTitle(getTranslated(context, "country")),
                    getText(widget.user.country == null ? "" : widget.user.country!),
                    SizedBox(height: size!.height * 0.06,),


                    getTitle(getTranslated(context, "age")),
                    getText(widget.user.age == null ? "" : widget.user.age.toString()),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "height")),
                    getText(widget.user.length == null ? "" : widget.user.length.toString()),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "weight")),
                    getText(widget.user.weight== null ? "" : widget.user.weight.toString()),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "maritalStatus")),
                    getText(widget.user.maritalStatus == null ? "" : widget.user.maritalStatus!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "education")),
                    getText(widget.user.education == null ? "" : widget.user.education!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "skincolor")),
                    getText(widget.user.color == null ? "" : widget.user.color!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "employmentStatus")),
                    getText(widget.user.employment == null ? "" : widget.user.employment!),
                    SizedBox(height: size!.height * 0.06,),

                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "childrenNum")),
                    getText(widget.user.childrenNum == null ? "" : widget.user.childrenNum.toString()),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "marriageType")),
                    getText(widget.user.marriage == null ? "" : widget.user.marriage!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "hijab")),
                    getText(widget.user.hijab == null ? "" : widget.user.hijab!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "livingStander")),
                    getText(widget.user.living == null ? "" : widget.user.living!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "Smoking")),
                    getText(widget.user.smooking == null ? "" : widget.user.smooking! ),
                    SizedBox(height: size!.height * 0.06,),
                    
                    getTitle(getTranslated(context, "tribal")),
                    getText(widget.user.tribal == null ? "" : widget.user.tribal! ),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "religion")),
                    getText(widget.user.origin == null ? "" : widget.user.origin!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "nature")),
                    getText((userDetails==null||userDetails!.characterNature! == null) ? "" : userDetails!.characterNature!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "values")),
                    getText((userDetails==null||userDetails!.values == null) ? "" : userDetails!.values!),
                    SizedBox(height: size!.height * 0.06,),


                    getTitle(getTranslated(context, "habits")),
                    getText((userDetails==null||userDetails!.habbits == null) ? "" : userDetails!.habbits!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "hobbies")),
                    getText((userDetails==null||userDetails!.hobbies == null )? "" : userDetails!.hobbies!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "life")),
                    getText((userDetails==null||userDetails!.priorties == null) ? "" : userDetails!.priorties!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "positive")),
                    getText((userDetails==null||userDetails!.positivePoints == null) ? "" : userDetails!.positivePoints!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "negative")),
                    getText((userDetails==null||userDetails!.negativePoints == null) ? "" : userDetails!.negativePoints!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "like")),
                    getText((userDetails==null||userDetails!.lovableThings == null) ? "" : userDetails!.lovableThings!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "disLike")),
                    getText((userDetails==null||userDetails!.hatefulThings == null) ? "" : userDetails!.hatefulThings!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "fiveYears")),
                    getText((userDetails==null||userDetails!.marriageYears == null) ? "" : userDetails!.marriageYears!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "quran")),
                    getText((userDetails==null||userDetails!.quranLevel == null) ? "" : userDetails!.quranLevel!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "sciences")),
                    getText((userDetails==null||userDetails!.religionLevel == null) ? "" : userDetails!.religionLevel!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "healthConditions")),
                    getText((userDetails==null||userDetails!.healthCondition == null) ? "" : userDetails!.healthCondition!),
                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "workTime")),
                    getText(days),
                    SizedBox(height: size!.height * 0.06,),

                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(getTranslated(context, "from") + ":  ",style: TextStyle(
                              color: AppColors.reddark2,
                              fontSize: 10,
                            ),),
                            getText(from)
                          ],
                        ),
                        SizedBox(width: size!.width * 0.085,),
                        Row(
                          children: [
                            Text(getTranslated(context, "to") + ":  ",style: TextStyle(
                              color: AppColors.reddark2,
                              fontSize: 10,
                            ),),
                            getText(to)
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: size!.height * 0.06,),

                    getTitle(getTranslated(context, "personalPhotoId")),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                          width: size!.width * 0.65,
                          height: size!.height * 0.17,
                          decoration: BoxDecoration(
                            color: widget.user.photoUrl != null && widget.user.photoUrl != "" ? Colors.transparent : AppColors.black2,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: AppColors.black2
                            ),
                          ),
                          child: widget.user.photoUrl != null && widget.user.photoUrl != "" ? Image.network(widget.user.photoUrl!): SizedBox()
                      ),
                    ),

                    SizedBox(height: size!.height * 0.1,),
                    widget.user.userType=="CONSULTANT"?Center(
                      child: Container(
                        width: size!.width * 0.7,
                        height: size!.height * 0.054,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColors.green1,
                                AppColors.pink,
                              ],
                            )
                        ),
                        child: MaterialButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BioDetailsScreen(
                                  consult: widget.user,
                                  loggedUser: widget.loggedUser,
                                  consultDetails: this.userDetails!,
                                  screen: 2,
                                  //loggedUser:loggedUser,
                                ),
                              ),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            getTranslated(context, "partnerSpecification"),
                            style: TextStyle(
                              fontFamily:
                              getTranslated(context, "fontFamily"),
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ):SizedBox(),
                    SizedBox(height: 20,),
                    Center(
                      child: Container(
                        width: size!.width * 0.65,
                        height: size!.height * 0.054,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColors.green1,
                                AppColors.pink,
                              ],
                            )
                        ),
                        child: MaterialButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserAppointmentsScreen(user:widget.user,loggedUser: widget.loggedUser, ), ),  );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            getTranslated(context, "appointments"),
                            style: TextStyle(
                              fontFamily:
                              getTranslated(context, "fontFamily"),
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Center(
                      child: Container(
                        width: size!.width * 0.65,
                        height: size!.height * 0.054,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColors.green1,
                                AppColors.pink,
                              ],
                            )
                        ),
                        child: MaterialButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyOrdersScreen(user:widget.user,loggedType:widget.user.userType!,fromSupport: true, ), ),  );

                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            getTranslated(context, "allOrders"),
                            style: TextStyle(
                              fontFamily:
                              getTranslated(context, "fontFamily"),
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget build2(BuildContext context) {


    if(widget.user.userType=="CONSULTANT"&&first&&widget.user.workDays!.length>0) {
      localFrom= DateTime.parse(widget.user.fromUtc!).toLocal().hour;
      localTo=DateTime.parse(widget.user.toUtc!).toLocal().hour;
      if(localTo==0)
        localTo=24;

      if(widget.user.workTimes!.length>0)
      {
        if( localFrom==12)
          from="12 PM";
        else if( localFrom==0)
          from="12 AM";
        else if( localFrom>12)
          from=((localFrom)-12).toString()+" PM";
        else
          from=(localFrom).toString()+" AM";

      }
      if(widget.user.workTimes!.length>0)
      {
        if( localTo==12)
          to="12 PM";
        else if( localTo==0||localTo==24)
          to="12 AM";
        else if( localTo>12)
          to=((localTo)-12).toString()+" PM";
        else
          to=(localTo).toString()+" AM";

      }
      //================
      dayList=[];
      if(widget.user.workDays!.contains("1"))
        dayList.add(getTranslated(context,"monday"));
      if(widget.user.workDays!.contains("2"))
        dayList.add(getTranslated(context,"tuesday"));
      if(widget.user.workDays!.contains("3"))
        dayList.add(getTranslated(context,"wednesday"));
      if(widget.user.workDays!.contains("4"))
        dayList.add(getTranslated(context,"thursday"));
      if(widget.user.workDays!.contains("5"))
        dayList.add(getTranslated(context,"friday"));
      if(widget.user.workDays!.contains("6"))
        dayList.add(getTranslated(context,"saturday"));
      if(widget.user.workDays!.contains("7"))
        dayList.add(getTranslated(context,"sunday"));
      setState(() {
        dayListValue=dayList;
        first=false;
      });
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key:_scaffoldKey,
      body:  Column(
        children: <Widget>[

          Container(
              width: size!.width,
              // height: 80,
              // color: Colors.white,
              child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                    child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 35,
                          width: 35,

                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Image.asset(
                              getTranslated(context, "back"),
                              width: 20,
                              height: 15,
                            ),
                          ),
                        ),
                        Text(
                          widget.user.name!,
                          textAlign:TextAlign.center,
                          style: TextStyle(fontWeight:FontWeight.w300,fontFamily: getTranslated(context,"fontFamily"),fontSize: 17.0,color:AppColors.balck2),
                        ),
                        chating?CircularProgressIndicator():ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.white.withOpacity(0.6),
                              onTap: () {
                                startChat();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                width: 38.0,
                                height: 35.0,
                                child: Icon(
                                  Icons.chat_outlined,
                                  color: AppColors.balck2,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))),
          Center( child: Container(  color: AppColors.white3, height: 1, width: size!.width )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(physics:  AlwaysScrollableScrollPhysics(),children: [
                SizedBox(height: 20,),
                Center(
                  child: Container(width: size!.width*.8,
                    padding: const EdgeInsets.only(top:2,right: 10,left: 10,bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.white,width: 2),
                      boxShadow: [
                        shadow()
                      ],
                    ),child:Column(
                      children: [
                        Stack(children: [
                          Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10,width: size!.width*.28,),
                              Container(height: 25,width: size!.width*.25,
                                decoration: BoxDecoration(
                                  color: AppColors.greendark2,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child:  Center(
                                  child: Text(
                                    getTranslated(context, "bio2"),
                                    style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),  color: AppColors.white,
                                      fontSize: 11.0,),

                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(top: 5,right:0,
                            child: Image.asset(
                              'assets/plan/Group2845.png',
                              width: 20,height: 20,
                            ),
                          ),

                        ],),
                        SizedBox(height: 10,),
                        Text( widget.user.bio!.length>165?widget.user.bio!.substring(0,165):widget.user.bio!,
                          style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),  color: AppColors.black,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w300,),
                        ),
                        SizedBox(height: 10,),
                        Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(onTap: (){
                              if(loadData){}
                              else
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>BioDetailsScreen(consult:widget.user,consultDetails: userDetails!,loggedUser: widget.loggedUser,screen: 1,),
                                  ),
                                );
                            },
                              child: Container(
                                height: 18,
                                padding: const EdgeInsets.only(left: 5, right: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.pink2,
                                  borderRadius: BorderRadius.circular(3.0),
                                  boxShadow: [
                                    shadow()
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(
                                        getTranslated(context, "readMore"),
                                        style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),  color: AppColors.white,
                                          fontSize: 8.0,
                                          fontWeight: FontWeight.normal,),

                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 8,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),),
                ),
                widget.user.userType=="USER"?SizedBox():Column(children: [
                  Center(
                    child: Container(width: size!.width*.8,
                      padding: const EdgeInsets.only(top:2,right: 10,left: 10,bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.white,width: 2),
                        boxShadow: [
                          shadow()
                        ],
                      ),child:Column(
                        children: [
                          Stack(children: [
                            Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 10,width: size!.width*.50,),
                                Container(height: 25,width: size!.width*.47,
                                  decoration: BoxDecoration(
                                    color: AppColors.greendark2,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child:  Center(
                                    child: Text(
                                      getTranslated(context, "aboutLife"),
                                      style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),  color: AppColors.white,
                                        fontSize: 11.0,),

                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(top: 5,right:0,
                              child: Image.asset(
                                'assets/plan/Group2845.png',
                                width: 20,height: 20,
                              ),
                            ),

                          ],),
                          SizedBox(height: 10,),
                          Text( widget.user.partnerSpecifications!.length>165?widget.user.partnerSpecifications!.substring(0,165):widget.user.partnerSpecifications!,
                            style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),  color: AppColors.black,
                              fontSize: 11.0,
                              fontWeight: FontWeight.w300,),
                          ),
                          SizedBox(height: 5,),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(onTap: (){
                                if(loadData){}
                                else
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>BioDetailsScreen(consult:widget.user,consultDetails: userDetails!,loggedUser: widget.loggedUser,screen: 2,),
                                    ),
                                  );
                              },
                                child: Container(
                                  height: 18,
                                  padding: const EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.pink2,
                                    borderRadius: BorderRadius.circular(3.0),
                                    boxShadow: [
                                      shadow()
                                    ],
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                          getTranslated(context, "readMore"),
                                          style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),  color: AppColors.white,
                                            fontSize: 8.0,
                                            fontWeight: FontWeight.normal,),

                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 8,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),),
                  ),
                  SizedBox(height: 40,),
             

                  SizedBox(height: 40,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(getTranslated(context, "Group2846"),
                        height: 25,
                      ),
                      SizedBox(width: 5,),
                      Container(height: 25,width: size!.width*.40,
                        decoration: BoxDecoration(
                          color: AppColors.greendark2,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child:  Center(
                          child: Text(
                            getTranslated(context, "workTime"),maxLines: 1,overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),  color: AppColors.white,
                              fontSize: 11.0,),

                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Image.asset(getTranslated(context, "Group2847"),height: 25,
                      ),
                    ],
                  ),
                  //days
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 40,bottom: 20),
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.center,children: [
                      Image.asset( 'assets/icons/icon/Group2828.png',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Wrap(alignment: WrapAlignment.start,runSpacing: 5.0,spacing: 5.0,direction: Axis.horizontal,
                            children: [
                              for(int x=0;x<dayListValue.length;x++)
                                daysWidget(dayListValue[x]),

                            ]),
                      ),
                    ],),
                  ),
                  //times
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,crossAxisAlignment:CrossAxisAlignment.center,children: [
                      Image.asset('assets/icons/icon/Group2829.png',
                        width: 19,
                        height: 19,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(height: 29,width: 42,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.time,
                              borderRadius: BorderRadius.circular(13.0),
                            ),child:  Center(
                              child:  Text(
                                from,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                    color:AppColors.black,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w300
                                ),),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text(
                            ":",
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                color:AppColors.grey,
                                fontSize: 9.0,
                                fontWeight: FontWeight.bold
                            ),),
                          SizedBox(width: 10,),
                          Container(height: 29,width: 42,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.time,
                              borderRadius: BorderRadius.circular(13.0),
                            ),child:  Center(
                              child:  Text(
                                to,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                    color:AppColors.black,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w300
                                ),),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(),
                    ],),
                  ),
                ],),
                SizedBox(height: 20,),
                Center(
                  child: Container(
                    width: size!.width * 0.65,
                    height: size!.height * 0.054,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.green1,
                            AppColors.pink,
                          ],
                        )
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserAppointmentsScreen(user:widget.user, loggedUser: widget.loggedUser, ), ),  );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        getTranslated(context, "appointments"),
                        style: TextStyle(
                          fontFamily:
                          getTranslated(context, "fontFamily"),
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: Container(
                    width: size!.width * 0.65,
                    height: size!.height * 0.054,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.green1,
                            AppColors.pink,
                          ],
                        )
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyOrdersScreen(user:widget.user,loggedType:widget.user.userType!,fromSupport: true, ), ),  );

                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        getTranslated(context, "allOrders"),
                        style: TextStyle(
                          fontFamily:
                          getTranslated(context, "fontFamily"),
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: Container(
                    width: size!.width * 0.65,
                    height: size!.height * 0.054,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.green1,
                            AppColors.pink,
                          ],
                        )
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InterviewScreen(
                              user: widget.user,
                              loggedUser:widget.loggedUser,
                            ),
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        getTranslated(context, "Details"),
                        style: TextStyle(
                          fontFamily:
                          getTranslated(context, "fontFamily"),
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],),
            ),
          ),

        ],
      ),
    );
  }
  void showNoNotifSnack(String text,bool status) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(7),
      backgroundColor: status?Colors.green.shade500:Colors.red.shade500,
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
      duration: Duration(milliseconds: 1500),
      icon: Icon(
        Icons.notification_important,
        color: Colors.white,
      ),
      messageText: Text(
        '$text',
        style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
    )..show(context);
  }

  showUpdatingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: getTranslated(context, "loading"),
        );
      },
    );
  }
  startChat() async {
    setState(() {
      chating=true;
    });
    QuerySnapshot querySnapshot = await  FirebaseFirestore.instance.collection("SupportList")
        .where( 'userUid', isEqualTo: widget.user.uid, ).limit(1).get();
    if(querySnapshot.docs.length!=0)
    {
      var item=SupportList.fromMap(querySnapshot.docs[0].data()  as Map);
      setState(() {
        load=false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SupportMessageScreen(
            item: item,
             user:widget.loggedUser), ),);
      setState(() {
        chating=false;
      });

    }
    else
    {
      setState(() {
        chating=false;
      });
    }
  }
  Widget getTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        title,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontFamily: getTranslated(context, "fontFamily"),
            fontSize: 17.0,
            color: AppColors.reddark,
            fontWeight: FontWeight.normal),
      ),
      // ),
      // ),
      // ),
    );
  }
  Widget getText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        text,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 10,
        style: TextStyle(
            fontFamily: getTranslated(context, "fontFamily"),
            fontSize: 13.0,
            color: AppColors.black2,
            fontWeight: FontWeight.normal),
      ),
    );
  }
}

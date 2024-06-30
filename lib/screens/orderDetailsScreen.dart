
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/consultPackage.dart';
import 'package:grocery_store/models/consultReview.dart';
import 'package:grocery_store/models/order.dart';
import 'package:grocery_store/models/promoCode.dart';
import 'package:grocery_store/models/user.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class OrderDetails extends StatefulWidget {
  final Orders order;
  final String type;
  final bool fromSupport;
  const OrderDetails({Key? key, required this.order, required this.type, required this.fromSupport})
      : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  consultPackage? package;
  PromoCode? promo;
  ConsultReview? review;
  bool loadPackage = true,
      loadPromo = true,
      loadAppointments = true,
      loadReview = true;
  DateFormat dateFormat = DateFormat('dd/MM/yy');
  List<AppAppointments> appointmentList = [];
  bool cancel = false;
  String theme = "";
  String answerNum="0",remainingNum="0",status="open";
  @override
  void initState() {
    super.initState();
    getOrderAppointment();

  }

  @override
  void didChangeDependencies() {
    getThemeName().then((theme) {
      setState(() {
        this.theme = theme;
      });
    });

    super.didChangeDependencies();
  }

  Future<void> getPackageDetails() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(Paths.packagesPath)
          .doc(widget.order.packageId)
          .get();
      setState(() {
        package = consultPackage.fromMap(documentSnapshot.data() as Map);
        loadPackage = false;
      });
    } catch (e) {
      print("orderDetails" + e.toString());
    }
  }

  Future<void> getPromoDetails() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(Paths.promoPath)
          .doc(widget.order.promoCodeId)
          .get();
      setState(() {
        promo = PromoCode.fromMap(documentSnapshot.data() as Map);
        loadPromo = false;
      });
    } catch (e) {
      print("orderDetails" + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSnakbar(String s, bool status) {
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
    return Scaffold(backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Container(
              width: size.width,
              child: SafeArea(
                  child: Padding( padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 35,
                          width: 35,

                          child: Center(
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
                        ),
                        Text(
                          getTranslated(context, "details"),
                          textAlign:TextAlign.left,
                          style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),fontSize: 16.0,color:Colors.black.withOpacity(0.8), fontWeight: FontWeight.bold),
                        ),
                        (widget.fromSupport&&widget.order.orderStatus!="closed"&&widget.order.orderStatus!="cancel")?cancel?CircularProgressIndicator():
                        InkWell(
                          splashColor:
                          Colors.white.withOpacity(0.5),
                          onTap: () async {
                            cancelDialog(size);
                          },
                          child: Container(height: 35,width: size.width*.3,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color:  Colors.red,
                              borderRadius: BorderRadius.circular(35.0),

                            ),child:  Center(
                              child: Text(
                                getTranslated(context, "cancel"),
                                style: GoogleFonts.elMessiri(
                                  color: theme=="light"?Colors.white:Colors.black,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),),
                            ),
                          ),
                        ):SizedBox(),


                      ],
                    ),
                  ))),
          Center(
              child: Container(
                  color: AppColors.lightGrey, height: 2, width: size.width * .9)),

          // change from here this is body of screen
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Container(
                      // height: 150,
                      width: size.width * .9,
                      decoration: BoxDecoration(
                        color: theme == "light"
                            ? Colors.white
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(0.0, 1.0),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                                color: theme == "light"? AppColors.white : AppColors.grey,
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(
                                    color: AppColors.lightGrey
                                )
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    getTranslated(context, "orderDetails"),
                                    style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                      color: theme == "light"
                                          ? AppColors.pink
                                          : AppColors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height:10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, "date"),
                                      style: TextStyle(
                                        color:AppColors.greydark,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      '${dateFormat.format(widget.order.orderTimestamp.toDate())}',
                                      style: TextStyle(
                                        color: AppColors.pink,
                                        fontSize: 15.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, "price"),
                                      style: TextStyle(
                                        color:
                                        AppColors.greydark,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      widget.order.price == null
                                          ? "0"
                                          : widget.order.price.toString() +
                                          "\$",
                                      style: TextStyle(
                                        color: AppColors.pink,
                                        fontSize: 15.0,
                                      ),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, "callprice"),
                                      style: TextStyle(
                                        color:
                                        AppColors.greydark,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      double.parse(widget.order.callPrice
                                          .toString())
                                          .toStringAsFixed(3) +
                                          "\$",

                                      style: TextStyle(
                                        color: AppColors.pink,
                                        fontSize: 15.0,
                                      ),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, "packageCall"),
                                      style: TextStyle(
                                        color:
                                        AppColors.greydark,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      widget.order.packageCallNum
                                          .toString(),
                                      style: TextStyle(
                                        color: AppColors.pink,
                                        fontSize: 15.0,
                                      ),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, "answeredCall"),
                                      style: TextStyle(
                                        color:
                                        AppColors.greydark,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    loadAppointments?CircularProgressIndicator():Text(answerNum,
                                      style: TextStyle(
                                        color: AppColors.pink,
                                        fontSize: 15.0,
                                      ),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, "remainingCall"),
                                      style: TextStyle(
                                        color:
                                        AppColors.greydark,
                                        fontSize: 15.0,
                                      ),
                                    ),

                                    loadAppointments?CircularProgressIndicator(): Text(remainingNum,
                                      style: TextStyle(
                                        color: AppColors.pink,
                                        fontSize: 15.0,
                                      ),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                     getTranslated(context, "orderType"),
                                      style: TextStyle(
                                        color:
                                        AppColors.greydark,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      widget.order.consultType,
                                      style: TextStyle(
                                        color: AppColors.pink,
                                        fontSize: 15.0,
                                      ),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, "status"),
                                      style: TextStyle(
                                        color:
                                        AppColors.greydark,
                                        fontSize: 15.0,
                                      ),
                                    ),

                                    loadAppointments?CircularProgressIndicator():Text(status,//widget.order.orderStatus,
                                      style: TextStyle(
                                        color: AppColors.pink,
                                        fontSize: 15.0,
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      // height: 150,
                      width: size.width * .9,
                      decoration: BoxDecoration(
                        color: theme == "light"
                            ? Colors.white
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(0.0, 1.0),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                                color: theme == "light"? AppColors.white : AppColors.grey,
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(
                                    color: AppColors.lightGrey
                                )
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 10, right: 10),
                              child:  Text(
                                getTranslated(context, "consultDetails"),
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color: theme == "light"
                                      ? AppColors.pink
                                      : AppColors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height:10,),
                          Column(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.white, width: 1),
                                  shape: BoxShape.circle,
                                  color: theme == "light"
                                      ? AppColors.pink
                                      : Colors.white,
                                ),
                                child: widget.order.consult.image!.isEmpty
                                    ? Icon(
                                  Icons.person,
                                  color: AppColors.white,
                                  size: 40.0,
                                )
                                    : ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(100.0),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                    'assets/icons/icon_person.png',
                                    placeholderScale: 0.5,
                                    imageErrorBuilder: (context,
                                        error, stackTrace) =>
                                        Icon(
                                          Icons.person,
                                          color: Colors.black,
                                          size: 50.0,
                                        ),
                                    image: widget.order.consult.image!,
                                    fit: BoxFit.cover,
                                    fadeInDuration:
                                    Duration(milliseconds: 250),
                                    fadeInCurve: Curves.easeInOut,
                                    fadeOutDuration:
                                    Duration(milliseconds: 150),
                                    fadeOutCurve: Curves.easeInOut,
                                  ),
                                ),
                              ),
                              Text(
                                widget.order.consult.name,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color: AppColors.greydark,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                widget.order.consult.phone,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color: AppColors.greydark,
                                  fontSize: 15.0,
                                  //  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      //  height: 150,
                      width: size.width * .9,
                      decoration: BoxDecoration(
                        color: theme == "light"
                            ? Colors.white
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(0.0, 1.0),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                                color: theme == "light"? AppColors.white : AppColors.grey,
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(
                                    color: AppColors.lightGrey
                                )
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    getTranslated(context, "clientDetails"),
                                    style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                      color: theme == "light"
                                          ? AppColors.pink
                                          : AppColors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height:10,),
                          Column(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.white, width: 1),
                                  shape: BoxShape.circle,
                                  color: theme == "light"
                                      ? AppColors.pink
                                      : Colors.white,
                                ),
                                child: widget.order.user.image!.isEmpty
                                    ? Icon(
                                  Icons.person,
                                  color: AppColors.white,
                                  size: 40.0,
                                )
                                    : ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(100.0),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                    'assets/icons/icon_person.png',
                                    placeholderScale: 0.5,
                                    imageErrorBuilder: (context,
                                        error, stackTrace) =>
                                        Icon(
                                          Icons.person,
                                          color: Colors.black,
                                          size: 50.0,
                                        ),
                                    image: widget.order.consult.image!,
                                    fit: BoxFit.cover,
                                    fadeInDuration:
                                    Duration(milliseconds: 250),
                                    fadeInCurve: Curves.easeInOut,
                                    fadeOutDuration:
                                    Duration(milliseconds: 150),
                                    fadeOutCurve: Curves.easeInOut,
                                  ),
                                ),
                              ),
                              Text(
                                widget.order.user.name,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color: AppColors.greydark,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                widget.order.user.phone,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color: AppColors.greydark,
                                  fontSize: 15.0,
                                  //  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // here code of listview ................
                  Center(
                    child: Container(
                      // height: 150,
                      width: size.width * .9,
                      decoration: BoxDecoration(
                        color: theme == "light"
                            ? Colors.white
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(0.0, 1.0),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                                color: theme == "light"? AppColors.white : AppColors.grey,
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(
                                    color: AppColors.lightGrey
                                )
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    getTranslated(context, "appointments"),
                                    style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                      color: theme == "light"
                                          ? AppColors.pink
                                          : AppColors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height:10,),

                          if (loadAppointments == false &&
                              appointmentList.length == 0)
                            Center(
                              child: Text(
                                getTranslated(context, "noData"),
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              itemCount: appointmentList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                return Container(
                                    height: 50,
                                    width: size.width * .8,
                                    padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color:  AppColors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            ( appointmentList[index].appointmentStatus=="closed"||widget.fromSupport==false)?Image.asset(
                                              'assets/applicationIcons/Iconly-Two-tone-Calendar.png',
                                              width: 15,
                                              height: 15,
                                            ):loadAppointments?CircularProgressIndicator():InkWell(
                                              splashColor:
                                              Colors.white.withOpacity(0.6),
                                              onTap: () async {
                                                loadAppointments=true;
                                               await FirebaseFirestore.instance
                                                    .collection(Paths.appAppointments).doc(appointmentList[index].appointmentId)
                                                    .delete();
                                               getOrderAppointment();
                                              },
                                              child: Icon(
                                                Icons.delete_outline,
                                                color: AppColors.red,
                                              ),
                                            )
                                            ,
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${dateFormat.format(appointmentList[index].appointmentTimestamp.toDate())}',

                                              //appointmentList[index].appointmentTimestamp.toString().replaceAll("UTC+2", ""),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                                color: theme == "light"
                                                    ? AppColors.black
                                                    : AppColors.white,
                                                fontSize: 9.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              appointmentList[index]
                                                  .time
                                                  .hour
                                                  .toString() +
                                                  ":" +
                                                  appointmentList[index]
                                                      .time
                                                      .minute
                                                      .toString() + "${appointmentList[index].time.hour > 12? "PM": "AM"}"
                                              ,
                                              style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                                color: AppColors.pink,
                                                fontSize: 9.0,
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 30,
                                          height: 15,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: AppColors.pink)
                                          ),
                                          child: Text(
                                            appointmentList[index].appointmentStatus,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                              color: AppColors.pink,
                                              fontSize: 9.0,
                                              //fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        appointmentList[index].appointmentStatus ==
                                            "closed"
                                            ? InkWell(
                                          splashColor:
                                          Colors.white.withOpacity(0.6),
                                          onTap: () {
                                            showReview(
                                                size,
                                                appointmentList[index]
                                                    .appointmentId);
                                          },
                                          child: Icon(
                                            Icons.star,
                                            color: AppColors.yellow,
                                          ),
                                        )
                                            : SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ));
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 8.0,
                                );
                              },
                            )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  cancelDialog(Size size) {
    return showDialog(
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        contentPadding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
        content: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                getTranslated(context, "cancel"),
                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                getTranslated(context, "cancelOrder"),
                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 50.0,
                    child: MaterialButton(
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        getTranslated(context, 'no'),
                        style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                          color: Colors.black87,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 50.0,
                    child: MaterialButton(
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () async {
                        Navigator.pop(context);
                        setState(() {
                          cancel=true;
                        });
                        print("cancelOrder");
                        QuerySnapshot querySnapshot = await  FirebaseFirestore.instance.collection(Paths.usersPath)
                            .where( 'uid', isEqualTo: widget.order.user.uid, ).limit(1).get();
                        if(querySnapshot!=null&&querySnapshot.docs.length!=0&&status!="cancel") {
                          var userSearch = GroceryUser.fromMap(querySnapshot.docs[0].data() as Map);
                          var price=0.0;
                          print("cancelOrder1");
                          print(widget.order.orderId);
                         var value= await FirebaseFirestore.instance
                              .collection(Paths.appAppointments)
                              .where( 'orderId', isEqualTo: widget.order.orderId,)
                              .where( 'appointmentStatus', isEqualTo: "closed",)
                              .get();
                            if(value.docs.length>0) {
                              print(value.docs.length);
                              price =(widget.order.packageCallNum - value.docs.length)*widget.order.callPrice;
                              print("cancelOrder1");
                              print(price);
                            }
                            else {
                              price =double.parse(((widget.order.packageCallNum)*widget.order.callPrice).toString());
                              print("cancelOrder2");
                              print(price);
                            }
                            dynamic balance=double.parse(price.toString());
                            print("cancelOrder3");
                            print(balance);
                            if(userSearch.balance!=null)
                            {
                              balance=userSearch.balance!+balance;
                              userSearch.balance=balance;
                            }
                            print("cancelOrder4");
                            print(balance);
                            await FirebaseFirestore.instance.collection(Paths.usersPath).doc(userSearch.uid).set({
                              'balance': balance,
                            }, SetOptions(merge: true));
                            print("cancelOrder5");
                            print(balance);
                            //update payment history
                            await FirebaseFirestore.instance.collection(Paths.userPaymentHistory).doc(Uuid().v4()).set({
                              'userUid': userSearch.uid,
                              'payType': "refund",
                              'payDate': Timestamp.now(), //FieldValue.serverTimestamp(),
                              'payDateValue':Timestamp.now().millisecondsSinceEpoch,
                              'amount':price.toString(),
                              'otherData': {
                                'uid': "fuHfYYjTmRf7rjkyIhxrqp1pPJ32",
                                'name': "Make My Nikah",
                                'image': "",
                                'phone': "..",
                              },
                            });
                            //cancel order
                            await FirebaseFirestore.instance.collection(Paths.ordersPath).doc(widget.order.orderId).set({
                              'orderStatus': "cancel",
                            }, SetOptions(merge: true));
                            //cancel allAppontment
                            var querySnapshot2 = await FirebaseFirestore.instance.collection(Paths.appAppointments)
                                .where('orderId', isEqualTo:widget.order.orderId)
                                .where('appointmentStatus', whereIn:['new','open'])
                                .get();
                            for (var doc in querySnapshot2.docs) {
                              await FirebaseFirestore.instance.collection(Paths.appAppointments).doc(doc.id).set({
                                'appointmentStatus':'cancel',
                              }, SetOptions(merge: true));
                            }




                        }
                        setState(() {
                          cancel=false;
                          status="cancel";
                          widget.order.orderStatus="cancel";
                        });
                        //
                      },
                      child: Text(
                        getTranslated(context, 'yes'),
                        style: GoogleFonts.cairo(
                          color: Colors.red.shade700,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }

  void showNoNotifSnack(String text, bool status) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(7),
      backgroundColor: status ? Colors.green.shade500 : Colors.red.shade500,
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
        color: theme == "light" ? Colors.white : Colors.black,
      ),
      messageText: Text(
        '$text',
        style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: theme == "light" ? Colors.white : Colors.black,
        ),
      ),
    )..show(context);
  }

  Future<void> getOrderAppointment() async {
    try{
      int answer=0,remain=0;
      loadAppointments=true;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Paths.appAppointments)
          .where( 'orderId', isEqualTo: widget.order.orderId)
          .get();
      QuerySnapshot querySnapshotClosed = await FirebaseFirestore.instance
          .collection(Paths.appAppointments)
          .where( 'orderId', isEqualTo: widget.order.orderId)
          .where( 'appointmentStatus', isEqualTo: "closed")
          .get();
      if(querySnapshot.docs.length>0)
      {
        var list=  List<AppAppointments>.from(
          querySnapshot.docs.map(
                (snapshot) => AppAppointments.fromMap(snapshot.data() as Map),  ),);

        setState(() {
          remainingNum=(widget.order.packageCallNum-querySnapshot.docs.length)>0?
            (widget.order.packageCallNum-querySnapshot.docs.length).toString()
              : "0";
          appointmentList = list;
          answerNum=querySnapshotClosed.docs.length.toString();
          status=querySnapshotClosed.docs.length>=widget.order.packageCallNum?"closed":
          querySnapshot.docs.length>=widget.order.packageCallNum?"completed":"open";
          loadAppointments=false;
        });
      }
      else{
        setState(() {
          appointmentList=[];
          remainingNum=widget.order.packageCallNum.toString();
          answerNum="0";
          status="open";
          loadAppointments=false;
        });
      }
print("hhhhhh");
      await FirebaseFirestore.instance.collection(Paths.ordersPath).doc(widget.order.orderId).update({
        'answeredCallNum': querySnapshotClosed.docs.length,
        'remainingCallNum':int.parse(remainingNum),
        'orderStatus':status,
      });
      print("hhhhhh11");
    }catch(e){
      print("getnumbererror"+e.toString());
    }
  }
  errorLog(String function,String error)async {
    String id = Uuid().v4();
    await FirebaseFirestore.instance.collection(Paths.errorLogPath)
        .doc(id)
        .set({
      'timestamp': Timestamp.now(),
      'id': id,
      'seen': false,
      'desc': error,
      'phone': "support",
      'screen': "orderDetailsScreen",
      'function': function,
    });
  }
  showReview(Size size, String appointmentId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Paths.consultReviewsPath)
        .where('appointmentId', isEqualTo: appointmentId)
        .get();
    if (querySnapshot.docs.length > 0) {
      setState(() {
        review = List<ConsultReview>.from(
          querySnapshot.docs.map(
                (snapshot) => ConsultReview.fromMap(snapshot.data() as Map),
          ),
        )[0];
        loadReview = false;
      });
    } else
      setState(() {
        review = null;
        loadReview = false;
      });

    return showDialog(
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        contentPadding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              getTranslated(context, "Reviews"),
              style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            (loadReview == true)
                ? Center(child: CircularProgressIndicator())
                : (loadReview == false && review != null)
                ? Container(
              //height: 90,width: size.width,
                padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10),
                color: theme == "light" ? Colors.white : Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border:
                        Border.all(color: Colors.black, width: 2),
                        shape: BoxShape.circle,
                        color: theme == "light"
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: review!.image.isEmpty
                          ? Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 45.0,
                      )
                          : ClipRRect(
                        borderRadius:
                        BorderRadius.circular(100.0),
                        child: FadeInImage.assetNetwork(
                          placeholder:
                          'assets/icons/icon_person.png',
                          placeholderScale: 0.5,
                          imageErrorBuilder:
                              (context, error, stackTrace) =>
                              Icon(
                                Icons.person,
                                color: Colors.black,
                                size: 45.0,
                              ),
                          image: review!.image,
                          fit: BoxFit.cover,
                          fadeInDuration:
                          Duration(milliseconds: 250),
                          fadeInCurve: Curves.easeInOut,
                          fadeOutDuration:
                          Duration(milliseconds: 150),
                          fadeOutCurve: Curves.easeInOut,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2, right: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review!.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                              color: Theme.of(context).primaryColor,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.star,
                                size: 13,
                                color: Colors.orange,
                              ),
                              Text(
                                "8",//review.rating.toStringAsFixed(1),
                                textAlign: TextAlign.start,
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            review!.review,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                              color: Theme.of(context).primaryColor,
                              fontSize: 13.0,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))
                : Center(
              child: Text(
                getTranslated(context, "noReviews"),
                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                  color: Colors.black87,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: Container(
                width: size.width * .5,
                child: MaterialButton(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  padding: const EdgeInsets.all(0.0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    getTranslated(context, 'Ok'),
                    style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                      color: Colors.black87,
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
      ),
      barrierDismissible: false,
      context: context,
    );
  }
}

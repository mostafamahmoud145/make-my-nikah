

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/models/user.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../models/consultDays.dart';
import '../models/consultPackage.dart';
import '../models/consultReview.dart';
import '../models/order.dart';

import '../screens/reportScreen.dart';
class ReviewDialog extends StatefulWidget {
  final String consultId;
  final String userId;
  final String appointmentId;
  ReviewDialog({required this.consultId, required this.userId, required this.appointmentId});

  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  bool load=true, adding=false,report=false;
  late GroceryUser consult,user;
  dynamic seriousRating=0.0,
      politeRating=0.0,
      exceptRating=0.0,
      appropriateRating=0.0;

  String name="....",image="",rateDescription = "";
  @override
  void initState() {
    super.initState();
    getConsultDetails();

  }
  Future<void> getConsultDetails() async {
    DocumentReference docRef = FirebaseFirestore.instance.collection(Paths.usersPath).doc(widget.consultId);
    final DocumentSnapshot documentSnapshot = await docRef.get();

    DocumentReference docRef2 = FirebaseFirestore.instance.collection(Paths.usersPath).doc(widget.userId);
    final DocumentSnapshot documentSnapshot2 = await docRef2.get();
    setState(() {
      consult= GroceryUser.fromMap(documentSnapshot.data() as Map);

      name=consult.name!;
      image=consult.photoUrl!;

      seriousRating = (consult.serious==null)?0.0:consult.serious;
      politeRating = (consult.polite==null)?0.0:consult.polite;
      exceptRating = (consult.exceptional==null)?0.0:consult.exceptional;
      appropriateRating = (consult.appropriate==null)?0.0:consult.appropriate;

      user=GroceryUser.fromMap(documentSnapshot2.data() as Map);
      print("userdata");
      print(user.name);
      load=false;
    });

  }

  @override
  Widget build(BuildContext context) {
    String star=getTranslated(context, "stars");
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 5.0,
      contentPadding: EdgeInsets.all(0),
      content: Container(
        height: size.height * 0.5,
        width: double.maxFinite,
        constraints: BoxConstraints.loose(size),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Container(
                width: size.width,
                child: SafeArea(
                    child: Padding( padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 35,
                            width: 35,

                            child: Center(
                              child: IconButton(
                                  onPressed: () {

                                    Navigator.pop(context);
                                  },
                                  icon: Image.asset("assets/icons/icon/Group2891.png",width: 13,height: 13,)
                              ),
                            ),
                          ),



                        ],
                      ),
                    ))),
            load?Center(child: CircularProgressIndicator()):Expanded(
              child: ListView(physics:  AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(40),
                children: [
                  Center(
                      child:  Image.asset("assets/icons/icon/Group2885.png",width: 192,height: 144,)
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: Text(
                      getTranslated(context, "rateConsult"),
                      style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                          fontSize: 18.0,
                          color:AppColors.balck2,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(getTranslated(context, "Serious"),style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily",),
                          fontSize: 14,
                          color: AppColors.black),),
                      RatingBar(
                        initialRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 15,
                        ratingWidget: RatingWidget(
                          full: Image.asset("assets/icons/icon/baseline-favorite-2.png",width: 13,height: 13,),
                          half: Image.asset("assets/icons/icon/baseline-favorite-1.png",width: 13,height: 13,),
                          empty: Image.asset("assets/icons/icon/baseline-favorite-3.png",width: 13,height: 13),
                        ),
                        onRatingUpdate: (rating) {
                          seriousRating = rating;
                          print("seious = $seriousRating");
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(getTranslated(context, "polite"),style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily",),
                          fontSize: 14,
                          color: AppColors.black),),
                      RatingBar(
                        initialRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 15,
                        ratingWidget: RatingWidget(
                          full: Image.asset("assets/icons/icon/baseline-favorite-2.png",width: 13,height: 13,),
                          half: Image.asset("assets/icons/icon/baseline-favorite-1.png",width: 13,height: 13,),
                          empty: Image.asset("assets/icons/icon/baseline-favorite-3.png",width: 13,height: 13),
                        ),
                        onRatingUpdate: (rating) {

                          politeRating = rating;

                          print("polite = $politeRating");
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(getTranslated(context, "exceptional"),style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily",),
                          fontSize: 14,
                          color: AppColors.black),),
                      RatingBar(
                        initialRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 15,
                        ratingWidget: RatingWidget(
                          full: Image.asset("assets/icons/icon/baseline-favorite-2.png",width: 13,height: 13,),
                          half: Image.asset("assets/icons/icon/baseline-favorite-1.png",width: 13,height: 13,),
                          empty: Image.asset("assets/icons/icon/baseline-favorite-3.png",width: 13,height: 13),
                        ),
                        onRatingUpdate: (rating) {
                          exceptRating = rating;

                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(getTranslated(context, "appropriate"),style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily",),
                          fontSize: 14,
                          color: AppColors.black),),
                      RatingBar(
                        initialRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 15,
                        ratingWidget: RatingWidget(
                          full: Image.asset("assets/icons/icon/baseline-favorite-2.png",width: 13,height: 13,),
                          half: Image.asset("assets/icons/icon/baseline-favorite-1.png",width: 13,height: 13,),
                          empty: Image.asset("assets/icons/icon/baseline-favorite-3.png",width: 13,height: 13),
                        ),
                        onRatingUpdate: (rating) {
                          appropriateRating = rating;

                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: size.height * 0.2,
                    width: size.width * 0.8,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: AppColors.grey3,width: 0.3),

                    ),
                    child: Center(
                      child:Container(width: size.width*.7,
                        child: TextField(
                          maxLines: 7,
                          maxLength: 152,
                          style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),fontSize: 13.0,color:AppColors.black, ),
                          cursorColor: Colors.black,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value)
                          {
                            setState(() {
                              rateDescription = value;
                            });
                          },
                          decoration: new InputDecoration(
                            counterStyle: TextStyle( color: Colors.grey,
                              fontSize: 13,),
                            hintStyle: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                              color: Colors.grey,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                            hintText: getTranslated(context,'description'),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,

                            //  hintText: sLabel
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  Center(
                    child: adding?CircularProgressIndicator():SizedBox(
                      height:50,
                      width: size.width * 0.8,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppColors.greendark2,
                                  AppColors.red1
                                ]
                            )
                        ),
                        height: 45,
                        child: MaterialButton(
                          onPressed: () async {

                            if (seriousRating > 0.0 && politeRating > 0.0 && exceptRating > 0.0 && appropriateRating > 0.0) {
                              //proceed
                              addReview();
                            }

                            else
                              showSnack(getTranslated(context, "completerate"),context);
                          },
                          //   color: AppColors.red1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(getTranslated(context, "submit"),
                            style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                              color: AppColors.black,
                              fontSize: 14.0,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  report?Center(child: CircularProgressIndicator()):TextButton(onPressed: () async {
                    setState(() {
                      report=true;
                    });
                    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                        .collection(Paths.complaintsPath)
                        .where( 'uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid )
                        .where( 'appointmentId', isEqualTo: widget.appointmentId )
                        .get();
                    setState(() {
                      report=false;
                    });
                    if(querySnapshot.size>0)
                    {
                      showSnack(getTranslated(context, "ratedbefor"),context);

                    }
                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ReportScreen(user: this.user,consult: this.consult,appointmentId: widget.appointmentId,)
                        ),
                      );
                    }
                  }, child: Text(getTranslated(context, "report"),style: TextStyle(
                      fontFamily: getTranslated(context, "fontFamily"),
                      color: AppColors.reddark2,
                      fontSize: 16
                  ),))
                ],
              ),
            ),

          ]),
        ),
      ),
    );
  }
  //-----------
  Future<void> addReview()async {
    setState(() {
      adding=true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Paths.consultReviewsPath)
        .where( 'uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid )
        .where( 'appointmentId', isEqualTo: widget.appointmentId )
        .get();
    if(querySnapshot.size>0)
    {
      showSnack(getTranslated(context, "ratedbefor"),context);
      setState(() {
        adding=false;
      });
    }
    else{
      String reviewId=Uuid().v4();
      try {
        double review = (seriousRating + politeRating + exceptRating + appropriateRating) / 4;
        await FirebaseFirestore.instance.collection(Paths.consultReviewsPath).doc(reviewId).set({
          'serious': double.parse((seriousRating.toString())),
          'polite': double.parse((politeRating.toString())),
          'exceptional': double.parse((exceptRating.toString())),
          'appropriate': double.parse((appropriateRating.toString())),
          'review': review.toString(),
          'description': rateDescription,
          'uid': user.uid,
          'name': user.name,
          'image': user.photoUrl,
          'consultUid': consult.uid,
          'appointmentId':widget.appointmentId,
          'reviewTime':Timestamp.now(),
          'consultName': consult.name,
          'consultImage': consult.photoUrl,
        }
        );
        //update user review
        List<ConsultReview> reviews;
        try {
          QuerySnapshot snap = await FirebaseFirestore.instance
              .collection(Paths.consultReviewsPath)
              .where('consultUid', isEqualTo: consult.uid)
              .get();

          reviews = List<ConsultReview>.from(
            (snap.docs).map(
                  (e) => ConsultReview.fromMap(e.data() as Map),
            ),
          );
          double seriousRating=0,politeRating=0,exceptionalRating=0,appropriateRating=0;
          if (reviews.length > 0) {
            for (var review in reviews) {
              seriousRating = seriousRating + double.parse(review.serious.toString());
              politeRating = politeRating + double.parse(review.polite.toString());
              exceptionalRating = exceptionalRating + double.parse(review.exceptional.toString());
              appropriateRating = appropriateRating + double.parse(review.appropriate.toString());
            }
            seriousRating = seriousRating / reviews.length;
            politeRating = politeRating / reviews.length;
            exceptionalRating = exceptionalRating / reviews.length;
            appropriateRating = appropriateRating / reviews.length;

            seriousRating=double.parse((seriousRating.toStringAsFixed(1)));
            politeRating=double.parse((politeRating.toStringAsFixed(1)));
            exceptionalRating=double.parse((exceptionalRating.toStringAsFixed(1)));
            appropriateRating=double.parse((appropriateRating.toStringAsFixed(1)));

            await FirebaseFirestore.instance.collection(Paths.usersPath).doc(consult.uid).set({
              'serious': seriousRating,
              'polite': politeRating,
              'exceptional': exceptionalRating,
              'appropriate': appropriateRating,
              'reviewsCount':reviews.length,

            }, SetOptions(merge: true));
          }
          setState(() {
            adding=false;
          });
          Navigator.pop(context);
        } catch (e) {
          print("reviewwwwww"+e.toString());
        }
      } catch (e) {
        print("reviewwwwww222"+e.toString());
      }
    }

  }

  void showSnack(String text, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(7),
      backgroundColor: Colors.green.shade500,
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
}

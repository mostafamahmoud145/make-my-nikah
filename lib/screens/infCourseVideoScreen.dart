/*

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../models/InfCourse.dart';
import '../models/InfCourse.dart';
import '../models/Influencer.dart';
import '../models/infCourseVideo.dart';
import '../models/user.dart';
import '../widget/infVideoItem.dart';


/// Homepage
class InfCourseVideosScreen extends StatefulWidget {
  final Influencer influencer;
  final InfCourses course;
  final String? loggedUserId;
  const InfCourseVideosScreen({Key? key,  required this.influencer,  required this.course,  this.loggedUserId}) : super(key: key);
  @override
  _InfCourseVideosScreenState createState() => _InfCourseVideosScreenState();
}

class _InfCourseVideosScreenState extends State<InfCourseVideosScreen> with SingleTickerProviderStateMixin {
  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
  bool buy=false;
  @override
  void initState() {
    updateViewCount();
    super.initState();

  }
  updateViewCount() async {
      await  FirebaseFirestore.instance.collection(Paths.infCoursesPath).doc(widget.course.courseId).update(
        {
         "views":FieldValue.increment(1),
        },
      );
    }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery .of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body:  Stack(children: [
        Column(
          children: <Widget>[
            Container(
                width: size.width,
                child: SafeArea(
                    child: Padding( padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
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
                          Container( width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              //border: Border.all(color: AppColors.black2)
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35.0),
                              child: widget.influencer.image == "" ? Image.asset("assets/icons/icon/im2.jpeg", width: 35,
                                height: 35,) : Image.network(widget.influencer.image),
                            ),
                          )

                        ],
                      ),
                    ))),
            Center( child: Container(  color: AppColors.white3, height: 1, width: size.width )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(widget.course.name,
                maxLines:3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color.fromRGBO(211, 211, 211,1),
                    fontSize: 19,
                    fontFamily: getTranslated(context, "fontFamily")
                ),),
            ),
            Expanded(
              child: RefreshIndicator(
                child: PaginateFirestore(
                  separator:SizedBox(height: 20,),
                  itemBuilderType: PaginateBuilderType.listView,
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),//Change types accordingly
                  itemBuilder: ( context, documentSnapshot,index) {
                    return  InfVideoItem(
                        video:  InfCourseVideo.fromMap(documentSnapshot[index].data() as Map),
                        influencer: widget.influencer,
                        course: widget.course,
                        loggedUserId:widget.loggedUserId!

                    );

                  },
                  query: FirebaseFirestore.instance.collection(Paths.infCourseVideosPath)
                      .where('courseId', isEqualTo: widget.course.courseId)
                      .where('active', isEqualTo: true)
                      .orderBy('order', descending: false),
                  listeners: [
                    refreshChangeListener,
                  ],
                  isLive: true,
                ),
                onRefresh: () async {
                  refreshChangeListener.refreshed = true;
                },
              ),
            )
          ],
        ),
        if(widget.course.price!="0.0"&&(!(widget.course.paidUsers.contains(widget.loggedUserId))))
          Positioned(
          left: 0,
          right: 0,
          bottom: 40,
          child: buy
              ? Center(child: CircularProgressIndicator())
              : Center(
                 child: InkWell(
                    onTap: () async {
                      if(widget.loggedUserId==null)
                        Navigator.pushNamed(context, '/Register_Type');
                      else if(widget.course.paidUsers.contains(widget.loggedUserId)){
                        Fluttertoast.showToast(
                            msg: getTranslated(context, "paidDone"),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      else {
                        setState(() {
                          buy = true;
                        });
                        stripePayment(email: widget.loggedUserId! + "@gmail.com",
                            amount: double.parse(widget.course.price)* 100.0,
                            context: context); //300
                      }

                    },
                    child: Container(
                width: MediaQuery.of(context).size.width * .6,
                height: 45.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: AppColors.green1,
                ),
                child: Center(
                  child: Text(
                    getTranslated(context, "buy"),
                    style: TextStyle(
                        fontFamily:
                        getTranslated(context, "fontFamily"),
                        color: AppColors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
          ),
        ),
      ])

    );
  }

  Future<void> stripePayment( { required String email, required double amount, required BuildContext context}) async {
    try {
      setState(() {
        buy=true;
      });
      DocumentReference docRef = FirebaseFirestore.instance.collection(Paths.usersPath).doc(widget.loggedUserId);
      final DocumentSnapshot documentSnapshot = await docRef.get();
      String payWith="balance";
      var user= GroceryUser.fromMap(documentSnapshot.data() as Map);
      if(user.balance>=double.parse(widget.course.price)){
        var newBalance=user.balance-double.parse(widget.course.price);
        await FirebaseFirestore.instance.collection(Paths.usersPath).doc(user.uid).set({
          'balance': newBalance,
        }, SetOptions(merge: true));
      }
      else{
        email=email.trim().replaceAll(' ', '');
        final response = await http.post(
            Uri.parse(
                'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/stripePaymentIntentRequest'),
            body: {
              'email': email,
              'amount': amount.toString(),//"100"
            });
        final jsonResponse = jsonDecode(response.body);
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: jsonResponse['paymentIntent'],
              customerId: jsonResponse['customer'],
              customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
              testEnv: false,
              applePay: true,
              googlePay: true,
              merchantDisplayName: "Make My Nikah",
              merchantCountryCode: "AE",
              primaryButtonColor: AppColors.red1,
            ));
        await Stripe.instance.presentPaymentSheet();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment is successful'),
          ),
        );
        payWith="stripe";
      }

      updateDatabaseAfterBuying(user,payWith);

    } catch (error) {
      print("stripeerror");
      print(error.toString());
      if (error is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured ${error.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured $error'),
          ),
        );
      }
      setState(() {
        buy=false;
      });
    }
  }
  updateDatabaseAfterBuying(GroceryUser user,String payWith) async {
    String id=Uuid().v4();
    DateTime dateValue=DateTime.now().toUtc();
    await FirebaseFirestore.instance.collection(Paths.paidCoursesPath).doc(id).set({
      'id':id,
      'date':{
        'day': dateValue.day,
        'month': dateValue.month,
        'year': dateValue.year,
      },
      'utcTime':DateTime.now().toUtc().toString(),
      "payWith":payWith,
      "platform": Platform.isIOS ? "iOS" : "Android",
      'course': {
        'id': widget.course.courseId,
        'name': widget.course.name,
        'price': widget.course.price,
        'image': widget.course.image,
        'influencer': widget.course.influencerId,

      },
      'user': {
        'uid': user.uid,
        'name': user.name,
        'image': user.photoUrl,
        'phone': user.phoneNumber,
        'countryCode': user.countryCode,
        'countryISOCode': user.countryISOCode,

      },
    });
    widget.course.paidUsers.add(user.uid);
    await FirebaseFirestore.instance.collection(Paths.infCoursesPath).doc(widget.course.courseId).set({
      'paidUsers': widget.course.paidUsers,
    }, SetOptions(merge: true));
    setState(() {
      buy=false;
    });
  }
}*/

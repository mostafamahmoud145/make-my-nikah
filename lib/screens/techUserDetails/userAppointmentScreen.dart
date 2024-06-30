

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/techAppointmentWidget.dart';
//import 'package:paginate_firestore/paginate_firestore.dart';

import '../../FireStorePagnation/paginate_firestore.dart';
import '../../config/colorsFile.dart';

class UserAppointmentsScreen extends StatefulWidget {
  final GroceryUser user;
  final GroceryUser loggedUser;
  const UserAppointmentsScreen({Key? key, required this.user, required this.loggedUser}) : super(key: key);
  @override
  _UserAppointmentsScreenState createState() => _UserAppointmentsScreenState();
}

class _UserAppointmentsScreenState extends State<UserAppointmentsScreen>with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                width: size.width,
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
                            getTranslated(context, "appointments"),
                            textAlign:TextAlign.center,
                            style: TextStyle(fontWeight:FontWeight.w300,fontFamily: getTranslated(context,"fontFamily"),fontSize: 17.0,color:AppColors.balck2),
                          ),
                       SizedBox()
                        ],
                      ),
                    ))),
            Center( child: Container(  color: AppColors.white3, height: 1, width: size.width )),
            Expanded(
              child: PaginateFirestore(
                itemBuilderType: PaginateBuilderType.listView,
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                //Change types accordingly
                itemBuilder: ( context, documentSnapshot,index) {
                  return  TechAppointmentWiget(
                    appointment: AppAppointments.fromMap(documentSnapshot[index].data() as Map),
                    loggedUser: widget.loggedUser, user: null,);
                },
                query: widget.user.userType=="USER"?FirebaseFirestore.instance.collection(Paths.appAppointments)
                    .where('user.uid', isEqualTo: widget.user.uid)
                    .orderBy('secondValue', descending: true):
                FirebaseFirestore.instance.collection(Paths.appAppointments)
                    .where('consult.uid', isEqualTo: widget.user.uid)
                    .orderBy('secondValue', descending: true),
                isLive: true,
              ),
            )

          ],
        ),

      ]),
    );
  }
}

/*


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/api/arabicPdf.dart';
import 'package:grocery_store/api/pdf_api.dart';
import 'package:grocery_store/api/pdf_paragraph_api.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/InfCourse.dart';
import 'package:grocery_store/models/Influencer.dart';
import 'package:grocery_store/models/payHistory.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/models/userPaymentHistory.dart';
import 'package:grocery_store/screens/table.dart';
import 'package:grocery_store/widget/button_widget.dart';
import 'package:grocery_store/widget/techAppointmentWidget.dart';
import 'package:grocery_store/widget/userPaymentHistoryListItem.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../config/colorsFile.dart';
import '../widget/infCourseItem.dart';
import '../widget/interviewListItem.dart';

class infCoursesScreen extends StatefulWidget {
  final Influencer influencer;
  final String? loggedUserId;

  const infCoursesScreen({Key? key, required this.influencer, this.loggedUserId}) : super(key: key);
  @override
  _infCoursesScreenState createState() => _infCoursesScreenState();
}

class _infCoursesScreenState extends State<infCoursesScreen>with SingleTickerProviderStateMixin {
  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery .of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body:  Column(
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
            child: Text(getTranslated(context, "courses"),style: TextStyle(
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
                  return  InfCourseItem(
                    influencer:widget.influencer,
                    course:  InfCourses.fromMap(documentSnapshot[index].data() as Map),
                    loggedUserId:widget.loggedUserId!,
                  );

                },
                query: FirebaseFirestore.instance.collection(Paths.infCoursesPath)
                    .where('influencerId', isEqualTo: widget.influencer.id)
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
    );
  }
}
*/

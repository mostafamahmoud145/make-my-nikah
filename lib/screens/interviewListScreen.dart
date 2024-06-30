

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/FireStorePagnation/bloc/pagination_listeners.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
//import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import '../FireStorePagnation/paginate_firestore.dart';
import '../config/colorsFile.dart';
import '../widget/interviewListItem.dart';

class InterviewListScreen extends StatefulWidget {
 final GroceryUser loggedUser;

  const InterviewListScreen({Key? key, required this.loggedUser}) : super(key: key);
  @override
  _InterviewListScreenState createState() => _InterviewListScreenState();
}

class _InterviewListScreenState extends State<InterviewListScreen>with SingleTickerProviderStateMixin {
  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
  late Query filterQuery;

  @override
  void initState() {
    super.initState();
      filterQuery= FirebaseFirestore.instance.collection(Paths.usersPath)
          .where('userType', isEqualTo: "CONSULTANT")
          .where('accountStatus', isEqualTo: "NotActive")
           .where('profileCompleted', isEqualTo: true)
           .orderBy('createdDate', descending: true);


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
                          getTranslated(context, "interviews"),
                          textAlign:TextAlign.left,
                          style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),fontSize: 17.0,color:AppColors.balck2,fontWeight: FontWeight.w300),
                        ),

                      ],
                    ),
                  ))),
          Center( child: Container(  color: AppColors.white3, height: 1, width: size.width )),
          Expanded(
            child: RefreshIndicator(
              child: PaginateFirestore(
                key: ValueKey(filterQuery),
                itemBuilderType: PaginateBuilderType.listView,
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),//Change types accordingly
                itemBuilder: ( context, documentSnapshot,index) {
                  return  InterviewListItem(
                    size:size,
                    loggedUser:widget.loggedUser,
                    user: GroceryUser.fromMap(documentSnapshot[index].data() as Map),
                  );

                },
                query: filterQuery,
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

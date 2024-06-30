

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/FireStorePagnation/paginate_firestore.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/generalNotifications.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/push_notifications_screens/sendNotificationScreen.dart';
import 'package:grocery_store/widget/generalNotificationItem.dart';
//import '../FireStorePagnation/paginate_firestore.dart';
class AllSendedNotificationSreen extends StatefulWidget {
  @override
  _AllSendedNotificationSreenState createState() => _AllSendedNotificationSreenState();
}

class _AllSendedNotificationSreenState extends State<AllSendedNotificationSreen>with SingleTickerProviderStateMixin {
  final TextEditingController searchController = new TextEditingController();
  bool load=false;
  String? lang,userImage,theme;
  String name ="";
  late Query filterQuery;
  @override
  void initState() {
    super.initState();

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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                width: size.width,child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                  child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        getTranslated(context, "notification"),
                        textAlign:TextAlign.left,
                        style: TextStyle(fontWeight:FontWeight.w300,fontFamily: getTranslated(context,"fontFamily"),fontSize: 17.0,color:AppColors.balck2),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white.withOpacity(0.6),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SendNotificationScreen(), ),);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              width: 38.0,
                              height: 35.0,
                              child: Icon(
                                Icons.add_circle_outline,
                                color:Colors.black,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))),

            Center( child: Container(  color: AppColors.white3, height: 1, width: size.width )),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0),
                ),
              ),

            ),
            SizedBox(height: 10,),
            Expanded(
              child: PaginateFirestore(
                itemBuilderType: PaginateBuilderType.listView,
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),//Change types accordingly
                itemBuilder: ( context, documentSnapshot,index) {
                  return  GeneralNotificationItem(
                    item: GeneralNotifications.fromMap(documentSnapshot[index].data() as Map),
                  );

                },
                query: FirebaseFirestore.instance.collection(Paths.generalNotificationsPath)
                    .orderBy('notificationTimestamp', descending: true),
                // to fetch real-time data
                isLive: true,
              ),
            ),

          ],
        ),

      ]),
    );
  }


}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/models/userPaymentHistory.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/techAppointmentWidget.dart';
import 'package:grocery_store/widget/userPaymentHistoryListItem.dart';
import '../FireStorePagnation/paginate_firestore.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../widget/IconButton.dart';

class UserPaymentHistoryScreen extends StatefulWidget {
  final GroceryUser user;

  const UserPaymentHistoryScreen({Key? key, required this.user})
      : super(key: key);
  @override
  _UserPaymentHistoryScreenState createState() =>
      _UserPaymentHistoryScreenState();
}

class _UserPaymentHistoryScreenState extends State<UserPaymentHistoryScreen>
    with SingleTickerProviderStateMixin {
  String theme = "light";
  @override
  void initState() {
    super.initState();
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
              width: size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                  child: Container(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        /*  IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset(
                            getTranslated(context, "back"),
                            width: 30,
                            height: 30,
                          ),
                        ),*/
                        IconButton1(
                          onPress: () {
                            Navigator.pop(context);
                          },
                          Width: AppSize.w53_3.w,
                          Height: AppSize.h53_3.h,
                          ButtonBackground: AppColors.white,
                          BoxShape1: BoxShape.circle,
                          Icon: AssetsManager.blackIosArrowLeftIconPath
                              .toString(),
                          IconWidth: AppSize.w28_4.w,
                          IconHeight: AppSize.h28_4.h,
                          IconColor: AppColors.black,
                        ),
                        Text(
                          getTranslated(context, "paymentHistory"),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: PaginateFirestore(
                itemBuilderType: PaginateBuilderType.listView,
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                //Change types accordingly
                itemBuilder: (context, documentSnapshot, index) {
                  return UserPaymentHistoryListItem(
                    history: UserPaymentHistory.fromMap(
                        documentSnapshot[index].data() as Map),
                  );
                },
                query: FirebaseFirestore.instance
                    .collection(Paths.userPaymentHistory)
                    .where('userUid', isEqualTo: widget.user.uid)
                    .orderBy('payDateValue', descending: true),
                isLive: true,
              ),
            )
          ],
        ),
      ]),
    );
  }
}

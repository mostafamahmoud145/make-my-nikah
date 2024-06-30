import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/models/userPaymentHistory.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/userPaymentHistoryListItem.dart';

import '../../../../FireStorePagnation/paginate_firestore.dart';

class HistoryWallet extends StatelessWidget {
  const HistoryWallet({
    super.key,
    required this.loggedUser,
  });
  final GroceryUser loggedUser;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PaginateFirestore(
        itemBuilderType: PaginateBuilderType.listView,
        onEmpty: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                getTranslated(context, "noAppointment"),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: AppColors.darkGrey,
                    fontFamily: getTranslated(context, "Montserratmedium"),
                    fontSize: AppFontsSizeManager.s26_6.sp),
              )
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p24.w,
        ),
        //Change types accordingly
        itemBuilder: (context, documentSnapshot, index) {
          print(loggedUser.uid);
          return UserPaymentHistoryListItem(
            history: UserPaymentHistory.fromMap(
                documentSnapshot[index].data() as Map),
          );
        },
        query: FirebaseFirestore.instance
            .collection(Paths.userPaymentHistory)
            .where('userUid', isEqualTo: loggedUser.uid)
            .orderBy('payDateValue', descending: true),
        isLive: true,
      ),
    );
  }
}

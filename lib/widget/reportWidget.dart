import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:timelines/timelines.dart';

import '../models/report.dart';
import '../screens/reportDetails.dart';

class ReportWidget extends StatelessWidget {
  final Report report;
  final GroceryUser loggedUser;

  ReportWidget({
    required this.report,
    required this.loggedUser,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ReportDetail(report: this.report, loogedUser: loggedUser),
              ),
            );
          },
          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.1,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.grey3)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.name!,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.black,
                          fontFamily: getTranslated(context, "fontFamily")),
                    ),
                    Row(
                      children: [
                        Text(
                          getTranslated(context, "complaintdate"),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppColors.reddark2,
                              fontSize: 8,
                              fontFamily: getTranslated(context, "fontFamily")),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            report.complaintTime!.toDate().day.toString() +
                                "/" +
                                report.complaintTime!
                                    .toDate()
                                    .month
                                    .toString() +
                                "/" +
                                report.complaintTime!.toDate().year.toString(),
                            style: TextStyle(
                                color: AppColors.grey2,
                                fontSize: 8,
                                fontFamily:
                                    getTranslated(context, "fontFamily")))
                      ],
                    )
                  ],
                ),

                InkWell(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1),
                      color: AppColors.reddark2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.arrow_forward_outlined,
                      color: AppColors.white,
                      size: 20,
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
// void showSnack(String text, BuildContext context) {
//   Flushbar(
//     margin: const EdgeInsets.all(8.0),
//     borderRadius: BorderRadius.circular(7),
//     backgroundColor: Colors.green.shade500,
//     animationDuration: Duration(milliseconds: 300),
//     isDismissible: true,
//     boxShadows: [
//       BoxShadow(
//         color: Colors.black12,
//         spreadRadius: 1.0,
//         blurRadius: 5.0,
//         offset: Offset(0.0, 2.0),
//       )
//     ],
//     shouldIconPulse: false,
//     duration: Duration(milliseconds: 2000),
//     icon: Icon(
//       Icons.error,
//       color: Colors.white,
//     ),
//     messageText: Text(
//       '$text',
//       style: GoogleFonts.poppins(
//         fontSize: 14.0,
//         fontWeight: FontWeight.w500,
//         letterSpacing: 0.3,
//         color: Colors.white,
//       ),
//     ),
//   )..show(context);
// }

}

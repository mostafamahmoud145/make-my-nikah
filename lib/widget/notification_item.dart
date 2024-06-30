
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/models/user_notification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/screens/AppointmentChatScreen.dart';
import 'package:grocery_store/screens/addReviewScreen.dart';
import 'package:grocery_store/screens/generalNotificationScreen.dart';
import 'package:grocery_store/screens/home_screen.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:intl/intl.dart';
import '../models/user_notification.dart' as prefix;

import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/user.dart';
import '../screens/payInfoScreen.dart';
import '../screens/interviewVideoCallScreen.dart';

class NotificationItem extends StatelessWidget {
  final Size size;
  final UserNotification userNotification;
  final int index;
  final List<prefix.Notification> notificationList;


  const NotificationItem({
    required this.size,
    required this.userNotification,
    required this.index,
    required this.notificationList,
  });

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('d MMMM y', 'en_US');
    return InkWell(
      splashColor:
      Colors.white.withOpacity(0.6),
      onTap: () async {
        try {
          print(FirebaseAuth.instance.currentUser!.uid);
          if (notificationList[index].notificationType ==
              "Review_Notification") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddReviewScreen(
                        consultId: notificationList[index].consultUid!,
                        userId: notificationList[index].userUid!,
                        appointmentId: notificationList[index].appointmentId!),
              ),
            );
          }

          else if (notificationList[index].notificationType ==
              "Appointment_Notification" &&
              notificationList[index].type == "consult")
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(notificationPage: 0,),
              ),
            );
          else if (notificationList[index].notificationType == "Nikah")
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(notificationPage: 0,),
              ),
            );
          else if (notificationList[index].notificationType ==
              "Appointment_Notification" &&
              notificationList[index].type == "user")
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(notificationPage: 1,),
              ),
            );
          else
          if (notificationList[index].notificationType == "TechnicalSupport")
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(notificationPage: 2,),
              ),
            );
          else if (notificationList[index].notificationType == "Chat") {
            DocumentReference docRef = FirebaseFirestore.instance.collection(
                Paths.usersPath).doc(notificationList[index].userUid);
            final DocumentSnapshot documentSnapshot = await docRef.get();
            var user = GroceryUser.fromMap(documentSnapshot.data() as Map);

            DocumentReference docRef2 = FirebaseFirestore.instance.collection(
                Paths.appAppointments).doc(
                notificationList[index].appointmentId);
            final DocumentSnapshot documentSnapshot2 = await docRef2.get();
            var appointment = AppAppointments.fromMap(documentSnapshot2.data() as Map);
            if (appointment.appointmentStatus != "closed" &&
                appointment.appointmentStatus != "cancel")
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AppointmentChatScreen(
                          appointment: appointment,
                          user: user
                      ),
                ),
              );
            else if (appointment.appointmentStatus != "closed")
              showSnack(getTranslated(context, "appointmentClosed"), context);
            else
              showSnack(getTranslated(context, "appointmentCanceled"), context);
          }
          else if (notificationList[index].notificationType == "Interview") {
            // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            //     fullscreenDialog: true,
            //     builder: (context) =>
            //         InterviewVideoCallScreen(
            //           userId: notificationList[index].userUid!,
            //         )));
          }

          else if (notificationList[index].notificationType == "Calling") {
            DocumentReference docRef = FirebaseFirestore.instance.collection(
                Paths.usersPath).doc(notificationList[index].userUid);
            final DocumentSnapshot documentSnapshot = await docRef.get();
            var user = GroceryUser.fromMap(documentSnapshot.data() as Map);

            DocumentReference docRef2 = FirebaseFirestore.instance.collection(
                Paths.appAppointments).doc(
                notificationList[index].appointmentId);
            final DocumentSnapshot documentSnapshot2 = await docRef2.get();
            var appointment = AppAppointments.fromMap(documentSnapshot2.data() as Map);
            if (appointment.appointmentStatus != "closed" &&
                appointment.appointmentStatus != "cancel" &&
                appointment.allowCall)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AppointmentChatScreen(
                          appointment: appointment,
                          user: user
                      ),
                ),
              );
            else if (appointment.appointmentStatus != "closed")
              showSnack(getTranslated(context, "appointmentClosed"), context);
            else
              showSnack(getTranslated(context, "appointmentCanceled"), context);
          }
          else if (notificationList[index].notificationType == "Account") {
            DocumentReference docRef = FirebaseFirestore.instance.collection(
                Paths.usersPath).doc(notificationList[index].userUid);
            final DocumentSnapshot documentSnapshot = await docRef.get();
            var user = GroceryUser.fromMap(documentSnapshot.data() as Map);

            if (user.allowEditPayinfo!)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      payInfoScreen(
                        consultUid: notificationList[index].userUid!,


                      ),
                ),
              );
            else
              showSnack(getTranslated(context, "contactSupport"), context);
          }
          else
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    GeneralNotificationScreen(
                        title: notificationList[index].notificationTitle!,
                        body: notificationList[index].notificationBody!,
                        image: notificationList[index].image,
                        link: notificationList[index].link

                      //user: user
                    ),
              ),
            );
        } catch (e) {
          print("notification error" + e.toString());
        }
      },
      child: Container(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    notificationList[index].notificationTitle!,
                    // '${notificationList[index].notificationTitle}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: getTranslated(context, "Montserratsemibold"),
                      fontSize: AppFontsSizeManager.s21_3.sp,
                      color: AppColors.pink2,
                      fontWeight: FontWeight.w600,),
                  ),
                ),
                Text(
                  '${dateFormat.format(
                      notificationList[index].timestamp!.toDate())}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: getTranslated(context, "Montserratmedium"),
                    fontSize: AppFontsSizeManager.s16.sp,
                    color: AppColors.balck2,
                    fontWeight: FontWeight.w500,),

                ),
              ],
            ),
            SizedBox(
              height: AppSize.h26_6.h,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${notificationList[index].notificationBody}',
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: getTranslated(context, "Montserrat"),
                      fontSize: AppFontsSizeManager.s18_6.sp,
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w400,),
                  ),
                ),
              ],
            ),
            SizedBox(
              height:AppSize.h30_6.h ,
            ),
        Container(
          width: size.width,
          height: AppSize.h1.h,
          color:AppColors.lightGrey3
        )
        ],
        ),
      ),
    );
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
    )
      ..show(context);
  }
}

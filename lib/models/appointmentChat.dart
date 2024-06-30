
import 'package:cloud_firestore/cloud_firestore.dart';


class AppointmentChat {
  String appointmentId;
  String message;
  Timestamp messageTime;
  String messageTimeUtc;
  dynamic type;
  String userUid;


  AppointmentChat({
    required this.message,
    required this.appointmentId,
    required this.messageTimeUtc,
    required this.messageTime,
    required this.userUid,
    this.type,


  });

  factory AppointmentChat.fromMap(Map data) {
    return AppointmentChat(
      appointmentId: data['appointmentId'],
      messageTimeUtc:data['messageTimeUtc'],
      message: data['message'],
      type: data['type'],
      userUid: data['userUid'],
      messageTime: data['messageTime'],

    );
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultDays {
  String day;
  dynamic date;
  List<dynamic> todayAppointmentList;
  String consultUid;

  ConsultDays({
    required this.day,
    this.date,
    required this.consultUid,
    required this.todayAppointmentList,
  });
  factory ConsultDays.fromMap(Map data) {

    return ConsultDays(
      day: data['day'],
      date: data['date'],
      consultUid: data['consultUid'],
      todayAppointmentList: data['todayAppointmentList']==null?[]:data['todayAppointmentList'],
    );
  }
  factory ConsultDays.fromHashMap(Map<String, dynamic> data) {
    return ConsultDays(
      day: data['day'],
      date: data['date'],
      consultUid: data['consultUid'],
      todayAppointmentList: data['todayAppointmentList']==null?[]:data['todayAppointmentList'],
    );
  }
}
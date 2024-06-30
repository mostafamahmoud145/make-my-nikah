
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order.dart';

class AppAppointments {
  String appointmentId;
  String appointmentStatus;
  Timestamp appointmentTimestamp;
  Timestamp timestamp;
  dynamic timeValue;
  dynamic secondValue;
  UserDetails consult;
  UserDetails user;
  AppointmentDate date;
  AppointmentTime time;
  String orderId;
  String? roomId;
  List<dynamic>?roomList;
  String type;
  dynamic callPrice;
  dynamic userChat;
  dynamic consultChat;
  //dynamic lessonTime;
  String consultType;
  String utcTime;
  //bool isUtc;
  bool allowCall;
  //dynamic remainingCallNum;
  dynamic callCost;

  AppAppointments({
    required this.appointmentId,
    required this.appointmentStatus,
    required this.consultType,
    required this.callCost,
    required this.appointmentTimestamp,
    required this.orderId,
    this.roomId,
    this.roomList,
    required this.timestamp,
    this.secondValue,
    this.timeValue,
    required this.utcTime,
    required this.type,
    required this.date,
    required this.time,
    required this.consult,
    required this.user,
    this.callPrice,
    this.consultChat,
    this.userChat,
    required this.allowCall,



  });

  factory AppAppointments.fromMap(Map data) {
    return AppAppointments(
      appointmentId: data['appointmentId'],
      consultType:data['consultType'],
      appointmentStatus: data['appointmentStatus'],
      appointmentTimestamp: data['appointmentTimestamp'],
      orderId: data['orderId'],
      roomId: data['roomId'],
      roomList: data['roomList']==null?[]:data['roomList'],
      callCost: data['callCost']==null?0.0:data['callCost'],
      utcTime:data['utcTime'],
      timeValue: data['timeValue'],
      type:data['type'],
      date: AppointmentDate.fromHashmap(data['date']),
      time: AppointmentTime.fromHashmap(data['time']),
      consult: UserDetails.fromHashmap(data['consult']),
      user: UserDetails.fromHashmap(data['user']),
      timestamp: data['timestamp'],
      allowCall: data['allowCall'],
      secondValue: data['secondValue'],
      callPrice:data['callPrice'],
        consultChat:data['consultChat'],
        userChat:data['userChat']

    );
  }
}

class AppointmentDate {
  int day;
  int month;
  int year;

  AppointmentDate({
    required this.day,
    required this.month,
    required this.year,
  });

  factory AppointmentDate.fromHashmap(Map<String, dynamic> Details) {
    return AppointmentDate(
        day: Details['day'],
        month: Details['month'],
        year: Details['year'],
    );
  }
}
class AppointmentTime {
  int hour;
  int minute;

  AppointmentTime({
    required this.hour,
    required this.minute,
  });

  factory AppointmentTime.fromHashmap(Map<String, dynamic> Details) {
    return AppointmentTime(
      hour: Details['hour'],
      minute: Details['minute'],
    );
  }
}



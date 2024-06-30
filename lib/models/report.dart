
import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String? id;
  String? appointmentId;
  Timestamp? complaintTime;
  String? complaints;
  String? consultName;
  String? consultPhone;
  String? consultUid;
  String? openingStatus;
  String? name;
  String? status;
  String? phone;
  String? uid;
  bool? other;


  Report({
     this.id,
     this.appointmentId,
     this.complaintTime,
     this.complaints,
     this.consultName,
     this.consultPhone,
     this.consultUid,
     this.openingStatus,
     this.name,
     this.status,
     this.phone,
     this.uid,
     this.other,


  });

  factory Report.fromMap(Map data) {
    
    return Report(
      id: data['id'],
      appointmentId: data['appointmentId'],
      complaintTime: data['complaintTime'],
      complaints:data['complaints'],
      consultName: data['consultName'],
      consultPhone: data['consultPhone'],
      consultUid : data['consultUid'],
      openingStatus: data['openingStatus'],
      name: data['name'],
      status: data['status'],
      phone: data['phone'],
      uid: data['uid'],
      other: data['other'],

    );
  }
}



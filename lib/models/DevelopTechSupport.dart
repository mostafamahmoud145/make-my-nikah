
import 'package:cloud_firestore/cloud_firestore.dart';
class DevelopTechSupport {
  String developTechSupportId;
  String userUid;
  String userName;
  String title;
  String status;
  Timestamp sendTime;


  DevelopTechSupport({
    required this.developTechSupportId,
    required this.userUid,
    required this.userName,
    required this.title,
    required this.sendTime,
    required this.status,
  });

  factory DevelopTechSupport.fromMap(Map data) {
    return DevelopTechSupport(
        developTechSupportId:data['developTechSupportId'],
        userUid: data['userUid'],
        title: data['title'],
        userName: data['userName'],
        status: data['status'],
        sendTime: data['sendTime'],
    );
  }
}



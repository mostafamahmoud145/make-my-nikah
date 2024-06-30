
import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotification {
  String? uid;
  bool unread;
  List<Notification> notifications;

  UserNotification({
    required this.notifications,
    required this.uid,
    required this.unread,
  });

  factory UserNotification.fromMap(Map data) {
    return UserNotification(
      notifications: List<Notification>.from(
        data['notifications'].map(
              (notif) {
            return Notification.fromMap(notif);
          },
        ),
      ),
      uid:data['uid'],
      unread: data['unread'],
    );
  }

}

class Notification {
  String? notificationBody;
  String? notificationId;
  String? notificationTitle;
  String? notificationType;
  String? type;
  String? appointmentId;
  String? userUid;
  String? consultUid;
  String? image;
  String? link;
  Timestamp? timestamp;
  String? chatId;

  Notification({
    this.notificationBody,
    this.notificationId,
    this.notificationTitle,
    this.notificationType,
    this.type,
    this.appointmentId,
    this.userUid,
    this.consultUid,
    this.timestamp,
    this.image,
    this.link,
    this.chatId,
  });

  factory Notification.fromMap(Map<dynamic, dynamic> map) {
    print("kkkkkk");
    return Notification(
      notificationBody: map['notificationBody'],
      notificationId: map['notificationId'],
      notificationTitle: map['notificationTitle'],
      notificationType: map['notificationType'],
      appointmentId: map['appointmentId'],
      userUid: map['userUid'],
      consultUid: map['consultUid'],
      type:map['type'],
      image:map['image'],
      link:map['link'],
      chatId:map['chatId'],
      timestamp: map['timestamp'],
    );
  }
}

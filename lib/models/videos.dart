
import 'package:cloud_firestore/cloud_firestore.dart';
class Video {
  String id;
  String consultUid;
  String link;
  String desc;
  Video({
    required this.id,
    required this.consultUid,
    required this.link,
    required this.desc,
  });
  factory Video.fromMap(Map data) {
    
    return Video(
      id: data['id'],
      consultUid: data['consultUid'],
      link: data['link'],
      desc: data['desc'],

    );
  }
  factory Video.fromHashmap(Map<String, dynamic> ranges) {
    return Video(
      id: ranges['id'],
      consultUid:ranges['consultUid'],
      link: ranges['link'],
      desc: ranges['desc'],
    );
  }
}
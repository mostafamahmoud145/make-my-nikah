
import 'package:cloud_firestore/cloud_firestore.dart';

class consultPackage {
  String Id;
  dynamic price;
  dynamic discount;
  String consultUid;
  bool active;
  dynamic callNum;


  consultPackage({
    required this.Id,
    this.price,
    required this.consultUid,
    this.discount,
    required this.active,
    this.callNum,
  });
  factory consultPackage.fromMap(Map data) {
    
    return consultPackage(
        Id: data['Id'],
        price: data['price'],
        discount: data['discount'],
        consultUid: data['consultUid'],
        active: data['active'],
        callNum: data['callNum']
    );
  }
  factory consultPackage.fromHashMap(Map<String, dynamic> review) {
    return consultPackage(
        Id: review['Id'],
        discount: review['discount'],
        price: review['price'],
        consultUid: review['consultUid'],
        active: review['active'],
        callNum: review['callNum']
    );
  }
}
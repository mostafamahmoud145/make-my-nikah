
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order.dart';

class Invoice {
  String? id;
  String? status;
  Timestamp? timestamp;
  UserDetails? user;
  Timestamp? expire;
  dynamic price;
  String? email;
  String? invoiceId;
  String? invoice;


  Invoice({
     this.id,
     this.status,
     this.expire,
    this.price,
     this.timestamp,
     this.user,
     this.email,
     this.invoiceId,
     this.invoice,




  });

  factory Invoice.fromMap(Map data) {
    
    return Invoice(
        id: data['id'],
        status:data['status'],
        email:data['email'],
        expire:data["expiry"],
        price:data['price'],
       invoiceId:data["invoiceId"],
       invoice:data["invoice"],
        user: UserDetails.fromHashmap(data['user']),
        timestamp: data['timestamp'],
    );
  }
}





  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/models/user.dart';
import 'package:uuid/uuid.dart';

errorLog(String function, String error,GroceryUser? loggedUser) async {
    String id = Uuid().v4();
    await FirebaseFirestore.instance
        .collection(Paths.errorLogPath)
        .doc(id)
        .set({
      'timestamp': Timestamp.now(),
      'id': id,
      'seen': false,
      'desc': error,
      'phone': loggedUser == null ? " " : loggedUser.phoneNumber,
      'screen': "CoachDetailScreen",
      'function': function,
    });
  }
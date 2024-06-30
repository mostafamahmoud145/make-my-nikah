import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/models/setting.dart';
import 'package:grocery_store/screens/google_apple_signup/data/model/failure_model.dart';
import 'package:grocery_store/screens/google_apple_signup/services/enum/http_response_status.dart';

class GoogleAppleSignUpRepo {
  Future<Either<FailureModel, Setting>> getSetting() async {
    try {
      Setting? setting;
      DocumentReference doc = FirebaseFirestore.instance
          .collection("Setting")
          .doc("pzBqiphy5o2kkzJgWUT7");
      final DocumentSnapshot documentSnapshot = await doc.get();
       setting = Setting.fromMap(documentSnapshot.data() as Map<String, dynamic>);
       if(setting!=null)
        return Right(setting);
        else
           return Left(FailureModel(responseStatus: HttpResponseStatus.failure));
     
    } catch (e) {
      print("getSettingError " + e.toString());
      return Left(FailureModel(responseStatus: HttpResponseStatus.failure));
    }
  }
}



import 'package:firebase_database/firebase_database.dart';

changeUserState({required String userId, required String state})async{
  await FirebaseDatabase.instance
      .ref('userCallState')
      .child(userId)
      .child('callState')
      .set(state);
}